Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755047Ab2BAG6z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 01:58:55 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:45487 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375Ab2BAG6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 01:58:54 -0500
From: Cong Wang <xiyou.wangcong@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <greg@kroah.com>, Dave Young <dyoung@redhat.com>
Subject: [PATCH 1/2] lkdtm: use atomic_t to replace count_lock
Date: Wed,  1 Feb 2012 14:58:19 +0800
Message-Id: <1328079501-24746-1-git-send-email-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew, this patch replaces
lkdtm-avoid-calling-lkdtm_do_action-with-spin-lock-held.patch
in your tree.

---------->

The spin lock count_lock only protects count, it can be removed by
using atomic_t. Suggested by Arnd.

Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <greg@kroah.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>

---
 drivers/misc/lkdtm.c |   19 ++++---------------
 1 files changed, 4 insertions(+), 15 deletions(-)

diff --git a/drivers/misc/lkdtm.c b/drivers/misc/lkdtm.c
index 150cd70..afdef2e 100644
--- a/drivers/misc/lkdtm.c
+++ b/drivers/misc/lkdtm.c
@@ -119,8 +119,7 @@ static int recur_count = REC_NUM_DEFAULT;
 
 static enum cname cpoint = CN_INVALID;
 static enum ctype cptype = CT_NONE;
-static int count = DEFAULT_COUNT;
-static DEFINE_SPINLOCK(count_lock);
+static atomic_t count = ATOMIC_INIT(DEFAULT_COUNT);
 
 module_param(recur_count, int, 0644);
 MODULE_PARM_DESC(recur_count, " Recursion level for the stack overflow test, "\
@@ -231,14 +230,11 @@ static const char *cp_name_to_str(enum cname name)
 static int lkdtm_parse_commandline(void)
 {
 	int i;
-	unsigned long flags;
 
 	if (cpoint_count < 1 || recur_count < 1)
 		return -EINVAL;
 
-	spin_lock_irqsave(&count_lock, flags);
-	count = cpoint_count;
-	spin_unlock_irqrestore(&count_lock, flags);
+	atomic_set(&count, cpoint_count);
 
 	/* No special parameters */
 	if (!cpoint_type && !cpoint_name)
@@ -353,18 +349,11 @@ static void lkdtm_do_action(enum ctype which)
 
 static void lkdtm_handler(void)
 {
-	unsigned long flags;
-
-	spin_lock_irqsave(&count_lock, flags);
-	count--;
 	printk(KERN_INFO "lkdtm: Crash point %s of type %s hit, trigger in %d rounds\n",
-			cp_name_to_str(cpoint), cp_type_to_str(cptype), count);
+			cp_name_to_str(cpoint), cp_type_to_str(cptype), atomic_dec_return(&count));
 
-	if (count == 0) {
+	if (!atomic_cmpxchg(&count, 0, cpoint_count))
 		lkdtm_do_action(cptype);
-		count = cpoint_count;
-	}
-	spin_unlock_irqrestore(&count_lock, flags);
 }
 
 static int lkdtm_register_cpoint(enum cname which)
-- 
1.7.7.6

