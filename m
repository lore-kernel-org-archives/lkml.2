Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754776Ab2FMV0R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 17:26:17 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51670 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754556Ab2FMV0Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 17:26:16 -0400
Date: Wed, 13 Jun 2012 14:26:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH 1/2] msync: support syncing a small part of the file
Message-Id: <20120613142614.6af42ef5.akpm@linux-foundation.org>
In-Reply-To: <1338497035-13014-2-git-send-email-pbonzini@redhat.com>
References: <1338497035-13014-1-git-send-email-pbonzini@redhat.com>
	<1338497035-13014-2-git-send-email-pbonzini@redhat.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 May 2012 22:43:54 +0200
Paolo Bonzini <pbonzini@redhat.com> wrote:

> msync does not need to flush changes to the entire file, even with MS_SYNC.
> Instead, it can use vfs_fsync_range to only synchronize a part of the file.
> 
> In addition, not all metadata has to be synced; msync is closer to
> fdatasync than it is to msync.  So, pass 1 to vfs_fsync_range.

Would be nice, but if applications were previously assuming that an
msync() was syncing the whole file, this patch will secretly and subtly
break them.  Convince me that this change won't weaken anyone's data
integrity ;)

> @@ -77,18 +79,23 @@ SYSCALL_DEFINE3(msync, unsigned long, start, size_t, len, int, flags)
>  			goto out_unlock;
>  		}
>  		file = vma->vm_file;
> -		start = vma->vm_end;
> +		next = min(end, vma->vm_end);
>  		if ((flags & MS_SYNC) && file &&
>  				(vma->vm_flags & VM_SHARED)) {
> +			file_offset = vma->vm_pgoff * PAGE_SIZE;
>  			get_file(file);
>  			up_read(&mm->mmap_sem);
> -			error = vfs_fsync(file, 0);
> +			error = vfs_fsync_range(file,
> +					start - vma->vm_start + file_offset,
> +					next - vma->vm_start + file_offset, 1);

Is that an off-by-one?  The "end" argument to vfs_fsync_range() is
"inclusive".  ie, it indexes the last byte, not the last byte+1.  It's
done this way so we can refer to end-of-file with -1UL.

