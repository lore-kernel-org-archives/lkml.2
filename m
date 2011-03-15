Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758634Ab1COVcy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 17:32:54 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:58388 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758540Ab1COVcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 17:32:50 -0400
Date: Tue, 15 Mar 2011 21:32:48 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [git pull] VFS - the first pile
Message-ID: <20110315213248.GL22723@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Let's try to start pushing early in the window this time...
There are several big ones in that:
	* pathname resolution rewrite: trailing symlink resolution is
iterative in all cases, overall structure simplified a _lot_, do_lookup()
turned into something readable, knowledge of RCU stuff localized, do_last()
returned to handling non-create cases as well, NEED_REVAL_DOT got a lot
saner.
	* open-by-fhandle series by Aneesh
	* O_PATH descriptors (basically, "location in namespace, not actually
opened from fs POV, can be dup'ed/passed around/etc. and used as starting
points in ...at(2) kind of syscalls, but not used for any IO; that stuff
allows to do sane pathname resolution in userland and avoids the need to
add fsckloads of extra syscalls in open-by-fhandle series).

There will be more pull requests; this is just taking care of really
heavy-weight stuff.

Please, pull from
git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs-2.6.git/ for-linus

Shortlog:
Al Viro (45):
      compat breakage in preadv() and pwritev()
      fix race in audit_get_nd()
      kill path_lookup()
      take RCU-dependent stuff around exec_permission() into a new helper
      sanitize path_walk() mess
      merge path_init and path_init_rcu
      merge component type recognition
      untangle the "need_reval_dot" mess
      pull dropping RCU on success of link_path_walk() into path_lookupat()
      pull security_inode_follow_link() into __do_follow_link()
      clean up the failure exits after __do_follow_link() in do_filp_open()
      Collect "operation mode" arguments of do_last() into a structure
      switch do_filp_open() to struct open_flags
      separate -ESTALE/-ECHILD retries in do_filp_open() from real work
      kill out_dput: in link_path_walk()
      pull handling of . and .. into inlined helper
      clear RCU on all failure exits from link_path_walk()
      make handle_dots() leave RCU mode on error
      make nameidata_dentry_drop_rcu_maybe() always leave RCU mode
      get rid of the last LOOKUP_RCU dependencies in link_path_walk()
      get rid of nd->file
      switch non-create side of open() to use of do_last()
      kill __lookup_one_len()
      sanitize pathname component hash calculation
      expand finish_open() in its only caller
      move may_open() from __open_name_create() to do_last()
      do_last: unify may_open() call and everyting after it
      fold __open_namei_create() and open_will_truncate() into do_last()
      do_last: kill a rudiment of old ->d_revalidate() workaround
      path_openat: clean ELOOP handling a bit
      untangle do_lookup()
      reduce vfs_path_lookup() to do_path_lookup()
      open-style analog of vfs_path_lookup()
      clean statfs-like syscalls up
      New AT_... flag: AT_EMPTY_PATH
      New kind of open files - "location only".
      Allow O_PATH for symlinks
      readlinkat(), fchownat() and fstatat() with empty relative pathnames
      Allow passing O_PATH descriptors via SCM_RIGHTS datagrams
      pull handling of one pathname component into a helper
      update nd->inode in __do_follow_link() instead of after do_follow_link()
      Make trailing symlink resolution in path_lookupat() iterative
      simplify link_path_walk() tail
      Turn resolution of trailing symlinks iterative everywhere
      tidy the trailing symlinks traversal up

Aneesh Kumar K.V (12):
      exportfs: Return the minimum required handle size
      vfs: Add name to file handle conversion support
      vfs: Add open by file handle support
      fs: Don't allow to create hardlink for deleted file
      fs: Remove i_nlink check from file system link callback
      x86: Add new syscalls for x86_32
      x86: Add new syscalls for x86_64
      unistd.h: Add new syscalls numbers to asm-generic
      vfs: Export file system uuid via /proc/<pid>/mountinfo
      ext3: Copy fs UUID to superblock.
      ext4: Copy fs UUID to superblock
      fs: allow AT_EMPTY_PATH in linkat(), limit that to CAP_DAC_READ_SEARCH

Diffstat:
 arch/alpha/kernel/osf_sys.c                  |   36 +-
 arch/parisc/hpux/sys_hpux.c                  |   65 +-
 arch/powerpc/platforms/cell/spufs/syscalls.c |    2 +-
 arch/um/drivers/mconsole_kern.c              |   21 +-
 arch/x86/ia32/ia32entry.S                    |    2 +
 arch/x86/include/asm/unistd_32.h             |    4 +-
 arch/x86/include/asm/unistd_64.h             |    4 +
 arch/x86/kernel/syscall_table_32.S           |    2 +
 fs/Kconfig                                   |    2 +-
 fs/Makefile                                  |    2 +
 fs/btrfs/export.c                            |    8 +-
 fs/btrfs/inode.c                             |    3 -
 fs/compat.c                                  |   69 +-
 fs/exec.c                                    |   18 +-
 fs/exportfs/expfs.c                          |   11 +-
 fs/ext3/namei.c                              |    7 -
 fs/ext3/super.c                              |    1 +
 fs/ext4/namei.c                              |    7 -
 fs/ext4/super.c                              |    2 +
 fs/fat/inode.c                               |    4 +-
 fs/fcntl.c                                   |   37 +-
 fs/fhandle.c                                 |  265 +++++
 fs/file_table.c                              |   55 +-
 fs/fuse/inode.c                              |    4 +-
 fs/gfs2/export.c                             |    8 +-
 fs/internal.h                                |   13 +
 fs/isofs/export.c                            |    8 +-
 fs/jfs/namei.c                               |    3 -
 fs/namei.c                                   | 1498 +++++++++++---------------
 fs/namespace.c                               |   16 +
 fs/nfsctl.c                                  |   21 +-
 fs/ocfs2/export.c                            |    8 +-
 fs/ocfs2/refcounttree.c                      |    2 +-
 fs/open.c                                    |  126 ++-
 fs/reiserfs/inode.c                          |    7 +-
 fs/reiserfs/namei.c                          |    4 -
 fs/stat.c                                    |    7 +-
 fs/statfs.c                                  |  176 ++--
 fs/ubifs/dir.c                               |   18 -
 fs/udf/namei.c                               |    7 +-
 fs/xfs/linux-2.6/xfs_export.c                |    4 +-
 include/asm-generic/fcntl.h                  |    4 +
 include/asm-generic/unistd.h                 |    6 +-
 include/linux/exportfs.h                     |    9 +-
 include/linux/fcntl.h                        |    1 +
 include/linux/file.h                         |    2 +
 include/linux/fs.h                           |   19 +-
 include/linux/namei.h                        |    7 +-
 include/linux/syscalls.h                     |    8 +-
 init/Kconfig                                 |   12 +
 kernel/audit_watch.c                         |   85 +-
 kernel/sys_ni.c                              |    5 +
 kernel/sysctl_binary.c                       |   19 +-
 mm/shmem.c                                   |    4 +-
 net/core/scm.c                               |    2 +-
 net/unix/af_unix.c                           |    2 +-
 net/unix/garbage.c                           |    2 +-
 57 files changed, 1489 insertions(+), 1255 deletions(-)

