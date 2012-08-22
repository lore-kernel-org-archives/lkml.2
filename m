Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933492Ab2HVXCX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 19:02:23 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:50737 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933308Ab2HVXCO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 19:02:14 -0400
From: Stephen Warren <swarren@wwwdotorg.org>
To: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>,
        Will Drewry <wad@chromium.org>, Kay Sievers <kay.sievers@vrfy.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org,
        cross-distro@lists.linaro.org, Stephen Warren <swarren@nvidia.com>
Subject: [PATCH 2/3] init: reduce PARTUUID min length to 1 from 36
Date: Wed, 22 Aug 2012 17:02:03 -0600
Message-Id: <1345676524-24450-2-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1345676524-24450-1-git-send-email-swarren@wwwdotorg.org>
References: <1345676524-24450-1-git-send-email-swarren@wwwdotorg.org>
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

Reduce the minimum length for a root=PARTUUID= parameter to be
considered valid from 36 to 1. EFI/GPT partition UUIDs are always
exactly 36 characters long, hence the previous limit. However, the
next patch will support DOS/MBR UUIDs too, which have a different,
shorter, format. Instead of validating any particular length, just
ensure that at least some non-empty value was given by the user.

Also, consider a missing UUID value to be a parsing error, in the
same vein as if /PARTNROFF exists and can't be parsed. As such, make
both error cases print a message and disable rootwait. Convert to
pr_err while we're at it.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
 init/do_mounts.c |   35 ++++++++++++++++++++++-------------
 1 files changed, 22 insertions(+), 13 deletions(-)

diff --git a/init/do_mounts.c b/init/do_mounts.c
index 4dba733..fcbe825 100644
--- a/init/do_mounts.c
+++ b/init/do_mounts.c
@@ -119,27 +119,29 @@ static dev_t devt_from_partuuid(const char *uuid_str)
 	struct gendisk *disk;
 	struct hd_struct *part;
 	int offset = 0;
-
-	if (strlen(uuid_str) < 36)
-		goto done;
+	bool clear_root_wait = false;
+	char *slash;
 
 	cmp.uuid = uuid_str;
-	cmp.len = 36;
 
+	slash = strchr(uuid_str, '/');
 	/* Check for optional partition number offset attributes. */
-	if (uuid_str[36]) {
+	if (slash) {
 		char c = 0;
 		/* Explicitly fail on poor PARTUUID syntax. */
-		if (sscanf(&uuid_str[36],
-			   "/PARTNROFF=%d%c", &offset, &c) != 1) {
-			printk(KERN_ERR "VFS: PARTUUID= is invalid.\n"
-			 "Expected PARTUUID=<valid-uuid-id>[/PARTNROFF=%%d]\n");
-			if (root_wait)
-				printk(KERN_ERR
-				     "Disabling rootwait; root= is invalid.\n");
-			root_wait = 0;
+		if (sscanf(slash + 1,
+			   "PARTNROFF=%d%c", &offset, &c) != 1) {
+			clear_root_wait = true;
 			goto done;
 		}
+		cmp.len = slash - uuid_str;
+	} else {
+		cmp.len = strlen(uuid_str);
+	}
+
+	if (!cmp.len) {
+		clear_root_wait = true;
+		goto done;
 	}
 
 	dev = class_find_device(&block_class, NULL, &cmp,
@@ -164,6 +166,13 @@ static dev_t devt_from_partuuid(const char *uuid_str)
 no_offset:
 	put_device(dev);
 done:
+	if (clear_root_wait) {
+		pr_err("VFS: PARTUUID= is invalid.\n"
+		       "Expected PARTUUID=<valid-uuid-id>[/PARTNROFF=%%d]\n");
+		if (root_wait)
+			pr_err("Disabling rootwait; root= is invalid.\n");
+		root_wait = 0;
+	}
 	return res;
 }
 #endif
-- 
1.7.0.4

