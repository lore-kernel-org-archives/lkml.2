Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753750Ab1H0O4o (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Aug 2011 10:56:44 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46543 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752513Ab1H0O4k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Aug 2011 10:56:40 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Aug 26 15:04:20 2011
Message-Id: <20110826220420.061085648@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 26 Aug 2011 15:03:35 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Timo Warns <warns@pre-sense.de>
Subject: [12/20] befs: Validate length of long symbolic links.
In-Reply-To: <20110826220431.GA15382@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Timo Warns <Warns@pre-sense.de>

commit 338d0f0a6fbc82407864606f5b64b75aeb3c70f2 upstream.

Signed-off-by: Timo Warns <warns@pre-sense.de>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/befs/linuxvfs.c |   23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

--- a/fs/befs/linuxvfs.c
+++ b/fs/befs/linuxvfs.c
@@ -469,17 +469,22 @@ befs_follow_link(struct dentry *dentry,
 		befs_data_stream *data = &befs_ino->i_data.ds;
 		befs_off_t len = data->size;
 
-		befs_debug(sb, "Follow long symlink");
-
-		link = kmalloc(len, GFP_NOFS);
-		if (!link) {
-			link = ERR_PTR(-ENOMEM);
-		} else if (befs_read_lsymlink(sb, data, link, len) != len) {
-			kfree(link);
-			befs_error(sb, "Failed to read entire long symlink");
+		if (len == 0) {
+			befs_error(sb, "Long symlink with illegal length");
 			link = ERR_PTR(-EIO);
 		} else {
-			link[len - 1] = '\0';
+			befs_debug(sb, "Follow long symlink");
+
+			link = kmalloc(len, GFP_NOFS);
+			if (!link) {
+				link = ERR_PTR(-ENOMEM);
+			} else if (befs_read_lsymlink(sb, data, link, len) != len) {
+				kfree(link);
+				befs_error(sb, "Failed to read entire long symlink");
+				link = ERR_PTR(-EIO);
+			} else {
+				link[len - 1] = '\0';
+			}
 		}
 	} else {
 		link = befs_ino->i_data.symlink;


