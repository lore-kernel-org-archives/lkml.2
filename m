Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754296Ab2FFF1V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 01:27:21 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:42232 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754105Ab2FFF1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 01:27:19 -0400
From: Wanpeng Li <liwp.linux@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Fengguang Wu <fengguang.wu@intel.com>, Rob Landley <rob@landley.net>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Eric W.Biederman" <ebiederm@xmission.com>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        "David S. Miller" <davem@davemloft.net>, Jan Kara <jack@suse.cz>,
        Mel Gorman <mgorman@suse.de>, Minchan Kim <minchan.kim@gmail.com>,
        James Morris <james.l.morris@oracle.com>, Ingo Molnar <mingo@elte.hu>,
        Michel Lespinasse <walken@google.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Gavin Shan <shangw@linux.vnet.ibm.com>,
        Wanpeng Li <liwp.linux@gmail.com>,
        Wanpeng Li <liwp@linux.vnet.ibm.com>
Subject: [PATCH v3] remove no longer use of pdflush interface
Date: Wed,  6 Jun 2012 13:26:25 +0800
Message-Id: <1338960385-14127-1-git-send-email-liwp.linux@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wanpeng Li <liwp@linux.vnet.ibm.com>

Since per-BDI flusher introduced to linux 2.6, pdflush mechanism is not
used any more. But the old interface of pdflush exported in /proc/sys/vm/
is still there. In order to take attention to back-compatibility issues,
printk warning information and return -ENOSYS to notice the users the
interface is removed.

Signed-off-by: Wanpeng Li <liwp@linux.vnet.ibm.com>

------------------

v3:

* rename proc_deprecated() to proc_obsolete()
* replace printk in proc_obsolete by prink_once and change warning information

v2:

* add printk warning
* add description in Documentation

v1:

* remove nr_pdflush_threads associated codes

------------------
---
 .../ABI/obsolete/proc-sys-vm-nr_pdflush_threads    |    5 +++++
 Documentation/feature-removal-schedule.txt         |    8 ++++++++
 Documentation/sysctl/vm.txt                        |   11 -----------
 fs/fs-writeback.c                                  |    5 -----
 include/linux/sysctl.h                             |    3 +++
 include/linux/writeback.h                          |    5 -----
 kernel/sysctl.c                                    |   18 +++++++++++++-----
 kernel/sysctl_binary.c                             |    2 +-
 8 files changed, 30 insertions(+), 27 deletions(-)
 create mode 100644 Documentation/ABI/obsolete/proc-sys-vm-nr_pdflush_threads

diff --git a/Documentation/ABI/obsolete/proc-sys-vm-nr_pdflush_threads b/Documentation/ABI/obsolete/proc-sys-vm-nr_pdflush_threads
new file mode 100644
index 0000000..edbe548
--- /dev/null
+++ b/Documentation/ABI/obsolete/proc-sys-vm-nr_pdflush_threads
@@ -0,0 +1,5 @@
+What:		/proc/sys/vm/nr_pdflush_threads
+Date:		June 2012
+Contact:	Wanpeng Li <liwp@linux.vnet.ibm.com>
+Description: Since pdflush is replaced by per-BDI flusher, the interface of old pdflush  
+             exported in /proc/sys/vm/ should be removed.
diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index 56000b3..8e4a60c 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -13,6 +13,14 @@ Who:	Jim Cromie <jim.cromie@gmail.com>, Jason Baron <jbaron@redhat.com>
 
 ---------------------------
 
+What: /proc/sys/vm/nr_pdflush_threads
+When: 2012
+Why: Since pdflush is deprecated, the interface exported in /proc/sys/vm/
+     should be removed.
+Who: Wanpeng Li <liwp@linux.vnet.ibm.com>
+
+---------------------------
+
 What:	CONFIG_APM_CPU_IDLE, and its ability to call APM BIOS in idle
 When:	2012
 Why:	This optional sub-feature of APM is of dubious reliability,
diff --git a/Documentation/sysctl/vm.txt b/Documentation/sysctl/vm.txt
index 96f0ee8..71c17d2 100644
--- a/Documentation/sysctl/vm.txt
+++ b/Documentation/sysctl/vm.txt
@@ -42,7 +42,6 @@ Currently, these files are in /proc/sys/vm:
 - mmap_min_addr
 - nr_hugepages
 - nr_overcommit_hugepages
-- nr_pdflush_threads
 - nr_trim_pages         (only if CONFIG_MMU=n)
 - numa_zonelist_order
 - oom_dump_tasks
@@ -426,16 +425,6 @@ See Documentation/vm/hugetlbpage.txt
 
 ==============================================================
 
