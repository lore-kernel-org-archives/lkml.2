Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754502Ab0H0LfR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 07:35:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33973 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754231Ab0H0LfO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 07:35:14 -0400
Date: Fri, 27 Aug 2010 21:35:02 +1000
From: Neil Brown <neilb@suse.de>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        vaurora@redhat.com, viro@zeniv.linux.org.uk, jblunck@suse.de,
        hch@infradead.org
Subject: Re: [PATCH 0/5] hybrid union filesystem prototype
Message-ID: <20100827213502.31af4a4c@notabene>
In-Reply-To: <E1Ooub5-0007Wh-SQ@pomaz-ex.szeredi.hu>
References: <20100826183340.027591901@szeredi.hu>
	<20100827170551.19616048@notabene>
	<E1Ooub5-0007Wh-SQ@pomaz-ex.szeredi.hu>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Aug 2010 10:47:39 +0200
Miklos Szeredi <miklos@szeredi.hu> wrote:

> Hi Neil,
> 
> On Fri, 27 Aug 2010, Neil Brown wrote:
> >  My first problem with this that there isn't nearly enough documentation.
> > So I offer the following to fix this problem.  Please correct anything that I
> > got glaringly wrong.  I don't claim it is at all complete, but touches on the
> > things that I thought were interesting.
> 
> Whoa, thank you very much.  I'll add it to the patchset with some
> fixes (see below).
> 
> > Hybrid Union Filesystem
> > =======================
> > 
> > This document describes a prototype for a new approach to providing
> > union-filesystem functionality in Linux.
> > A union-filesystem tries to present the union of two different filesystems as
> > though it were a single filesystem.  The result will inevitably fail to look
> > exactly like a normal filesystem for various technical reasons.  The
> > expectation is that many use cases will be able to ignore these differences.
> > 
> > This approach is 'hybrid' because the objects that appear in the filesystem
> > do not all appear to belong to that filesystem.  In many case an object
> > accessed in the hybrid-union will be indistinguishable from accessing the
> > corresponding object from the original filesystem.  This is most obvious
> > from the 'st_dev' field returned by stat(2).  Some objects will report an
> > st_dev from one original filesystem, some from the other, none will report an
> > st_dev from the union itself.
> 
> Hmm, that's a bug.  Directories actually come from the union itself
> for various reasons, and it does report the correct st_ino but not
> st_dev.  Fixed.

I was wondering why you even bothered to fiddle st_ino.  Given that lots of
other things come from one fs or the other, having the merged directories
appear to be from the upper filesystem doesn't seem like a problem.  I don't
really care either way though.

> > 
> > The lower filesystem can be any filesystem supported by Linux and does not
> > need to be writable.  It could even be another union.
> 
> Almost.  Xattr namespace issues currently prevent that, but with
> escaping it could be worked around if necessary.

But you never access the xattrs for the lower directory so that shouldn't
matter.
Have a union for the upper fs would certainly be sufficiently 'interesting'
to explicitly forbid.

> > 
> > Changes to underlying filesystems
> > ---------------------------------
> > 
> 
> For now I refuse to even think about what happens in this case.
> 
> The easiest way out of this mess might simply be to enforce exclusive
> modification to the underlying filesystems on a local level, same as
> the union mount strategy.  For NFS and other remote filesystems we
> either
> 
>  a) add some way to enforce it,
>  b) live with the consequences if not enforced on the system level, or
>  c) disallow them to be part of the union.
> 

I actually think that your approach can work quite will with either the
upper or lower changing independently.  Certainly it can produce some odd
situations, but even NFS can do that (though maybe not quite so odd).

It think the best approach would be to handle the few that can be handled and
explicitly document the rest - people might even find them useful.


Anyway, here is my next instalment which are the review comments, now that I
have some documentation to read :-)

In no particular order:

1/ You call union_remove_whiteouts on an upper directory once you have
   determined that the merged directory is empty, which implies that the only
   things in the the upper directory are whiteouts.
   union_remove_whiteouts calls union_unlink_writeout on every entry.
   It checks that each entry is a DT_LNK - which we assume it must be - but
   doesn't check the the inode there is really a whiteout.
   It seem inconsistent to do the one check but not the other.

   As this could race with independent changes on the upper filesystem, I
   thick it would be safest to at least check the i_mode and i_size of the
   dentry->d_inode that is found, and possible do a readlink as well to
   ensure we only delete whiteouts.

1a/ A minor optimisation for union_is_white would be to check i_size matches
    size of (union-whiteout)

2/ It bothers me that the 'dev_name' arg to union_get_sb is unused, yet there
   are mandatory options.  I think it would be nice if dev_name were required
   to be lower,upper and options were left for other things.
   So the typical usage would be:

       mount -t union /path/to/lower,/path/to/upper /mount/point

3/ I think it would be great if you made use of d_revalidate to handle some
   of the worst problems caused by underlying filesystem changes.  If you
   cache i_mtime and i_version of the parent in the dentry and re-do the
   lookup if either is different from the directory you could hide most of
   the issues mentioned in the doco about dentries expiring.  And if you
   called d_revalidate in the underlying filesystem at the same time you could
   probably hide all the rest.

4/ The problem you mentioned about ->i_mutex which is taken during unlink
   being quasi-global could be eased somewhat by simply having a small pool
   of inodes and assigning them to dentries pseudo-randomly.  Or possibly
   having one 'file' inode per directory (that might be a bit wasteful
   though).

5/ I wonder if it would be useful to recognise 'fallthrough' objects (much 
   like whiteouts but inverted) and to optionally (based on mount option) copy
   up any directory on readdir and fill it with fall-throughs for any lower
   name that isn't in the upper.  This helps with enormous directories
   (though not if upper is RAMFS of course) and ensures a stable directory
   cookie.


While I like the idea of being able to work with changeable filesystems and
think most scenarios can be handled adequately, there is one that I'm not
comfortable with.
If you open a file readonly and get a handle on the file in the lower
filesystem, and then you fchmod the handle, it will work but will change the
lower filesystem - which you don't really want (I think).
The only way to avoid this currently is to require the lower vfsmnt to be
mounted readonly.  That is probably acceptable (it can be mounted read-write
elsewhere) but I'd like it to be easier than that.
An alternate would be to teach mnt_want_write_file about some new flag which
marks the 'struct file' as 'really-readonly' and have union_open set that
flag.  Note sure if I really like that or not.
Probably for now just:

6/  require  __mnt_is_readonly(lowerpath.mnt) at mount time.

Finally, I think it is really important to document all the non-standard
aspects of the unioned filesystem in some detail and suggest work-around for
potentially problematic behaviour.
The fact that a read-only open can get a lower-filesystem filehandle has a
lot of interesting consequences.
If you take a read-lock, it doesn't stop an other process writing to the file
(though it does stop the file from changing!).
If you request a DNOTIFY on a directory, you will not see when things get
added.
If you take a lease on a file it won't be broken by someone trying to write.

So if you:
  - create a union.
  - start a daemon that watches for changes
  - make changes

The daemon could never notice.  Of course if you stop everything and restart
it will then work smoothly, as the 'make-changes' will have copied-up the
directory.

Most such confusion can be easily avoided by 'touching' any file or directory
that will be monitored for changes or will be involved in locking.  Having to
do that after creating a union is a hassle, but only a minor hassle I think,
and may not actually be needed at all in many cases.

On the whole, I really like this approach.  It strikes a good balance between
simplicity and functionality.  It doesn't provide perfect semantics, but I
think it provides good-enough semantics and a very moderate cost.

Thanks,
NeilBrown
