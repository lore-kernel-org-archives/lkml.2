Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752736Ab0IFIk0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 04:40:26 -0400
Received: from smtprelay01.ispgateway.de ([80.67.31.39]:42668 "EHLO
	smtprelay01.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752493Ab0IFIkZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 04:40:25 -0400
Message-ID: <4C84A804.9010307@ladisch.de>
Date: Mon, 06 Sep 2010 10:36:20 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
        Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>
Subject: [PATCH] hpet: fix unwanted interrupt due to stale irq status bit
References: <AANLkTi=CvnJ7oKoaj1_NjegdvbEoiBtmnVn-xEL8e2D3@mail.gmail.com>
In-Reply-To: <AANLkTi=CvnJ7oKoaj1_NjegdvbEoiBtmnVn-xEL8e2D3@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Df-Sender: linux-kernel@cl.domainfactory-kunde.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jaswinder Singh Rajput wrote:
> By executing Documentation/timers/hpet_example.c
> 
> for polling, I requested for 3 iterations but it seems iteration work
> for only 2 as first expired time is always very small.
> 
> # ./hpet_example poll /dev/hpet 10 3
> -hpet: executing poll
> hpet_poll: info.hi_flags 0x0
> hpet_poll: expired time = 0x13
> hpet_poll: revents = 0x1
> hpet_poll: data 0x1
> hpet_poll: expired time = 0x1868c
> hpet_poll: revents = 0x1
> hpet_poll: data 0x1
> hpet_poll: expired time = 0x18645
> hpet_poll: revents = 0x1
> hpet_poll: data 0x1

Clearing the HPET interrupt enable bit disables interrupt generation
but does not disable the timer, so the interrupt status bit will still
be set when the timer elapses.  If another interrupt arrives before
the timer has been correctly programmed (due to some other device on
the same interrupt line, or CONFIG_DEBUG_SHIRQ), this results in an
extra unwanted interrupt event because the status bit is likely to be
set from comparator matches that happened before the device was opened.

Therefore, we have to ensure that the interrupt status bit is and
stays cleared until we actually program the timer.

Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
Reported-by: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
Cc: <stable@kernel.org>
---
 drivers/char/hpet.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

--- a/drivers/char/hpet.c
+++ b/drivers/char/hpet.c
@@ -514,6 +514,21 @@ static int hpet_ioctl_ieon(struct hpet_d
 	if (irq) {
 		unsigned long irq_flags;
 
+		if (devp->hd_flags & HPET_SHARED_IRQ) {
+			/*
+			 * To prevent the interrupt handler from seeing an
+			 * unwanted interrupt status bit, program the timer
+			 * so that it will not fire in the near future ...
+			 */
+			writel(readl(&timer->hpet_config) & ~Tn_TYPE_CNF_MASK,
+			       &timer->hpet_config);
+			write_counter(read_counter(&hpet->hpet_mc),
+				      &timer->hpet_compare);
+			/* ... and clear any left-over status. */
+			isr = 1 << (devp - devp->hd_hpets->hp_dev);
+			writel(isr, &hpet->hpet_isr);
+		}
+
 		sprintf(devp->hd_name, "hpet%d", (int)(devp - hpetp->hp_dev));
 		irq_flags = devp->hd_flags & HPET_SHARED_IRQ
 						? IRQF_SHARED : IRQF_DISABLED;
