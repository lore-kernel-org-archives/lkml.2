Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757321Ab2CMPvo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 11:51:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2035 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757195Ab2CMPvd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 11:51:33 -0400
Date: Tue, 13 Mar 2012 16:43:37 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Matt Helsley <matthltc@us.ibm.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Kees Cook <keescook@chromium.org>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] c/r: prctl: Add ability to set new mm_struct::exe_file v3
Message-ID: <20120313154337.GA25711@redhat.com>
References: <20120309144239.GD13346@moon> <20120309152122.GA7802@redhat.com> <20120309154224.GE13346@moon> <20120309220244.GD19584@count0.beaverton.ibm.com> <20120309223932.GB725@moon> <20120309235901.GE19584@count0.beaverton.ibm.com> <20120310074854.GA3065@moon> <20120313024511.GF19584@count0.beaverton.ibm.com> <20120313062625.GA1912@moon> <20120313071812.GA6969@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120313071812.GA6969@moon>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/13, Cyrill Gorcunov wrote:
>
> Matt, Oleg, there is a final version I hope,
> which should fit everyone.

Well, this version looks correct, but you are checking the same
condition twice, with the different comments. This is confusing.

> +static int prctl_set_mm_exe_file(struct mm_struct *mm, unsigned int fd)
> +{
> +	struct file *exe_file;
> +	struct dentry *dentry;
> +	int err;
> +
> +	/*
> +	 * Setting new mm::exe_file is only allowed
> +	 * when no VM_EXECUTABLE vma's left. This is
> +	 * a special C/R case when a restored program
> +	 * need to change own /proc/$pid/exe symlink.
> +	 * After this call mm::num_exe_file_vmas become
> +	 * meaningless.
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
> +	down_write(&mm->mmap_sem);
> +	if (likely(!mm->exe_file))

This means that the num_exe_file_vmas check at the start is not needed.
If you want it as a "fast-path" check, please fix the comment. Or just
remove it. Otherwise the code looks as if we have to check them both.

Matt, is it really possible to hit mm->exe_file = NULL in
removed_exe_file_vma ? Unless I missed something, this check just
hides the potentional problem, no?

IOW, shouldn't it do

	void removed_exe_file_vma(struct mm_struct *mm)
	{
		WARN_ON(!mm->exe_file);
		WARN_ON(mm->num_exe_file_vmas <= 0);

		if (!--mm->num_exe_file_vmas) {
			fput(mm->exe_file);
			mm->exe_file = NULL;
		}
	}

?

Oleg.

