Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756415Ab1JCPKd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 11:10:33 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:6416 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755141Ab1JCPK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 11:10:27 -0400
X-IronPort-AV: E=Sophos;i="4.68,479,1312156800"; 
   d="scan'208";a="8182340"
Subject: xen: IPI interrupts not resumed early enough on suspend/resume
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Thomas Gleixner <tglx@linutronix.de>,
        Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: xen-devel <xen-devel@lists.xensource.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Mon, 3 Oct 2011 16:10:26 +0100
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3- 
Content-Transfer-Encoding: 7bit
Message-ID: <1317654626.21903.72.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

Recently I've been chasing an issue where a Xen guest will fail to
resume about 1 time in 100. I eventually managed to bisect this back to
676dc3cf5bc3 "xen: Use IRQF_FORCE_RESUME".

The Xen suspend procedure (drivers/xen/manage.c:do_suspend()) is roughly
(I've omitted some uninteresting parts) as follows:
  dpm_suspend_start()
  dpm_suspend_noirq()
  stop_machine()
   -> xen_suspend()
        syscore_suspend()
        HYPERVISOR_suspend() /* Hypercall, returns on resume */
        xen_irq_resume() /* Re-establishes evtchn<->irq bindings */
        syscore_resume()
  dpm_resume_noirq()
  dpm_resume_end()

The resume process appears to be coming to a halt at the end of the
stop_machine invocation of xen_suspend(), i.e. after syscore_resume()
but before dpm_resume_noirq().

Looking at the stack traces of all VCPUs when this happens it appears
that they are all idle, which suggests we are missing an event to cause
a reschedule out of the stop_machine thread back into the suspending
thread.

One of the effects of 676dc3cf5bc3 was to move the unmasking of the
timer and IPI interrupts from xen_irq_resume() (i.e. within the
stop_machine region) to dpm_resume_noirq() (i.e. outside the
stop_machine region). Since the IPI interrupts includes the reschedule
IPI I rather suspect that is the reason for the problem. I added a hack
to unmask the reched* IPIs at xen_irq_resume() time and so far it seems
to fix things, which backs up my gut feeling.

I can see a few options for how I might go about solving this in a
non-hacky way, which approach do you think would be preferable:

      * Add "IRQF_RESUME_EARLY", driven from syscore_resume, and use it
        for these interrupts.
      * register syscore ops for the Xen event channel subsystem to
        unmask the IPIs earlier (would probably look a lot like the code
        removed by 676dc3cf5bc3).
      * add syscore_ops to Xen smp subsystem to unmask the specific IPIs
        (which it binds at start of day) earlier.
      * push dpm_(suspend|resume)_noirq down into stop machine region
      * use something other than stop_machine to quiesce system and move
        to cpu0 for suspend (doesn't seem sensible to reproduce that
        functionality).

Routing IPIs through the regular IRQ path seems a little bit unusual but
it looks like powerpc does something similar in smp_request_message_ipi
and mpic_request_ipis and that code uses the syscore approach. Does
applying that here too seem sane?

Any preference / advice?

Thanks,
Ian.

