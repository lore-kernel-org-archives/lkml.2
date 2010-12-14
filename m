Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759175Ab0LNKNi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 05:13:38 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:54705 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753953Ab0LNKNg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 05:13:36 -0500
Date: Tue, 14 Dec 2010 15:43:44 +0530
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
Subject: [Patch 12/21] Check if the process is an ELF executable
Message-ID: <20101214154344.5c2b4737@suzukikp>
In-Reply-To: <20101214152259.67896960@suzukikp>
References: <20101214152259.67896960@suzukikp>
Organization: IBM
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Validate if the process is an ELF exec. This will be later extended to identify 
if the task is a native ELF or a compat ELF.

Signed-off-by: Suzuki K. Poulose <suzuki@in.ibm.com>
---
 fs/proc/gencore.c |   31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

Index: linux-2.6.36-rc7/fs/proc/gencore.c
===================================================================
--- linux-2.6.36-rc7.orig/fs/proc/gencore.c
+++ linux-2.6.36-rc7/fs/proc/gencore.c
@@ -23,6 +23,8 @@
  */
 
 #include <linux/seq_file.h>
+#include <linux/elf.h>
+
 #include "internal.h"
 #include "gencore.h"
 
@@ -85,6 +87,30 @@ static int release_gencore(struct inode 
 }
 
 /*
+ * Determine whether the task is an ELF executable.
+ * Returns
+ * 	< 0	- Non-ELF
+ * 	0 	- Native ELF Executable
+ */
+static int get_elf_class(struct task_struct *task)
+{
+	struct elfhdr hdr;
+	int ret = 0;
+
+	ret = kernel_read(task->mm->exe_file, 0, (char*)&hdr, sizeof(hdr));
+	if (ret < 0)
+		return ret;
+
+	/* Verify the ELF magic on the exe_file */
+	if (memcmp(hdr.e_ident, ELFMAG, SELFMAG))
+		return -EINVAL;
+	if (elf_check_arch(&hdr))
+		return 0;
+
+	return -EINVAL;
+}
+
+/*
  * Validate if the call is valid. We also need to prevent >1 open
  * of the same file.
  */
@@ -93,10 +119,15 @@ static int open_gencore(struct inode *in
 	struct task_struct *task = get_proc_task(inode);
 	struct core_proc *cp;
 	int ret = 0;
+	int elf_class;
 
 	if (!task)
 		return -ENOENT;
 
+	elf_class = get_elf_class(task);
+	if (elf_class < 0)
+		return elf_class;
+
 	mutex_lock(&core_mutex);
 	cp = get_core_proc(task);
 	if (cp) {
