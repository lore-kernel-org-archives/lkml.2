Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754681Ab0JGSho (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 14:37:44 -0400
Received: from www.tglx.de ([62.245.132.106]:41462 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751100Ab0JGShm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 14:37:42 -0400
Date: Thu, 7 Oct 2010 20:37:31 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Grazvydas Ignotas <notasas@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: twl4030 irq crashes
In-Reply-To: <AANLkTik++Rb-x+aLtKv83USqSn8tQ4iyfSyWCNgfM+nO@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1010072037010.2501@localhost6.localdomain6>
References: <AANLkTik0q3i9SkydhJFbousVrHbc+eMM2SkaxR4MD41U@mail.gmail.com> <alpine.LFD.2.00.1010070058220.17015@localhost6.localdomain6> <AANLkTik++Rb-x+aLtKv83USqSn8tQ4iyfSyWCNgfM+nO@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463795968-1426186621-1286476652=:2501"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463795968-1426186621-1286476652=:2501
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Thu, 7 Oct 2010, Grazvydas Ignotas wrote:
> On Thu, Oct 7, 2010 at 1:59 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> > On Thu, 7 Oct 2010, Grazvydas Ignotas wrote:
> >
> >> Hello,
> >>
> >> I've pulled today's (20101006) linux-next and twl4030 started crashing
> >> on certain interrupts. twl4030 irq code hasn't changed so it's
> >> probably genirq's fault:
> >>
> >> [    0.889739] Unable to handle kernel NULL pointer dereference at
> >> virtual address 00000000
> >> [    0.898193] pgd = c0004000
> >> [    0.901000] [00000000] *pgd=00000000
> >> [    0.904754] Internal error: Oops: 80000005 [#1]
> >> [    0.909484] last sysfs file:
> >> [    0.912567] Modules linked in:
> >> [    0.915771] CPU: 0    Not tainted
> >> (2.6.36-rc6-next-20101006-00001-g766a681-dirty #205)
> >> [    0.924133] PC is at 0x0
> >> [    0.926788] LR is at handle_edge_irq+0x84/0x14c
> >
> > Can you please decode that line with
> >
> > addr2line -e vmlinux c0077244
> 
> kernel/irq/chip.c:725

The patch below should cure that.

Thanks,

	tglx
---
diff --git a/drivers/mfd/twl4030-irq.c b/drivers/mfd/twl4030-irq.c
index 61c8664..b9fda70 100644
--- a/drivers/mfd/twl4030-irq.c
+++ b/drivers/mfd/twl4030-irq.c
@@ -810,7 +810,7 @@ int twl4030_init_irq(int irq_num, unsigned irq_base, unsigned irq_end)
 	twl4030_irq_chip = dummy_irq_chip;
 	twl4030_irq_chip.name = "twl4030";
 
-	twl4030_sih_irq_chip.ack = dummy_irq_chip.ack;
+	twl4030_sih_irq_chip.irq_ack = dummy_irq_chip.irq_ack;
 
 	for (i = irq_base; i < irq_end; i++) {
 		set_irq_chip_and_handler(i, &twl4030_irq_chip,

---1463795968-1426186621-1286476652=:2501--
