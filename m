Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757299Ab0GAVcL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 17:32:11 -0400
Received: from kroah.org ([198.145.64.141]:33192 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759029Ab0GAVPM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 17:15:12 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:43:01 2010
Message-Id: <20100701174301.235433839@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:44:24 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Shi Weihua <shiwh@cn.fujitsu.com>, Chris Mason <chris.mason@oracle.com>
Subject: [174/200] Btrfs: should add a permission check for setfacl
In-Reply-To: <20100701175201.GA2149@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shi Weihua <shiwh@cn.fujitsu.com>

commit 2f26afba46f0ebf155cf9be746496a0304a5b7cf upstream.

On btrfs, do the following
------------------
# su user1
# cd btrfs-part/
# touch aaa
# getfacl aaa
  # file: aaa
  # owner: user1
  # group: user1
  user::rw-
  group::rw-
  other::r--
# su user2
# cd btrfs-part/
# setfacl -m u::rwx aaa
# getfacl aaa
  # file: aaa
  # owner: user1
  # group: user1
  user::rwx           <- successed to setfacl
  group::rw-
  other::r--
------------------
but we should prohibit it that user2 changing user1's acl.
In fact, on ext3 and other fs, a message occurs:
  setfacl: aaa: Operation not permitted

This patch fixed it.

Signed-off-by: Shi Weihua <shiwh@cn.fujitsu.com>
Signed-off-by: Chris Mason <chris.mason@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/btrfs/acl.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/btrfs/acl.c
+++ b/fs/btrfs/acl.c
@@ -160,6 +160,9 @@ static int btrfs_xattr_acl_set(struct de
 	int ret;
 	struct posix_acl *acl = NULL;
 
+	if (!is_owner_or_cap(dentry->d_inode))
+		return -EPERM;
+
 	if (value) {
 		acl = posix_acl_from_xattr(value, size);
 		if (acl == NULL) {


