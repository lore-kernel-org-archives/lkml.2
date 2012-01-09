Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755116Ab2AIHLp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 02:11:45 -0500
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:46685 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754247Ab2AIHLn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 02:11:43 -0500
Date: Mon, 9 Jan 2012 17:41:24 +1030
From: Christopher Yeoh <cyeoh@au1.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org
Cc: Chris Yeoh <yeohc@au1.ibm.com>, Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>
Subject: Re: cross memory attach && security check
Message-ID: <20120109174124.0d588b5b@Gantu.yeoh.info>
In-Reply-To: <20120105151012.GA25671@redhat.com>
References: <20120105151012.GA25671@redhat.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
x-cbid: 12010821-0260-0000-0000-0000005983B0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Jan 2012 16:10:12 +0100
Oleg Nesterov <oleg@redhat.com> wrote:
 
> Just noticed the new file in mm/ ;) A couple of questions.
> 
> process_vm_rw_core() does
> 
> 	task_lock(task);
> 	if (__ptrace_may_access(task, PTRACE_MODE_ATTACH)) {
> 		task_unlock(task);
> 		rc = -EPERM;
> 		goto put_task_struct;
> 	}
> 	mm = task->mm;
> 
> this is racy, task_lock() can't help. And I don't think you should
> use it directly.
> 
> execve() does exec_mmap() first, this switches to the new ->mm.
> After that install_exec_creds() changes task->cred. The window
> is not that small.
> 
> I guess you need ->cred_guard_mutex, please look at mm_for_maps().
> 

Thanks, agreed this looks like it's a problem. Need to do a bit more
testing, but I think the following patch fixes the race?

Signed-off-by: Chris Yeoh <yeohc@au1.ibm.com>
 process_vm_access.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/mm/process_vm_access.c b/mm/process_vm_access.c
index e920aa3..207d7cc 100644
--- a/mm/process_vm_access.c
+++ b/mm/process_vm_access.c
@@ -298,9 +298,14 @@ static ssize_t process_vm_rw_core(pid_t pid, const struct iovec *lvec,
 		goto free_proc_pages;
 	}
 
+	rc = mutex_lock_interruptible(&task->signal->cred_guard_mutex);
+	if (rc)
+		goto put_task_struct;
+
 	task_lock(task);
 	if (__ptrace_may_access(task, PTRACE_MODE_ATTACH)) {
 		task_unlock(task);
+		mutex_unlock(&task->signal->cred_guard_mutex);
 		rc = -EPERM;
 		goto put_task_struct;
 	}
@@ -308,12 +313,14 @@ static ssize_t process_vm_rw_core(pid_t pid, const struct iovec *lvec,
 
 	if (!mm || (task->flags & PF_KTHREAD)) {
 		task_unlock(task);
+		mutex_unlock(&task->signal->cred_guard_mutex);
 		rc = -EINVAL;
 		goto put_task_struct;
 	}
 
 	atomic_inc(&mm->mm_users);
 	task_unlock(task);
+	mutex_unlock(&task->signal->cred_guard_mutex);
 
 	for (i = 0; i < riovcnt && iov_l_curr_idx < liovcnt; i++) {
 		rc = process_vm_rw_single_vec(

> Another question, process_vm_rw_pages() does get_user_pages() without
> FOLL_FORCE. Is this on purpose? This limits the usage of the new
> syscalls.

Other than reading the comment for get_user_pages saying that I don't want
to set the force flag, I didn't really consider it. The use cases where I'm
interested (intranode communication) has the cooperation of the target process 
anyway so its not needed. Any downsides to having FOLL_FORCE enabled?

> Hmm. And could you please explain the change in
> rw_copy_check_uvector()? Why process_vm_rw() does
> rw_copy_check_uvector(READ, rvec, check_access => 0) ?

process_vm_readv/writev get passed an iovec for another process which 
describes where to read/write from/to. So we need to do part of what
rw_copy_check_uvector ordinarily does (validate and copy the iovec
data), but we don't want to check the memory it points to at this point
because it refers to memory in the other process (this check is done later).

So the change to rw_copy_check_uvector to optionally not do this second check
allows us to reuse the code rather than have another function which is almost
identical.

Regards,

Chris
-- 
cyeoh@au.ibm.com

