Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966971Ab0GSV6k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 17:58:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39179 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966938Ab0GSV6g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 17:58:36 -0400
Date: Mon, 19 Jul 2010 17:58:06 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Ian Kent <raven@themaw.net>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
        Miklos Szeredi <miklos@szeredi.hu>, Jan Blunck <jblunck@suse.de>,
        Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 22/38] union-mount: Implement union lookup
Message-ID: <20100719215806.GA11089@shell>
References: <1276627208-17242-1-git-send-email-vaurora@redhat.com> <1276627208-17242-23-git-send-email-vaurora@redhat.com> <20100713044909.GG3949@zeus.themaw.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100713044909.GG3949@zeus.themaw.net>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 13, 2010 at 12:49:10PM +0800, Ian Kent wrote:
> On Tue, Jun 15, 2010 at 11:39:52AM -0700, Valerie Aurora wrote:
> > Implement unioned directories, whiteouts, and fallthrus in pathname
> > lookup routines.  do_lookup() and lookup_hash() call lookup_union()
> > after looking up the dentry from the top-level file system.
> > lookup_union() is centered around __lookup_hash(), which does cached
> > and/or real lookups and revalidates each dentry in the union stack.
> > 
> > XXX - implement negative union cache entries
> > 
> > XXX - What about different permissions on different layers on the same
> > directory name?  Should complain, fail, test permissions on all
> > layers, what?
> > ---
> >  fs/namei.c |  171 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
> >  fs/union.c |   94 +++++++++++++++++++++++++++++++++
> >  fs/union.h |    7 +++
> >  3 files changed, 271 insertions(+), 1 deletions(-)
> > 
> > diff --git a/fs/namei.c b/fs/namei.c
> > index 06aad7e..45be5e5 100644
> > --- a/fs/namei.c
> > +++ b/fs/namei.c
> > @@ -35,6 +35,7 @@
> >  #include <asm/uaccess.h>
> >  
> >  #include "internal.h"
> > +#include "union.h"
> >  
> >  /* [Feb-1997 T. Schoebel-Theuer]
> >   * Fundamental changes in the pathname lookup mechanisms (namei)
> > @@ -722,6 +723,160 @@ static __always_inline void follow_dotdot(struct nameidata *nd)
> >  	follow_mount(&nd->path);
> >  }
> >  
> > +static struct dentry *__lookup_hash(struct qstr *name, struct dentry *base,
> > +				    struct nameidata *nd);
> > +
> > +/*
> > + * __lookup_union - Given a path from the topmost layer, lookup and
> > + * revalidate each dentry in its union stack, building it if necessary
> > + *
> > + * @nd - nameidata for the parent of @topmost
> > + * @name - pathname from this element on
> > + * @topmost - path of the topmost matching dentry
> > + *
> > + * Given the nameidata and the path of the topmost dentry for this
> > + * pathname, lookup, revalidate, and build the associated union stack.
> > + * @topmost must be either a negative dentry or a directory, and not a
> > + * whiteout.
> > + *
> > + * This function may stomp nd->path with the path of the parent
> > + * directory of lower layer, so the caller must save nd->path and
> > + * restore it afterwards.  You probably want to use lookup_union(),
> > + * not __lookup_union().
> > + */
> > +
> > +static int __lookup_union(struct nameidata *nd, struct qstr *name,
> > +			  struct path *topmost)
> > +{
> > +	struct path parent = nd->path;
> > +	struct path lower, upper;
> > +	struct union_dir *ud;
> > +	/* new_ud is the tail of the list of union dirs for this dentry */
> 
> Should new_ud be next_ud, since there is no new_ud defined?

It's also the head of the list.  Good anti-comment, there.  Fixed, thanks!

-VAL
