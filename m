Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752474Ab1HHPss (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 11:48:48 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:56140 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877Ab1HHPsr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 11:48:47 -0400
Date: Mon, 8 Aug 2011 17:48:42 +0200
From: Tejun Heo <tj@kernel.org>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Nathan Lynch <ntl@pobox.com>, Oren Laadan <orenl@cs.columbia.edu>,
        Daniel Lezcano <dlezcano@fr.ibm.com>, Serge Hallyn <serue@us.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Glauber Costa <glommer@parallels.com>, containers@lists.osdl.org,
        linux-kernel@vger.kernel.org, Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@canonical.com>
Subject: Re: [patch 1/4] proc: Introduce the /proc/<pid>/mfd/ directory
Message-ID: <20110808154842.GD22863@htj.dyndns.org>
References: <20110807210112.245578619@openvz.org>
 <20110807210526.741513583@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110807210526.741513583@openvz.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Maybe cc'ing linux-mm is a good idea for this one?

On Mon, Aug 08, 2011 at 01:01:13AM +0400, Cyrill Gorcunov wrote:
> This one behaves similarly to the /proc/<pid>/fd/ one - it contains symlinks
> one for each mapping with file, the name of a symlink is vma->vm_start, the
> target is the file. Opening a symlink results in a file that point exactly
> to the same inode as them vma's one.
> 
> This thing is aimed to help checkpointing processes.

I generally agree this is a good idea.  Can you please add how it
would look (say, example ls -l output) in the patch description?
Maybe some people think using both start and end addresses for symlink
name is better?

Another nit: I find the 'mfd' name a bit confusing as there's no file
descriptor involved at all.  Maybe map_files (as we already have maps)
or something like that?

> +static int proc_mfd_get_link(struct inode *inode, struct path *path)
...
> +	down_read(&mm->mmap_sem);
> +	for (vma = mm->mmap; vma; vma = vma->vm_next) {
> +		if (vma->vm_start < vm_start)
> +			continue;
> +		if (vma->vm_start > vm_start)
> +			break;

Why do linear walk instead of find_vma()?

> +static const struct dentry_operations tid_mfd_dentry_operations = {
> +	.d_delete	= pid_delete_dentry,
> +};

Don't we also need revalidation here like tid_fd_dentry_operations?
Also, I think it would be better if all the related functions are
collected into one contiguous chunk.  The scattering doesn't seem to
make much sense.

> +static struct dentry *proc_mfd_lookup(struct inode *dir,
> +		struct dentry *dentry, struct nameidata *nd)
> +{
..
> +	down_read(&mm->mmap_sem);
> +	for (vma = mm->mmap; vma; vma = vma->vm_next) {
> +		if (vma->vm_start == vm_start)
> +			break;
> +		if (vma->vm_start > vm_start)
> +			goto out_no_vma;
> +	}

Ditto, no reason to do linear walk.

Thanks.

-- 
tejun
