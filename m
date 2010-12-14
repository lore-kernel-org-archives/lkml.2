Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759041Ab0LNKBa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 05:01:30 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:43665 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758663Ab0LNKB1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 05:01:27 -0500
Date: Tue, 14 Dec 2010 15:31:35 +0530
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
Subject: [Patch 4/21] Make fill_psinfo generic
Message-ID: <20101214153135.5f4423e0@suzukikp>
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

fill_psinfo() fills the NT_PRPSINFO note for the core. NT_PRPSINFO stores the 
command line of the process, which is stored at from mm->arg_start. Make 
fill_psinfo reusable by supporting other tasks. Use access_process_vm() to read 
the command line args for non-current task. 

Signed-off-by: Suzuki K. Poulose <suzuki@in.ibm.com>
---
 fs/binfmt_elf.c |   17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

Index: linux-2.6.36-rc7/fs/binfmt_elf.c
===================================================================
--- linux-2.6.36-rc7.orig/fs/binfmt_elf.c
+++ linux-2.6.36-rc7/fs/binfmt_elf.c
@@ -1211,9 +1211,20 @@ static int fill_psinfo(struct elf_prpsin
 	len = mm->arg_end - mm->arg_start;
 	if (len >= ELF_PRARGSZ)
 		len = ELF_PRARGSZ-1;
-	if (copy_from_user(&psinfo->pr_psargs,
-		           (const char __user *)mm->arg_start, len))
-		return -EFAULT;
+	/*
+	 * If we are dumping core for "another task"
+	 * we can't use copy_from_user().
+	 */
+	if (p->group_leader == current->group_leader) {
+		if (copy_from_user(&psinfo->pr_psargs,
+			           (const char __user *)mm->arg_start, len))
+			return -EFAULT;
+	} else {
+		int bytes = access_process_vm(p, mm->arg_start,
+						&psinfo->pr_psargs, len, 0);
+		if (bytes != len)
+			return -EFAULT;
+	}
 	for(i = 0; i < len; i++)
 		if (psinfo->pr_psargs[i] == 0)
 			psinfo->pr_psargs[i] = ' ';
