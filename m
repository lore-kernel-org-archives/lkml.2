Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756854Ab0HPVHo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 17:07:44 -0400
Received: from mail.windriver.com ([147.11.1.11]:34503 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756007Ab0HPVHl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 17:07:41 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
        Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 1/5] kdb: fix compile error without CONFIG_KALLSYMS
Date: Mon, 16 Aug 2010 16:06:25 -0500
Message-Id: <1281992789-2471-2-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1281992789-2471-1-git-send-email-jason.wessel@windriver.com>
References: <1281992789-2471-1-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 16 Aug 2010 21:06:35.0697 (UTC) FILETIME=[E92A5A10:01CB3D86]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If CONFIG_KGDB_KDB is set and CONFIG_KALLSYMS is not set the kernel
will fail to build with the error:

kernel/built-in.o: In function `kallsyms_symbol_next':
kernel/debug/kdb/kdb_support.c:237: undefined reference to `kdb_walk_kallsyms'
kernel/built-in.o: In function `kallsyms_symbol_complete':
kernel/debug/kdb/kdb_support.c:193: undefined reference to `kdb_walk_kallsyms'

The kdb_walk_kallsyms needs a #ifdef proper header to match the C
implementation.  This patch also fixes the compiler warnings in
kdb_support.c when compiling without CONFIG_KALLSYMS set.  The
compiler warnings are a result of the kallsyms_lookup() macro not
initializing the two of the pass by reference variables.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
Reported-by: Michal Simek <monstr@monstr.eu>
---
 kernel/debug/kdb/kdb_private.h |    7 +++++++
 kernel/debug/kdb/kdb_support.c |    4 ++--
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/kernel/debug/kdb/kdb_private.h b/kernel/debug/kdb/kdb_private.h
index c438f54..be775f7 100644
--- a/kernel/debug/kdb/kdb_private.h
+++ b/kernel/debug/kdb/kdb_private.h
@@ -255,7 +255,14 @@ extern void kdb_ps1(const struct task_struct *p);
 extern void kdb_print_nameval(const char *name, unsigned long val);
 extern void kdb_send_sig_info(struct task_struct *p, struct siginfo *info);
 extern void kdb_meminfo_proc_show(void);
+#ifdef CONFIG_KALLSYMS
 extern const char *kdb_walk_kallsyms(loff_t *pos);
+#else /* ! CONFIG_KALLSYMS */
+static inline const char *kdb_walk_kallsyms(loff_t *pos)
+{
+	return NULL;
+}
+#endif /* ! CONFIG_KALLSYMS */
 extern char *kdb_getstr(char *, size_t, char *);
 
 /* Defines for kdb_symbol_print */
diff --git a/kernel/debug/kdb/kdb_support.c b/kernel/debug/kdb/kdb_support.c
index 45344d5..6b2485d 100644
--- a/kernel/debug/kdb/kdb_support.c
+++ b/kernel/debug/kdb/kdb_support.c
@@ -82,8 +82,8 @@ static char *kdb_name_table[100];	/* arbitrary size */
 int kdbnearsym(unsigned long addr, kdb_symtab_t *symtab)
 {
 	int ret = 0;
-	unsigned long symbolsize;
-	unsigned long offset;
+	unsigned long symbolsize = 0;
+	unsigned long offset = 0;
 #define knt1_size 128		/* must be >= kallsyms table size */
 	char *knt1 = NULL;
 
-- 
1.6.3.3

