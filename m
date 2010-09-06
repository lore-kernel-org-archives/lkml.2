Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755053Ab0IFAvV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Sep 2010 20:51:21 -0400
Received: from cantor2.suse.de ([195.135.220.15]:32820 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755031Ab0IFAvT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Sep 2010 20:51:19 -0400
From: NeilBrown <neilb@suse.de>
To: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 06 Sep 2010 10:50:28 +1000
Subject: [PATCH 01/10] ovl: small optimisation for ovl_lookup
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <20100906005028.20775.47191.stgit@localhost.localdomain>
In-Reply-To: <20100906004829.20775.68828.stgit@localhost.localdomain>
References: <20100906004829.20775.68828.stgit@localhost.localdomain>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we find a non-directory in the upper layer, there is no point
performing a lookup in the lower layer as whatever is found will just
be ignored anyway.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 fs/overlayfs/overlayfs.c |   17 ++++++++---------
 1 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/fs/overlayfs/overlayfs.c b/fs/overlayfs/overlayfs.c
index 0fe3944..0ddfeec 100644
--- a/fs/overlayfs/overlayfs.c
+++ b/fs/overlayfs/overlayfs.c
@@ -495,7 +495,8 @@ static struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 				dput(upperdentry);
 				upperdentry = NULL;
 				ue->opaque = true;
-			}
+			} else if (!S_ISDIR(upperdentry->d_inode->i_mode))
+				ue->opaque = true;
 			revert_creds(old_cred);
 			put_cred(override_cred);
 		}
@@ -507,14 +508,12 @@ static struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 			dput(upperdentry);
 			goto out_free;
 		}
-	}
-
-	if (lowerdentry && upperdentry &&
-	    (!S_ISDIR(upperdentry->d_inode->i_mode) ||
-	     !S_ISDIR(lowerdentry->d_inode->i_mode))) {
-		dput(lowerdentry);
-		lowerdentry = NULL;
-		ue->opaque = true;
+		if (lowerdentry && upperdentry &&
+		    !S_ISDIR(lowerdentry->d_inode->i_mode)) {
+			dput(lowerdentry);
+			lowerdentry = NULL;
+			ue->opaque = true;
+		}
 	}
 
 	if (lowerdentry || upperdentry) {


