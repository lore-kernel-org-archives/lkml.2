Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933682Ab1D2TBb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 15:01:31 -0400
Received: from kroah.org ([198.145.64.141]:35096 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933626Ab1D2S6t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 14:58:49 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Apr 29 11:56:57 2011
Message-Id: <20110429185657.344031011@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 29 Apr 2011 11:56:12 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Vasiliy Kulikov <segoon@openwall.com>,
        Dave Airlie <airlied@redhat.com>
Subject: [49/55] agp: fix arbitrary kernel memory writes
In-Reply-To: <20110429185706.GA12824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Vasiliy Kulikov <segoon@openwall.com>

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
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/drivers/char/agp/generic.c
+++ b/drivers/char/agp/generic.c
@@ -1089,8 +1089,8 @@ int agp_generic_insert_memory(struct agp
 		return -EINVAL;
 	}
 
-	/* AK: could wrap */
-	if ((pg_start + mem->page_count) > num_entries)
+	if (((pg_start + mem->page_count) > num_entries) ||
+	    ((pg_start + mem->page_count) < pg_start))
 		return -EINVAL;
 
 	j = pg_start;
@@ -1124,7 +1124,7 @@ int agp_generic_remove_memory(struct agp
 {
 	size_t i;
 	struct agp_bridge_data *bridge;
-	int mask_type;
+	int mask_type, num_entries;
 
 	bridge = mem->bridge;
 	if (!bridge)
@@ -1136,6 +1136,11 @@ int agp_generic_remove_memory(struct agp
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


