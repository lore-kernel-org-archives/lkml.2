Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932437Ab2CATsZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 14:48:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6818 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757180Ab2CATsX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 14:48:23 -0500
Date: Thu, 1 Mar 2012 20:41:20 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Kees Cook <keescook@chromium.org>, Tejun Heo <tj@kernel.org>
Subject: Re: [RFC] c/r: prctl: Add ability to set new mm_struct::exe_file
Message-ID: <20120301194120.GA11400@redhat.com>
References: <20120229151634.GE4796@moon> <20120229192400.GA13194@redhat.com> <20120229200103.GJ11326@moon> <20120301180616.GA7652@redhat.com> <20120301191714.GF9930@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120301191714.GF9930@moon>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/01, Cyrill Gorcunov wrote:
>
> So, Oleg, basically the new version will use opened fd in form
> like (note, I'll recheck for refs and locks more so this is
> a draft version to point idea)
>
> static int prctl_set_mm_exe_file(struct mm_struct *mm, unsigned int fd)
> {
> 	struct files_struct *files;
> 	struct file *file;
> 	int ret;
>
> 	/*
> 	 * Make sure if someone is trying to obtain
> 	 * the existing exe_file it will not get
> 	 * results until we've finished.
> 	 */
> 	down_write(&mm->mmap_sem);
>
> 	files = get_files_struct(current);
> 	if (!files)
> 		return -EINVAL;
>
> 	spin_lock(&files->file_lock);
>
> 	file = fcheck_files(files, fd);
> 	if (!file) {
> 		ret = -EBADFD;
> 		goto out_unlock;
> 	}
> 	get_file(file);
> 	spin_unlock(&files->file_lock);
>
> 	if (mm->num_exe_file_vmas)
> 		removed_exe_file_vma(mm);

Still can't understand. I think you need:

	file = fget(fd);
	if (!file)
		return -EBADF;

	down_write(&mm->mmap_sem);
	if (mm->num_exe_file_vmas) {
		fput(mm->exe_file);
		mm->exe_file = file;
		file = NULL;
	}
	up_write(&mm->mmap_sem);

	if (!file)
		return 0;

	fput(file);
	return -ESOMETHING;

and that is all.

Oleg.

