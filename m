Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933415Ab2GKWYQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 18:24:16 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53797 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932159Ab2GKWYO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 18:24:14 -0400
Message-ID: <1342045451.19666.26.camel@tucsk.pomaz.szeredi.hu>
Subject: Re: [PATCH 2/3] audit: fix refcounting in audit-tree
From: Miklos Szeredi <mszeredi@suse.cz>
To: Eric Paris <eparis@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, viro@ZenIV.linux.org.uk,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Date: Thu, 12 Jul 2012 00:24:11 +0200
In-Reply-To: <1341597173.5347.5.camel@localhost>
References: <1340646378-5169-1-git-send-email-miklos@szeredi.hu>
	 <1340646378-5169-3-git-send-email-miklos@szeredi.hu>
	 <1341597173.5347.5.camel@localhost>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-07-06 at 13:52 -0400, Eric Paris wrote:
> On Mon, 2012-06-25 at 19:46 +0200, Miklos Szeredi wrote:
> > From: Miklos Szeredi <mszeredi@suse.cz>
> > 
> > Refcounting of fsnotify_mark in audit tree is broken.  E.g:
> > 
> >                               refcount
> > create_chunk
> >   alloc_chunk                 1
> >   fsnotify_add_mark           2
> > 
> > untag_chunk
> >   fsnotify_get_mark           3
> >   fsnotify_destroy_mark
> >     audit_tree_freeing_mark   2
> >   fsnotify_put_mark           1
> >   fsnotify_put_mark           0
> >   via destroy_list
> >     fsnotify_mark_destroy    -1
> > 
> > This was reported by various people as triggering Oops when stopping auditd.
> > 
> > We could just remove the put_mark from audit_tree_freeing_mark() but that would
> > break freeing via inode destruction.  So this patch simply omits a put_mark
> > after calling destroy_mark (or adds a get_mark before).
> > 
> > Next patch will clean up the remaining mess.
> > 
> > Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
> > CC: stable@vger.kernel.org
> 
> Agreed this is needed.  My changelog was:
> 
>     audit: fix ref count problems in audit trees
>     
>     Before the switch from in kernel inotify to fsnotify for audit trees the
>     code regularly did:
>         inotify_evict_watch(&chunk->watch);
>         put_inotify_watch(&chunk->watch);
>     
>     I translated this in fsnotify_speak into:
>         fsnotify_destroy_mark_by_entry(chunk_entry);
>         fsnotify_put_mark(chunk_entry);
>     
>     The problem is that the inotify_evict_watch function actually took a
>     reference on chunk->watch, which is what was being dropped by
>     put_inotify_watch().  The fsnotify code does not take such a reference
>     during fsnotify_destroy_mark_by_entry().  Thus we are dropping reference
>     counts prematurely and eventually we hit a use after free!  Whoops!
>     
>     Fix these call sites to not drop the extra reference.
>     
>     Reported-by: Valentin Avram <aval13@gmail.com>
>     Reported-by: Peter Moody <pmoody@google.com>
>     Partial-patch-by: Marcelo Cerri <mhcerri@linux.vnet.ibm.com>
>     Signed-off-by: Eric Paris <eparis@redhat.com>
> 
> Maybe you can use some of that changelog in your next post?  (If you do
> one?)  The only reason you would repost is because I don't understand
> why you took a ref in some places instead of just not dropping it
> everywhere...
> 
> > ---
> >  kernel/audit_tree.c |    5 ++---
> >  1 files changed, 2 insertions(+), 3 deletions(-)
> > 
> > diff --git a/kernel/audit_tree.c b/kernel/audit_tree.c
> > index d52d247..31fdc48 100644
> > --- a/kernel/audit_tree.c
> > +++ b/kernel/audit_tree.c
> > @@ -250,7 +250,6 @@ static void untag_chunk(struct node *p)
> >  		spin_unlock(&hash_lock);
> >  		spin_unlock(&entry->lock);
> >  		fsnotify_destroy_mark(entry);
> > -		fsnotify_put_mark(entry);
> >  		goto out;
> >  	}
> >  
> > @@ -293,7 +292,6 @@ static void untag_chunk(struct node *p)
> >  	spin_unlock(&hash_lock);
> >  	spin_unlock(&entry->lock);
> >  	fsnotify_destroy_mark(entry);
> > -	fsnotify_put_mark(entry);
> >  	goto out;
> >  
> >  Fallback:
> > @@ -332,6 +330,7 @@ static int create_chunk(struct inode *inode, struct audit_tree *tree)
> >  		spin_unlock(&hash_lock);
> >  		chunk->dead = 1;
> >  		spin_unlock(&entry->lock);
> > +		fsnotify_get_mark(entry);
> >  		fsnotify_destroy_mark(entry);
> >  		fsnotify_put_mark(entry);
> >  		return 0;
> 
> Like here?  Why not just avoid the atomic op altogether?

Simply because fsnotify_destroy_mark() assumes that the caller is
holding a reference to the mark (or the inode is keeping the mark
pinned, not the case here AFAICS).  Without that ref it can Oops.

> 
> > @@ -412,6 +411,7 @@ static int tag_chunk(struct inode *inode, struct audit_tree *tree)
> >  		spin_unlock(&chunk_entry->lock);
> >  		spin_unlock(&old_entry->lock);
> >  
> > +		fsnotify_get_mark(chunk_entry);
> >  		fsnotify_destroy_mark(chunk_entry);
> >  
> >  		fsnotify_put_mark(chunk_entry);
> > @@ -445,7 +445,6 @@ static int tag_chunk(struct inode *inode, struct audit_tree *tree)
> >  	spin_unlock(&old_entry->lock);
> >  	fsnotify_destroy_mark(old_entry);
> >  	fsnotify_put_mark(old_entry); /* pair to fsnotify_find mark_entry */
> > -	fsnotify_put_mark(old_entry); /* and kill it */
> >  	return 0;
> >  }
> >  
> 
> 


