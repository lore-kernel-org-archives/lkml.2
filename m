Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754754Ab2DCPCx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 11:02:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46046 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754386Ab2DCPCw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 11:02:52 -0400
Date: Tue, 3 Apr 2012 17:02:25 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Cong Wang <xiyou.wangcong@gmail.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Vasiliy Kulikov <segoon@openwall.com>,
        David Rientjes <rientjes@google.com>
Subject: Re: [Patch v2] proc: clean up /proc/<pid>/environ handling
Message-ID: <20120403150225.GA6152@redhat.com>
References: <20120328153936.495f567a.akpm@linux-foundation.org> <1333441703-8180-1-git-send-email-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1333441703-8180-1-git-send-email-xiyou.wangcong@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/03, Cong Wang wrote:
>
> +static int environ_open(struct inode *inode, struct file *file)
> +{
> +	struct task_struct *task = get_proc_task(file->f_path.dentry->d_inode);
> +	struct mm_struct *mm;
> +
> +	if (!task)
> +		return -ESRCH;
> +
> +	mm = mm_for_maps(task);
> +	put_task_struct(task);
> +
> +	if (IS_ERR(mm))
> +		return PTR_ERR(mm);
> +
> +	if (mm) {
> +		/* ensure this mm_struct can't be freed */
> +		atomic_inc(&mm->mm_count);
> +		/* but do not pin its memory */
> +		mmput(mm);
> +	}
> +
> +	file->private_data = mm;
> +
> +	return 0;
> +}

Well, can we unify this code with mem_open() ? Say, let it be
__mem_open() or whatever, then mem_open() can use the common
helper and add FMODE_UNSIGNED_OFFSET. Just we need another
argument for mm_access.

> +static int environ_release(struct inode *inode, struct file *file)
> +{
> +	struct mm_struct *mm = file->private_data;
> +	if (mm)
> +		mmdrop(mm);
> +	return 0;
> +}

Again, this is identical with mem_release(), proc_environ_operations
can simply use it instead.

Oleg.

