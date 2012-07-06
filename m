Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933108Ab2GFSMZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 14:12:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55001 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932828Ab2GFSMS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 14:12:18 -0400
Message-ID: <1341597064.5347.3.camel@localhost>
Subject: Re: [PATCH 3/3] audit: clean up refcounting in audit-tree
From: Eric Paris <eparis@redhat.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org, mszeredi@suse.cz
Date: Fri, 06 Jul 2012 13:51:04 -0400
In-Reply-To: <1340646378-5169-4-git-send-email-miklos@szeredi.hu>
References: <1340646378-5169-1-git-send-email-miklos@szeredi.hu>
	 <1340646378-5169-4-git-send-email-miklos@szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-06-25 at 19:46 +0200, Miklos Szeredi wrote:
> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> Drop the initial reference by fsnotify_init_mark early instead of
> audit_tree_freeing_mark() at destroy time.
> 
> In the cases we destroy the mark before we drop the initial reference we need to
> get rid of the get_mark that balances the put_mark in audit_tree_freeing_mark().
> 
> Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>

I don't love this.  The reference from fsnotify_init_mark() should live
until fsnotify_mark_destroy().  If we need to drop a reference in
audit_tree_freeing_mark() we should be taking that elsewhere....

> ---
>  kernel/audit_tree.c |   12 +++++++++---
>  1 files changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/audit_tree.c b/kernel/audit_tree.c
> index 31fdc48..7b95706 100644
> --- a/kernel/audit_tree.c
> +++ b/kernel/audit_tree.c
> @@ -292,6 +292,7 @@ static void untag_chunk(struct node *p)
>  	spin_unlock(&hash_lock);
>  	spin_unlock(&entry->lock);
>  	fsnotify_destroy_mark(entry);
> +	fsnotify_put_mark(&new->mark);	/* drop initial reference */
>  	goto out;
>  
>  Fallback:
> @@ -330,7 +331,6 @@ static int create_chunk(struct inode *inode, struct audit_tree *tree)
>  		spin_unlock(&hash_lock);
>  		chunk->dead = 1;
>  		spin_unlock(&entry->lock);
> -		fsnotify_get_mark(entry);
>  		fsnotify_destroy_mark(entry);
>  		fsnotify_put_mark(entry);
>  		return 0;
> @@ -346,6 +346,7 @@ static int create_chunk(struct inode *inode, struct audit_tree *tree)
>  	insert_hash(chunk);
>  	spin_unlock(&hash_lock);
>  	spin_unlock(&entry->lock);
> +	fsnotify_put_mark(entry);	/* drop initial reference */
>  	return 0;
>  }
>  
> @@ -411,7 +412,6 @@ static int tag_chunk(struct inode *inode, struct audit_tree *tree)
>  		spin_unlock(&chunk_entry->lock);
>  		spin_unlock(&old_entry->lock);
>  
> -		fsnotify_get_mark(chunk_entry);
>  		fsnotify_destroy_mark(chunk_entry);
>  
>  		fsnotify_put_mark(chunk_entry);
> @@ -444,6 +444,7 @@ static int tag_chunk(struct inode *inode, struct audit_tree *tree)
>  	spin_unlock(&chunk_entry->lock);
>  	spin_unlock(&old_entry->lock);
>  	fsnotify_destroy_mark(old_entry);
> +	fsnotify_put_mark(chunk_entry);	/* drop initial reference */
>  	fsnotify_put_mark(old_entry); /* pair to fsnotify_find mark_entry */
>  	return 0;
>  }
> @@ -915,7 +916,12 @@ static void audit_tree_freeing_mark(struct fsnotify_mark *entry, struct fsnotify
>  	struct audit_chunk *chunk = container_of(entry, struct audit_chunk, mark);
>  
>  	evict_chunk(chunk);
> -	fsnotify_put_mark(entry);
> +
> +	/*
> +	 * We are guaranteed to have at least one reference to the mark from
> +	 * either the inode or the caller of fsnotify_destroy_mark().
> +	 */
> +	BUG_ON(atomic_read(&entry->refcnt) < 1);
>  }
>  
>  static bool audit_tree_send_event(struct fsnotify_group *group, struct inode *inode,


