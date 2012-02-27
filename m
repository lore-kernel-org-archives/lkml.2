Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753801Ab2B0C5K (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Feb 2012 21:57:10 -0500
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:38277 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753546Ab2B0C5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Feb 2012 21:57:08 -0500
Message-ID: <4F4AF106.5050001@xenotime.net>
Date: Sun, 26 Feb 2012 18:57:10 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: linux-fsdevel@vger.kernel.org, viro@ZenIV.linux.org.uk,
        valerie.aurora@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 18/73] union-mount: Union mounts documentation [ver #2]
References: <20120221175721.25235.8901.stgit@warthog.procyon.org.uk> <20120221175947.25235.58759.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120221175947.25235.58759.stgit@warthog.procyon.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/21/2012 09:59 AM, David Howells wrote:

> From: Valerie Aurora <vaurora@redhat.com>
> 
> Document design and implementation of union mounts (a.k.a. writable overlays).
> 
> With corrections from Andreas Gruenbacher <agruen@suse.de>.
> 
> Original-author: Valerie Aurora <vaurora@redhat.com>
> Signed-off-by: David Howells <dhowells@redhat.com>
> ---
> 
>  Documentation/filesystems/union-mounts.txt |  712 ++++++++++++++++++++++++++++
>  1 files changed, 712 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/filesystems/union-mounts.txt
> 
> diff --git a/Documentation/filesystems/union-mounts.txt b/Documentation/filesystems/union-mounts.txt
> new file mode 100644
> index 0000000..596bfe6
> --- /dev/null
> +++ b/Documentation/filesystems/union-mounts.txt
> @@ -0,0 +1,712 @@
> +Union mounts (a.k.a. writable overlays)
> +=======================================
> +
> +This document describes the architecture and current status of union mounts,
> +also known as writable overlays.
> +
> +In this document:
> + - Overview of union mounts
> + - Terminology
> + - VFS implementation
> + - Locking strategy
> + - VFS/file system interface
> + - Userland interface
> + - NFS interaction
> + - Status
> + - Contributing to union mounts
> +
> +Overview
> +========
> +
> +A union mount layers one read-write file system over one or more read-only file
> +systems, with all writes going to the writable file system.  The namespace of
> +both file systems appears as a combined whole to userland, with files and
> +directories on the writable file system covering up any files or directories
> +with matching pathnames on the read-only file system.  The read-write file
> +system is the "topmost" or "upper" file system and the read-only file systems
> +are the "lower" file systems.  A few use cases:
> +
> +- Root file system on CD with writes saved to hard drive (LiveCD)
> +- Multiple virtual machines with the same starting root file system
> +- Cluster with NFS mounted root on clients
> +
> +Most if not all of these problems could be solved with a COW block device or a




                            problems?  use cases?

> +clustered file system (include NFS mounts).  However, for some use cases,
> +sharing is more efficient and better performing if done at the file system
> +namespace level.  COW block devices only increase their divergence as time goes
> +on, and a fully coherent writable file system is unnecessary synchronization
> +overhead if no other client needs to see the writes.
> +
> +What union mounts are not
> +-------------------------
> +




...


> +
> +Terminology
> +===========
> +



...

> +VFS objects and union mounts
> +----------------------------
> +




...

> +
> +In union mounts, a file system can only be the topmost layer for one union
> +mount.  A file system can be part of multiple union mounts if it is a read-only
> +layer.  So dentries in the read-only layers can be part of multiple unions,
> +while a dentry in the read-write layer can only be part of one unin.






typo:                                                             union.

> +
> +union_dir structure
> +---------------------
> +




...

> +/*
> + * The union_stack structure.  It is an array of struct paths of
> + * directories below the topmost directory in a unioned directory, The




                                                           directory.

> + * topmost dentry has a pointer to this structure.  The topmost dentry
> + * can only be part of one union, so we can reference it from the
> + * dentry, but lower dentries can be part of multiple union stacks.
> + *
> + * The number of dirs actually allocated is kept in the superblock,
> + * s_union_count.
> + */
> +struct union_stack {
> +	struct path u_dirs[0];
> +};
> +
> +This structure is flexible enough to support an arbitrary number of layers of
> +unioned file systems.  Since there can be more than two layers, this section
> +will talk about mapping "upper" directories to "lower" directories, instead of
> +"topmost" directories to "bottom" directories.
> +
> +Traversing the union stack
> +--------------------------
> +



...



> +Permission checks
> +-----------------
> +



...

> +
> +inode_permission() calls sb_permission() and __inode_permission() on the same
> +path.  We create path_permission() which calls sb_permission() on the parent
> +directory from the top layer, and __inode_permission() on the target on the
> +lower layer.  This gets us the correct write permissions consdering that the




                                                            considering

> +file will be copied up.
> +
> +Locking strategy
> +================
> +
> +The current union mount locking strategy is based on the following
> +rules:
> +
> +* The lower layer file system is always read-only
> +* The topmost file system is always read-write
> +  => A file system can never a topmost and lower layer at the same time


                      can never be topmost and a lower layer at the same time

> +
> +Additionally, the topmost layer may only be mounted exactly once.  Don't think
> +of the topmost layer as a separate independent file system; when it is part of
> +a union mount, it is only a file system in conjunction with the read-only
> +bottom layer.  The read-only bottom layer is an independent file system in and
> +of itself and can be mounted elsewhere, including as the bottom layer for
> +another union mount.
> +
> +Thus, we may define a stable locking order in terms of top layer and bottom
> +layer locks, since a top layer is never a bottom layer and a bottom layer is
> +never a top layer.  Another simplifying assumption is that all directories in a
> +pathname exist on the top layer, as they are created step-by-step during
> +lookup.  This prevents us from ever having to walk backwards up the path
> +creating directory entries, which can get complicated.  By implication, parent
> +directories paths during any operation (rename(), unlink(),etc.) are from the


   directory paths

> +top layer.  Dentries for directories from the bottom layer are only ever seen
> +or used by the lookup code.
> +
> +The two major problems we avoid with the above rules are:
> +
> +Lock ordering: Imagine two union stacks with the same two file systems: A
> +mounted over B, and B mounted over A.  Sometimes locks on objects in both A and
> +B will have to be held simultanously.  What order should they be acquired in?


                          simultaneously.

> +Simply acquiring them from top to bottom will create a lock-ordering problem -
> +one thread acquires lock on object from A and then tries for a lock on object
> +from B, while another thread grabs the lock on object from B and then waits for
> +the lock on object from A.  Some other lock ordering must be defined.
> +
> +Movement/change/disappearance of objects on multiple layers: A variety of nasty
> +corner cases arise when more than one layer is changing at the same time.
> +Changes in the directory topology and their effect on inheritance are of
> +special concern.  Al Viro's canonical email on the subject:
> +
> +http://lkml.indiana.edu/hypermail/linux/kernel/0802.0/0839.html
> +
> +We don't try to solve any of these cases, just avoid them in the first place.
> +
> +Todo: Prevent top layer from being mounted more than once.
> +

...

> +Userland support
> +================
> +
> +The mount command must support the "-o union" mount option and pass the
> +corresponding MS_UNION flag to the kerel.  A util-linux git tree with union


                                      kernel.

> +mount support is here:
> +
> +git://git.kernel.org/pub/scm/utils/util-linux-ng/val/util-linux-ng.git
> +
> +File system utilities must support whiteouts and fallthrus.  An e2fsprogs git
> +tree with union mount support is here:
> +
> +git://git.kernel.org/pub/scm/fs/ext2/val/e2fsprogs.git
> +
> +Currently, whiteout directory entries are not returned to userland.  While the
> +directory type for whiteouts, DT_WHT, has been defined for many years, very
> +little userland code handles them.  Userland will never see fallthru directory
> +entries.

...

> +Non-features
> +------------
> +


...

> +Read-only top layer: The readdir() strategy fundamentally requires the ability
> +to create persistent directory entries on the top layer file system (which may
> +be tmpfs).  However, you can union two read-only file systems by union mounting
> +a third file system (such as tmpfs) over the two read-onlly file systems.


                                                    read-only

> +Numerous alternatives to this readdir() strategy (including in-kernel or
> +in-application caching) exist and are compatible with union mounts with its
> +writing-readdir() implementation disabled.  Creating a readdir() cookie that is
> +stable across multiple readdir()s requires one of:
> +
> +- Write to stable storage (e.g., fallthru dentries)
> +- Non-evictable kernel memory cache (doesn't handle NFS server reboot)
> +- Per-application caching by glibc readdir()
> +
> +Often these features are supported by other unioning file systems or by other
> +versions of union mounts.




-- 
~Randy
