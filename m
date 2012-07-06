Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933014Ab2GFSMW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 14:12:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21375 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932813Ab2GFSMQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 14:12:16 -0400
Message-ID: <1341597173.5347.5.camel@localhost>
Subject: Re: [PATCH 2/3] audit: fix refcounting in audit-tree
From: Eric Paris <eparis@redhat.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org, mszeredi@suse.cz,
        stable@vger.kernel.org
Date: Fri, 06 Jul 2012 13:52:53 -0400
In-Reply-To: <1340646378-5169-3-git-send-email-miklos@szeredi.hu>
References: <1340646378-5169-1-git-send-email-miklos@szeredi.hu>
	 <1340646378-5169-3-git-send-email-miklos@szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-06-25 at 19:46 +0200, Miklos Szeredi wrote:
> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> Refcounting of fsnotify_mark in audit tree is broken.  E.g:
> 
>                               refcount
> create_chunk
>   alloc_chunk                 1
>   fsnotify_add_mark           2
> 
> untag_chunk
>   fsnotify_get_mark           3
>   fsnotify_destroy_mark
>     audit_tree_freeing_mark   2
>   fsnotify_put_mark           1
>   fsnotify_put_mark           0
>   via destroy_list
>     fsnotify_mark_destroy    -1
> 
> This was reported by various people as triggering Oops when stopping auditd.
> 
> We could just remove the put_mark from audit_tree_freeing_mark() but that would
> break freeing via inode destruction.  So this patch simply omits a put_mark
> after calling destroy_mark (or adds a get_mark before).
> 
> Next patch will clean up the remaining mess.
> 
> Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
> CC: stable@vger.kernel.org

Agreed this is needed.  My changelog was:

    audit: fix ref count problems in audit trees
    
    Before the switch from in kernel inotify to fsnotify for audit trees the
    code regularly did:
        inotify_evict_watch(&chunk->watch);
        put_inotify_watch(&chunk->watch);
    
    I translated this in fsnotify_speak into:
        fsnotify_destroy_mark_by_entry(chunk_entry);
        fsnotify_put_mark(chunk_entry);
    
    The problem is that the inotify_evict_watch function actually took a
    reference on chunk->watch, which is what was being dropped by
    put_inotify_watch().  The fsnotify code does not take such a reference
    during fsnotify_destroy_mark_by_entry().  Thus we are dropping reference
    counts prematurely and eventually we hit a use after free!  Whoops!
    
    Fix these call sites to not drop the extra reference.
    
    Reported-by: Valentin Avram <aval13@gmail.com>
    Reported-by: Peter Moody <pmoody@google.com>
    Partial-patch-by: Marcelo Cerri <mhcerri@linux.vnet.ibm.com>
    Signed-off-by: Eric Paris <eparis@redhat.com>

Maybe you can use some of that changelog in your next post?  (If you do
one?)  The only reason you would repost is because I don't understand
why you took a ref in some places instead of just not dropping it
everywhere...

> ---
>  kernel/audit_tree.c |    5 ++---
>  1 files changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/audit_tree.c b/kernel/audit_tree.c
> index d52d247..31fdc48 100644
> --- a/kernel/audit_tree.c
> +++ b/kernel/audit_tree.c
> @@ -250,7 +250,6 @@ static void untag_chunk(struct node *p)
>  		spin_unlock(&hash_lock);
>  		spin_unlock(&entry->lock);
>  		fsnotify_destroy_mark(entry);
> -		fsnotify_put_mark(entry);
>  		goto out;
>  	}
>  
> @@ -293,7 +292,6 @@ static void untag_chunk(struct node *p)
>  	spin_unlock(&hash_lock);
>  	spin_unlock(&entry->lock);
>  	fsnotify_destroy_mark(entry);
> -	fsnotify_put_mark(entry);
>  	goto out;
>  
>  Fallback:
> @@ -332,6 +330,7 @@ static int create_chunk(struct inode *inode, struct audit_tree *tree)
>  		spin_unlock(&hash_lock);
>  		chunk->dead = 1;
>  		spin_unlock(&entry->lock);
> +		fsnotify_get_mark(entry);
>  		fsnotify_destroy_mark(entry);
>  		fsnotify_put_mark(entry);
>  		return 0;

Like here?  Why not just avoid the atomic op altogether?

> @@ -412,6 +411,7 @@ static int tag_chunk(struct inode *inode, struct audit_tree *tree)
>  		spin_unlock(&chunk_entry->lock);
>  		spin_unlock(&old_entry->lock);
>  
> +		fsnotify_get_mark(chunk_entry);
>  		fsnotify_destroy_mark(chunk_entry);
>  
>  		fsnotify_put_mark(chunk_entry);
> @@ -445,7 +445,6 @@ static int tag_chunk(struct inode *inode, struct audit_tree *tree)
>  	spin_unlock(&old_entry->lock);
>  	fsnotify_destroy_mark(old_entry);
>  	fsnotify_put_mark(old_entry); /* pair to fsnotify_find mark_entry */
> -	fsnotify_put_mark(old_entry); /* and kill it */
>  	return 0;
>  }
>  


