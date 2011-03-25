Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933953Ab1CZAXr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 20:23:47 -0400
Received: from kroah.org ([198.145.64.141]:41596 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932343Ab1CYXwg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 19:52:36 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Mar 25 16:45:10 2011
Message-Id: <20110325234510.435991699@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 25 Mar 2011 16:44:01 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Amir Goldstein <amir73il@users.sf.net>, Jan Kara <jack@suse.cz>
Subject: [25/63] ext3: skip orphan cleanup on rocompat fs
In-Reply-To: <20110325234526.GA18017@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Amir Goldstein <amir73il@gmail.com>

commit ce654b37f87980d95f339080e4c3bdb2370bdf22 upstream.

Orphan cleanup is currently executed even if the file system has some
number of unknown ROCOMPAT features, which deletes inodes and frees
blocks, which could be very bad for some RO_COMPAT features.

This patch skips the orphan cleanup if it contains readonly compatible
features not known by this ext3 implementation, which would prevent
the fs from being mounted (or remounted) readwrite.

Signed-off-by: Amir Goldstein <amir73il@users.sf.net>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ext3/super.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -1464,6 +1464,13 @@ static void ext3_orphan_cleanup (struct
 		return;
 	}
 
+	/* Check if feature set allows readwrite operations */
+	if (EXT3_HAS_RO_COMPAT_FEATURE(sb, ~EXT3_FEATURE_RO_COMPAT_SUPP)) {
+		ext3_msg(sb, KERN_INFO, "Skipping orphan cleanup due to "
+			 "unknown ROCOMPAT features");
+		return;
+	}
+
 	if (EXT3_SB(sb)->s_mount_state & EXT3_ERROR_FS) {
 		if (es->s_last_orphan)
 			jbd_debug(1, "Errors on filesystem, "


