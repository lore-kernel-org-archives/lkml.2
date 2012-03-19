Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757481Ab2CSWPL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 18:15:11 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53530 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756989Ab2CSWPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 18:15:08 -0400
Date: Mon, 19 Mar 2012 15:15:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Kees Cook <keescook@chromium.org>, Tejun Heo <tj@kernel.org>,
        Matt Helsley <matthltc@us.ibm.com>
Subject: Re: [patch 1/2] c/r: prctl: Add ability to set new
 mm_struct::exe_file
Message-Id: <20120319151507.93bab32a.akpm@linux-foundation.org>
In-Reply-To: <20120316210343.925446961@openvz.org>
References: <20120316205556.595309230@openvz.org>
	<20120316210343.925446961@openvz.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 17 Mar 2012 00:55:57 +0400
Cyrill Gorcunov <gorcunov@openvz.org> wrote:

> When we do restore we would like to have a way to setup
> a former mm_struct::exe_file so that /proc/pid/exe would
> point to the original executable file a process had at
> checkpoint time.
> 
> For this the PR_SET_MM_EXE_FILE code is introduced.
> This option takes a file descriptor which will be
> set as a source for new /proc/$pid/exe symlink.
> 
> Note it allows to change /proc/$pid/exe iif there
> are no VM_EXECUTABLE vmas present for current process,
> simply because this feature is a special to C/R
> and mm::num_exe_file_vmas become meaningless after
> that.
> 
> Also this action is one-shot only. For security reason
> we don't allow to change the symlink several times.

What is this mysterious "security reason"?

>
> ...
>
> +static int prctl_set_mm_exe_file(struct mm_struct *mm, unsigned int fd)
> +{
> +	struct file *exe_file;
> +	struct dentry *dentry;
> +	int err;
> +
> +	/*
> +	 * Setting new mm::exe_file is only allowed
> +	 * when no VM_EXECUTABLE vma's left. So make
> +	 * a fast test first.
> +	 */
> +	if (mm->num_exe_file_vmas)
> +		return -EBUSY;
> +
> +	exe_file = fget(fd);
> +	if (!exe_file)
> +		return -EBADF;
> +
> +	dentry = exe_file->f_path.dentry;
> +
> +	/*
> +	 * Because the original mm->exe_file
> +	 * points to executable file, make sure
> +	 * this one is executable as well to not
> +	 * break an overall picture.
> +	 */
> +	err = -EACCES;
> +	if (!S_ISREG(dentry->d_inode->i_mode)	||
> +	    exe_file->f_path.mnt->mnt_flags & MNT_NOEXEC)
> +		goto exit;
> +
> +	err = inode_permission(dentry->d_inode, MAY_EXEC);
> +	if (err)
> +		goto exit;
> +
> +	/*
> +	 * For security reason changing mm->exe_file
> +	 * is one-shot action.
> +	 */

It should be explained here also.  The comment is pretty useless - if
we don't tell people what this "security reason" is, how can future
developers be sure that they aren't violating it?

> +	down_write(&mm->mmap_sem);
> +	if (likely(!mm->exe_file))
> +		set_mm_exe_file(mm, exe_file);
> +	else
> +		err = -EBUSY;
> +	up_write(&mm->mmap_sem);
> +
> +exit:
> +	fput(exe_file);
> +	return err;
> +}
> +
>  static int prctl_set_mm(int opt, unsigned long addr,
>  			unsigned long arg4, unsigned long arg5)
>  {
>
> ...
>
