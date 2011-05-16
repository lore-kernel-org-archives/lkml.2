Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755788Ab1EPOqM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 10:46:12 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:35617 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755622Ab1EPOqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 10:46:08 -0400
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-security-module@vger.kernel.org
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, James Morris <jmorris@namei.org>,
        David Safford <safford@watson.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
        Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
Subject: [PATCH v5 00/21] EVM
Date: Mon, 16 May 2011 10:44:54 -0400
Message-Id: <1305557115-15652-1-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Extended Verification Module(EVM) detects offline tampering of the security
extended attributes (e.g. security.selinux, security.SMACK64, security.ima),
which is the basis for LSM permission decisions and, with the IMA-appraisal
patchset, integrity appraisal decisions. This patchset provides the framework
and an initial method to detect offline tampering of the security extended
attributes.  The initial method maintains an HMAC-sha1 across a set of
security extended attributes, storing the HMAC as the extended attribute
'security.evm'. To verify the integrity of an extended attribute, EVM exports
evm_verifyxattr(), which re-calculates the HMAC and compares it with the
version stored in 'security.evm'.  Other methods of validating the integrity
of a file's metadata will be posted separately (eg. EVM-digital-signatures).

While this patchset does authenticate the security xattrs, and
cryptographically binds them to the inode, coming extensions will bind other
directory and inode metadata for more complete protection.  To help simplify
the review and upstreaming process, each extension will be posted separately
(eg. IMA-appraisal, IMA-appraisal-directory).  For a general overview of the
proposed Linux integrity subsystem, refer to Dave Safford's whitepaper:
http://downloads.sf.net/project/linux-ima/linux-ima/Integrity_overview.pdf.

Much appreciation to Dave Hansen, Serge Hallyn, and Matt Helsley for
reviewing the original patches.

Changes from v4:
- Added evm_inode_post_init calls for: btrfs, gfs2, jffs2, jfs, and xfs.
- Prevent an invalid security.evm xattr from being updated.
- evm_verifyxattr() performance improvement (Dmitry Kasatkin)
- Fixed evm_verify_hmac() to be fail safe (Dmitry Kasatkin)
- Additional naming change generalizations in preparation for other methods
  of integrity authentication. (Dmitry Kasatkin) 

Mimi Zohar
David Safford

Dmitry Kasatkin (5):
  evm: add support for different security.evm data types
  evm: crypto hash replaced by shash
  evm: additional parameter to pass integrity cache entry 'iint'
  evm: evm_verify_hmac must not return INTEGRITY_UNKNOWN
  evm: replace hmac_status with evm_status

Mimi Zohar (16):
  integrity: move ima inode integrity data management
  xattr: define vfs_getxattr_alloc and vfs_xattr_cmp
  evm: re-release
  ima: move ima_file_free before releasing the file
  security: imbed evm calls in security hooks
  evm: evm_inode_post_removexattr
  evm: imbed evm_inode_post_setattr
  evm: evm_inode_post_init
  fs: add evm_inode_post_init calls
  evm: add evm_inode_post_init call in btrfs
  evm: add evm_inode_post_init call in gfs2
  evm: add evm_inode_post_init call in jffs2
  evm: add evm_inode_post_init call in jfs
  evm: add evm_inode_post_init call in xfs
  evm: permit only valid security.evm xattrs to be updated
  evm: add evm_inode_setattr to prevent updating an invalid
    security.evm

 Documentation/ABI/testing/evm       |   23 ++
 Documentation/kernel-parameters.txt |    6 +
 fs/attr.c                           |    5 +-
 fs/btrfs/xattr.c                    |   39 +++-
 fs/ext2/xattr_security.c            |   31 +++-
 fs/ext3/xattr_security.c            |   30 ++-
 fs/ext4/xattr_security.c            |   30 ++-
 fs/file_table.c                     |    2 +-
 fs/gfs2/inode.c                     |   28 ++-
 fs/jffs2/security.c                 |   26 ++-
 fs/jfs/xattr.c                      |   45 +++--
 fs/xattr.c                          |   63 ++++++-
 fs/xfs/linux-2.6/xfs_iops.c         |   27 ++-
 include/linux/evm.h                 |   92 +++++++++
 include/linux/ima.h                 |   13 --
 include/linux/integrity.h           |   43 ++++
 include/linux/xattr.h               |   14 ++-
 security/Kconfig                    |    2 +-
 security/Makefile                   |    4 +-
 security/integrity/Kconfig          |    7 +
 security/integrity/Makefile         |   12 +
 security/integrity/evm/Kconfig      |   12 +
 security/integrity/evm/Makefile     |    6 +
 security/integrity/evm/evm.h        |   39 ++++
 security/integrity/evm/evm_crypto.c |  211 +++++++++++++++++++
 security/integrity/evm/evm_main.c   |  384 +++++++++++++++++++++++++++++++++++
 security/integrity/evm/evm_secfs.c  |  108 ++++++++++
 security/integrity/iint.c           |  171 ++++++++++++++++
 security/integrity/ima/Kconfig      |    1 +
 security/integrity/ima/Makefile     |    2 +-
 security/integrity/ima/ima.h        |   29 +--
 security/integrity/ima/ima_api.c    |    7 +-
 security/integrity/ima/ima_iint.c   |  169 ---------------
 security/integrity/ima/ima_main.c   |   12 +-
 security/integrity/integrity.h      |   38 ++++
 security/security.c                 |   26 ++-
 36 files changed, 1465 insertions(+), 292 deletions(-)
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
 delete mode 100644 security/integrity/ima/ima_iint.c
 create mode 100644 security/integrity/integrity.h

-- 
1.7.3.4

