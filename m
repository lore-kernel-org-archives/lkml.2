Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755499Ab2K2Vah (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 16:30:37 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:56645 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754725Ab2K2Vag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 16:30:36 -0500
Date: Thu, 29 Nov 2012 21:30:34 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Revert "__d_unalias() should refuse to move mountpoints"
Message-ID: <20121129213034.GT4939@ZenIV.linux.org.uk>
References: <50609C43.1070702@canonical.com>
 <87txumrct6.fsf@xmission.com>
 <50615268.1040805@canonical.com>
 <8db34325-e8e4-4e24-85dd-c8951769e2b6@email.android.com>
 <506173A6.2050705@canonical.com>
 <87ipb2pemt.fsf@xmission.com>
 <50618F96.1020204@canonical.com>
 <87sja6nxvt.fsf@xmission.com>
 <20121129200612.GP4939@ZenIV.linux.org.uk>
 <20121129205334.GR4939@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121129205334.GR4939@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2012 at 08:53:34PM +0000, Al Viro wrote:
> On Thu, Nov 29, 2012 at 08:06:12PM +0000, Al Viro wrote:
> > On Tue, Sep 25, 2012 at 04:29:58AM -0700, Eric W. Biederman wrote:
> > > Maarten Lankhorst <maarten.lankhorst@canonical.com> writes:
> > > 
> > > >> Could you try the following patch?  This should report what directories
> > > >> cannot be renamed because one of them is a mount point and it gives some
> > > >> real insight into what is going on.
> > > >
> > > > ls /
> > > > __d_unalias: /dev -> /dev
> > > > __d_unalias: /proc -> /proc
> > > > __d_unalias: /sys -> /sys
> > > 
> > > Ok.  That is what I thought was going on.  For some reason nfs is
> > > attempting to recreate an existing dentry.
> > > 
> > > Does this fix the nfs problem for you?
> > > 
> > > Eric
> > > 
> > > diff --git a/fs/dcache.c b/fs/dcache.c
> > > index 8086636..6390f0f 100644
> > > --- a/fs/dcache.c
> > > +++ b/fs/dcache.c
> > > @@ -2404,6 +2404,9 @@ out_unalias:
> > >  	if (likely(!d_mountpoint(alias))) {
> > >  		__d_move(alias, dentry);
> > >  		ret = alias;
> > > +	} else if ((alias->d_parent == dentry->d_parent) &&
> > > +		   !dentry_cmp(alias, dentry->d_name.name, dentry->d_name.len))
> > > +		ret = alias;
> > >  	}
> > 
> > The interesting question is why the hell had it decided that preexisting
> > dentry was not good enough for it?  Note that we have arrived to nfs_lookup()
> > after we'd decided *not* to use the damn alias.  The trace posted upthread
> > went __lookup_hash() -> lookup_real().  It means that lookup_dcache()
> > has not produced this one.  And no, even if ->d_revalidate() decided it
> > was no good, the logics in d_invalidate() would've said "busy" and we'd
> > gone with that dentry anyway.  So it means that d_lookup() has not
> > found it at all.
> > 
> > IOW, something out there is blindly unhashing mountpoint dentries; that's
> > where the real root of the problem seems to be.  Could you slap
> > WARN_ON(d_mountpoint(dentry)) in __d_drop() and see what it catches?
> 
> Ho-hum...  nfs_prime_dcache() seems to be the likely suspect.  What happens
> if we get nfs_same_file() failing for some reason for a mountpoint there?
> Or for a busy directory, for that matter...
> 
> Guys, could somebody with reproducer see if we step into the else side of
>                 if (nfs_same_file(dentry, entry)) {
>                         nfs_refresh_inode(dentry->d_inode, entry->fattr);
>                         goto out;
>                 } else {
>                         d_drop(dentry);
>                         dput(dentry);
>                 }
> in nfs_prime_dcache() with dentry being a mountpoint?  If nothing else,
> I would suggest replacing that d_drop(dentry) with
> 	if (d_invalidate(dentry) != 0)
> 		goto out;
> in there.

Guys, could you test the following and see if it fixes the breakage?  If so,
we need to figure out what's making nfs_same_file() spew apparent false
negatives...

diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index ce8cb92..55436f5 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -450,7 +450,10 @@ void nfs_prime_dcache(struct dentry *parent, struct nfs_entry *entry)
 			nfs_refresh_inode(dentry->d_inode, entry->fattr);
 			goto out;
 		} else {
-			d_drop(dentry);
+			if (d_invalidate(dentry) != 0) {
+				WARN_ON(1);
+				goto out;
+			}
 			dput(dentry);
 		}
 	}
h/openrisc/kernel/signal.c   |    6 ++----
 arch/score/kernel/signal.c      |    7 ++-----
 arch/sh/kernel/signal_64.c      |    6 ++----
 arch/um/kernel/exec.c           |    3 ++-
 5 files changed, 9 insertions(+), 15 deletions(-)
