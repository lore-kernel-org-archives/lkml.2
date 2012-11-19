Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751861Ab2KSUvY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 15:51:24 -0500
Received: from mail.parknet.co.jp ([210.171.160.6]:33314 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751624Ab2KSUvW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 15:51:22 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Jan Kara <jack@suse.cz>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: The bug of iput() removal from flusher thread?
References: <8762541uyx.fsf@devron.myhome.or.jp>
	<873906vumh.fsf@devron.myhome.or.jp>
	<20121119145140.GA20532@quack.suse.cz>
	<20121119194102.GB20532@quack.suse.cz>
Date: Tue, 20 Nov 2012 05:51:15 +0900
In-Reply-To: <20121119194102.GB20532@quack.suse.cz> (Jan Kara's message of
	"Mon, 19 Nov 2012 20:41:02 +0100")
Message-ID: <87a9udtiyk.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Kara <jack@suse.cz> writes:

>>From 4fdc5d9a66dfe0286ef4f4a7f53fd3b15086470f Mon Sep 17 00:00:00 2001
> From: Jan Kara <jack@suse.cz>
> Date: Mon, 19 Nov 2012 20:01:16 +0100
> Subject: [PATCH] writeback: Put unused inodes to LRU after writeback completion
>
> Commit 169ebd90 removed iget-iput pair from inode writeback. As a side effect,
> inodes that are dirty during iput_final() call won't be ever added to inode LRU
> (iput_final() doesn't add dirty inodes to LRU and later when the inode is
> cleaned there's noone to add the inode there). Thus inodes are effectively
> unreclaimable until someone looks them up again.
>
> Practical effect of this bug is limited by the fact that inodes are
> pinned by a dentry for long enough that the inode gets cleaned. But still
> the bug can have nasty consequences leading up to OOM conditions under
> certain circumstances. Following can easily reproduce the problem:
>
> for (( i = 0; i < 1000; i++ )); do
>   mkdir $i
>   for (( j = 0; j < 1000; j++ )); do
>     touch $i/$j
>     echo 2 > /proc/sys/vm/drop_caches
>   done
> done
>
> then one needs to run 'sync; ls -lR' to make inodes reclaimable again.
>
> We fix the issue by inserting unused clean inodes into the LRU after writeback
> finishes in inode_sync_complete().
>
> CC: Al Viro <viro@zeniv.linux.org.uk>
> Reported-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
> Signed-off-by: Jan Kara <jack@suse.cz>

Need to Cc to stable@

> ---
>  fs/fs-writeback.c |    3 +++
>  fs/inode.c        |    2 +-
>  fs/internal.h     |    1 +
>  3 files changed, 5 insertions(+), 1 deletions(-)
>
> diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> index 51ea267..ed7613b 100644
> --- a/fs/fs-writeback.c
> +++ b/fs/fs-writeback.c
> @@ -227,6 +227,9 @@ static void requeue_io(struct inode *inode, struct bdi_writeback *wb)
>  
>  static void inode_sync_complete(struct inode *inode)
>  {
> +	/* If inode is clean an unused, put it into LRU now.  */
> +	if (!(inode->i_state & I_DIRTY) && !atomic_read(&inode->i_count))
> +		inode_lru_list_add(inode);

IMHO, open coding this would be bad idea. And another one is
I_REFERENCED. We really want to remove I_REFERENCED?

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
