Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755108Ab2BEWrS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 17:47:18 -0500
Received: from 1wt.eu ([62.212.114.60]:61866 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753719Ab2BEW0T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 17:26:19 -0500
Message-Id: <20120205220949.621395683@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Sun, 05 Feb 2012 23:09:53 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Vasiliy Kulikov <segoon@openwall.com>, Dave Airlie <airlied@redhat.com>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: [PATCH 04/91] agp: fix arbitrary kernel memory writes
In-Reply-To: <0635750f5f06ed2ca212b91fcb5c4483@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-longterm review patch.  If anyone has any objections, please let us know.

------------------

commit 194b3da873fd334ef183806db751473512af29ce upstream.

pg_start is copied from userspace on AGPIOC_BIND and AGPIOC_UNBIND ioctl
cmds of agp_ioctl() and passed to agpioc_bind_wrap().  As said in the
comment, (pg_start + mem->page_count) may wrap in case of AGPIOC_BIND,
and it is not checked at all in case of AGPIOC_UNBIND.  As a result, user
with sufficient privileges (usually "video" group) may generate either
local DoS or privilege escalation.

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/char/agp/generic.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

Index: longterm-2.6.27/drivers/char/agp/generic.c
===================================================================
--- longterm-2.6.27.orig/drivers/char/agp/generic.c	2012-02-05 22:34:34.961915038 +0100
+++ longterm-2.6.27/drivers/char/agp/generic.c	2012-02-05 22:34:35.500916106 +0100
@@ -1099,8 +1099,8 @@
 		return -EINVAL;
 	}
 
-	/* AK: could wrap */
-	if ((pg_start + mem->page_count) > num_entries)
+	if (((pg_start + mem->page_count) > num_entries) ||
+	    ((pg_start + mem->page_count) < pg_start))
 		return -EINVAL;
 
 	j = pg_start;
@@ -1132,7 +1132,7 @@
 {
 	size_t i;
 	struct agp_bridge_data *bridge;
-	int mask_type;
+	int mask_type, num_entries;
 
 	bridge = mem->bridge;
 	if (!bridge)
@@ -1144,6 +1144,11 @@
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


