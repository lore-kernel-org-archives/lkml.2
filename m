Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756472Ab2CAXRQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 18:17:16 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:51815 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754481Ab2CAXRP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 18:17:15 -0500
Date: Thu, 1 Mar 2012 15:17:14 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Siddhesh Poyarekar <siddhesh.poyarekar@gmail.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Jamie Lokier <jamie@shareable.org>, Mike Frysinger <vapier@gentoo.org>,
        Alexey Dobriyan <adobriyan@gmail.com>, Matt Mackall <mpm@selenic.com>,
        linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 2/2] procfs: Mark stack vma with pid of the owning task
Message-Id: <20120301151714.72434a0a.akpm@linux-foundation.org>
In-Reply-To: <1330579259-3456-2-git-send-email-siddhesh.poyarekar@gmail.com>
References: <20120228174049.GA11136@redhat.com>
	<201202241112.46337.vapier@gentoo.org>
	<1330579259-3456-1-git-send-email-siddhesh.poyarekar@gmail.com>
	<1330579259-3456-2-git-send-email-siddhesh.poyarekar@gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  1 Mar 2012 10:50:59 +0530
Siddhesh Poyarekar <siddhesh.poyarekar@gmail.com> wrote:

> --- a/fs/proc/task_mmu.c
> +++ b/fs/proc/task_mmu.c
> @@ -262,8 +262,14 @@ show_map_vma(struct seq_file *m, struct vm_area_struct *vma, int is_pid)
>  				if (vma->vm_start <= mm->brk &&
>  						vma->vm_end >= mm->start_brk) {
>  					name = "[heap]";
> -				} else if (vm_is_stack(task, vma, is_pid)) {
> -					name = "[stack]";
> +				} else {
> +					pid_t tid =
> +						vm_is_stack(task, vma, is_pid);
> +					if (tid != 0) {
> +						pad_len_spaces(m, len);
> +						seq_printf(m, "[stack:%d]",
> +								tid);
> +					}

Well, the 80-column police police will get you there, and it is pretty silly-looking.


We can avoid the first line break by doing

					pid_t tid;

					tid = vm_is_stack(task, vma, is_pid);

nice and easy!

And we can avoid the other by saving a whole tabstop:

--- a/fs/proc/task_mmu.c~procfs-mark-stack-vma-with-pid-of-the-owning-task-fix
+++ a/fs/proc/task_mmu.c
@@ -222,6 +222,7 @@ show_map_vma(struct seq_file *m, struct 
 	unsigned long start, end;
 	dev_t dev = 0;
 	int len;
+	const char *name;
 
 	if (file) {
 		struct inode *inode = vma->vm_file->f_path.dentry->d_inode;
@@ -255,31 +256,33 @@ show_map_vma(struct seq_file *m, struct 
 	if (file) {
 		pad_len_spaces(m, len);
 		seq_path(m, &file->f_path, "\n");
-	} else {
-		const char *name = arch_vma_name(vma);
-		if (!name) {
-			if (mm) {
-				if (vma->vm_start <= mm->brk &&
-						vma->vm_end >= mm->start_brk) {
-					name = "[heap]";
-				} else {
-					pid_t tid =
-						vm_is_stack(task, vma, is_pid);
-					if (tid != 0) {
-						pad_len_spaces(m, len);
-						seq_printf(m, "[stack:%d]",
-								tid);
-					}
-				}
+		goto out;
+	}
+
+	name = arch_vma_name(vma);
+	if (!name) {
+		if (mm) {
+			if (vma->vm_start <= mm->brk &&
+					vma->vm_end >= mm->start_brk) {
+				name = "[heap]";
 			} else {
-				name = "[vdso]";
+				pid_t tid;
+
+				tid = vm_is_stack(task, vma, is_pid);
+				if (tid != 0) {
+					pad_len_spaces(m, len);
+					seq_printf(m, "[stack:%d]", tid);
+				}
 			}
-		}
-		if (name) {
-			pad_len_spaces(m, len);
-			seq_puts(m, name);
+		} else {
+			name = "[vdso]";
 		}
 	}
+	if (name) {
+		pad_len_spaces(m, len);
+		seq_puts(m, name);
+	}
+out:
 	seq_putc(m, '\n');
 }

Which is not the prettiest thing in the world, but it gets the job done.


