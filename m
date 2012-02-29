Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757211Ab2B2TbE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 14:31:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:31428 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754837Ab2B2TbC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 14:31:02 -0500
Date: Wed, 29 Feb 2012 20:24:00 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Kees Cook <keescook@chromium.org>, Tejun Heo <tj@kernel.org>
Subject: Re: [RFC] c/r: prctl: Add ability to set new mm_struct::exe_file
Message-ID: <20120229192400.GA13194@redhat.com>
References: <20120229151634.GE4796@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120229151634.GE4796@moon>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/29, Cyrill Gorcunov wrote:
>
> +static int prctl_set_mm_exe_file(struct mm_struct *mm,
> +				 const void __user *path,
> +				 size_t size)
> +{
> +	struct file *new_exe_file;
> +	char *pathbuf;
> +	int ret = 0;
> +
> +	if (size >= PATH_MAX)
> +		return -EINVAL;
> +
> +	/*
> +	 * We allow to change only those exe's which
> +	 * are not mapped several times. This one
> +	 * is early test while mmap_sem is taken.
> +	 */
> +	if (mm->num_exe_file_vmas > 1)
> +		return -EBUSY;

I don't really understand this check, but it is racy. Another thread
can change ->num_exe_file_vmas right after the check.

> +       up_read(&mm->mmap_sem);

up? I do not see down...

> +	new_exe_file = open_exec(pathbuf);
> +	kfree(pathbuf);
> +
> +	down_read(&mm->mmap_sem);

probably you meant "up" here. OK, I am ignoring ->mmap_sem, I can't
understand what did you really mean ;)

> +	if (IS_ERR(new_exe_file))
> +		return PTR_ERR(new_exe_file);
> +
> +	/*
> +	 * We allow to change only those exe's which
> +	 * are not mapped several times.
> +	 */
> +	if (mm->num_exe_file_vmas < 2) {
> +		set_mm_exe_file(mm, new_exe_file);
> +		ret = 0;
> +	} else
> +		ret = -EBUSY;
> +
> +	return ret;

Both success/EBUSY leak new_exe_file. And I agree with Pavel,
prctl_set_mm_exe_file() should take fd, not filename.

I simply can't understand why set_mm_exe_file() is safe. What
if we race with another thread doing set_mm_exe_file() too?
Or it can race with added_exe_file_vma/removed_exe_file_vma.

And. set_mm_exe_file() sets ->num_exe_file_vmas = 0, this is
simply wrong? It should match the number of VM_EXECUTABLE
vmas.

In short, I do not understand the patch at all. It seems, you
only need to replace mm->exe_file under down_write(mmap_sem)
and nothing else.

Oleg.

