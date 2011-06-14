Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753601Ab1FNXuF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 19:50:05 -0400
Received: from prod-mail-xrelay01.akamai.com ([72.246.2.12]:47146 "EHLO
	prod-mail-xrelay01.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751303Ab1FNXuC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 19:50:02 -0400
X-Greylist: delayed 574 seconds by postgrey-1.27 at vger.kernel.org; Tue, 14 Jun 2011 19:50:02 EDT
From: Josh Hunt <johunt@akamai.com>
To: Ankita Garg <ankita@in.ibm.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Tapan Dhimant <tdhimant@akamai.com>
Subject: [PATCH] lkdtm: Fix race when crashpoint is hit multiple times before checking count
Date: Tue, 14 Jun 2011 16:40:27 -0700
Message-Id: <1308094827-29684-1-git-send-email-johunt@akamai.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We observed the crash point count going negative in cases where the crash point
is hit multiple times before the check of "count == 0" is done. Because of this
we never call lkdtm_do_action(). This patch just adds a spinlock to protect
count.

Reported-by: Tapan Dhimant <tdhimant@akamai.com>
Signed-off-by: Josh Hunt <johunt@akamai.com>
---
 drivers/misc/lkdtm.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/misc/lkdtm.c b/drivers/misc/lkdtm.c
index 81d7fa4..150cd70 100644
--- a/drivers/misc/lkdtm.c
+++ b/drivers/misc/lkdtm.c
@@ -120,6 +120,7 @@ static int recur_count = REC_NUM_DEFAULT;
 static enum cname cpoint = CN_INVALID;
 static enum ctype cptype = CT_NONE;
 static int count = DEFAULT_COUNT;
+static DEFINE_SPINLOCK(count_lock);
 
 module_param(recur_count, int, 0644);
 MODULE_PARM_DESC(recur_count, " Recursion level for the stack overflow test, "\
@@ -230,11 +231,14 @@ static const char *cp_name_to_str(enum cname name)
 static int lkdtm_parse_commandline(void)
 {
 	int i;
+	unsigned long flags;
 
 	if (cpoint_count < 1 || recur_count < 1)
 		return -EINVAL;
 
+	spin_lock_irqsave(&count_lock, flags);
 	count = cpoint_count;
+	spin_unlock_irqrestore(&count_lock, flags);
 
 	/* No special parameters */
 	if (!cpoint_type && !cpoint_name)
@@ -349,6 +353,9 @@ static void lkdtm_do_action(enum ctype which)
 
 static void lkdtm_handler(void)
 {
+	unsigned long flags;
+
+	spin_lock_irqsave(&count_lock, flags);
 	count--;
 	printk(KERN_INFO "lkdtm: Crash point %s of type %s hit, trigger in %d rounds\n",
 			cp_name_to_str(cpoint), cp_type_to_str(cptype), count);
@@ -357,6 +364,7 @@ static void lkdtm_handler(void)
 		lkdtm_do_action(cptype);
 		count = cpoint_count;
 	}
+	spin_unlock_irqrestore(&count_lock, flags);
 }
 
 static int lkdtm_register_cpoint(enum cname which)
-- 
1.7.0.4

