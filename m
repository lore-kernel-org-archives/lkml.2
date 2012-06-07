Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757235Ab2FGBYg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 21:24:36 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:65079 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754565Ab2FGBYf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 21:24:35 -0400
Date: Wed, 6 Jun 2012 18:24:04 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Will Deacon <will.deacon@arm.com>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] ipc: shm: restore MADV_REMOVE functionality on shared
 memory segments
In-Reply-To: <1339002606-30921-1-git-send-email-will.deacon@arm.com>
Message-ID: <alpine.LSU.2.00.1206061819200.23986@eggly.anvils>
References: <1339002606-30921-1-git-send-email-will.deacon@arm.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Jun 2012, Will Deacon wrote:
> Commit 17cf28af ("mm/fs: remove truncate_range") removed the
> truncate_range inode operation in favour of the fallocate file
> operation.
> 
> When using SYSV IPC shared memory segments, calling madvise with the
> MADV_REMOVE advice on an area of shared memory will attempt to invoke
> the .fallocate function for the shm_file_operations, which is NULL and
> therefore returns -EOPNOTSUPP to userspace. The previous behaviour would
> inherit the inode_operations from the underlying tmpfs file and invoke
> truncate_range there.
> 
> This patch restores the previous behaviour by wrapping the underlying
> fallocate function in shm_fallocate, as we do for fsync.
> 
> Cc: Hugh Dickins <hughd@google.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Will Deacon <will.deacon@arm.com>

Acked-by: Hugh Dickins <hughd@google.com>

Many thanks for discovering and fixing this so quickly:
I admit it never even crossed my mind to look over here in ipc/shm.

But I do have a minor improvement below, which akpm will probably
want to merge in on top.

> ---
>  ipc/shm.c |   12 ++++++++++++
>  1 files changed, 12 insertions(+), 0 deletions(-)
> 
> diff --git a/ipc/shm.c b/ipc/shm.c
> index 5e2cbfd..8830e79 100644
> --- a/ipc/shm.c
> +++ b/ipc/shm.c
> @@ -393,6 +393,16 @@ static int shm_fsync(struct file *file, loff_t start, loff_t end, int datasync)
>  	return sfd->file->f_op->fsync(sfd->file, start, end, datasync);
>  }
>  
> +static long shm_fallocate(struct file *file, int mode, loff_t offset,
> +			  loff_t len)
> +{
> +	struct shm_file_data *sfd = shm_file_data(file);
> +
> +	if (!sfd->file->f_op->fallocate)
> +		return -EINVAL;
> +	return sfd->file->f_op->fallocate(file, mode, offset, len);
> +}
> +
>  static unsigned long shm_get_unmapped_area(struct file *file,
>  	unsigned long addr, unsigned long len, unsigned long pgoff,
>  	unsigned long flags)
> @@ -410,6 +420,7 @@ static const struct file_operations shm_file_operations = {
>  	.get_unmapped_area	= shm_get_unmapped_area,
>  #endif
>  	.llseek		= noop_llseek,
> +	.fallocate	= shm_fallocate,
>  };
>  
>  static const struct file_operations shm_file_operations_huge = {
> @@ -418,6 +429,7 @@ static const struct file_operations shm_file_operations_huge = {
>  	.release	= shm_release,
>  	.get_unmapped_area	= shm_get_unmapped_area,
>  	.llseek		= noop_llseek,
> +	.fallocate	= shm_fallocate,
>  };
>  
>  int is_file_shm_hugepages(struct file *file)
> -- 
> 1.7.4.1

[PATCH] ipc: shm: shm_fallocate use -ENOTSUPP

When underlying filesystem (i.e. hugetlbfs) does not support fallocate(),
let shm_fallocate() fail with -EOPNOTSUPP rather than -EINVAL: so that
madvise(,,MADV_REMOVE) gives the same error as it does wherever else
fallocate() is unsupported.  vmtruncate_range() gave -ENOSYS in this
case, but that was not quite right.

Signed-off-by: Hugh Dickins <hughd@google.com>
___

 ipc/shm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- will/ipc/shm.c	2012-06-06 17:54:42.968102209 -0700
+++ hugh/ipc/shm.c	2012-06-06 17:58:14.600106628 -0700
@@ -399,7 +399,7 @@ static long shm_fallocate(struct file *f
 	struct shm_file_data *sfd = shm_file_data(file);
 
 	if (!sfd->file->f_op->fallocate)
-		return -EINVAL;
+		return -EOPNOTSUPP;
 	return sfd->file->f_op->fallocate(file, mode, offset, len);
 }
 
