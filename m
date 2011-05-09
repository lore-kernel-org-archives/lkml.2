Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753664Ab1EIIWs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 04:22:48 -0400
Received: from www.linutronix.de ([62.245.132.108]:36411 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753499Ab1EIIWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 04:22:46 -0400
Date: Mon, 9 May 2011 10:22:38 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Christian Hoffmann <email@christianhoffmann.info>
cc: john stultz <johnstul@us.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Long timeout when booting >= 2.6.38
In-Reply-To: <4DC2DE2C.40108@christianhoffmann.info>
Message-ID: <alpine.LFD.2.02.1105091020450.2895@ionos>
References: <4DBEFCBA.3070501@christianhoffmann.info>  <1304363375.3226.5.camel@work-vm> <4DBF1725.3030800@christianhoffmann.info>  <1304372955.3226.15.camel@work-vm>  <4DBF2FB4.8000304@christianhoffmann.info> <1304470839.3037.12.camel@work-vm>
 <4DC100D0.1030302@christianhoffmann.info> <alpine.LFD.2.02.1105041015220.3005@ionos> <4DC1832E.5030806@christianhoffmann.info> <alpine.LFD.2.02.1105041931510.3005@ionos> <4DC1AB9B.8080501@christianhoffmann.info> <alpine.LFD.2.02.1105042154410.3005@ionos>
 <4DC2DE2C.40108@christianhoffmann.info>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 May 2011, Christian Hoffmann wrote:

> > 
> > So we are back to:
> > 
> > [    0.644189] Calling fixup hook: quirk_usb_early_handoff+0x0/0x4a6
> > [  145.936254] Calling fixup hook: pci_fixup_video+0x0/0xac
> > 
> > So we really need to know what's happening there.
> > 
> > Can you please apply the following patch and enable
> > CONFIG_FUNCTION_TRACER and add "ftrace=function" on the command line?
> > 
> > When the box is up, mount debugfs (mount -t debugfs debugfs
> > /sys/kernel/debug) and read out /sys/kernel/debug/tracing/trace, bzip2
> > it and provide it somewhere for download. If you have no way to do
> > that, mail it to me offlist.
> 
> Hi,
> 
> trace can be found here:
> 
> http://dl.dropbox.com/u/21820416/hanging_2.6.39-rc6.trace.bz2

Thanks, can you please add the following patch and generate another
trace ?

Thanks,

	Thomas

--- linux-2.6.orig/kernel/timer.c
+++ linux-2.6/kernel/timer.c
@@ -1268,11 +1268,14 @@ unsigned long get_next_timer_interrupt(u
 	if (cpu_is_offline(smp_processor_id()))
 		return now + NEXT_TIMER_MAX_DELTA;
 	spin_lock(&base->lock);
+	trace_printk("nx: %lx tj: %lx\n", base->next_timer, base->timer_jiffies);
 	if (time_before_eq(base->next_timer, base->timer_jiffies))
 		base->next_timer = __next_timer_interrupt(base);
 	expires = base->next_timer;
 	spin_unlock(&base->lock);
 
+	trace_printk("ex: %lx nw: %lx\n", expires, now);
+
 	if (time_before_eq(expires, now))
 		return now;
 
