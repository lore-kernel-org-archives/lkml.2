Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754619Ab2GIOkG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 10:40:06 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38309 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754506Ab2GIOiZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 10:38:25 -0400
Message-Id: <20120709143119.739842286@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 09 Jul 2012 15:31:37 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Mike Snitzer <snitzer@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>, Alasdair G Kergon <agk@redhat.com>
Subject: [ 21/48] dm persistent data: fix allocation failure in space map checker init
In-Reply-To: <20120709143116.348975190@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Snitzer <snitzer@redhat.com>

commit b0239faaf87c38bb419c9264bf20817438ddc3a9 upstream.

If CONFIG_DM_DEBUG_SPACE_MAPS is enabled and memory is fragmented and a
sufficiently-large metadata device is used in a thin pool then the space
map checker will fail to allocate the memory it requires.

Switch from kmalloc to vmalloc to allow larger virtually contiguous
allocations for the space map checker's internal count arrays.

Reported-by: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/md/persistent-data/dm-space-map-checker.c |   30 +++++++++++++--------
 1 file changed, 19 insertions(+), 11 deletions(-)

diff --git a/drivers/md/persistent-data/dm-space-map-checker.c b/drivers/md/persistent-data/dm-space-map-checker.c
index 6d7c832..fc90c11 100644
--- a/drivers/md/persistent-data/dm-space-map-checker.c
+++ b/drivers/md/persistent-data/dm-space-map-checker.c
@@ -8,6 +8,7 @@
 
 #include <linux/device-mapper.h>
 #include <linux/export.h>
+#include <linux/vmalloc.h>
 
 #ifdef CONFIG_DM_DEBUG_SPACE_MAPS
 
@@ -89,13 +90,23 @@ static int ca_create(struct count_array *ca, struct dm_space_map *sm)
 
 	ca->nr = nr_blocks;
 	ca->nr_free = nr_blocks;
-	ca->counts = kzalloc(sizeof(*ca->counts) * nr_blocks, GFP_KERNEL);
-	if (!ca->counts)
-		return -ENOMEM;
+
+	if (!nr_blocks)
+		ca->counts = NULL;
+	else {
+		ca->counts = vzalloc(sizeof(*ca->counts) * nr_blocks);
+		if (!ca->counts)
+			return -ENOMEM;
+	}
 
 	return 0;
 }
 
+static void ca_destroy(struct count_array *ca)
+{
+	vfree(ca->counts);
+}
+
 static int ca_load(struct count_array *ca, struct dm_space_map *sm)
 {
 	int r;
@@ -126,12 +137,14 @@ static int ca_load(struct count_array *ca, struct dm_space_map *sm)
 static int ca_extend(struct count_array *ca, dm_block_t extra_blocks)
 {
 	dm_block_t nr_blocks = ca->nr + extra_blocks;
-	uint32_t *counts = kzalloc(sizeof(*counts) * nr_blocks, GFP_KERNEL);
+	uint32_t *counts = vzalloc(sizeof(*counts) * nr_blocks);
 	if (!counts)
 		return -ENOMEM;
 
-	memcpy(counts, ca->counts, sizeof(*counts) * ca->nr);
-	kfree(ca->counts);
+	if (ca->counts) {
+		memcpy(counts, ca->counts, sizeof(*counts) * ca->nr);
+		ca_destroy(ca);
+	}
 	ca->nr = nr_blocks;
 	ca->nr_free += extra_blocks;
 	ca->counts = counts;
@@ -151,11 +164,6 @@ static int ca_commit(struct count_array *old, struct count_array *new)
 	return 0;
 }
 
-static void ca_destroy(struct count_array *ca)
-{
-	kfree(ca->counts);
-}
-
 /*----------------------------------------------------------------*/
 
 struct sm_checker {


