Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757357Ab1LHBCz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 20:02:55 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:44196 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755481Ab1LHBCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 20:02:54 -0500
Date: Thu, 8 Dec 2011 01:02:52 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: linux-fsdevel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: [RFC][patch series] vfsmount gutting
Message-ID: <20111208010251.GF2203@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	OK, that's something I wanted to do for a long time - struct vfsmount
contains too much stuff that is strictily VFS-internal and not needed by
anything outside of a very small subset of VFS, at that.  As the matter of
fact, only 3 fields, 1 of them redundant, are used by code outside of that
area - it's mnt_flags ("how it's mounted"), mnt_root ("what dentry tree
is mounted here", assign-once thing) and mnt_sb (always equal to
mnt_root->d_sb, also assign-once, might or might not be not needed).

	What I've done in vfs.git#vfsmount-guts is massive trimming of
struct vfsmount.  It's a long massage session for fs/namespace.c and
friends.  Here's what happens there:

	* struct vfsmount is embedded into a VFS-private structure.  The
best name I'd been able to come up with was struct mount and yes, it would
be more natural the other way round.  Since all instances of struct vfsmount
come from alloc_vfsmnt(), it's safe - they can't be static, they can't be
on stack, they can't be embedded into other structures or arrays.
	* said structure is defined in fs/mounts.h.  All fields of struct
vfsmount except for these 3 had been moved to struct mount.  Very few files
include that one.
	* fs/namespace.c and fs/pnode.c internals are dealing with struct
mount * instead of struct vfsmount *; the public API is unchanged and
still gets struct vfsmount *, of course.  We use container_of() to get to
the corresponding struct mount * (see real_mount() in fs/mounts.h).
	* ->mnt_parent and ->mnt_master point to struct mount *; it's
more convenient that way.
	* struct mnt_namespace became opaque - its definition is in the
same fs/mounts.h.  ->root points to struct mount * now (that, BTW, is
what had lead to grep over the tree that found breakage in apparmor).
	* proc/*/mounts-related code got moved to separate file -
fs/proc_namespace.c; essentially it's a part of procfs, but its ties to
fs/namespace.c are much stronger than those to the rest of fs/proc/*.
Interface boundary shifted a bit, with IMO cleaner separation as the
result.

	Filesystem code is unchanged; it still gets pointers to struct
vfsmount *, it's just that this structure is less cluttered now and
IMO it makes a lot more sense that way.

	What is missing:
1) Review.  As far as I can see on local testing, the thing works, but extra
eyes would obviously be very welcome.
2) Documentation of the vfsmount ex-guts.  This stuff is dealt with by
very compact area now, so it really can be sanely documented.  In progress...
3) layout optimizations wrt holes, cacheline boundaries, etc.  It's not
too far from what we used to have before, but it'll need to be dealt with.
4) *possibly* a removal of ->mnt_sb.  I'm not sure about that one; it
is redundant (for all vfsmounts ->mnt_sb == ->mnt_root->d_sb and they are
assigned at the same point, before anything can see that vfsmount) and
it's not as if it had been used on a lot of hot paths, but...  Note, BTW,
that in a lot of cases we have path->dentry->d_sb spelled as path->mnt->mnt_sb;
these don't really need ->mnt_sb, of course.  Another class of users is
something along the lines of configfs_mount->mnt_sb->s_root.  What it wants
to be is configfs_mount->mnt_root - these internal vfsmounts have roots
set to that fs in question, so that's a straightforward optimization.  Hell
knows...  It's a separate series in any case.

	I'm going to put that series into -next; if anybody sees problems
with it, please yell.

	I'm *NOT* mailbombing fsdevel with that - it's a long series and
if somebody wants a private mailbomb, that can always be arranged.  Or you
could grab git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git
#vfsmount-guts and use git format-patch locally...

Al, off to review Miklos' series now...
