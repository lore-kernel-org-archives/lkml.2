Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753256Ab1HYLE0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 07:04:26 -0400
Received: from www.linutronix.de ([62.245.132.108]:33107 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753035Ab1HYLEZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 07:04:25 -0400
Date: Thu, 25 Aug 2011 13:04:23 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Luciano Coelho <coelho@ti.com>
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 3.1-rc3 fails to boot on my pandaboard
Message-ID: <20110825110423.GA12911@linutronix.de>
References: <1314268769.2296.283.camel@cumari>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1314268769.2296.283.camel@cumari>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Luciano Coelho | 2011-08-25 13:39:29 [+0300]:

>Hi,
Hi,

>Any ideas what may be going wrong?

I think my commit was identified as bogus and tglx is going to revert 
it. The problem is that I force ONESHOT mode for all threaded IRQs but
there are also others without the flag which is not allowed.

I was trying to check something but I don't get my board to boot. Could
you please try to boot with the patch reverted and paste me the
the output of 
 cat /proc/interrupts | grep 74 ?

I *think* that the flow handler is level (I can't find evidence of it
beeing edge, and omap_alloc_gc() is the place installing it).

So could you please gather additional debug info with this patch?

diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 2e94258..eda25a0 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -1327,6 +1327,9 @@ int request_threaded_irq(unsigned int irq, irq_handler_t handler,
 	if (!irq_settings_can_request(desc))
 		return -EINVAL;
 
+	if (irq == 74)
+		printk(KERN_ERR "%s() h %pS th %pS f %lx dev %s flow %pS\n", __func__,
+				handler, thread_fn, irqflags, devname, desc->handle_irq);
 	if (!handler) {
 		if (!thread_fn)
 			return -EINVAL;


%pS should resolve the function names.

Sebastian
