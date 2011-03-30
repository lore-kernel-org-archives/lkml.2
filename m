Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965206Ab1C3VVw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:21:52 -0400
Received: from mga09.intel.com ([134.134.136.24]:9067 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965157Ab1C3VJe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:09:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="727133917"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: amir73il@gmail.com, amir73il@users.sf.net, jack@suse.cz, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com
Subject: [PATCH] [227/275] ext3: skip orphan cleanup on rocompat fs
Message-Id: <20110330210752.B69D23E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:07:52 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 fs/ext3/super.c |    7 +++++++
 1 file changed, 7 insertions(+)

Index: linux-2.6.35.y/fs/ext3/super.c
===================================================================
--- linux-2.6.35.y.orig/fs/ext3/super.c	2011-03-29 22:50:25.063617102 -0700
+++ linux-2.6.35.y/fs/ext3/super.c	2011-03-29 23:03:02.960224426 -0700
@@ -1459,6 +1459,13 @@
 		return;
 	}
 
+	/* Check if feature set allows readwrite operations */
+	if (EXT3_HAS_RO_COMPAT_FEATURE(sb, ~EXT3_FEATURE_RO_COMPAT_SUPP)) {
+		printk(KERN_INFO "EXT3-fs: %s: Skipping orphan cleanup due to "
+			 "unknown ROCOMPAT features\n", sb->s_id);
+		return;
+	}
+
 	if (EXT3_SB(sb)->s_mount_state & EXT3_ERROR_FS) {
 		if (es->s_last_orphan)
 			jbd_debug(1, "Errors on filesystem, "
