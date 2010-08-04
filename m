Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758669Ab0HDTsM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 15:48:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60637 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756813Ab0HDTsJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 15:48:09 -0400
Date: Wed, 4 Aug 2010 15:47:50 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: viro@zeniv.linux.org.uk, jblunck@suse.de, hch@infradead.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 19/38] union-mount: Introduce union_dir structure and basic operations
Message-ID: <20100804194749.GA2134@shell>
References: <1276627208-17242-1-git-send-email-vaurora@redhat.com> <1276627208-17242-20-git-send-email-vaurora@redhat.com> <E1OgfJb-0000n9-KZ@pomaz-ex.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1OgfJb-0000n9-KZ@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 04, 2010 at 04:51:31PM +0200, Miklos Szeredi wrote:
> On Tue, 15 Jun 2010, Valerie Aurora wrote:
> > This patch adds the basic structures and operations of VFS-based union
> > mounts (but not the ability to mount or lookup unioned file systems).
> > Each directory in a unioned file system has an associated union stack
> > created when the directory is first looked up.  The union stack is a
> > union_dir structure kept in a hash table indexed by mount and dentry
> > of the directory; thus, specific paths are unioned, not dentries
> > alone.  The union_dir keeps a pointer to the upper path and the lower
> > path and can be looked up by either path.  Currently only two layers
> > are supported, but the union_dir struct is flexible enough to allow
> > more than two layers.
> > 
> > This particular version of union mounts is based on ideas by Jan
> > Blunck, Bharata Rao, and many others.
> > 
> > Signed-off-by: Valerie Aurora <vaurora@redhat.com>
> > ---
> 
> 
> > --- a/include/linux/dcache.h
> > +++ b/include/linux/dcache.h
> > @@ -100,7 +100,9 @@ struct dentry {
> >  	struct hlist_node d_hash;	/* lookup hash list */
> >  	struct dentry *d_parent;	/* parent directory */
> >  	struct qstr d_name;
> > -
> > +#ifdef CONFIG_UNION_MOUNT
> > +	struct union_dir *d_union_dir;	/* head of union stack */
> > +#endif
> 
> This botches the carefully tuned length of struct dentry.  At least a
> FIXME comment needs to be added that this is something to be
> addressed.

Okay, added.

> Why was the hash table concept dropped?  The header comment still
> talks about that?

Simply, Al Viro didn't like it.  But note that the current
implementation still uses part of the hash table solution.  You still
have union_dir structures external to dentries for the read-only
layers of the stack.  The change is from Al's observation that the
topmost dentry could only be part of one stack.  Why do a lookup on
the topmost dentry when you could keep an pointer to the stack in the
dentry itself and skip the lookup?  Once you have the head of the
stack, you don't need lookup for the rest of it.  This eliminates all
the lookup machinery and the union hash table lock, which seems like a
big win to me.

The biggest drawback of the hash table in my mind was that it
introduced a new global synchronization point in lookup.  Making it go
fast would be dcache lookup optimization all over again.

Thanks,

-VAL
