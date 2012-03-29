Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933413Ab2C2OpV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 10:45:21 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:43003 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933179Ab2C2Omb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 10:42:31 -0400
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-security-module@vger.kernel.org
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Al Viro <viro@ZenIV.linux.org.uk>,
        David Safford <safford@linux.vnet.ibm.com>,
        Dmitry Kasatkin <dmitry.kasatkin@intel.com>
Subject: [PATCH v4 00/12] ima: appraisal extension 
Date: Thu, 29 Mar 2012 10:41:28 -0400
Message-Id: <1333032100-4159-1-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.6.5
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12032914-5806-0000-0000-000013D8F4D5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IMA currently maintains an integrity measurement list used to assert the
integrity of the running system to a third party.  The IMA-appraisal
extension adds local integrity validation and enforcement of the
measurement against a "good" value stored as an extended attribute
'security.ima'.  The initial methods for validating 'security.ima' are
hashed based, which provides file data integrity, and digital signature
based, which in addition to providing file data integrity, provides
authenticity.

New hooks:
ima_inode_setxattr(), ima_inode_removexattr(), ima_inode_post_setattr(),
and ima_defer_fput()

IMA-appraisal extends the measurement policy ABI with two new keywords:
appraise/dont_appraise and adds a new boot parameter 'ima_appraise_tcb'
to appraise all files owned by root.  Like the ima_tcb measurement policy,
the ima_appraise_tcb policy does not appraise pseudo filesystem files
(eg. debugfs, tmpfs, securityfs, selinuxfs or ramfs.)

Additional rules can be added to the default IMA measurement/appraisal
policy, which take advantage of the SELinux labels, for a more fine
grained policy.

Locking changes:

The ima-appraisal extension maintains the file integrity measurement as
an extended attribute 'security.ima'.  ima_file_free(), called on __fput(),
updates 'security.ima' to reflect any changes made to the file.  In fix
mode, process_measurement() writes 'security.ima' to reflect the current
file hash.  Writing extended attributes and other file metadata (eg. chmod),
requires taking the i_mutex.  Both ima_file_free() and process_measurement()
took the iint->mutex and then the i_mutex, while chmod() took the locks in
reverse order.  To resolve the potential lock inversion deadlock, the
redundant iint->mutex was eliminated.

Writing 'security.ima' from __fput() caused an mmap_sem/i_mutex lockdep,
when an mmapped file was closed before it was munmapped.  To resolve this
lockdep, ima_defer_fput() defers the __fput for files, that were closed
prior to the munmap and were mmapped write, by incrementing the f_count
and creating/adding it to the workqueue.

Prereqs:
   vfs: fix IMA lockdep circular locking dependency
   vfs: iversion truncate bug fix

Changelog v4:
- ima_defer_fput() performance improvements

Changelog v3:
- defined the boot command line parameter 'ima_appraise_tcb' to permit
  measuring without appraising, and appraising without measuring.
- use slab mempool to defer __fput() work
- change appraisal default for filesystems without xattr support to fail

Changelog v2:
- Split the "ima: allocating iint improvements" patch, making the
  spinlock to rwlock/read_lock change into a separate patch.
- Removed the "vfs: Correctly set the dir i_mutex lockdep class" dependency.
- New: "ima: delay calling __fput()"
- Minor changes listed in individual patch descriptions

Changelog v1:
- Initial posting of the IMA-appraisal patches, separately from EVM.

Dmitry Kasatkin (3):
  ima: free securityfs violations file
  ima: allocating iint improvements
  ima: digital signature verification support

Mimi Zohar (9):
  vfs: extend vfs_removexattr locking
  vfs: move ima_file_free before releasing the file
  ima: integrity appraisal extension
  ima: add appraise action keywords and default rules
  ima: replace iint spinlock with rwlock/read_lock
  ima: add inode_post_setattr call
  ima: add ima_inode_setxattr/removexattr function and calls
  ima: defer calling __fput()
  ima: add support for different security.ima data types

 Documentation/ABI/testing/ima_policy  |   25 ++-
 Documentation/kernel-parameters.txt   |    8 +
 fs/attr.c                             |    2 +
 fs/file_table.c                       |    7 +-
 fs/xattr.c                            |    6 +-
 include/linux/ima.h                   |   32 +++
 include/linux/integrity.h             |    7 +-
 include/linux/xattr.h                 |    3 +
 security/integrity/evm/evm_main.c     |    3 +
 security/integrity/iint.c             |   64 +++----
 security/integrity/ima/Kconfig        |   15 ++
 security/integrity/ima/Makefile       |    2 +
 security/integrity/ima/ima.h          |   37 ++++-
 security/integrity/ima/ima_api.c      |   56 ++++--
 security/integrity/ima/ima_appraise.c |  344 +++++++++++++++++++++++++++++++++
 security/integrity/ima/ima_crypto.c   |    8 +-
 security/integrity/ima/ima_fs.c       |    1 +
 security/integrity/ima/ima_main.c     |   89 ++++++---
 security/integrity/ima/ima_policy.c   |  181 +++++++++++++-----
 security/integrity/integrity.h        |   11 +-
 security/security.c                   |    6 +
 21 files changed, 758 insertions(+), 149 deletions(-)
 create mode 100644 security/integrity/ima/ima_appraise.c

-- 
1.7.6.5

