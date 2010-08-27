Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754238Ab0H0Qxz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 12:53:55 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:56287 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753254Ab0H0Qxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 12:53:53 -0400
To: Neil Brown <neilb@suse.de>
CC: miklos@szeredi.hu, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, vaurora@redhat.com,
        viro@zeniv.linux.org.uk, jblunck@suse.de, hch@infradead.org
In-reply-to: <20100827213502.31af4a4c@notabene> (message from Neil Brown on
	Fri, 27 Aug 2010 21:35:02 +1000)
Subject: Re: [PATCH 0/5] hybrid union filesystem prototype
References: <20100826183340.027591901@szeredi.hu>
	<20100827170551.19616048@notabene>
	<E1Ooub5-0007Wh-SQ@pomaz-ex.szeredi.hu> <20100827213502.31af4a4c@notabene>
Message-Id: <E1Op2BV-0008Ut-BR@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 27 Aug 2010 18:53:45 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Aug 2010, Neil Brown wrote:
> I was wondering why you even bothered to fiddle st_ino.  Given that lots of
> other things come from one fs or the other, having the merged directories
> appear to be from the upper filesystem doesn't seem like a problem.  I don't
> really care either way though.

"rm -rf" complains if st_ino of a directory changes spontaneously.

> > > The lower filesystem can be any filesystem supported by Linux and does not
> > > need to be writable.  It could even be another union.
> > 
> > Almost.  Xattr namespace issues currently prevent that, but with
> > escaping it could be worked around if necessary.
> 
> But you never access the xattrs for the lower directory so that shouldn't
> matter.

Ah, right.  Another small issue is that currently unionfs accesses
inode->i_* from the underlying filesystems instead of calling
->getattr(), which will break if the underlying fs is a union with its
dummy inodes.  But that should be easy to fix.

> I actually think that your approach can work quite will with either the
> upper or lower changing independently.  Certainly it can produce some odd
> situations, but even NFS can do that (though maybe not quite so odd).
> 
> It think the best approach would be to handle the few that can be handled and
> explicitly document the rest - people might even find them useful.

I think it's best to leave that stuff until someone actually cares.
The "people might find it useful" argument is not strong enough to put
nontrivial effort into thinking about all the weird corner cases.

> Anyway, here is my next instalment which are the review comments, now that I
> have some documentation to read :-)
> 
> In no particular order:
> 
> 1/ You call union_remove_whiteouts on an upper directory once you have
>    determined that the merged directory is empty, which implies that the only
>    things in the the upper directory are whiteouts.
>    union_remove_whiteouts calls union_unlink_writeout on every entry.
>    It checks that each entry is a DT_LNK - which we assume it must be - but
>    doesn't check the the inode there is really a whiteout.
>    It seem inconsistent to do the one check but not the other.

The DT_LNK check is done to filter out "." and "..".  Added comment.

>    As this could race with independent changes on the upper filesystem, I
>    thick it would be safest to at least check the i_mode and i_size of the
>    dentry->d_inode that is found, and possible do a readlink as well to
>    ensure we only delete whiteouts.
> 
> 1a/ A minor optimisation for union_is_white would be to check i_size matches
>     size of (union-whiteout)

I'm not fond of relying on inode->i_* members directly as unionfs
itself doesn't play by those rules.  But maybe it's OK here as
anything wanting to be an upper filesystem will be sufficiently
"normal" for this to work.

Fixed.

> 2/ It bothers me that the 'dev_name' arg to union_get_sb is unused, yet there
>    are mandatory options.  I think it would be nice if dev_name were required
>    to be lower,upper and options were left for other things.
>    So the typical usage would be:
> 
>        mount -t union /path/to/lower,/path/to/upper /mount/point
> 

I think that's a matter of taste.  The 'dev_name' argument is just a
specialized option, and when that option needs a structure like your
example then IMO it's better to just move it to normal options.

> 3/ I think it would be great if you made use of d_revalidate to handle some
>    of the worst problems caused by underlying filesystem changes.  If you
>    cache i_mtime and i_version of the parent in the dentry and re-do the
>    lookup if either is different from the directory you could hide most of
>    the issues mentioned in the doco about dentries expiring.  And if you
>    called d_revalidate in the underlying filesystem at the same time you could
>    probably hide all the rest.

As I said, I'd leave it until someone actually needs this.

> 
> 4/ The problem you mentioned about ->i_mutex which is taken during unlink
>    being quasi-global could be eased somewhat by simply having a small pool
>    of inodes and assigning them to dentries pseudo-randomly.  Or possibly
>    having one 'file' inode per directory (that might be a bit wasteful
>    though).

That's an idea, but I'm inclined just to add some hacks to the VFS to
omit the locking if some inode flag is set.

> 5/ I wonder if it would be useful to recognise 'fallthrough' objects (much 
>    like whiteouts but inverted) and to optionally (based on mount option) copy
>    up any directory on readdir and fill it with fall-throughs for any lower
>    name that isn't in the upper.  This helps with enormous directories
>    (though not if upper is RAMFS of course) and ensures a stable directory
>    cookie.

I'm not sure if the stable directory cookie problem is important
enough.  AFAIR some ancient versions of libc relied on directory
seeking and also some weird apps might, but anything sane will not
touch that interface (and I'm hoping someday we can get rid of it for
good).

As for caching large directories, I think that's best done with the
page cache, not by permanently copying up the contents to the upper
directory.

> While I like the idea of being able to work with changeable filesystems and
> think most scenarios can be handled adequately, there is one that I'm not
> comfortable with.
> If you open a file readonly and get a handle on the file in the lower
> filesystem, and then you fchmod the handle, it will work but will change the
> lower filesystem - which you don't really want (I think).
> The only way to avoid this currently is to require the lower vfsmnt to be
> mounted readonly.  That is probably acceptable (it can be mounted read-write
> elsewhere) but I'd like it to be easier than that.
> An alternate would be to teach mnt_want_write_file about some new flag which
> marks the 'struct file' as 'really-readonly' and have union_open set that
> flag.  Note sure if I really like that or not.
> Probably for now just:
> 
> 6/  require  __mnt_is_readonly(lowerpath.mnt) at mount time.

Right, that's at the front of the todo list.

> Finally, I think it is really important to document all the non-standard
> aspects of the unioned filesystem in some detail and suggest work-around for
> potentially problematic behaviour.

I agree completely.  I just tend to write code first and documentation
later (or as late as possibly can) so your contribution in this area
really warms my heart :)

Thanks,
Miklos
