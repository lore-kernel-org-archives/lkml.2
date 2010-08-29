Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751703Ab0H2EmU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Aug 2010 00:42:20 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57915 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750826Ab0H2EmS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Aug 2010 00:42:18 -0400
Date: Sun, 29 Aug 2010 14:42:07 +1000
From: Neil Brown <neilb@suse.de>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        vaurora@redhat.com, viro@zeniv.linux.org.uk, jblunck@suse.de,
        hch@infradead.org
Subject: Re: [PATCH 0/5] hybrid union filesystem prototype
Message-ID: <20100829144207.4fbf2713@notabene>
In-Reply-To: <E1Op2BV-0008Ut-BR@pomaz-ex.szeredi.hu>
References: <20100826183340.027591901@szeredi.hu>
	<20100827170551.19616048@notabene>
	<E1Ooub5-0007Wh-SQ@pomaz-ex.szeredi.hu>
	<20100827213502.31af4a4c@notabene>
	<E1Op2BV-0008Ut-BR@pomaz-ex.szeredi.hu>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Aug 2010 18:53:45 +0200
Miklos Szeredi <miklos@szeredi.hu> wrote:

> On Fri, 27 Aug 2010, Neil Brown wrote:
> > I was wondering why you even bothered to fiddle st_ino.  Given that lots of
> > other things come from one fs or the other, having the merged directories
> > appear to be from the upper filesystem doesn't seem like a problem.  I don't
> > really care either way though.
> 
> "rm -rf" complains if st_ino of a directory changes spontaneously.

I see...
Doesn't that mean that you must always present a merged-directory if the
lower directory exists.
Otherwise if you "rm -r" in a directory that only exists in the lower
filesystem, the inode will change on the first 'unlink' call.
??

> 
> > > > The lower filesystem can be any filesystem supported by Linux and does not
> > > > need to be writable.  It could even be another union.
> > > 
> > > Almost.  Xattr namespace issues currently prevent that, but with
> > > escaping it could be worked around if necessary.
> > 
> > But you never access the xattrs for the lower directory so that shouldn't
> > matter.
> 
> Ah, right.  Another small issue is that currently unionfs accesses
> inode->i_* from the underlying filesystems instead of calling
> ->getattr(), which will break if the underlying fs is a union with its
> dummy inodes.  But that should be easy to fix.
> 
> > I actually think that your approach can work quite will with either the
> > upper or lower changing independently.  Certainly it can produce some odd
> > situations, but even NFS can do that (though maybe not quite so odd).
> > 
> > It think the best approach would be to handle the few that can be handled and
> > explicitly document the rest - people might even find them useful.
> 
> I think it's best to leave that stuff until someone actually cares.
> The "people might find it useful" argument is not strong enough to put
> nontrivial effort into thinking about all the weird corner cases.

My thought on this is that in order to describe the behaviour of the
filesystem accurately you need to think about all the weird corner cases.

Then it becomes a question of: is it easier to document the weird behaviour,
or change the code so the documentation will be easier to understand?
Some cases will go one way, some the other.

But as you suggest this isn't urgent.

> 
> > Anyway, here is my next instalment which are the review comments, now that I
> > have some documentation to read :-)
> > 
> > In no particular order:
> > 
> > 1/ You call union_remove_whiteouts on an upper directory once you have
> >    determined that the merged directory is empty, which implies that the only
> >    things in the the upper directory are whiteouts.
> >    union_remove_whiteouts calls union_unlink_writeout on every entry.
> >    It checks that each entry is a DT_LNK - which we assume it must be - but
> >    doesn't check the the inode there is really a whiteout.
> >    It seem inconsistent to do the one check but not the other.
> 
> The DT_LNK check is done to filter out "." and "..".  Added comment.
> 
> >    As this could race with independent changes on the upper filesystem, I
> >    thick it would be safest to at least check the i_mode and i_size of the
> >    dentry->d_inode that is found, and possible do a readlink as well to
> >    ensure we only delete whiteouts.
> > 
> > 1a/ A minor optimisation for union_is_white would be to check i_size matches
> >     size of (union-whiteout)
> 
> I'm not fond of relying on inode->i_* members directly as unionfs
> itself doesn't play by those rules.  But maybe it's OK here as
> anything wanting to be an upper filesystem will be sufficiently
> "normal" for this to work.
> 
> Fixed.

I see your point and I think you are right.  In most cases the filesystem or
some support-library it calls should be the only thing to look at i_*
directly.
An exception seems to be that (i_mode & S_IFMT) is often treated and publicly
viewable.  But I agree that assuming i_size means something particular is
dangerous.


> > 
> > 4/ The problem you mentioned about ->i_mutex which is taken during unlink
> >    being quasi-global could be eased somewhat by simply having a small pool
> >    of inodes and assigning them to dentries pseudo-randomly.  Or possibly
> >    having one 'file' inode per directory (that might be a bit wasteful
> >    though).
> 
> That's an idea, but I'm inclined just to add some hacks to the VFS to
> omit the locking if some inode flag is set.

Every new flag you add is another sign of weakness in the VFS....

Hmmm... vfs_unlink checks if the victim is a mountpoint, which suggests that
you can mount on a non-directory.  I'm not sure if I knew that.
I wonder how this union fs would cope if a file in the upper filesystem were
mounted-on....I suspect it would work correctly.



Two other thoughts.
My comment about set-theory unions being commutative set me thinking.  I
really don't think "union" is the right name for this thing.  There is
nothing about it which really fits that proper definition of a union.
whiteouts mean that even the list of names in a directory is not the union of
the lists of names in the upper and lower directories.
"overlay" is a much more accurate name.  But union seems to be the name
that is most used.  I wonder if it is too late to change that.

Also, dnotify (and presumably inotifiy) doesn't work reliably in the current
implementation.
It works for opaque directories and those which don't have a namesake in the
lower filesystem, but for others it never notifies of changes to any files in
the directory.
This is because dnotify will set an fsnotifier on the merged-directory in the
union-fs, but the change happens to the file in the upper fs, so
fsnotify_parent will only call notifiers on the parent in the upper fs.

I think the way to fix this would involve the union-fs putting a notifier on
the upper dir to match whatever is on the merged-dir.  However the filesystem
currently isn't told when notifiers are attach to an inode.  I think it would
be good to add an inode_operation which is called whenever the notifiers are
changed.  This would also allow a networked filesystem to report notification
if the protocol supported it.
Does that seem reasonable?

NeilBrown
