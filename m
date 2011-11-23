Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759428Ab1KWAlz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 19:41:55 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42986 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759388Ab1KWAlw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 19:41:52 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Nov 22 16:24:04 2011
Message-Id: <20111123002404.677589039@clark.kroah.org>
User-Agent: quilt/0.48-20.1.2
Date: Tue, 22 Nov 2011 16:23:08 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Edward Donovan <edward.donovan@numble.net>,
        maciej.rutecki@gmail.com, Thomas Gleixner <tglx@linutronix.de>
Subject: [01/53] genirq: Fix irqfixup, irqpoll regression
In-Reply-To: <20111123002419.GA8531@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Edward Donovan <edward.donovan@numble.net>

commit c75d720fca8a91ce99196d33adea383621027bf2 upstream.

commit d05c65fff0 ("genirq: spurious: Run only one poller at a time")
introduced a regression, leaving the boot options 'irqfixup' and
'irqpoll' non-functional. The patch placed tests in each function, to
exit if the function is already running. The test in 'misrouted_irq'
exited when it should have proceeded, effectively disabling
'misrouted_irq' and 'poll_spurious_irqs'.

The check for an already running poller needs to be "!= 1" not "== 1"
as "1" is the value when the first poller starts running.

Signed-off-by: Edward Donovan <edward.donovan@numble.net>
Cc: maciej.rutecki@gmail.com
Link: http://lkml.kernel.org/r/1320175784-6745-1-git-send-email-edward.donovan@numble.net
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/irq/spurious.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/irq/spurious.c
+++ b/kernel/irq/spurious.c
@@ -115,7 +115,7 @@ static int misrouted_irq(int irq)
 	struct irq_desc *desc;
 	int i, ok = 0;
 
-	if (atomic_inc_return(&irq_poll_active) == 1)
+	if (atomic_inc_return(&irq_poll_active) != 1)
 		goto out;
 
 	irq_poll_cpu = smp_processor_id();


