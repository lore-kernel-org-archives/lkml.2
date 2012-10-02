Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752833Ab2JBAR2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 20:17:28 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:38254 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752430Ab2JBARH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 20:17:07 -0400
From: Jeff Layton <jlayton@redhat.com>
To: viro@ZenIV.linux.org.uk
Cc: eparis@redhat.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-audit@redhat.com
Subject: [PATCH v7 00/49] audit/getname/estale patch series
Date: Mon,  1 Oct 2012 20:16:09 -0400
Message-Id: <1349137018-21948-1-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.7.11.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset is a unification of the 3 series that I posted
individually over the last several months. The main reason for all of
this is the last series (the estale one). The 3 series are as follows:

audit: this is an overhaul of the audit_names code that cleans up the
code, adds a few micro-optimizations and fixes a few minor bugs. It also
changes that code to allow for retrying syscalls without creating
duplicate records.

getname: this changes the getname/putname interface to deal with a new
struct getname_info rather than "bare" strings. This allows us to pass
around some ancillary data with the resulting getname string. It also
has the nice effect of making it OK to call getname on the same userland
string more than once.

estale: this patchset retrofits many of the path-based syscalls in the
kernel to retry the lookup and operation when the operation returns
ESTALE. There might be a few more that need similar changes afterward,
but this should cover most of the ones people are interested in.

Because there are dependencies between these patchsets, I decided to
just post the whole shebang as one giant patchset.

Al's recent execve unification work paved the way for this by greatly
reducing the number of getname() callers. Thus, this set depends on his
work being merged.

At this point, I think it's this set is ready for merge into 3.7 with
one caveat: The getname patches touch some arch specific code in execve
implementations that have not been unified yet. Some of them I don't
have hardware or working emulators for, so they're not even compile
tested.

That said, the arch-specific changes are pretty straightforward. I don't
expect problems with them, but if there are I'm fairly certain we can
straighten them out before 3.7 ships.

Since this is a large set, it may be easier to just pull them. Pull
request follows:

------------------------[snip]---------------------------
The following changes since commit 659c04881db5f69c8f6f789106be4af85404f03b:

  sparc32: switch to generic sys_execve() (2012-10-01 01:02:23 -0400)

are available in the git repository at:

  git://git.samba.org/jlayton/linux.git estale

for you to fetch changes up to e7c07a567a6ba18ec7d1ef8ceea4f9978a325bed:

  vfs: make lremovexattr retry once on ESTALE error (2012-10-01 19:59:58 -0400)
------------------------[snip]---------------------------

Eric Paris (1):
  audit: make audit_compare_dname_path use parent_len helper

