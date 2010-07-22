Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758825Ab0GVUog (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 16:44:36 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:58670 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752352Ab0GVUoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 16:44:34 -0400
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
        linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        James Morris <jmorris@namei.org>,
        David Safford <safford@watson.ibm.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>
Subject: [PATCH v2 00/14] EVM
Date: Thu, 22 Jul 2010 16:44:01 -0400
Message-Id: <1279831456-2765-1-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am reposting the EVM and IMA appraisal patches with the following changes:
- adds Documentation/ABI/testing/evm
- removed leading blanks (checkpatch.pl)
- removed file trailing blank lines (git quiltimport)
- added include files, where functions are first defined, to resolve
  'symbol not declared, should be static' (new sparse warnings)
- fixed stub function definitions to be 'static inline' to resolve
  'defined but not used' gcc warnings.
(More specific changelog details are in the individual patch descriptions.)

fs summary:
- Moves ima_iint.c up a layer to security/integrity and renames
  ima_inode_alloc/free hooks to integrity_inode_alloc/free
- Defines 2 new generic functions: vfs_getxattr_alloc, vfs_xattr_cmp
- Adds 3 EVM calls in the security hooks: evm_inode_setxattr(),
	evm_inode_post_setxattr(), evm_inode_removexattr
- Defines 3 new calls: evm_inode_post_init(), evm_inode_post_setattr(),
	evm_inode_post_removexattr()
- Exports: evm_verifyxattr()
- Defines 3 new IMA calls for IMA appraisal: ima_inode_setxattr(),
  ima_inode_removexattr(), and ima_inode_post_setattr()

To address concerns of exposing the EVM key to userspace in plaintext
(Eric Paris, Stephan Smalley), future work will define new key-types 
for use with TPM sealed keys and encrypted symmetric keys, so that on
systems with a TPM, the EVM key will never be visible outside the kernel
in plaintext form.

Extended Verification Module(EVM) detects offline tampering of the
security extended attributes (e.g. security.selinux, security.SMACK64,
security.ima), which is the basis for LSM permission decisions and,
with this set of patches, integrity appraisal decisions. To detect
offline tampering of the extended attributes, EVM maintains an
HMAC-sha1 across a set of security extended attributes, storing the
HMAC as the extended attribute 'security.evm'. To verify the integrity
of an extended attribute, EVM exports evm_verifyxattr(), which
re-calculates the HMAC and compares it with the version stored in
'security.evm'.

IMA currently maintains an integrity measurement list, containing
the hashes of all executables, mmapped execute files, and files open
for read by root (assuming the default measurement policy). The
measurement list, with other information, can be used to assert the
integrity of the running system to a third party. The "ima: integrity
appraisal extension" patch extends IMA with local measurement
appraisal. The extension stores and maintains the file integrity
measurement as an extended attribute 'security.ima', which EVM can be
configured to protect.

DAC/MAC protect the integrity of a running system.  An offline attack
can bypass these protection mechanisms by mounting the disk under a
different operating system and modifying the file data/metadata.  If
the disk is subsequently remounted under the EVM + DAC/MAC + IMA
protected OS, then the hash of the file data won't match the hash stored
in the IMA xattr, or the TPM-calculated HMAC of the file's metadata won't
be valid.  Therefore, IMA + MAC + EVM can protect system integrity online
and detect offline tampering.

This patch set applies to the security-testing/next tree.  For more 
information on IMA/EVM, refer to http://linux-ima.sourceforge.net/#EVM.

Much appreciation to Dave Hansen, Serge Hallyn, and Matt Helsley for
reviewing the patches.

Mimi Zohar (14):
  integrity: move ima inode integrity data management
  xattr: define vfs_getxattr_alloc and vfs_xattr_cmp
  evm: re-release
  ima: move ima_file_free before releasing the file
  security: imbed evm calls in security hooks
  evm: inode post removexattr
  evm: imbed evm_inode_post_setattr
  evm: inode_post_init
  fs: add evm_inode_post_init calls
  ima: integrity appraisal extension
  ima: appraise default rules
  ima: inode post_setattr
  ima: add ima_inode_setxattr and ima_inode_removexattr
  ima: appraise measurement required

 Documentation/ABI/testing/evm         |   22 +++
 Documentation/kernel-parameters.txt   |    4 +
 fs/attr.c                             |    7 +-
 fs/ext2/xattr_security.c              |   31 +++-
 fs/ext3/xattr_security.c              |   30 +++-
 fs/ext4/xattr_security.c              |   30 +++-
 fs/file_table.c                       |    2 +-
 fs/xattr.c                            |   63 ++++++-
 include/linux/evm.h                   |   82 ++++++++
 include/linux/ima.h                   |   30 ++-
 include/linux/integrity.h             |   35 ++++
 include/linux/xattr.h                 |   17 ++-
 security/Kconfig                      |    2 +-
 security/Makefile                     |    4 +-
 security/integrity/Kconfig            |    7 +
 security/integrity/Makefile           |   12 ++
 security/integrity/evm/Kconfig        |   13 ++
 security/integrity/evm/Makefile       |    6 +
 security/integrity/evm/evm.h          |   38 ++++
 security/integrity/evm/evm_crypto.c   |  198 +++++++++++++++++++
 security/integrity/evm/evm_main.c     |  336 +++++++++++++++++++++++++++++++++
 security/integrity/evm/evm_secfs.c    |  108 +++++++++++
 security/integrity/iint.c             |  153 +++++++++++++++
 security/integrity/ima/Kconfig        |   16 ++
 security/integrity/ima/Makefile       |    4 +-
 security/integrity/ima/ima.h          |   77 +++++---
 security/integrity/ima/ima_api.c      |   61 +++++--
 security/integrity/ima/ima_appraise.c |  151 +++++++++++++++
 security/integrity/ima/ima_iint.c     |  146 --------------
 security/integrity/ima/ima_main.c     |  153 +++++++++++++---
 security/integrity/ima/ima_policy.c   |   61 ++++++-
 security/integrity/integrity.h        |   50 +++++
 security/security.c                   |   27 +++-
 33 files changed, 1719 insertions(+), 257 deletions(-)
 create mode 100644 Documentation/ABI/testing/evm
 create mode 100644 include/linux/evm.h
 create mode 100644 include/linux/integrity.h
 create mode 100644 security/integrity/Kconfig
 create mode 100644 security/integrity/Makefile
 create mode 100644 security/integrity/evm/Kconfig
 create mode 100644 security/integrity/evm/Makefile
 create mode 100644 security/integrity/evm/evm.h
 create mode 100644 security/integrity/evm/evm_crypto.c
 create mode 100644 security/integrity/evm/evm_main.c
 create mode 100644 security/integrity/evm/evm_secfs.c
 create mode 100644 security/integrity/iint.c
 create mode 100644 security/integrity/ima/ima_appraise.c
 delete mode 100644 security/integrity/ima/ima_iint.c
 create mode 100644 security/integrity/integrity.h

