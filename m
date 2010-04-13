Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752580Ab0DMTjw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 15:39:52 -0400
Received: from cantor.suse.de ([195.135.220.2]:49431 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751883Ab0DMTjv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 15:39:51 -0400
Message-ID: <4BC4C888.9040104@suse.com>
Date: Tue, 13 Apr 2010 15:39:52 -0400
From: Jeff Mahoney <jeffm@suse.com>
Organization: SUSE Labs, Novell, Inc
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100317 SUSE/3.0.4-1.5 Thunderbird/3.0.4
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       ReiserFS Mailing List <reiserfs-devel@vger.kernel.org>,
       Edward Shishkin <edward.shishkin@gmail.com>, stable@kernel.org,
       Christian Kujau <lists@nerdbynature.de>, kernel@jbeekman.nl,
       gregsurbey@hotmail.com, Marco Gatti <marco.gatti@gmail.com>
Subject: [PATCH] reiserfs: Fix corruption during shrinking of xattrs
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Commit 48b32a3553a54740d236b79a90f20147a25875e3 introduced a problem
 that causes corruption when extended attributes are replaced with a
 smaller value.

 The issue is that the reiserfs_setattr to shrink the xattr file was
 moved from before the write to after the write.

 The root issue has always been in the reiserfs xattr code, but was
 papered over by the fact that in the shrink case, the file would just
 be expanded again while the xattr was written.

 The end result is that the last 8 bytes of xattr data are lost.

 This patch fixes it to use new_size.

 This issue was reported at: https://bugzilla.kernel.org/show_bug.cgi?id=14826

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
Cc: stable@kernel.org
---

 fs/reiserfs/xattr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/reiserfs/xattr.c
+++ b/fs/reiserfs/xattr.c
@@ -553,7 +560,7 @@ reiserfs_xattr_set_handle(struct reiserf
 	if (!err && new_size < i_size_read(dentry->d_inode)) {
 		struct iattr newattrs = {
 			.ia_ctime = current_fs_time(inode->i_sb),
-			.ia_size = buffer_size,
+			.ia_size = new_size,
 			.ia_valid = ATTR_SIZE | ATTR_CTIME,
 		};
 
-- 
Jeff Mahoney
SUSE Labs