Jeff Layton (48):
  audit: remove unnecessary NULL ptr checks from do_path_lookup
  audit: pass in dentry to audit_copy_inode wherever possible
  audit: no need to walk list in audit_inode if name is NULL
  audit: reverse arguments to audit_inode_child
  audit: add a new "type" field to audit_names struct
  audit: set the name_len in audit_inode for parent lookups
  audit: remove dirlen argument to audit_compare_dname_path
  audit: optimize audit_compare_dname_path
  audit: overhaul __audit_inode_child to accomodate retrying
  vfs: allocate page instead of names_cache buffer in mount_block_root
  vfs: make dir_name arg to do_mount a const char *
  acct: constify the name arg to acct_on
  vfs: define getname_info struct and have getname() return it
  audit: allow audit code to satisfy getname requests from its
    names_list
  vfs: turn do_path_lookup into wrapper around getname_info variant
  vfs: make path_openat take a getname_info pointer
  audit: make audit_inode take getname_info
  vfs: embed getname_info inside of names_cache allocation if possible
  vfs: unexport getname and putname symbols
  vfs: add a retry_estale helper function to handle retries on ESTALE
  vfs: make fstatat retry on ESTALE errors from getattr call
  vfs: fix readlinkat to retry on ESTALE
  vfs: add new "reval" argument to kern_path_create and
    user_path_create
  vfs: fix mknodat to retry on ESTALE errors
  vfs: fix mkdir to retry on ESTALE errors
  vfs: fix symlinkat to retry on ESTALE errors
  vfs: fix linkat to retry on ESTALE errors
  vfs: add a reval argument to user_path_parent
  vfs: make rmdir retry on ESTALE errors
  vfs: make do_unlinkat retry on ESTALE errors
  vfs: fix renameat to retry on ESTALE errors
  vfs: have do_sys_truncate retry once on an ESTALE error
  vfs: have faccessat retry once on an ESTALE error
  vfs: have chdir retry lookup and call once on ESTALE error
  vfs: make chroot retry once on ESTALE error
  vfs: make fchmodat retry once on ESTALE errors
  vfs: make fchownat retry once on ESTALE errors
  vfs: convert do_filp_open to use retry_estale helper
  vfs: convert do_file_open_root to use retry_estale helper
  vfs: allow utimensat() calls to retry once on an ESTALE error
  vfs: allow setxattr to retry once on ESTALE errors
  vfs: allow lsetxattr() to retry once on ESTALE errors
  vfs: make getxattr retry once on an ESTALE error
  vfs: make lgetxattr retry once on ESTALE
  vfs: make listxattr retry once on ESTALE error
  vfs: make llistxattr retry once on ESTALE error
  vfs: make removexattr retry once on ESTALE
  vfs: make lremovexattr retry once on ESTALE error

 arch/alpha/kernel/osf_sys.c                  |  16 +-
 arch/avr32/kernel/process.c                  |   4 +-
 arch/blackfin/kernel/process.c               |   4 +-
 arch/cris/arch-v10/kernel/process.c          |   4 +-
 arch/cris/arch-v32/kernel/process.c          |   4 +-
 arch/h8300/kernel/process.c                  |   4 +-
 arch/hexagon/kernel/syscall.c                |   4 +-
 arch/ia64/kernel/process.c                   |   4 +-
 arch/m32r/kernel/process.c                   |   4 +-
 arch/microblaze/kernel/sys_microblaze.c      |   4 +-
 arch/mips/kernel/linux32.c                   |   4 +-
 arch/mips/kernel/syscall.c                   |   4 +-
 arch/openrisc/kernel/process.c               |   4 +-
 arch/parisc/hpux/fs.c                        |   4 +-
 arch/parisc/kernel/process.c                 |   4 +-
 arch/parisc/kernel/sys_parisc32.c            |   4 +-
 arch/powerpc/platforms/cell/spufs/syscalls.c |   2 +-
 arch/score/kernel/sys_score.c                |   4 +-
 arch/sh/kernel/process_32.c                  |   4 +-
 arch/sh/kernel/process_64.c                  |   4 +-
 arch/tile/kernel/process.c                   |   8 +-
 arch/unicore32/kernel/sys.c                  |   4 +-
 arch/xtensa/kernel/process.c                 |   4 +-
 drivers/base/devtmpfs.c                      |   7 +-
 fs/btrfs/ioctl.c                             |   2 +-
 fs/compat.c                                  |  12 +-
 fs/exec.c                                    |  14 +-
 fs/filesystems.c                             |   4 +-
 fs/internal.h                                |   4 +-
 fs/namei.c                                   | 469 +++++++++++++++++----------
 fs/namespace.c                               |   6 +-
 fs/ocfs2/refcounttree.c                      |   3 +-
 fs/open.c                                    | 289 ++++++++++-------
 fs/quota/quota.c                             |   4 +-
 fs/stat.c                                    |  32 +-
 fs/utimes.c                                  |  15 +-
 fs/xattr.c                                   | 160 +++++----
 include/linux/audit.h                        |  52 ++-
 include/linux/fs.h                           |  44 ++-
 include/linux/fsnotify.h                     |   8 +-
 include/linux/namei.h                        |   4 +-
 init/do_mounts.c                             |   7 +-
 ipc/mqueue.c                                 |  17 +-
 kernel/acct.c                                |   6 +-
 kernel/audit.h                               |   7 +-
 kernel/audit_watch.c                         |   3 +-
 kernel/auditfilter.c                         |  65 ++--
 kernel/auditsc.c                             | 233 ++++++++-----
 mm/swapfile.c                                |  11 +-
 net/unix/af_unix.c                           |   2 +-
 50 files changed, 988 insertions(+), 598 deletions(-)

-- 
1.7.11.4

