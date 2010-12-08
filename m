Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757140Ab0LHBAn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:00:43 -0500
Received: from kroah.org ([198.145.64.141]:48823 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757016Ab0LHBAh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 20:00:37 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:31 2010
Message-Id: <20101208005731.362628790@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:57:57 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Clemens Ladisch <clemens@ladisch.de>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        john stultz <johnstul@us.ibm.com>, Bob Picco <bpicco@redhat.com>
Subject: [100/289] hpet: fix unwanted interrupt due to stale irq status bit
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Clemens Ladisch <clemens@ladisch.de>

commit 96e9694df446d1154ec2f4fdba8908588b9cba38 upstream.

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
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Bob Picco <bpicco@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/char/hpet.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

--- a/drivers/char/hpet.c
+++ b/drivers/char/hpet.c
@@ -479,6 +479,21 @@ static int hpet_ioctl_ieon(struct hpet_d
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


