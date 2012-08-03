Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753343Ab2HCKXI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 06:23:08 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:35241 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752028Ab2HCKXF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 06:23:05 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: eparis@redhat.com, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] audit: don't free_chunk() after fsnotify_add_mark()
References: <87eho8rsjs.fsf@tucsk.pomaz.szeredi.hu>
Date: Fri, 03 Aug 2012 12:24:25 +0200
In-Reply-To: <87eho8rsjs.fsf@tucsk.pomaz.szeredi.hu> (Miklos Szeredi's message
	of "Thu, 19 Jul 2012 11:47:35 +0200")
Message-ID: <87obmsnuhy.fsf@tucsk.pomaz.szeredi.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos Szeredi <miklos@szeredi.hu> writes:

> Al, your are the co-maintainer of audit, right?  Can you please apply
> these patches as Eric is on vaction.

Eric, Al,

Can you please apply these two bugfix patches for audit?

Thanks,
Miklos


> From: Miklos Szeredi <mszeredi@suse.cz>
>
> Don't do free_chunk() after fsnotify_add_mark().  That one does a delayed unref
> via the destroy list and this results in use-after-free.
>
> Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
> Acked-by: Eric Paris <eparis@redhat.com>
> CC: stable@vger.kernel.org
> ---
>  kernel/audit_tree.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> Index: linux-2.6/kernel/audit_tree.c
> ===================================================================
> --- linux-2.6.orig/kernel/audit_tree.c	2011-10-26 14:26:24.000000000 +0200
> +++ linux-2.6/kernel/audit_tree.c	2012-05-30 16:56:04.000000000 +0200
> @@ -259,7 +259,7 @@ static void untag_chunk(struct node *p)
>  
>  	fsnotify_duplicate_mark(&new->mark, entry);
>  	if (fsnotify_add_mark(&new->mark, new->mark.group, new->mark.i.inode, NULL, 1)) {
> -		free_chunk(new);
> +		fsnotify_put_mark(&new->mark);
>  		goto Fallback;
>  	}
>  
> @@ -322,7 +322,7 @@ static int create_chunk(struct inode *in
>  
>  	entry = &chunk->mark;
>  	if (fsnotify_add_mark(entry, audit_tree_group, inode, NULL, 0)) {
> -		free_chunk(chunk);
> +		fsnotify_put_mark(entry);
>  		return -ENOSPC;
>  	}
>  
> @@ -396,7 +396,7 @@ static int tag_chunk(struct inode *inode
>  	fsnotify_duplicate_mark(chunk_entry, old_entry);
>  	if (fsnotify_add_mark(chunk_entry, chunk_entry->group, chunk_entry->i.inode, NULL, 1)) {
>  		spin_unlock(&old_entry->lock);
> -		free_chunk(chunk);
> +		fsnotify_put_mark(chunk_entry);
>  		fsnotify_put_mark(old_entry);
>  		return -ENOSPC;
>  	}
