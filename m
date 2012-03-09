Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755934Ab2CINyu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 08:54:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:19069 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753824Ab2CINyt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 08:54:49 -0500
Date: Fri, 9 Mar 2012 14:47:32 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Matt Helsley <matthltc@us.ibm.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Kees Cook <keescook@chromium.org>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] c/r: prctl: Add ability to set new mm_struct::exe_file v3
Message-ID: <20120309134732.GA3696@redhat.com>
References: <20120308165112.GF21812@moon> <20120308182623.GA17221@redhat.com> <20120308190303.GG21812@moon> <20120308190534.GA19827@redhat.com> <20120308192504.GH21812@moon> <20120308192559.GA20782@redhat.com> <20120308214817.GO21812@moon> <20120309124811.GA610@redhat.com> <20120309125735.GB13346@moon> <20120309133555.GA23040@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120309133555.GA23040@moon>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/09, Cyrill Gorcunov wrote:
>
> On Fri, Mar 09, 2012 at 04:57:35PM +0400, Cyrill Gorcunov wrote:
> >
> > yeah, thanks, will update.
> >
>
> This one should fit all requirements I hope.

Oh, sorry Cyrill, I simply can't resist...

> +static int prctl_set_mm_exe_file(struct mm_struct *mm, unsigned int fd)
> +{
> +	struct file *exe_file;
> +	struct dentry *dentry;
> +	int err;
> +
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
> +	 * Setting new mm::exe_file is only allowed
> +	 * when no VM_EXECUTABLE vma's left. This is
> +	 * a special C/R case when a restored program
> +	 * need to change own /proc/$pid/exe symlink.
> +	 * After this call mm::num_exe_file_vmas become
> +	 * meaningless. If mm::num_exe_file_vmas will
> +	 * ever increase back from zero -- this code
> +	 * needs to be revised, thus WARN_ here, just
> +	 * to be sure.

To be shure in what??

> +	 */
> +	down_write(&mm->mmap_sem);
> +	WARN_ON_ONCE(mm->num_exe_file_vmas);

We already checked it is zero. Yes, it shouldn't grow. But why
do we need another check here?

If it can grow, it can grow after we drop mmap_sem as well and
this would be wrong. So may be we need another WARN_ON() at the
end?

I'd understand if you add something like

	WARN_ON(!mm->num_exe_file_vmas && !current->in_exec);

into added_exe_file_vma().

Or

	WARN_ON(mm->num_exe_file_vmas <= 0);

into removed_exe_file_vma().

But imho your WARN looks like "OK, I checked it lockless but I
am not sure this is correct".

Oleg.

