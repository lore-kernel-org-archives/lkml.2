Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752813Ab1GGXz4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 19:55:56 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:48125 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751805Ab1GGXzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 19:55:55 -0400
X-Sasl-enc: byIRR636FfPgLx2qxQu2ptnCE9ABvJWvzyyqiWfCS2xQ 1310082954
Date: Thu, 7 Jul 2011 16:55:47 -0700
From: Greg KH <greg@kroah.com>
To: Wengang Wang <wen.gang.wang@oracle.com>
Cc: stable@kernel.org, greg.marsden@oracle.com, joe.jin@oracle.com,
        linux-kernel@vger.kernel.org
Subject: Re: [stable] [PATCH] mm: prevent concurrent unmap_mapping_range() on
 the same inode --to stable
Message-ID: <20110707235547.GA1119@kroah.com>
References: <201106240702.p5O72bkH003998@acsmt358.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201106240702.p5O72bkH003998@acsmt358.oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 24, 2011 at 03:02:08PM +0800, Wengang Wang wrote:
>         mainline commit 2aa15890f3c191326678f1bd68af61ec6b8753ec
> 
>     mm: prevent concurrent unmap_mapping_range() on the same inode
> 
>     Michael Leun reported that running parallel opens on a fuse filesystem
>     can trigger a "kernel BUG at mm/truncate.c:475"
> 
>     Gurudas Pai reported the same bug on NFS.
> 
>     The reason is, unmap_mapping_range() is not prepared for more than
>     one concurrent invocation per inode.  For example:
> 
>       thread1: going through a big range, stops in the middle of a vma and
>          stores the restart address in vm_truncate_count.
> 
>       thread2: comes in with a small (e.g. single page) unmap request on
>          the same vma, somewhere before restart_address, finds that the
>          vma was already unmapped up to the restart address and happily
>          returns without doing anything.
> 
>     Another scenario would be two big unmap requests, both having to
>     restart the unmapping and each one setting vm_truncate_count to its
>     own value.  This could go on forever without any of them being able to
>     finish.
> 
>     Truncate and hole punching already serialize with i_mutex.  Other
>     callers of unmap_mapping_range() do not, and it's difficult to get
>     i_mutex protection for all callers.  In particular ->d_revalidate(),
>     which calls invalidate_inode_pages2_range() in fuse, may be called
>     with or without i_mutex.
> 
>     This patch adds a new mutex to 'struct address_space' to prevent
>     running multiple concurrent unmap_mapping_range() on the same mapping.
> 
>     [ We'll hopefully get rid of all this with the upcoming mm
>       preemptibility series by Peter Zijlstra, the "mm: Remove i_mmap_mutex
>       lockbreak" patch in particular.  But that is for 2.6.39 ]
> 
> 
>     Adding this patch causes Kabi breakage.
> 
>     Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
>     Reported-by: Michael Leun <lkml20101129@newton.leun.net>
>     Reported-by: Gurudas Pai <gurudas.pai@oracle.com>
>     Tested-by: Gurudas Pai <gurudas.pai@oracle.com>
>     Acked-by: Hugh Dickins <hughd@google.com>
>     Cc: stable@kernel.org
>     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
>     Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>

As this patch showed up in 2.6.39, I'm confused as to what you wanted me
to do with it, so I've dropped it from my queue.

greg k-h
