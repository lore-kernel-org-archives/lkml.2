Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756131Ab1HXLSP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 07:18:15 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:44788 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855Ab1HXLSO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 07:18:14 -0400
Date: Wed, 24 Aug 2011 15:18:06 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Nathan Lynch <ntl@pobox.com>, Oren Laadan <orenl@cs.columbia.edu>,
        Daniel Lezcano <dlezcano@fr.ibm.com>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>, linux-kernel@vger.kernel.org,
        James Bottomley <jbottomley@parallels.com>,
        LINUXFS-ML <linux-fsdevel@vger.kernel.org>, containers@lists.osdl.org
Subject: Re: [RFC] fs, proc: Introduce the /proc/<pid>/map_files/ directory
 v2
Message-ID: <20110824111806.GA7191@albatros>
References: <20110824085329.GL29452@sun>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110824085329.GL29452@sun>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Cyrill,

On Wed, Aug 24, 2011 at 12:53 +0400, Cyrill Gorcunov wrote:
> +static struct dentry *proc_map_files_lookup(struct inode *dir,
> +		struct dentry *dentry, struct nameidata *nd)
> +{
> +	struct task_struct *task;
> +	unsigned long vm_start;
> +	struct vm_area_struct *vma;
> +	struct mm_struct *mm;
> +	struct dentry *result;
> +	char *endp;
> +
> +	result = ERR_PTR(-ENOENT);
> +
> +	task = get_proc_task(dir);
> +	if (!task)
> +		goto out_no_task;
> +
> +	vm_start = simple_strtoul(dentry->d_name.name, &endp, 16);
> +	if (*endp != '\0')
> +		goto out_no_mm;
> +
> +	mm = get_task_mm(task);
> +	if (!mm)
> +		goto out_no_mm;
> +
> +	down_read(&mm->mmap_sem);
> +	vma = find_vma(mm, vm_start);
> +	if (!vma || vma->vm_start != vm_start)
> +		goto out_no_vma;
> +	result = proc_map_files_instantiate(dir, dentry, task, vma);
> +
> +out_no_vma:
> +	up_read(&mm->mmap_sem);
> +	mmput(mm);
> +out_no_mm:
> +	put_task_struct(task);
> +out_no_task:
> +	return result;
> +}

You have no ptrace_may_access() check in ->lookup(), only in ->readdir().

> +static const struct inode_operations proc_map_files_inode_operations = {
> +	.lookup		= proc_map_files_lookup,
> +	.setattr	= proc_setattr,
> +};
> +
> +static int proc_map_files_readdir(struct file *filp, void *dirent, filldir_t filldir)
> +{
...
> +	ret = -EPERM;
> +	if (!ptrace_may_access(task, PTRACE_MODE_READ))
> +		goto out;
...
> +	}

Thanks,

-- 
Vasiliy
