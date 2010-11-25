Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751550Ab0KYHAb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 02:00:31 -0500
Received: from mga09.intel.com ([134.134.136.24]:16389 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751146Ab0KYHAa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 02:00:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,253,1288594800"; 
   d="scan'208";a="680911801"
Subject: [PATCH] printk, Use RCU to prevent potential lock contention in
 kmsg_dump
From: Huang Ying <ying.huang@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 25 Nov 2010 15:00:28 +0800
Message-ID: <1290668428.2903.333.camel@yhuang-dev>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dump_list_lock is used to protect dump_list in kmsg_dumper
implementation, kmsg_dump() uses it to traverse dump_list too. But if
there is contention on the lock, kmsg_dump() will fail, and the
valuable kernel message may be lost.

This patch solves this issue with RCU.  Because kmsg_dump() only read
the list, no lock is needed in kmsg_dump().  So that kmsg_dump() will
never fail because of lock contention.

Signed-off-by: Huang Ying <ying.huang@intel.com>
---
 kernel/printk.c |   30 +++++++-----------------------
 1 file changed, 7 insertions(+), 23 deletions(-)

--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -39,6 +39,7 @@
 #include <linux/syslog.h>
 #include <linux/cpu.h>
 #include <linux/notifier.h>
+#include <linux/rculist.h>
 
 #include <asm/uaccess.h>
 
@@ -1498,7 +1499,7 @@ int kmsg_dump_register(struct kmsg_dumpe
 	/* Don't allow registering multiple times */
 	if (!dumper->registered) {
 		dumper->registered = 1;
-		list_add_tail(&dumper->list, &dump_list);
+		list_add_tail_rcu(&dumper->list, &dump_list);
 		err = 0;
 	}
 	spin_unlock_irqrestore(&dump_list_lock, flags);
@@ -1522,29 +1523,16 @@ int kmsg_dump_unregister(struct kmsg_dum
 	spin_lock_irqsave(&dump_list_lock, flags);
 	if (dumper->registered) {
 		dumper->registered = 0;
-		list_del(&dumper->list);
+		list_del_rcu(&dumper->list);
 		err = 0;
 	}
 	spin_unlock_irqrestore(&dump_list_lock, flags);
+	synchronize_rcu();
 
 	return err;
 }
 EXPORT_SYMBOL_GPL(kmsg_dump_unregister);
 
-static const char * const kmsg_reasons[] = {
-	[KMSG_DUMP_OOPS]	= "oops",
-	[KMSG_DUMP_PANIC]	= "panic",
-	[KMSG_DUMP_KEXEC]	= "kexec",
-};
-
-static const char *kmsg_to_str(enum kmsg_dump_reason reason)
-{
-	if (reason >= ARRAY_SIZE(kmsg_reasons) || reason < 0)
-		return "unknown";
-
-	return kmsg_reasons[reason];
-}
-
 /**
  * kmsg_dump - dump kernel log to kernel message dumpers.
  * @reason: the reason (oops, panic etc) for dumping
@@ -1583,13 +1571,9 @@ void kmsg_dump(enum kmsg_dump_reason rea
 		l2 = chars;
 	}
 
-	if (!spin_trylock_irqsave(&dump_list_lock, flags)) {
-		printk(KERN_ERR "dump_kmsg: dump list lock is held during %s, skipping dump\n",
-				kmsg_to_str(reason));
-		return;
-	}
-	list_for_each_entry(dumper, &dump_list, list)
+	rcu_read_lock();
+	list_for_each_entry_rcu(dumper, &dump_list, list)
 		dumper->dump(dumper, reason, s1, l1, s2, l2);
-	spin_unlock_irqrestore(&dump_list_lock, flags);
+	rcu_read_unlock();
 }
 #endif


