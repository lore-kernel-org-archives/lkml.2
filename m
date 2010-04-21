Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756878Ab0DUWTE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 18:19:04 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:52443 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756798Ab0DUWTA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 18:19:00 -0400
Subject: Re: [PATCH 00/14] EVM
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       James Morris <jmorris@namei.org>,
       David Safford <safford@watson.ibm.com>,
       Dave Hansen <dave@linux.vnet.ibm.com>
In-Reply-To: <20100421145848.b36ab7bd.randy.dunlap@oracle.com>
References: <1271886594-3719-1-git-send-email-zohar@linux.vnet.ibm.com>
	 <20100421145848.b36ab7bd.randy.dunlap@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 21 Apr 2010 18:18:58 -0400
Message-ID: <1271888338.2650.13.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-04-21 at 14:58 -0700, Randy Dunlap wrote:
> On Wed, 21 Apr 2010 17:49:40 -0400 Mimi Zohar wrote:
> 
> > Extended Verification Module(EVM) detects offline tampering of the
> > security extended attributes (e.g. security.selinux, security.SMACK64,
> > security.ima), which is the basis for LSM permission decisions and,
> > with this set of patches, integrity appraisal decisions. To detect
> > offline tampering of the extended attributes, EVM maintains an
> > HMAC-sha1 across a set of security extended attributes, storing the
> > HMAC as the extended attribute 'security.evm'. To verify the integrity
> > of an extended attribute, EVM exports evm_verifyxattr(), which
> > re-calculates the HMAC and compares it with the version stored in
> > 'security.evm'.
> > 
> ...
> > 
> > Much appreciation to Dave Hansen, Serge Hallyn, and Matt Helsley for
> > reviewing the patches.
> > 
> > Mimi
> > 
> > Mimi Zohar (14):
> >   integrity: move ima inode integrity data management
> >   security: move LSM xattrnames to xattr.h
> >   xattr: define vfs_getxattr_alloc and vfs_xattr_cmp
> >   evm: re-release
> >   ima: move ima_file_free before releasing the file
> >   security: imbed evm calls in security hooks
> >   evm: inode post removexattr
> >   evm: imbed evm_inode_post_setattr
> >   evm: inode_post_init
> >   fs: add evm_inode_post_init calls
> >   ima: integrity appraisal extension
> >   ima: appraise default rules
> >   ima: inode post_setattr
> >   ima: add ima_inode_setxattr and ima_inode_removexattr
> > --
> 
> A summary diffstat would be good to see in patch 00/14.
> 
> Lacking that, at least each individual patch should have a diffstat summary
> in it.  Please read Documentation/SubmittingPatches.
> 
> ---
> ~Randy

Only two minor changes from the RFC posting:

0011-ima-integrity-appraisal-extension.patch adds a missing
ima_fix_xattr() call.

Index: security-testing-2.6/security/integrity/ima/ima_appraise.c
===================================================================
--- security-testing-2.6.orig/security/integrity/ima/ima_appraise.c
+++ security-testing-2.6/security/integrity/ima/ima_appraise.c
@@ -92,8 +92,13 @@ int ima_appraise_measurement(struct inte
 				ima_fix_xattr(dentry, iint);
 			integrity_audit_msg(AUDIT_INTEGRITY_DATA, inode,
 					    filename, op, cause, 1, 0);
-		} else
+		} else {
 			status = INTEGRITY_PASS;
+
+			if ((status == INTEGRITY_UNKNOWN)
+			    && (ima_appraise & IMA_APPRAISE_FIX))
+				ima_fix_xattr(dentry, iint);
+		}
 		iint->flags |= IMA_APPRAISED;
 	} else {
 		if (status == INTEGRITY_NOLABEL)

0012-ima-appraise-default-rules.patch replaces audit_log_format() calls
with ima_log_string(), introduced in Eric's patches.

Mimi


