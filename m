Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752069Ab0LVLWu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 06:22:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58606 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751813Ab0LVLWt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 06:22:49 -0500
From: Amerigo Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: WANG Cong <amwang@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        Neil Horman <nhorman@tuxdriver.com>,
        WANG Cong <xiyou.wangcong@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Dan Carpenter <error27@gmail.com>, Tejun Heo <tj@kernel.org>
Subject: [RFC Patch] kcore: restrict access to the whole memory
Date: Wed, 22 Dec 2010 19:21:59 +0800
Message-Id: <1293016926-1714-1-git-send-email-amwang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch restricts /proc/kcore from accessing the whole memory,
instead, only an ELF header can be read.

The initial patch was done by Vivek.

Signed-off-by: WANG Cong <amwang@redhat.com>

---
diff --git a/fs/proc/Kconfig b/fs/proc/Kconfig
index 6a00688..2fd1df1 100644
--- a/fs/proc/Kconfig
+++ b/fs/proc/Kconfig
@@ -32,6 +32,14 @@ config PROC_KCORE
 	bool "/proc/kcore support" if !ARM
 	depends on PROC_FS && MMU
 
+config STRICT_PROC_KCORE
+	bool "Only export an ELF header from /proc/kcore"
+	depends on PROC_KCORE
+	default n
+	help
+	If this option is enabled, only an ELF header can be read from
+	/proc/kcore, instead of a whole ELF image.
+
 config PROC_VMCORE
 	bool "/proc/vmcore support"
 	depends on PROC_FS && CRASH_DUMP
diff --git a/fs/proc/kcore.c b/fs/proc/kcore.c
index 6f37c39..c45ff00 100644
--- a/fs/proc/kcore.c
+++ b/fs/proc/kcore.c
@@ -90,7 +90,12 @@ static size_t get_kcore_size(int *nphdr, size_t *elf_buflen)
 			roundup(sizeof(struct elf_prpsinfo), 4) +
 			roundup(sizeof(struct task_struct), 4);
 	*elf_buflen = PAGE_ALIGN(*elf_buflen);
+#ifdef CONFIG_STRICT_PROC_KCORE
+	return *elf_buflen;
+#else
 	return size + *elf_buflen;
+#endif
+
 }
 
 static void free_kclist_ents(struct list_head *head)
@@ -429,7 +434,7 @@ read_kcore(struct file *file, char __user *buffer, size_t buflen, loff_t *fpos)
 	size_t size, tsz;
 	size_t elf_buflen;
 	int nphdr;
-	unsigned long start;
+	unsigned long __maybe_unused start;
 
 	read_lock(&kclist_lock);
 	size = get_kcore_size(&nphdr, &elf_buflen);
@@ -473,6 +478,9 @@ read_kcore(struct file *file, char __user *buffer, size_t buflen, loff_t *fpos)
 	} else
 		read_unlock(&kclist_lock);
 
+#ifdef CONFIG_STRICT_PROC_KCORE
+	return acc;
+#else
 	/*
 	 * Check to see if our file offset matches with any of
 	 * the addresses in the elf_phdr on our list.
@@ -537,6 +545,7 @@ read_kcore(struct file *file, char __user *buffer, size_t buflen, loff_t *fpos)
 	}
 
 	return acc;
+#endif
 }
 
 
