Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030520Ab2CNC3u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 22:29:50 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:23031 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965226Ab2CNC3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 22:29:46 -0400
X-Authority-Analysis: v=2.0 cv=d9t3OGfE c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=UBy9sU4F98IA:10 a=tUOiOLPuDfcA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=20KFwNOVAAAA:8 a=qAFbsPHvHkIfRpjvm-YA:9 a=0AYb-7x522CTyZe-e4oA:7 a=jEp0ucaQiEUA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120314022944.515930971@goodmis.org>
User-Agent: quilt/0.50-1
Date: Tue, 13 Mar 2012 22:26:59 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>
Subject: [PATCH RT 1/7] Revert "ACPI: Convert embedded controller lock to raw spinlock"
References: <20120314022658.783312660@goodmis.org>
Content-Disposition: inline; filename=0001-Revert-ACPI-Convert-embedded-controller-lock-to-raw-.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

This reverts commit 1a39c79b4d1a6911a39083719a999fbfba7287ae.
---
 drivers/acpi/ec.c       |   22 +++++++++++-----------
 drivers/acpi/internal.h |    2 +-
 2 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
index db0e6c3..b72a603 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -152,10 +152,10 @@ static int ec_transaction_done(struct acpi_ec *ec)
 {
 	unsigned long flags;
 	int ret = 0;
-	raw_spin_lock_irqsave(&ec->curr_lock, flags);
+	spin_lock_irqsave(&ec->curr_lock, flags);
 	if (!ec->curr || ec->curr->done)
 		ret = 1;
-	raw_spin_unlock_irqrestore(&ec->curr_lock, flags);
+	spin_unlock_irqrestore(&ec->curr_lock, flags);
 	return ret;
 }
 
@@ -169,7 +169,7 @@ static void start_transaction(struct acpi_ec *ec)
 static void advance_transaction(struct acpi_ec *ec, u8 status)
 {
 	unsigned long flags;
-	raw_spin_lock_irqsave(&ec->curr_lock, flags);
+	spin_lock_irqsave(&ec->curr_lock, flags);
 	if (!ec->curr)
 		goto unlock;
 	if (ec->curr->wlen > ec->curr->wi) {
@@ -194,7 +194,7 @@ err:
 	if (in_interrupt())
 		++ec->curr->irq_count;
 unlock:
-	raw_spin_unlock_irqrestore(&ec->curr_lock, flags);
+	spin_unlock_irqrestore(&ec->curr_lock, flags);
 }
 
 static int acpi_ec_sync_query(struct acpi_ec *ec);
@@ -232,9 +232,9 @@ static int ec_poll(struct acpi_ec *ec)
 		if (acpi_ec_read_status(ec) & ACPI_EC_FLAG_IBF)
 			break;
 		pr_debug(PREFIX "controller reset, restart transaction\n");
-		raw_spin_lock_irqsave(&ec->curr_lock, flags);
+		spin_lock_irqsave(&ec->curr_lock, flags);
 		start_transaction(ec);
-		raw_spin_unlock_irqrestore(&ec->curr_lock, flags);
+		spin_unlock_irqrestore(&ec->curr_lock, flags);
 	}
 	return -ETIME;
 }
@@ -247,17 +247,17 @@ static int acpi_ec_transaction_unlocked(struct acpi_ec *ec,
 	if (EC_FLAGS_MSI)
 		udelay(ACPI_EC_MSI_UDELAY);
 	/* start transaction */
-	raw_spin_lock_irqsave(&ec->curr_lock, tmp);
+	spin_lock_irqsave(&ec->curr_lock, tmp);
 	/* following two actions should be kept atomic */
 	ec->curr = t;
 	start_transaction(ec);
 	if (ec->curr->command == ACPI_EC_COMMAND_QUERY)
 		clear_bit(EC_FLAGS_QUERY_PENDING, &ec->flags);
-	raw_spin_unlock_irqrestore(&ec->curr_lock, tmp);
+	spin_unlock_irqrestore(&ec->curr_lock, tmp);
 	ret = ec_poll(ec);
-	raw_spin_lock_irqsave(&ec->curr_lock, tmp);
+	spin_lock_irqsave(&ec->curr_lock, tmp);
 	ec->curr = NULL;
-	raw_spin_unlock_irqrestore(&ec->curr_lock, tmp);
+	spin_unlock_irqrestore(&ec->curr_lock, tmp);
 	return ret;
 }
 
@@ -678,7 +678,7 @@ static struct acpi_ec *make_acpi_ec(void)
 	mutex_init(&ec->lock);
 	init_swait_head(&ec->wait);
 	INIT_LIST_HEAD(&ec->list);
-	raw_spin_lock_init(&ec->curr_lock);
+	spin_lock_init(&ec->curr_lock);
 	return ec;
 }
 
diff --git a/drivers/acpi/internal.h b/drivers/acpi/internal.h
index 2519b6e..6f889ba 100644
--- a/drivers/acpi/internal.h
+++ b/drivers/acpi/internal.h
@@ -64,7 +64,7 @@ struct acpi_ec {
 	struct swait_head wait;
 	struct list_head list;
 	struct transaction *curr;
-	raw_spinlock_t curr_lock;
+	spinlock_t curr_lock;
 };
 
 extern struct acpi_ec *first_ec;
-- 
1.7.8.3