-nr_pdflush_threads
-
-The current number of pdflush threads.  This value is read-only.
-The value changes according to the number of dirty pages in the system.
-
-When necessary, additional pdflush threads are created, one per second, up to
-nr_pdflush_threads_max.
-
-==============================================================
-
 nr_trim_pages
 
 This is available only on NOMMU kernels.
diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 8d2fb8c..f2d0109 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -52,11 +52,6 @@ struct wb_writeback_work {
 	struct completion *done;	/* set if the caller waits */
 };
 
-/*
- * We don't actually have pdflush, but this one is exported though /proc...
- */
-int nr_pdflush_threads;
-
 /**
  * writeback_in_progress - determine whether there is writeback in progress
  * @bdi: the device's backing_dev_info structure.
diff --git a/include/linux/sysctl.h b/include/linux/sysctl.h
index c34b4c8..5fa7bfa 100644
--- a/include/linux/sysctl.h
+++ b/include/linux/sysctl.h
@@ -964,6 +964,9 @@ extern int proc_doulongvec_ms_jiffies_minmax(struct ctl_table *table, int,
 				      void __user *, size_t *, loff_t *);
 extern int proc_do_large_bitmap(struct ctl_table *, int,
 				void __user *, size_t *, loff_t *);
+extern int proc_obsolete(struct ctl_table *, int, 
+				void __user *, size_t *, loff_t *);
+
 
 /*
  * Register a set of sysctl names by calling register_sysctl_table
diff --git a/include/linux/writeback.h b/include/linux/writeback.h
index 6d0a0fc..c66fe33 100644
--- a/include/linux/writeback.h
+++ b/include/linux/writeback.h
@@ -189,9 +189,4 @@ void tag_pages_for_writeback(struct address_space *mapping,
 
 void account_page_redirty(struct page *page);
 
-/* pdflush.c */
-extern int nr_pdflush_threads;	/* Global so it can be exported to sysctl
-				   read-only. */
-
-
 #endif		/* WRITEBACK_H */
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 4ab1187..8d95a54 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1095,11 +1095,9 @@ static struct ctl_table vm_table[] = {
 		.extra1		= &zero,
 	},
 	{
-		.procname	= "nr_pdflush_threads",
-		.data		= &nr_pdflush_threads,
-		.maxlen		= sizeof nr_pdflush_threads,
-		.mode		= 0444 /* read-only*/,
-		.proc_handler	= proc_dointvec,
+		.procname       = "nr_pdflush_threads",
+		.mode           = 0444 /* read-only */,
+		.proc_handler   = proc_obsolete,
 	},
 	{
 		.procname	= "swappiness",
@@ -2505,6 +2503,15 @@ int proc_doulongvec_ms_jiffies_minmax(struct ctl_table *table, int write,
 
 #endif /* CONFIG_PROC_SYSCTL */
 
+/* notice associated proc obsoleted */
+int proc_obsolete(struct ctl_table *table, int write,
+		    void __user *buffer, size_t *lenp, loff_t *ppos)
+{
+	printk_once(KERN_WARNING "%s exported in /proc is scheduled for removal\n", 
+			table->procname);
+	return -ENOSYS;
+}
+
 /*
  * No sense putting this after each symbol definition, twice,
  * exception granted :-)
@@ -2517,3 +2524,4 @@ EXPORT_SYMBOL(proc_dointvec_ms_jiffies);
 EXPORT_SYMBOL(proc_dostring);
 EXPORT_SYMBOL(proc_doulongvec_minmax);
 EXPORT_SYMBOL(proc_doulongvec_ms_jiffies_minmax);
+EXPORT_SYMBOL(proc_obsolete);
diff --git a/kernel/sysctl_binary.c b/kernel/sysctl_binary.c
index a650694..65bdcf1 100644
--- a/kernel/sysctl_binary.c
+++ b/kernel/sysctl_binary.c
@@ -147,7 +147,7 @@ static const struct bin_table bin_vm_table[] = {
 	{ CTL_INT,	VM_DIRTY_RATIO,			"dirty_ratio" },
 	/* VM_DIRTY_WB_CS "dirty_writeback_centisecs" no longer used */
 	/* VM_DIRTY_EXPIRE_CS "dirty_expire_centisecs" no longer used */
-	{ CTL_INT,	VM_NR_PDFLUSH_THREADS,		"nr_pdflush_threads" },
+	/* VM_NR_PDFLUSH_THREADS "nr_pdflush_threads" no longer used */
 	{ CTL_INT,	VM_OVERCOMMIT_RATIO,		"overcommit_ratio" },
 	/* VM_PAGEBUF unused */
 	/* VM_HUGETLB_PAGES "nr_hugepages" no longer used */
-- 
1.7.9.5

