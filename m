Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755008Ab0H3KSY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 06:18:24 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:51808 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754700Ab0H3KSX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 06:18:23 -0400
To: Neil Brown <neilb@suse.de>
CC: miklos@szeredi.hu, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, vaurora@redhat.com,
        viro@zeniv.linux.org.uk, jblunck@suse.de, hch@infradead.org
In-reply-to: <20100829144207.4fbf2713@notabene> (message from Neil Brown on
	Sun, 29 Aug 2010 14:42:07 +1000)
Subject: Re: [PATCH 0/5] hybrid union filesystem prototype
References: <20100826183340.027591901@szeredi.hu>
	<20100827170551.19616048@notabene>
	<E1Ooub5-0007Wh-SQ@pomaz-ex.szeredi.hu>
	<20100827213502.31af4a4c@notabene>
	<E1Op2BV-0008Ut-BR@pomaz-ex.szeredi.hu> <20100829144207.4fbf2713@notabene>
Message-Id: <E1Oq1RL-0003zF-Tw@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 30 Aug 2010 12:18:11 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 29 Aug 2010, Neil Brown wrote:
> On Fri, 27 Aug 2010 18:53:45 +0200
> Miklos Szeredi <miklos@szeredi.hu> wrote:
> 
> > On Fri, 27 Aug 2010, Neil Brown wrote:
> > > I was wondering why you even bothered to fiddle st_ino.  Given
> > > that lots of other things come from one fs or the other, having
> > > the merged directories appear to be from the upper filesystem
> > > doesn't seem like a problem.  I don't really care either way
> > > though.
> > 
> > "rm -rf" complains if st_ino of a directory changes spontaneously.
> 
> I see...
> Doesn't that mean that you must always present a merged-directory if the
> lower directory exists.

Directory opens are never "forwarded" to the lower filesystem like
other opens.  One reason is that lookups continuing from the file's
path need to be on the union filesystem instead on one of the
underlying filesystems.

> Otherwise if you "rm -r" in a directory that only exists in the lower
> filesystem, the inode will change on the first 'unlink' call.
> ??

Right.

Since the union filesystem doesn't have "real" inodes the st_ino on
union directories are stable only as long as the inode is in the
cache.  That's not a problem for "rm -rf" because the ancestor
directory will always have a reference through one of its children.

> > I think it's best to leave that stuff until someone actually cares.
> > The "people might find it useful" argument is not strong enough to put
> > nontrivial effort into thinking about all the weird corner cases.
> 
> My thought on this is that in order to describe the behaviour of the
> filesystem accurately you need to think about all the weird corner cases.
> 
> Then it becomes a question of: is it easier to document the weird behaviour,
> or change the code so the documentation will be easier to understand?
> Some cases will go one way, some the other.
> 
> But as you suggest this isn't urgent.

You didn't mention one possibility: add limitations that prevent the
weird corner cases arising.  I believe this is the simplest option.


> > > 4/ The problem you mentioned about ->i_mutex which is taken during unlink
> > >    being quasi-global could be eased somewhat by simply having a small pool
> > >    of inodes and assigning them to dentries pseudo-randomly.  Or possibly
> > >    having one 'file' inode per directory (that might be a bit wasteful
> > >    though).
> > 
> > That's an idea, but I'm inclined just to add some hacks to the VFS to
> > omit the locking if some inode flag is set.
> 
> Every new flag you add is another sign of weakness in the VFS....
> 
> Hmmm... vfs_unlink checks if the victim is a mountpoint, which suggests that
> you can mount on a non-directory.  I'm not sure if I knew that.

mount --bind has always worked on non-directories too.  It's a useful
feature.

> I wonder how this union fs would cope if a file in the upper filesystem were
> mounted-on....I suspect it would work correctly.

Mounts on the union fs work as expected, they don't care about inodes
except that directories cannot cover non-directories and vice-versa.

Mounts on the upper and lower fs are currenly ignored.  It's an
interesting question whether union fs should handle mount trees on the
underlying filesystems or not.


> My comment about set-theory unions being commutative set me thinking.  I
> really don't think "union" is the right name for this thing.  There is
> nothing about it which really fits that proper definition of a union.
> whiteouts mean that even the list of names in a directory is not the union of
> the lists of names in the upper and lower directories.
> "overlay" is a much more accurate name.  But union seems to be the name
> that is most used.  I wonder if it is too late to change that.

We could call it overlayfs.  People learn new names quickly :)

> Also, dnotify (and presumably inotifiy) doesn't work reliably in the current
> implementation.
> It works for opaque directories and those which don't have a namesake in the
> lower filesystem, but for others it never notifies of changes to any files in
> the directory.
> This is because dnotify will set an fsnotifier on the merged-directory in the
> union-fs, but the change happens to the file in the upper fs, so
> fsnotify_parent will only call notifiers on the parent in the upper fs.

I think *notify will work correctly, every modificaton will be
notified on both the union fs and the upper fs.  But I haven't tested
this yet.

Thanks,
Miklos
