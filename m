Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756854Ab0IPWXF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 18:23:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45949 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755641Ab0IPWOT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 18:14:19 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Christoph Hellwig <hch@infradead.org>,
        Andreas Gruenbacher <agruen@suse.de>, Nick Piggin <npiggin@kernel.dk>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Valerie Aurora <vaurora@redhat.com>
Subject: [PATCH 00/34] Union mount core for review
Date: Thu, 16 Sep 2010 15:11:51 -0700
Message-Id: <1284675145-4391-1-git-send-email-vaurora@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series is the core mount and lookup infrastructure from union
mounts, split up into small, easily digestible, bikeshed-friendly
pieces.  All of the (non-documentation, non-whitespace) patches in
this series are less than 140 lines long.  It's like Twitter for
kernel patches.

VFS developers should be able to review each of these patches in 3
minutes or less.  If it takes you longer, email me and I'll post a
video on YouTube making fun of you.

Changes since last posted version:

 - Lower directory entries now in one array, not linked list
 - Use clone_mnt() flags to automate hard read-only counts
 - Actually enforce top-layer-mounted-only-once rule
 - Retune DNAME_INLINE_LEN_MIN to keep 64-byte alignment
 - Updated documentation

Next on the todo list:

 - Rewrite in-kernel copyup to be more awesomer
  * Prevent half-finished copies appearing after crash
  * Set correct owners/perms/etc. of copied up dirs/files
  * Remove races between parent/target lookup
  * On metadata writes, only copyup file data if it succeeds
 - Keep reviewing hybrid union patches

After I finish that (3-4 weeks?), I have nothing major left on my
to-do list.  I'm sure that will change as I get code reviews. :)

Against 2.6.35.  The rest of the series (whiteouts, fallthrus,
soon-to-be-obsolete copyup, etc.) is in branch "split_lookup"
in:

git://git.kernel.org/pub/scm/linux/kernel/git/val/linux-2.6.git

Thanks for reviewing!

-VAL

Jan Blunck (3):
  union-mount: Introduce MNT_UNION and MS_UNION flags
  union-mount: Free union stack on removal of topmost dentry from
    dcache
  union-mount: Create IS_MNT_UNION()

Valerie Aurora (31):
  VFS: Make clone_mnt() and copy_tree() return error codes
  VFS: Add CL_NO_SHARED flag to clone_mnt()/copy_tree()
  VFS: Add CL_NO_SLAVE flag to clone_mnt()/copy_tree()
  VFS: Add CL_MAKE_HARD_READONLY flag to clone_mnt()/copy_tree()
  union-mount: Union mounts documentation
  union-mount: Add CONFIG_UNION_MOUNT option
  union-mount: Create union_stack structure
  union-mount: Add two superblock fields for union mounts
  union-mount: Add union_alloc()
  union-mount: Add union_find_dir()
  union-mount: Create d_free_unions()
  union-mount: Create union_add_dir()
  union-mount: Add union_create_topmost_dir()
  union-mount: Create needs_lookup_union()
  union-mount: Create check_topmost_union_mnt()
  union-mount: Add clone_union_tree() and put_union_sb()
  union-mount: Create build_root_union()
  union-mount: Create prepare_mnt_union() and cleanup_mnt_union()
  union-mount: Prevent improper union-related remounts
  union-mount: Prevent topmost file system from being mounted elsewhere
  union-mount: Prevent bind mounts of union mounts
  union-mount: Implement union mount
  union-mount: Temporarily disable some syscalls
  union-mount: Basic infrastructure of __union_lookup()
  union-mount: Process negative dentries in __union_lookup()
  union-mount: Return files found in lower layers in __union_lookup()
  union-mount: Build union stack in __lookup_union()
  union-mount: Follow mount in __lookup_union()
  union-mount: Add lookup_union() wrapper for __lookup_union()
  union-mount: Add do_lookup_union() wrapper for __lookup_union()
  union-mount: Call union lookup functions in lookup path

 Documentation/filesystems/union-mounts.txt |  744 ++++++++++++++++++++++++++++
 fs/Kconfig                                 |   13 +
 fs/Makefile                                |    1 +
 fs/dcache.c                                |   14 +
 fs/namei.c                                 |  204 ++++++++
 fs/namespace.c                             |  378 ++++++++++++--
 fs/pnode.c                                 |    5 +-
 fs/pnode.h                                 |    3 +
 fs/super.c                                 |    1 +
 fs/union.c                                 |  178 +++++++
 fs/union.h                                 |   80 +++
 include/linux/dcache.h                     |   22 +-
 include/linux/fs.h                         |   13 +
 include/linux/mount.h                      |    4 +
 14 files changed, 1604 insertions(+), 56 deletions(-)
 create mode 100644 Documentation/filesystems/union-mounts.txt
 create mode 100644 fs/union.c
 create mode 100644 fs/union.h

