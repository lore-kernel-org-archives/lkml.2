Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756350Ab1COX0U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 19:26:20 -0400
Received: from tundra.namei.org ([65.99.196.166]:34566 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755416Ab1COX0Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 19:26:16 -0400
Date: Wed, 16 Mar 2011 10:26:11 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: [GIT] Security subsystem changes for 2.6.39
Message-ID: <alpine.LRH.2.00.1103161007330.19446@tundra.namei.org>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull the following changes for the 2.6.39 kernel.

Notable enhancements: 

- Improved mmap support for Smack
- Pathname hooks for CacheFiles (previously unmediated for pathname security)
- Improved management & error handling for keys
- Pass the last pathname component to LSM when creating an inode, to 
  allow it to be used in labeling decisions; implementation for SELinux
- New sb_remount LSM hook; implementation for SELinux to refuse remounts
  if mount labels change
- Misc. fixes and cleanups for AppArmor, SELinux networking, IMA and 
  TOMOYO


The following changes since commit 521cb40b0c44418a4fd36dc633f575813d59a43d:
  Linus Torvalds (1):
        Linux 2.6.38

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6 for-linus

Casey Schaufler (3):
      Subject: [PATCH] Smack: mmap controls for library containment
      Smack: correct behavior in the mmap hook
      Smack: correct final mmap check comparison

David Howells (5):
      CacheFiles: Add calls to path-based security hooks
      KEYS: Add an RCU payload dereference macro
      KEYS: Add a key type op to permit the key description to be vetted
      KEYS: Add a new keyctl op to reject a key with a specified error code
      KEYS: Add an iovec version of KEYCTL_INSTANTIATE

Eric Paris (6):
      fs/vfs/security: pass last path component to LSM on inode creation
      SELinux: Use dentry name in new object labeling
      selinux: drop unused packet flow permissions
      Revert "selinux: simplify ioctl checking"
      LSM: Pass -o remount options to the LSM
      SELinux: implement the new sb_remount LSM hook

Harry Ciao (3):
      SELinux: Auto-generate security_is_socket_class
      SELinux: Socket retains creator role and MLS attribute
      SELinux: Compute SID for the newly created socket

James Morris (4):
      Merge branch 'master'; commit 'v2.6.38-rc7' into next
      Merge branch 'master' of git://git.infradead.org/users/eparis/selinux into next
      Merge branch 'security-next' of git://git.kernel.org/.../jj/apparmor-dev into next
      Merge branch 'next' into for-linus

John Johansen (1):
      AppArmor: Cleanup make file to remove cruft and make it easier to read

Lucian Adrian Grijincu (2):
      security/selinux: fix /proc/sys/ labeling
      security: remove unused security_sysctl hook

Michal Hocko (1):
      AppArmor: cleanup generated files correctly

Mimi Zohar (5):
      IMA: convert i_readcount to atomic
      IMA: define readcount functions
      IMA: maintain i_readcount in the VFS layer
      IMA: remove IMA imbalance checking
      ima: remove unnecessary call to ima_must_measure

Shan Wei (3):
      security:selinux: kill unused MAX_AVTAB_HASH_MASK and ebitmap_startbit
      security:smack: kill unused SMACK_LIST_MAX, MAY_ANY and MAY_ANYWRITE
      AppArmor: kill unused macros in lsm.c

Steffen Klassert (3):
      selinux: Fix check for xfrm selinux context algorithm
      selinux: Fix wrong checks for selinux_policycap_netpeer
      selinux: Fix packet forwarding checks on postrouting

Tetsuo Handa (1):
      TOMOYO: Fix memory leak upon file open.

 Documentation/keys-request-key.txt      |    9 +-
 Documentation/keys.txt                  |   28 ++-
 arch/x86/Kconfig                        |    5 +
 fs/btrfs/inode.c                        |   13 +-
 fs/btrfs/xattr.c                        |    6 +-
 fs/btrfs/xattr.h                        |    3 +-
 fs/cachefiles/namei.c                   |   52 ++++-
 fs/ext2/ext2.h                          |    2 +-
 fs/ext2/ialloc.c                        |    5 +-
 fs/ext2/namei.c                         |    8 +-
 fs/ext2/xattr.h                         |    6 +-
 fs/ext2/xattr_security.c                |    5 +-
 fs/ext3/ialloc.c                        |    5 +-
 fs/ext3/namei.c                         |    8 +-
 fs/ext3/xattr.h                         |    4 +-
 fs/ext3/xattr_security.c                |    5 +-
 fs/ext4/ialloc.c                        |    2 +-
 fs/ext4/xattr.h                         |    4 +-
 fs/ext4/xattr_security.c                |    5 +-
 fs/file_table.c                         |    5 +-
 fs/gfs2/inode.c                         |    7 +-
 fs/jffs2/dir.c                          |    9 +-
 fs/jffs2/nodelist.h                     |    2 +-
 fs/jffs2/security.c                     |    5 +-
 fs/jffs2/write.c                        |   18 +-
 fs/jffs2/xattr.h                        |    5 +-
 fs/jfs/jfs_xattr.h                      |    5 +-
 fs/jfs/namei.c                          |    8 +-
 fs/jfs/xattr.c                          |    6 +-
 fs/namespace.c                          |    4 +
 fs/ocfs2/namei.c                        |    4 +-
 fs/ocfs2/refcounttree.c                 |    3 +-
 fs/ocfs2/xattr.c                        |   10 +-
 fs/ocfs2/xattr.h                        |    4 +-
 fs/open.c                               |    3 +-
 fs/proc/proc_sysctl.c                   |    1 -
 fs/reiserfs/namei.c                     |    9 +-
 fs/reiserfs/xattr_security.c            |    3 +-
 fs/xfs/linux-2.6/xfs_iops.c             |    9 +-
 include/linux/ext3_fs.h                 |    3 +-
 include/linux/fs.h                      |   23 ++-
 include/linux/ima.h                     |    6 -
 include/linux/key-type.h                |   14 +-
 include/linux/key.h                     |    5 +
 include/linux/keyctl.h                  |    2 +
 include/linux/reiserfs_xattr.h          |    2 +
 include/linux/security.h                |   35 ++--
 include/linux/xattr.h                   |    2 +
 kernel/sysctl.c                         |    5 -
 mm/shmem.c                              |    9 +-
 net/rxrpc/ar-key.c                      |   19 ++
 scripts/selinux/genheaders/genheaders.c |   20 ++
 security/apparmor/Makefile              |   38 +++-
 security/apparmor/lsm.c                 |    2 -
 security/capability.c                   |   15 +-
 security/integrity/ima/ima.h            |    3 +-
 security/integrity/ima/ima_api.c        |   13 +-
 security/integrity/ima/ima_iint.c       |    5 -
 security/integrity/ima/ima_main.c       |  136 ++----------
 security/keys/compat.c                  |   50 ++++
 security/keys/encrypted.c               |    3 +-
 security/keys/internal.h                |    8 +
 security/keys/key.c                     |   27 ++-
 security/keys/keyctl.c                  |  143 +++++++++++-
 security/keys/keyring.c                 |    4 +-
 security/keys/request_key.c             |    2 +-
 security/keys/trusted.c                 |    3 +-
 security/keys/user_defined.c            |    3 +-
 security/security.c                     |   19 +-
 security/selinux/hooks.c                |  350 ++++++++++++++++--------------
 security/selinux/include/classmap.h     |    7 +-
 security/selinux/include/security.h     |    8 +-
 security/selinux/ss/avtab.h             |   23 +-
 security/selinux/ss/ebitmap.h           |    1 -
 security/selinux/ss/mls.c               |    5 +-
 security/selinux/ss/mls.h               |    3 +-
 security/selinux/ss/policydb.c          |  130 +++++++++++
 security/selinux/ss/policydb.h          |   14 +-
 security/selinux/ss/services.c          |   73 +++++--
 security/selinux/xfrm.c                 |    2 +-
 security/smack/smack.h                  |   17 +-
 security/smack/smack_access.c           |   52 +++--
 security/smack/smack_lsm.c              |  287 ++++++++++++++++++++----
 security/smack/smackfs.c                |  370 +++++++++++++++++++++----------
 security/tomoyo/file.c                  |    5 +-
 85 files changed, 1549 insertions(+), 712 deletions(-)


-- 
James Morris
<jmorris@namei.org>
