Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755372Ab1BSSec (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Feb 2011 13:34:32 -0500
Received: from www.hansjkoch.de ([178.63.77.200]:41220 "EHLO www.hansjkoch.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754444Ab1BSSea (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Feb 2011 13:34:30 -0500
Date: Sat, 19 Feb 2011 19:34:27 +0100
From: "Hans J. Koch" <hjk@hansjkoch.de>
To: "TK, Pratheesh Gangadhar" <pratheesh@ti.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "gregkh@suse.de" <gregkh@suse.de>,
        "Chatterjee, Amit" <amit.chatterjee@ti.com>,
        "Hans J. Koch" <hjk@hansjkoch.de>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] PRUSS UIO driver support
Message-ID: <20110219183427.GG4684@local>
References: <1298041530-26855-1-git-send-email-pratheesh@ti.com>
 <201102181644.17634.arnd@arndb.de>
 <alpine.LFD.2.00.1102181713480.2701@localhost6.localdomain6>
 <201102181731.05644.arnd@arndb.de>
 <alpine.LFD.2.00.1102181802580.2701@localhost6.localdomain6>
 <B85A65D85D7EB246BE421B3FB0FBB593024B83C108@dbde02.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <B85A65D85D7EB246BE421B3FB0FBB593024B83C108@dbde02.ent.ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 19, 2011 at 09:10:23PM +0530, TK, Pratheesh Gangadhar wrote:
> 
> For my understanding - if the interrupt is not shared and not level triggered -
> is this okay to have empty handler?

Greg already said he won't accept that. And I'm quite sure these interrupts
are level triggered, since that is the default on arch/omap.

E.g. in arch/arm/mach-omap1/irq.c, a loop sets all irqs to level triggered
handling: set_irq_handler(j, handle_level_irq); (line 234)

> In this specific case, these interrupt lines are internal to SOC and hooked to ARM INTC from PRUSS. PRUSS has another INTC to handle system events to PRUSS as well as to generate system events to host ARM. These generated events are used for IPC between user application and PRU firmware and for async notifications from PRU firmware to user space. I don't see a reason to make it shared as we have 8 lines available for use. As mentioned before ARM INTC interrupt processing logic converts interrupts to active high pulses.

What's a "pulse triggered interrupt"? I know level and edge triggered ones.

> 
> I also looked at the interrupt handling in existing UIO drivers
> 
> 
> static irqreturn_t my_uio_handler(int irq, struct uio_info *dev_info)
> {
>         if (no interrupt is enabled and no interrupt is active) /For shared interrupt handling
>                 return IRQ_NONE;
> 
>         disable interrupt; // For level triggered interrupts 
>         return IRQ_HANDLED;
> }
> 
> It's not clear how and where interrupts are re-enabled. Is this expected to be done from user space?

That's the normal case, yes. You re-enable the interrupts by accessing the irq
mask register of your chip.

> 
> Uio_secos3.c has an irqcontrol function to enable/disable interrupts. Is this the recommended approach?

No. That is a workaround for broken hardware. You need it if and only if your
chip 1) has several internal irq sources and 2) there's no possibility for
the kernel to mask the interrupt in the chip without loosing the information
which irq source actually triggered the interrupt.

If that is the case, the kernel will disable the irq line in some other way
without touching the chip. Userspace then needs a way to re-enable irqs,
and that's where the irqcontrol function is used.

Normally, you shouldn't need it.

Thanks,
Hans
