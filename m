Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756031Ab0CQT7P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 15:59:15 -0400
Received: from cantor.suse.de ([195.135.220.2]:58148 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751821Ab0CQT7M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 15:59:12 -0400
Message-ID: <4BA1348E.9070201@suse.com>
Date: Wed, 17 Mar 2010 15:59:10 -0400
From: Jeff Mahoney <jeffm@suse.com>
Organization: SUSE Labs, Novell, Inc
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100228 SUSE/3.0.3-1.3 Thunderbird/3.0.3
MIME-Version: 1.0
To: ReiserFS Mailing List <reiserfs-devel@vger.kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/2] reiserfs: fix oops while creating privroot with selinux
 enabled
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Commit 57fe60df contains a bug that will cause it to oops when
 mounting a file system that didn't previously contain extended
 attributes on a system using security.* xattrs.

 The issue is that while creating the privroot during mount
 reiserfs_security_init calls reiserfs_xattr_jcreate_nblocks
 which dereferences the xattr root. The xattr root doesn't exist, so
 we get an oops.

 This fixes http://bugzilla.kernel.org/show_bug.cgi?id=15309

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/reiserfs/xattr_security.c   |    2 +-
 include/linux/reiserfs_xattr.h |    5 +++++
 2 files changed, 6 insertions(+), 1 deletion(-)

--- a/fs/reiserfs/xattr_security.c
+++ b/fs/reiserfs/xattr_security.c
@@ -76,7 +76,7 @@ int reiserfs_security_init(struct inode
 		return error;
 	}
 
-	if (sec->length) {
+	if (sec->length && reiserfs_xattrs_initialized(inode->i_sb)) {
 		blocks = reiserfs_xattr_jcreate_nblocks(inode) +
 			 reiserfs_xattr_nblocks(inode, sec->length);
 		/* We don't want to count the directories twice if we have
--- a/include/linux/reiserfs_xattr.h
+++ b/include/linux/reiserfs_xattr.h
@@ -70,6 +70,11 @@ int reiserfs_security_write(struct reise
 void reiserfs_security_free(struct reiserfs_security_handle *sec);
 #endif
 
+static inline int reiserfs_xattrs_initialized(struct super_block *sb)
+{
+	return REISERFS_SB(sb)->priv_root != NULL;
+}
+
 #define xattr_size(size) ((size) + sizeof(struct reiserfs_xattr_header))
 static inline loff_t reiserfs_xattr_nblocks(struct inode *inode, loff_t size)
 {
-- 
Jeff Mahoney
SUSE Labs
