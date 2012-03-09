Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755789Ab2CIMzb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 07:55:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58108 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753843Ab2CIMz3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 07:55:29 -0500
Date: Fri, 9 Mar 2012 13:48:11 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Matt Helsley <matthltc@us.ibm.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Kees Cook <keescook@chromium.org>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] c/r: prctl: Add ability to set new mm_struct::exe_file v3
Message-ID: <20120309124811.GA610@redhat.com>
References: <20120308165112.GF21812@moon> <20120308182623.GA17221@redhat.com> <20120308190303.GG21812@moon> <20120308190534.GA19827@redhat.com> <20120308192504.GH21812@moon> <20120308192559.GA20782@redhat.com> <20120308214817.GO21812@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120308214817.GO21812@moon>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/09, Cyrill Gorcunov wrote:
>
> +static int prctl_set_mm_exe_file(struct mm_struct *mm, unsigned int fd)
> +{
> +	struct file *exe_file;
> +	struct dentry *dentry;
> +	int err;
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
> +	 * Setting new mm::exe_file is only allowed
> +	 * when no executable VMAs left. This is
                   ^^^^^^^^^^
Perhaps this is just me, but imho "executable" is not clear enough.
I'd suggest VM_EXECUTABLE to avoid the confusion with VM_EXEC.

> +	 * special C/R case when a restored program
> +	 * need to change own /proc/$pid/exe symlink.
> +	 * After this call mm::num_exe_file_vmas become
> +	 * meaningless.
> +	 */
> +	down_write(&mm->mmap_sem);
> +	if (mm->num_exe_file_vmas == 0) {

You can check this at the very start lockless and simplify the code.
Once it is zero, it can never grow (or we have a bug anyway).

> +		set_mm_exe_file(mm, exe_file);
> +		exe_file = NULL;
> +	} else
> +		err = -EBUSY;
> +	up_write(&mm->mmap_sem);
> +
> +exit:
> +	if (exe_file)
> +		fput(exe_file);

This doesn't look correct, you need fput() in any case.
set_mm_exe_file() does another get_file().

Oleg.

