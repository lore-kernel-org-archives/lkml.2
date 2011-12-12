Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754221Ab1LLVx3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 16:53:29 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56772 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751549Ab1LLVxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 16:53:25 -0500
Date: Mon, 12 Dec 2011 13:53:23 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Kees Cook <keescook@chromium.org>, LKML <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, Andrew Vagin <avagin@openvz.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>
Subject: Re: [patch 3/3] [PATCH] prctl: Add PR_SET_MM codes to set up
 mm_struct entires v3
Message-Id: <20111212135323.2f757d9b.akpm@linux-foundation.org>
In-Reply-To: <20111212205114.GR2199@moon>
References: <20111212200642.836001668@openvz.org>
	<20111212201715.244414996@openvz.org>
	<CAGXu5jLSrwLeWoQNAA5uyWEewugnr1cWrxzH=wD9JnvZwgAggw@mail.gmail.com>
	<20111212205114.GR2199@moon>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Dec 2011 00:51:14 +0400
Cyrill Gorcunov <gorcunov@gmail.com> wrote:

> 
> When we restore a task we need to set up text, data and data
> heap sizes from userspace to the values a task had at
> checkpoint time. This patch adds auxilary prctl codes for that.
> 
> While most of them have a statistical nature (their values
> are involved into calculation of /proc/<pid>/statm output)
> the start_brk and brk values are used to compute an allowed
> size of program data segment expansion. Which means an arbitrary
> changes of this values might be dangerous operation. So to restrict
> access the following requirements applied to prctl calls:
> 
>  - The process has to have CAP_SYS_ADMIN capability granted.
>  - For all opcodes except start_brk/brk members an appropriate
>    VMA area must exist and should fit certain VMA flags,
>    such as:
>    - code segment must be executable but not writable;
>    - data segment must not be executable.
> 
> start_brk/brk values must not intersect with data segment
> and must not exceed RLIMIT_DATA resource limit.
> 
> Still the main guard is CAP_SYS_ADMIN capability check.
> 
> Note the kernel should be compiled with CONFIG_CHECKPOINT_RESTORE
> support otherwise these prctl calls will return -EINVAL.
> 
> ...
>
> +#ifdef CONFIG_CHECKPOINT_RESTORE
> +static int prctl_set_mm(int opt, unsigned long addr,
> +			unsigned long arg4, unsigned long arg5)
> +{
> +	unsigned long rlim = rlimit(RLIMIT_DATA);
> +	unsigned long vm_req_flags;
> +	unsigned long vm_bad_flags;
> +	struct vm_area_struct *vma;
> +	int error = 0;
> +
> +	if (arg4 | arg5)
> +		return -EINVAL;
> +
> +	if (!capable(CAP_SYS_ADMIN))
> +		return -EPERM;
> +
> +	if (addr >= TASK_SIZE)
> +		return -EINVAL;
> +
> +	down_read(&current->mm->mmap_sem);

This may not be true of all compiler versions, but when I cache
current->mm in a local, the code size is reduced rather a lot:

akpm:/usr/src/25> size kernel/sys.o
   text    data     bss     dec     hex filename
  22685   14376    7616   44677    ae85 kernel/sys.o
  22489   14376    7616   44481    adc1 kernel/sys.o

diff -puN kernel/sys.c~c-r-prctl-add-pr_set_mm-codes-to-set-up-mm_struct-entries-fix kernel/sys.c
--- a/kernel/sys.c~c-r-prctl-add-pr_set_mm-codes-to-set-up-mm_struct-entries-fix
+++ a/kernel/sys.c
@@ -1701,6 +1701,7 @@ static int prctl_set_mm(int opt, unsigne
 	unsigned long vm_bad_flags;
 	struct vm_area_struct *vma;
 	int error = 0;
+	struct mm_struct *mm = current->mm;
 
 	if (arg4 | arg5)
 		return -EINVAL;
@@ -1711,8 +1712,8 @@ static int prctl_set_mm(int opt, unsigne
 	if (addr >= TASK_SIZE)
 		return -EINVAL;
 
-	down_read(&current->mm->mmap_sem);
-	vma = find_vma(current->mm, addr);
+	down_read(&mm->mmap_sem);
+	vma = find_vma(mm, addr);
 
 	if (opt != PR_SET_MM_START_BRK && opt != PR_SET_MM_BRK) {
 		/* It must be existing VMA */
@@ -1732,9 +1733,9 @@ static int prctl_set_mm(int opt, unsigne
 			goto out;
 
 		if (opt == PR_SET_MM_START_CODE)
-			current->mm->start_code = addr;
+			mm->start_code = addr;
 		else
-			current->mm->end_code = addr;
+			mm->end_code = addr;
 		break;
 
 	case PR_SET_MM_START_DATA:
@@ -1747,9 +1748,9 @@ static int prctl_set_mm(int opt, unsigne
 			goto out;
 
 		if (opt == PR_SET_MM_START_DATA)
-			current->mm->start_data = addr;
+			mm->start_data = addr;
 		else
-			current->mm->end_data = addr;
+			mm->end_data = addr;
 		break;
 
 	case PR_SET_MM_START_STACK:
@@ -1762,31 +1763,31 @@ static int prctl_set_mm(int opt, unsigne
 		if ((vma->vm_flags & vm_req_flags) != vm_req_flags)
 			goto out;
 
-		current->mm->start_stack = addr;
+		mm->start_stack = addr;
 		break;
 
 	case PR_SET_MM_START_BRK:
-		if (addr <= current->mm->end_data)
+		if (addr <= mm->end_data)
 			goto out;
 
 		if (rlim < RLIM_INFINITY &&
-		    (current->mm->brk - addr) +
-		    (current->mm->end_data - current->mm->start_data) > rlim)
+		    (mm->brk - addr) +
+		    (mm->end_data - mm->start_data) > rlim)
 			goto out;
 
-		current->mm->start_brk = addr;
+		mm->start_brk = addr;
 		break;
 
 	case PR_SET_MM_BRK:
-		if (addr <= current->mm->end_data)
+		if (addr <= mm->end_data)
 			goto out;
 
 		if (rlim < RLIM_INFINITY &&
-		    (addr - current->mm->start_brk) +
-		    (current->mm->end_data - current->mm->start_data) > rlim)
+		    (addr - mm->start_brk) +
+		    (mm->end_data - mm->start_data) > rlim)
 			goto out;
 
-		current->mm->brk = addr;
+		mm->brk = addr;
 		break;
 
 	default:
@@ -1797,7 +1798,7 @@ static int prctl_set_mm(int opt, unsigne
 	error = 0;
 
 out:
-	up_read(&current->mm->mmap_sem);
+	up_read(&mm->mmap_sem);
 
 	return error;
 }
_

