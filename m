Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757279Ab1DNQzX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 12:55:23 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52976 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752181Ab1DNQzW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 12:55:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=gB6/LWGtH37ha8faghUxXgakSWxNFSmSOErgF/D3a8zJ7G+VtbL83xFoqhcWHh9rqu
         shALn9gz6dhdL/4eNWvL5QNQB1onswYK/0cXrbmkMh2rhFTLiaj4uddxS6GD1ZWihLpD
         RVlsxdfn6txQboycAFopn7q89Iw182JID4dKE=
From: Vasiliy Kulikov <segoon@openwall.com>
To: linux-kernel@vger.kernel.org
Cc: security@kernel.org, David Airlie <airlied@linux.ie>
Subject: [PATCH] char: agp: fix arbitrary kernel memory writes
Date: Thu, 14 Apr 2011 20:55:16 +0400
Message-Id: <1302800116-31518-1-git-send-email-segoon@openwall.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pg_start is copied from userspace on AGPIOC_BIND and AGPIOC_UNBIND ioctl
cmds of agp_ioctl() and passed to agpioc_bind_wrap().  As said in the
comment, (pg_start + mem->page_count) may wrap in case of AGPIOC_BIND,
and it is not checked at all in case of AGPIOC_UNBIND.  As a result, user
with sufficient privileges (usually "video" group) may generate either
local DoS or privilege escalation.

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
---
 drivers/char/agp/generic.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/char/agp/generic.c b/drivers/char/agp/generic.c
index 012cba0..745e7ba 100644
--- a/drivers/char/agp/generic.c
+++ b/drivers/char/agp/generic.c
@@ -1089,8 +1089,8 @@ int agp_generic_insert_memory(struct agp_memory * mem, off_t pg_start, int type)
 		return -EINVAL;
 	}
 
-	/* AK: could wrap */
-	if ((pg_start + mem->page_count) > num_entries)
+	if (((pg_start + mem->page_count) > num_entries) ||
+	    ((pg_start + mem->page_count) < pg_start))
 		return -EINVAL;
 
 	j = pg_start;
@@ -1124,7 +1124,7 @@ int agp_generic_remove_memory(struct agp_memory *mem, off_t pg_start, int type)
 {
 	size_t i;
 	struct agp_bridge_data *bridge;
-	int mask_type;
+	int mask_type, num_entries;
 
 	bridge = mem->bridge;
 	if (!bridge)
@@ -1136,6 +1136,11 @@ int agp_generic_remove_memory(struct agp_memory *mem, off_t pg_start, int type)
 	if (type != mem->type)
 		return -EINVAL;
 
+	num_entries = agp_num_entries();
+	if (((pg_start + mem->page_count) > num_entries) ||
+	    ((pg_start + mem->page_count) < pg_start))
+		return -EINVAL;
+
 	mask_type = bridge->driver->agp_type_to_mask_type(bridge, type);
 	if (mask_type != 0) {
 		/* The generic routines know nothing of memory types */
-- 
1.7.0.4

