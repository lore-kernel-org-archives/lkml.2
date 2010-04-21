Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756761Ab0DUVu2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 17:50:28 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:44596 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755393Ab0DUVuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 17:50:25 -0400
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org,
       Mimi Zohar <zohar@linux.vnet.ibm.com>, James Morris <jmorris@namei.org>,
       David Safford <safford@watson.ibm.com>,
       Dave Hansen <dave@linux.vnet.ibm.com>
Subject: [PATCH 00/14] EVM
Date: Wed, 21 Apr 2010 17:49:40 -0400
Message-Id: <1271886594-3719-1-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.6.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
the hashes of all executables, mmaped execute files, and files open
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

This patch set applies to the security-testing/next tree. They
prereq remove-kref-set.patch (https://patchwork.kernel.org/patch/86079,
linux-next commit 8e47f1004).

Much appreciation to Dave Hansen, Serge Hallyn, and Matt Helsley for
reviewing the patches.

Mimi

Mimi Zohar (14):
  integrity: move ima inode integrity data management
  security: move LSM xattrnames to xattr.h
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
