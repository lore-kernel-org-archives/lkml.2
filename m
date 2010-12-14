Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759166Ab0LNKYS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 05:24:18 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:58672 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756896Ab0LNKYQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 05:24:16 -0500
Date: Tue, 14 Dec 2010 15:54:25 +0530
From: "Suzuki K. Poulose" <suzuki@in.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: "Suzuki K. Poulose" <suzuki@in.ibm.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Christoph Hellwig <hch@lst.de>, Masami Hiramatsu <mhiramat@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Daisuke HATAYAMA <d.hatayama@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>, Roland McGrath <roland@redhat.com>,
        Amerigo Wang <amwang@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [Patch 19/21] Identify the ELF class of the process
Message-ID: <20101214155425.58d13c3e@suzukikp>
In-Reply-To: <20101214152259.67896960@suzukikp>
References: <20101214152259.67896960@suzukikp>
Organization: IBM
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Identify the ELF class of the process to native or compat.

Signed-off-by: Suzuki K. Poulose <suzuki@in.ibm.com>
---
 fs/proc/gencore.c |   17 +++++++++++++----
 fs/proc/gencore.h |    3 +++
 2 files changed, 16 insertions(+), 4 deletions(-)

Index: linux-2.6.36-rc7/fs/proc/gencore.c
===================================================================
--- linux-2.6.36-rc7.orig/fs/proc/gencore.c
+++ linux-2.6.36-rc7/fs/proc/gencore.c
@@ -106,7 +106,8 @@ static ssize_t read_gencore(struct file 
 	}
 	mutex_unlock(&core_mutex);
 
-	ret = elf_read_gencore(cp, buffer, buflen, fpos);
+	if (cp->elf_class == ELF_CLASS_NATIVE)
+		ret = elf_read_gencore(cp, buffer, buflen, fpos);
 
 out:
 	put_task_struct(task);
@@ -177,8 +178,8 @@ static int release_gencore(struct inode 
 /*
  * Determine whether the task is an ELF executable.
  * Returns
- * 	< 0	- Non-ELF
- * 	0 	- Native ELF Executable
+ * 	-EINVAL - On non ELF execs
+ * 	Returns the ELF_CLASS_NATIVE or ELF_CLASS_COMPAT
  */
 static int get_elf_class(struct task_struct *task)
 {
@@ -193,8 +194,15 @@ static int get_elf_class(struct task_str
 	if (memcmp(hdr.e_ident, ELFMAG, SELFMAG))
 		return -EINVAL;
 	if (elf_check_arch(&hdr))
-		return 0;
+		return ELF_CLASS_NATIVE;
 
+#ifdef CONFIG_COMPAT_BINFMT_ELF
+	{
+		struct elf32_hdr *chdr = (struct elf32_hdr *)&hdr;
+		if (compat_elf_check_arch(chdr))
+			return ELF_CLASS_COMPAT;
+	}
+#endif
 	return -EINVAL;
 }
 
@@ -238,6 +246,7 @@ static int open_gencore(struct inode *in
 	INIT_LIST_HEAD(&cp->list);
 	list_add(&cp->list, &core_list);
 	mutex_unlock(&core_mutex);
+	cp->elf_class = elf_class;
 
 	max_regset = get_max_regsets(task);
 
Index: linux-2.6.36-rc7/fs/proc/gencore.h
===================================================================
--- linux-2.6.36-rc7.orig/fs/proc/gencore.h
+++ linux-2.6.36-rc7/fs/proc/gencore.h
@@ -6,6 +6,8 @@
 #include <linux/elfcore.h>
 #include <linux/elfcore-internal.h>
 
+enum { ELF_CLASS_NATIVE, ELF_CLASS_COMPAT };
+
 struct elf_thread_core_info {
 	unsigned short frozen;
 	unsigned short num_notes;	/* Number of notes for this thread */
@@ -28,6 +30,7 @@ struct core_proc {
 	size_t nphdrs;		/* number of phdrs */
 	size_t notes_size;
 	size_t size;
+	unsigned char elf_class;
 };
 
 extern void try_to_freeze_core_threads(struct core_proc *cp);
