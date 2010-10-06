Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758696Ab0JFM3n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 08:29:43 -0400
Received: from adelie.canonical.com ([91.189.90.139]:50953 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756004Ab0JFM3m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 08:29:42 -0400
Date: Wed, 6 Oct 2010 13:29:40 +0100
From: Andy Whitcroft <apw@canonical.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: overlayfs: BUG in ovl_whiteout
Message-ID: <20101006122940.GC19733@agent57>
References: <20101001180702.GD2832@shadowen.org>
 <E1P2hGO-0001kL-Gw@pomaz-ex.szeredi.hu>
 <20101004173343.GA19733@agent57>
 <E1P2rSX-0002hz-Lj@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1P2rSX-0002hz-Lj@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 04, 2010 at 10:16:29PM +0200, Miklos Szeredi wrote:
> 
> OK, my guess is that it's a 'rename to self' which was not properly
> implemented.
> 
> Does the following patch make a difference?

That one panic'd immediatly.  Seems that we can have missmatched lowers
as well.  I applied the below over the top, and that seems to pass
testing without tripping the WARN_ON.

-apw

commit 03375858c62f617846b5dc4968fe8178eda51a7c
Author: Andy Whitcroft <apw@canonical.com>
Date:   Tue Oct 5 14:54:08 2010 +0100

    overlayfs: handle missing lower inodes in ovl_is_same_inode
    
    Signed-off-by: Andy Whitcroft <apw@canonical.com>

diff --git a/fs/overlayfs/overlayfs.c b/fs/overlayfs/overlayfs.c
index c10cc7b..f596222 100644
--- a/fs/overlayfs/overlayfs.c
+++ b/fs/overlayfs/overlayfs.c
@@ -1964,19 +1964,25 @@ static int ovl_statfs(struct dentry *dentry, struct kstatfs *buf)
 
 static bool ovl_is_same_inode(struct dentry *d1, struct dentry *d2)
 {
-	struct dentry *upperd1;
-	struct dentry *upperd2;
+	struct dentry *od1;
+	struct dentry *od2;
 
-	upperd1 = ovl_dentry_upper(d1);
-	upperd2 = ovl_dentry_upper(d2);
+	od1 = ovl_dentry_upper(d1);
+	od2 = ovl_dentry_upper(d2);
 
-	if (upperd1 && upperd2)
-		return vfs_is_same_inode(upperd1, upperd2);
+	if (od1 && od2)
+		return vfs_is_same_inode(od1, od2);
 
-	if (upperd1 || upperd2)
+	if (od1 || od2)
 		return false;
 
-	return vfs_is_same_inode(ovl_dentry_lower(d1), ovl_dentry_lower(d2));
+	od1 = ovl_dentry_lower(d1);
+	od2 = ovl_dentry_lower(d2);
+
+	if (od1 && od2)
+		return vfs_is_same_inode(od1, od2);
+
+	return false;
 }
 
 static const struct super_operations ovl_super_operations = {
