Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754293Ab0FAHO2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 03:14:28 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:52325 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751612Ab0FAHOZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 03:14:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=sq3orhpGhVFbnoklnfGWk9JuVaBXN5vuowLbnOAQVL7fwdeNTuGmcLgvJF+MdDDjMS
         byBT1d/C4TRtU4TO1jZz40LEP3I8RQnTVCe2XUVdzQPv9dLp5OlidVmHrxXJGhE3ap5G
         KIyIB0uBF1AuKxez6xtcOHfh4GI5egT3U7pBQ=
Date: Tue, 1 Jun 2010 09:14:04 +0200
From: Dan Carpenter <error27@gmail.com>
To: James Morris <jmorris@namei.org>
Cc: Casey Schaufler <casey@schaufler-ca.com>,
       "David P. Quigley" <dpquigl@tycho.nsa.gov>,
       David Howells <dhowells@redhat.com>, Serge Hallyn <serue@us.ibm.com>,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [patch] smack: opt_dentry is never null in in smack_d_instantiate()
Message-ID: <20100601071404.GH5483@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	James Morris <jmorris@namei.org>,
	Casey Schaufler <casey@schaufler-ca.com>,
	"David P. Quigley" <dpquigl@tycho.nsa.gov>,
	David Howells <dhowells@redhat.com>,
	Serge Hallyn <serue@us.ibm.com>,
	linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes some unneeded code for if opt_dentry is null because
that can never happen.

The function dereferences "opt_dentry" earlier when it checks 
"if (opt_dentry->d_parent == opt_dentry) {".  That code was added in
2008.

This function called from security_d_instantiate().  I checked all the 
places which call security_d_instantiate() and dentry is always non-null.
I also checked the selinux version of this hook and there is a comment
which says that dentry should be non-null if called from 
d_instantiate().

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index 0f2fc48..07abc9c 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -2191,7 +2191,7 @@ static void smack_ipc_getsecid(struct kern_ipc_perm *ipp, u32 *secid)
 
 /**
  * smack_d_instantiate - Make sure the blob is correct on an inode
- * @opt_dentry: unused
+ * @opt_dentry: dentry where inode will be attached
  * @inode: the object
  *
  * Set the inode's security blob if it hasn't been done already.
@@ -2310,20 +2310,10 @@ static void smack_d_instantiate(struct dentry *opt_dentry, struct inode *inode)
 		/*
 		 * Get the dentry for xattr.
 		 */
-		if (opt_dentry == NULL) {
-			dp = d_find_alias(inode);
-			if (dp == NULL)
-				break;
-		} else {
-			dp = dget(opt_dentry);
-			if (dp == NULL)
-				break;
-		}
-
+		dp = dget(opt_dentry);
 		fetched = smk_fetch(inode, dp);
 		if (fetched != NULL)
 			final = fetched;
-
 		dput(dp);
 		break;
 	}
