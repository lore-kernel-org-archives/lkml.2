Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756159Ab0IXNKA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 09:10:00 -0400
Received: from usindmx04.hds.com ([207.126.252.15]:33114 "EHLO
	usindmx04.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755756Ab0IXNJ6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 09:09:58 -0400
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        "simon.kagstrom@netinsight.net" <simon.kagstrom@netinsight.net>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Satoru Moriya <satoru.moriya@hds.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        "David.Woodhouse@intel.com" <David.Woodhouse@intel.com>,
        "anton@samba.org" <anton@samba.org>,
        "ben@decadent.org.uk" <ben@decadent.org.uk>,
        "randy.dunlap@oracle.com" <randy.dunlap@oracle.com>,
        "jason.wessel@windriver.com" <jason.wessel@windriver.com>
Date: Fri, 24 Sep 2010 09:08:14 -0400
Subject: [RFC][PATCH] Fix kexec abort due to IPI from panic().
Thread-Topic: [RFC][PATCH] Fix kexec abort due to IPI from panic().
Thread-Index: ActV9NeRGIQilg9bRH6SmEJa3/stIgF89wvw
Message-ID: <5C4C569E8A4B9B42A84A977CF070A35B2C0DCFFB3E@USINDEVS01.corp.hds.com>
References: <5C4C569E8A4B9B42A84A977CF070A35B2C0979C90E@USINDEVS01.corp.hds.com>
 <m1wrql2sf1.fsf@fess.ebiederm.org>
In-Reply-To: <m1wrql2sf1.fsf@fess.ebiederm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eric,

This is a patch which makes kmsg_dump() non-blocking.
Please give me your comments and suggestions.

I improved it as follows.

(1) Improvement of dump_list_lock
    (1-1) I changed dump_list to RCU for deleting dump_list_lock in kmsg_dump().
    (1-2) I moved kmsg_dump(KMSG_DUMP_KEXEC) behind machine_crash_shutdown() 
          for avoiding concurrent execution of dump_list functions.
    (1-3) I also moved kmsg_dump(KMSG_DUMP_PANIC) behind smp_send_stop() for the 
          same reason.
 
(2) Improvement of logbuf_lock
    I added spinlock_init(&logbuf_lock) when executing kmsg_dump() in kexec or panic path
    for preventing dead lock.

We can delete blocking kmsg_dump call in crash_kexec and panic path.

 Signed-off-by: Seiji Aguchi <seiji.aguchi@hds.com>

---
 kernel/kexec.c  |   10 ++++++++--
 kernel/panic.c  |    4 ++--
 kernel/printk.c |   19 ++++++++++---------
 3 files changed, 20 insertions(+), 13 deletions(-)

diff --git a/kernel/kexec.c b/kernel/kexec.c
index c0613f7..fdc6bfc 100644
--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -1075,16 +1075,22 @@ void crash_kexec(struct pt_regs *regs)
 	 * sufficient.  But since I reuse the memory...
 	 */
 	if (mutex_trylock(&kexec_mutex)) {
+		unsigned long flags;
+
+		local_irq_save(flags);
+
 		if (kexec_crash_image) {
 			struct pt_regs fixed_regs;
 
-			kmsg_dump(KMSG_DUMP_KEXEC);
-
 			crash_setup_regs(&fixed_regs, regs);
 			crash_save_vmcoreinfo();
 			machine_crash_shutdown(&fixed_regs);
+			kmsg_dump(KMSG_DUMP_KEXEC);
 			machine_kexec(kexec_crash_image);
 		}
+
+		local_irq_restore(flags);
+
 		mutex_unlock(&kexec_mutex);
 	}
 }
diff --git a/kernel/panic.c b/kernel/panic.c
index 4c13b1a..e14d1d6 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -87,8 +87,6 @@ NORET_TYPE void panic(const char * fmt, ...)
 	 */
 	crash_kexec(NULL);
 
-	kmsg_dump(KMSG_DUMP_PANIC);
-
 	/*
 	 * Note smp_send_stop is the usual smp shutdown function, which
 	 * unfortunately means it may not be hardened to work in a panic
@@ -96,6 +94,8 @@ NORET_TYPE void panic(const char * fmt, ...)
 	 */
 	smp_send_stop();
 
+	kmsg_dump(KMSG_DUMP_PANIC);
+
 	atomic_notifier_call_chain(&panic_notifier_list, 0, buf);
 
 	bust_spinlocks(0);
diff --git a/kernel/printk.c b/kernel/printk.c
index 8fe465a..6d6b09f 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -1478,7 +1478,7 @@ int kmsg_dump_register(struct kmsg_dumper *dumper)
 	/* Don't allow registering multiple times */
 	if (!dumper->registered) {
 		dumper->registered = 1;
-		list_add_tail(&dumper->list, &dump_list);
+		list_add_tail_rcu(&dumper->list, &dump_list);
 		err = 0;
 	}
 	spin_unlock_irqrestore(&dump_list_lock, flags);
@@ -1502,10 +1502,11 @@ int kmsg_dump_unregister(struct kmsg_dumper *dumper)
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
@@ -1541,6 +1542,10 @@ void kmsg_dump(enum kmsg_dump_reason reason)
 	unsigned long l1, l2;
 	unsigned long flags;
 
+
+	if (reason == KMSG_DUMP_KEXEC || reason == KMSG_DUMP_PANIC)
+		spin_lock_init(&logbuf_lock);
+
 	/* Theoretically, the log could move on after we do this, but
 	   there's not a lot we can do about that. The new messages
 	   will overwrite the start of what we dump. */
@@ -1563,13 +1568,9 @@ void kmsg_dump(enum kmsg_dump_reason reason)
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
-- 
1.7.2.2


Seiji
