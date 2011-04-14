Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754286Ab1DNWk5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 18:40:57 -0400
Received: from www.linutronix.de ([62.245.132.108]:50596 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753994Ab1DNWk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 18:40:56 -0400
Date: Fri, 15 Apr 2011 00:40:53 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: =?ISO-8859-15?Q?Erik_Bot=F6?= <erik.boto@pelagicore.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] irq: prevent crash if irq chip does not provide irq_ack
 function
In-Reply-To: <1302798759.8200.71.camel@erik-mbook>
Message-ID: <alpine.LFD.2.00.1104150034310.2744@localhost6.localdomain6>
References: <1302798759.8200.71.camel@erik-mbook>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463795968-1845048119-1302820854=:2744"
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463795968-1845048119-1302820854=:2744
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Thu, 14 Apr 2011, Erik Botö wrote:

> When using the pca953x driver (driver/gpio/pca953x.c) I found that the
> kernel crashed with the following trace:
> 
> BUG: unable to handle kernel NULL pointer dereference at   (null)
> IP: [<  (null)>]   (null)
> *pde = 00000000 
> Oops: 0000 [#1] PREEMPT SMP 
> last sysfs file: /sys/devices/virtual/input/input9/name
> Modules linked in: tsc2007 hid_apple usbhid mmci_pci mmc_core adv7180 sta2x11_vip videobuf_dma_contig videobuf_core joydev tc_ivi_i2c_loader stmmac libphy snd_hda_codec_r]
> 
> Pid: 723, comm: kworker/0:1 Not tainted 2.6.37.2-15.1-adaptation-b2 #9 To be filled by O.E.M. To be filled by O.E.M./To be filled by O.E.M.
> EIP: 0060:[<00000000>] EFLAGS: 00010202 CPU: 0
> EIP is at 0x0
> EAX: c16320c0 EBX: c16320c0 ECX: 00000046 EDX: c1650f40
> ESI: c1632104 EDI: 00000008 EBP: ed20bf3c ESP: ed20bf28
>  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
> Process kworker/0:1 (pid: 723, ti=ed20a000 task=ed89e130
> task.ti=ed20a000)
> Stack:
>  c106c3a9 000000cb ed0ae180 c16320c0 00000008 ed20bf5c c115cb77 000000cb
>  00000003 c0210000 ed0ae1f4 ec75d440 ee402b40 ed20bf88 c104518d ed20bf88
>  ee40007b c115ca44 00000000 ee406a00 ee406a85 ec75d440 ee402b40 c16ec500
> Call Trace:
>  [<c106c3a9>] ? handle_edge_irq+0x7b/0x126
>  [<c115cb77>] ? pca953x_irq_work+0x133/0x164
>  [<c104518d>] ? process_one_work+0x1db/0x327
>  [<c115ca44>] ? pca953x_irq_work+0x0/0x164
>  [<c10455c5>] ? worker_thread+0x187/0x2a2
>  [<c104543e>] ? worker_thread+0x0/0x2a2
>  [<c10491f3>] ? kthread+0x63/0x68
>  [<c1049190>] ? kthread+0x0/0x68
>  [<c1002d36>] ? kernel_thread_helper+0x6/0x10
> Code:  Bad EIP value.
> EIP: [<00000000>] 0x0 SS:ESP 0068:ed20bf28
> CR2: 0000000000000000
> ---[ end trace b7ccc9d6a0ebad9d ]---
> 
> This crash happens when handle_edge_irq() does not check if there is an
> irq_ack before calling it. Other functions in chip.c check for the
> existence before calling so I suppose it should be done here as well. 

Not really. handle_edge_irq calls chip->irq_ack() forever unconditionally
because that's how the flow type works. 

Either that pca* chip sets the wrong flow handler or it lacks the ack
function. So no, we don't change the core code for that.

Btw, I can't find pca953x_irq_work() in mainline, so I guess it's out
of tree. Before it hits the tree it want's to be converted to proper
threaded irq handlers as well.

Thanks,

	tglx

> Signed-off-by: Erik Botö <erik.boto@pelagicore.com>
> Signed-off-by: Richard Röjfors <richard.rojfors@pelagicore.com>
> ---
> diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
> index 4af1e2b..dfd852c 100644
> --- a/kernel/irq/chip.c
> +++ b/kernel/irq/chip.c
> @@ -447,7 +447,8 @@ handle_edge_irq(unsigned int irq, struct irq_desc *desc)
>  	kstat_incr_irqs_this_cpu(irq, desc);
>  
>  	/* Start handling the irq */
> -	desc->irq_data.chip->irq_ack(&desc->irq_data);
> +	if (desc->irq_data.chip->irq_ack)
> +		desc->irq_data.chip->irq_ack(&desc->irq_data);
>  
>  	do {
>  		if (unlikely(!desc->action)) {
> 
> 
---1463795968-1845048119-1302820854=:2744--
