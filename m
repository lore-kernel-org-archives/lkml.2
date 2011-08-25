Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753303Ab1HYLYn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 07:24:43 -0400
Received: from na3sys009aog119.obsmtp.com ([74.125.149.246]:48805 "EHLO
	na3sys009aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752204Ab1HYLYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 07:24:40 -0400
Subject: Re: 3.1-rc3 fails to boot on my pandaboard
From: Luciano Coelho <coelho@ti.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20110825110423.GA12911@linutronix.de>
References: <1314268769.2296.283.camel@cumari>
	 <20110825110423.GA12911@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 25 Aug 2011 14:24:34 +0300
Message-ID: <1314271474.2296.295.camel@cumari>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-08-25 at 13:04 +0200, Sebastian Andrzej Siewior wrote: 
> * Luciano Coelho | 2011-08-25 13:39:29 [+0300]:
> >Any ideas what may be going wrong?
> 
> I think my commit was identified as bogus and tglx is going to revert 
> it. The problem is that I force ONESHOT mode for all threaded IRQs but
> there are also others without the flag which is not allowed.
> 
> I was trying to check something but I don't get my board to boot. Could
> you please try to boot with the patch reverted and paste me the
> the output of 
>  cat /proc/interrupts | grep 74 ?

Hmmm... There doesn't seem to be an irq 74.  The only thing I get is
this:

root@xiru:~# cat /proc/interrupts | grep 74
IPI1:       2667       3743  Rescheduling interrupts

Which is probably not what you wanted. ;)


> I *think* that the flow handler is level (I can't find evidence of it
> beeing edge, and omap_alloc_gc() is the place installing it).
> 
> So could you please gather additional debug info with this patch?
> 
> diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
> index 2e94258..eda25a0 100644
> --- a/kernel/irq/manage.c
> +++ b/kernel/irq/manage.c
> @@ -1327,6 +1327,9 @@ int request_threaded_irq(unsigned int irq, irq_handler_t handler,
>  	if (!irq_settings_can_request(desc))
>  		return -EINVAL;
>  
> +	if (irq == 74)
> +		printk(KERN_ERR "%s() h %pS th %pS f %lx dev %s flow %pS\n", __func__,
> +				handler, thread_fn, irqflags, devname, desc->handle_irq);
>  	if (!handler) {
>  		if (!thread_fn)
>  			return -EINVAL;
> 
> 
> %pS should resolve the function names.

As I mentioned above, there doesn't seem to be irq 74, so this code
doesn't hit.

These are the interrupts reported in /proc/interrupts on my board:

root@xiru:~# cat /proc/interrupts
           CPU0       CPU1       
39:          0          0       GIC  TWL6030-PIH
41:          0          0       GIC  l3-dbg-irq
42:          0          0       GIC  l3-app-irq
44:       5397          0       GIC  DMA
52:          0          0       GIC  gpmc
69:         16          0       GIC  gp timer
88:        270          0       GIC  omap_i2c
89:          0          0       GIC  omap_i2c
91:        183          0       GIC  mmc1
93:          0          0       GIC  omap_i2c
94:          0          0       GIC  omap_i2c
102:          0          0       GIC  serial idle
104:          0          0       GIC  serial idle
105:          0          0       GIC  serial idle
106:        290          0       GIC  serial idle, OMAP UART2
108:          1          0       GIC  ohci_hcd:usb3
109:        493          0       GIC  ehci_hcd:usb1
115:       6260          0       GIC  mmc0
124:          1          0       GIC  musb-hdrc
125:          0          0       GIC  musb-hdrc
213:          0          0      GPIO  wl1271
372:          0          0   twl6030  twl6030_usb
378:          0          0   twl6030  twl6030_usb
379:          0          0   twl6030  rtc0
IPI0:          0          0  Timer broadcast interrupts
IPI1:       2995       3606  Rescheduling interrupts
IPI2:          0          0  Function call interrupts
IPI3:         57         61  Single function call interrupts
IPI4:          0          0  CPU stop interrupts
LOC:       8879       5844  Local timer interrupts
Err:          0


-- 
Cheers,
Luca.

