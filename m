Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756750Ab1DNQcq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 12:32:46 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:58063 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155Ab1DNQco (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 12:32:44 -0400
Subject: [PATCH] irq: prevent crash if irq chip does not provide irq_ack
 function
From: Erik =?ISO-8859-1?Q?Bot=F6?= <erik.boto@pelagicore.com>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 14 Apr 2011 18:32:39 +0200
Message-ID: <1302798759.8200.71.camel@erik-mbook>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When using the pca953x driver (driver/gpio/pca953x.c) I found that the
kernel crashed with the following trace:

BUG: unable to handle kernel NULL pointer dereference at   (null)
IP: [<  (null)>]   (null)
*pde = 00000000 
Oops: 0000 [#1] PREEMPT SMP 
last sysfs file: /sys/devices/virtual/input/input9/name
Modules linked in: tsc2007 hid_apple usbhid mmci_pci mmc_core adv7180 sta2x11_vip videobuf_dma_contig videobuf_core joydev tc_ivi_i2c_loader stmmac libphy snd_hda_codec_r]

Pid: 723, comm: kworker/0:1 Not tainted 2.6.37.2-15.1-adaptation-b2 #9 To be filled by O.E.M. To be filled by O.E.M./To be filled by O.E.M.
EIP: 0060:[<00000000>] EFLAGS: 00010202 CPU: 0
EIP is at 0x0
EAX: c16320c0 EBX: c16320c0 ECX: 00000046 EDX: c1650f40
ESI: c1632104 EDI: 00000008 EBP: ed20bf3c ESP: ed20bf28
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Process kworker/0:1 (pid: 723, ti=ed20a000 task=ed89e130
task.ti=ed20a000)
Stack:
 c106c3a9 000000cb ed0ae180 c16320c0 00000008 ed20bf5c c115cb77 000000cb
 00000003 c0210000 ed0ae1f4 ec75d440 ee402b40 ed20bf88 c104518d ed20bf88
 ee40007b c115ca44 00000000 ee406a00 ee406a85 ec75d440 ee402b40 c16ec500
Call Trace:
 [<c106c3a9>] ? handle_edge_irq+0x7b/0x126
 [<c115cb77>] ? pca953x_irq_work+0x133/0x164
 [<c104518d>] ? process_one_work+0x1db/0x327
 [<c115ca44>] ? pca953x_irq_work+0x0/0x164
 [<c10455c5>] ? worker_thread+0x187/0x2a2
 [<c104543e>] ? worker_thread+0x0/0x2a2
 [<c10491f3>] ? kthread+0x63/0x68
 [<c1049190>] ? kthread+0x0/0x68
 [<c1002d36>] ? kernel_thread_helper+0x6/0x10
Code:  Bad EIP value.
EIP: [<00000000>] 0x0 SS:ESP 0068:ed20bf28
CR2: 0000000000000000
---[ end trace b7ccc9d6a0ebad9d ]---

This crash happens when handle_edge_irq() does not check if there is an
irq_ack before calling it. Other functions in chip.c check for the
existence before calling so I suppose it should be done here as well. 

Signed-off-by: Erik Botö <erik.boto@pelagicore.com>
Signed-off-by: Richard Röjfors <richard.rojfors@pelagicore.com>
---
diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index 4af1e2b..dfd852c 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -447,7 +447,8 @@ handle_edge_irq(unsigned int irq, struct irq_desc *desc)
 	kstat_incr_irqs_this_cpu(irq, desc);
 
 	/* Start handling the irq */
-	desc->irq_data.chip->irq_ack(&desc->irq_data);
+	if (desc->irq_data.chip->irq_ack)
+		desc->irq_data.chip->irq_ack(&desc->irq_data);
 
 	do {
 		if (unlikely(!desc->action)) {

