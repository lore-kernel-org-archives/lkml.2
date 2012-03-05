Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932425Ab2CEO2l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 09:28:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23303 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932325Ab2CEO2j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 09:28:39 -0500
Date: Mon, 5 Mar 2012 15:21:30 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Kees Cook <keescook@chromium.org>, Tejun Heo <tj@kernel.org>
Subject: Re: [RFC] c/r: prctl: Add ability to set new mm_struct::exe_file
Message-ID: <20120305142130.GA9393@redhat.com>
References: <20120229151634.GE4796@moon> <20120229192400.GA13194@redhat.com> <20120229200103.GJ11326@moon> <20120301180616.GA7652@redhat.com> <20120301191714.GF9930@moon> <20120301194120.GA11400@redhat.com> <20120302142630.GK8681@moon> <20120302152621.GA29744@redhat.com> <20120302161247.GO8681@moon> <20120303223333.GB26846@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120303223333.GB26846@moon>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/04, Cyrill Gorcunov wrote:
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
> +	 * Permissions should be the same as if the
> +	 * file has being opened by the kernel for
> +	 * execution.
> +	 */

Why?

> +	err = -EACCES;
> +	if (!S_ISREG(dentry->d_inode->i_mode)	||
> +	    exe_file->f_path.mnt->mnt_flags & MNT_NOEXEC)
> +		goto exit;
> +
> +	if ((exe_file->f_flags & O_ACCMODE) != O_RDONLY)
> +		goto exit;
> +
> +	err = inode_permission(dentry->d_inode, MAY_EXEC);
> +	if (err)
> +		goto exit;

OK, I won't argue, probably this makes sense to make sure that
admin can't get a heart attack looking at /proc/pid/exe.

But the O_RDONLY check looks strange. We are not going to write
to this file, we only set the name (and that is why I think it
should be mm->exe_path). What is the point to check that the file
was opened without FMODE_WRITE? Even if there were any security
risk the apllication can open this file again with the different
flags.

And btw this check is redundant anyway because you do
deny_write_access() below. However, this deny_write_access() looks
wrong:

> +	down_write(&mm->mmap_sem);
> +	if (mm->num_exe_file_vmas) {
> +
> +		err = deny_write_access(exe_file);

And who does allow_write_access() ?

Oleg.

