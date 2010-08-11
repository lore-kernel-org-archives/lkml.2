Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759013Ab0HKX7C (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 19:59:02 -0400
Received: from kroah.org ([198.145.64.141]:43451 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759096Ab0HKX6m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 19:58:42 -0400
X-Mailbox-Line: From gregkh@clark.site Wed Aug 11 16:55:01 2010
Message-Id: <20100811235501.611961818@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 11 Aug 2010 16:54:47 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Chris Mason <chris.mason@oracle.com>, Jeff Mahoney <jeffm@suse.com>
Subject: [066/111] Btrfs: deal with NULL acl sent to btrfs_set_acl
In-Reply-To: <20100811235623.GA24440@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Chris Mason <chris.mason@oracle.com>

commit a9cc71a60c29a09174bee2fcef8f924c529fd4b7 upstream.

It is legal for btrfs_set_acl to be sent a NULL acl.  This
makes sure we don't dereference it.  A similar patch was sent by
Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>

Signed-off-by: Chris Mason <chris.mason@oracle.com>
Acked-by: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/btrfs/acl.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/fs/btrfs/acl.c
+++ b/fs/btrfs/acl.c
@@ -112,12 +112,14 @@ static int btrfs_set_acl(struct btrfs_tr
 	switch (type) {
 	case ACL_TYPE_ACCESS:
 		mode = inode->i_mode;
-		ret = posix_acl_equiv_mode(acl, &mode);
-		if (ret < 0)
-			return ret;
-		ret = 0;
-		inode->i_mode = mode;
 		name = POSIX_ACL_XATTR_ACCESS;
+		if (acl) {
+			ret = posix_acl_equiv_mode(acl, &mode);
+			if (ret < 0)
+				return ret;
+			inode->i_mode = mode;
+		}
+		ret = 0;
 		break;
 	case ACL_TYPE_DEFAULT:
 		if (!S_ISDIR(inode->i_mode))


