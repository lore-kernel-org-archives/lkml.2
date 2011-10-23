Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932091Ab1JWNp5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 09:45:57 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:59797 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755438Ab1JWNp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 09:45:56 -0400
X-Sasl-enc: YXitteRq83f6ysCyzfb5GoeKC1uYeQ4zYBqxJkgXe/O+ 1319377554
Subject: Re: [PATCH] CIFS: fix automount for DFS shares
From: Ian Kent <raven@themaw.net>
To: Jeff Layton <jlayton@redhat.com>
Cc: Gerlando Falauto <gerlando.falauto@keymile.com>,
        linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>
In-Reply-To: <20111023074653.352be663@tlielax.poochiereds.net>
References: <1317985771-28876-1-git-send-email-gerlando.falauto@keymile.com>
	 <1317985771-28876-2-git-send-email-gerlando.falauto@keymile.com>
	 <1319368474.7876.4.camel@perseus.themaw.net>
	 <20111023074653.352be663@tlielax.poochiereds.net>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 23 Oct 2011 21:45:50 +0800
Message-ID: <1319377550.7876.38.camel@perseus.themaw.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-10-23 at 07:46 -0400, Jeff Layton wrote:
> On Sun, 23 Oct 2011 19:14:34 +0800
> Ian Kent <raven@themaw.net> wrote:
> 
> > On Fri, 2011-10-07 at 13:09 +0200, Gerlando Falauto wrote:
> > > Automounting directories are now invalidated by .d_revalidate()
> > > so to be d_instantiate()d again with the right DCACHE_NEED_AUTOMOUNT
> > > flag
> > 
> > But why doesn't CIFS know this is a DFS inode the first time around, it
> > appears to do a truck load of work looking that stuff up?
> > 
> 
> This area needs some work...
> 
> The readdir codepath in cifs uses the FIND_FIRST/NEXT calls on the
> wire. Those return both filenames and attributes for the particular SMB
> call infolevel. That in turn is used to instantiate dentries and inodes
> for those entries.
> 
> Unfortunately though, we have not found a way to determine whether a
> particular inode is a DFS referral from within this codepath. The only
> way to know for sure (AFAIK) is to try an operation on a specific
> pathname and then look for a NT_STATUS_PATH_NOT_COVERED return code.
> 
> > > 
> > > Signed-off-by: Gerlando Falauto <gerlando.falauto@keymile.com>
> > > ---
> > >  fs/cifs/dir.c |    7 ++++++-
> > >  1 files changed, 6 insertions(+), 1 deletions(-)
> > > 
> > > diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
> > > index 9ea65cf..67f54d3 100644
> > > --- a/fs/cifs/dir.c
> > > +++ b/fs/cifs/dir.c
> > > @@ -637,8 +637,13 @@ cifs_d_revalidate(struct dentry *direntry, struct nameidata *nd)
> > >  	if (direntry->d_inode) {
> > >  		if (cifs_revalidate_dentry(direntry))
> > >  			return 0;
> > > -		else
> > > +		else {
> > > +			/* We want automonting inodes to be
> > > +			 * considered invalid or so */
> > > +			if (IS_AUTOMOUNT(direntry->d_inode))
> > > +				return 0;
> > 
> > I'd be inclined to set DCACHE_NEED_AUTOMOUNT here but are we certain
> > that cifs_revalidate_dentry() will always return 0 for a DFS inode or at
> > least ones that don't yet have DCACHE_NEED_AUTOMOUNT set and why?
> > 
> 
> You mean you'd set that in the "return 1" case here? That doesn't sound
> quite right if so. This inode could be entirely unrelated to DFS.

Actually, the return code might not matter. The current code returns 1
if cifs_revalidate_dentry() returns 0, so yes, that's what I'm saying.
Setting DCACHE_NEED_AUTOMOUNT in d_flags if S_AUTOMOUNT() is set is
enough to trigger the mount and S_AUTOMOUNT() will be set if it's been
seen as a DFS point.

If cifs_revalidate_dentry() returns 1 it returns false and the lookup
gets re-done so the other case looks like it handles the case where we
now know the thing is a DFS inode but haven't set the dcache flag since
the dentry wasn't actually instantiated.

> 
> Currently, cifs_revalidate_dentry checks to see if the attributes on
> the inode are "too old" (past the actimeo setting). If they are then it
> will issue a QUERY_PATH_INFO call on the wire to try and update those
> attributes. If it's a DFS inode then you'll get an error back and that
> function should return 0.
> 
> It's possible however that the inode has already had its attributes
> updated recently, and was found to be an automount point. That is, it
> got S_AUTOMOUNT set but no referral chasing happened. At that point I'm
> a little fuzzy as to what should happen...

Right, from the POV of CIFS .... the automounting bit is ....

The automounting happens during the follow after the lookup/revalidate
of the path component if the appropriate flag(s) is set. The follow will
be done for each mountpoint dentry in the stack, calling ->d_manage() if
needed, for each and once the last one is reached ->d_automount() is
called if it is needed. That's a bit simplified but is basically the way
it's done.

What I'm suggesting is that there's no need to allocate a new dentry
when the attributes have now been filled in and the dentry is seen as a
DFS point.

Not sure how that will go with multiple concurrent walks though.

> 
> The safest thing would seem to be to return 0 in that case, to force an
> invalidation and lookup on this dentry again, but maybe there's a better
> way to handle that?

Who else can we consult on this?

> 
> > >  			return 1;
> > > +		}
> > >  	}
> > >  
> > >  	/*
> > 
> > 
> 
> 


