Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162208Ab2GLW4u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 18:56:50 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58752 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162151Ab2GLWnw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 18:43:52 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Vivek Goyal <vgoyal@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
        Alasdair G Kergon <agk@redhat.com>
Subject: [ 135/187] dm persistent data: fix allocation failure in space map checker init
Date: Thu, 12 Jul 2012 15:34:51 -0700
Message-Id: <20120712191534.902940213@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120712191522.742634173@linuxfoundation.org>
References: <20120712192421.GA28926@kroah.com>
 <20120712191522.742634173@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/persistent-data/dm-space-map-checker.c |   30 +++++++++++++---------
 1 file changed, 19 insertions(+), 11 deletions(-)

--- a/drivers/md/persistent-data/dm-space-map-checker.c
+++ b/drivers/md/persistent-data/dm-space-map-checker.c
@@ -8,6 +8,7 @@
 
 #include <linux/device-mapper.h>
 #include <linux/export.h>
+#include <linux/vmalloc.h>
 
 #ifdef CONFIG_DM_DEBUG_SPACE_MAPS
 
@@ -89,13 +90,23 @@ static int ca_create(struct count_array
 
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
@@ -126,12 +137,14 @@ static int ca_load(struct count_array *c
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
@@ -151,11 +164,6 @@ static int ca_commit(struct count_array
 	return 0;
 }
 
-static void ca_destroy(struct count_array *ca)
-{
-	kfree(ca->counts);
-}
-
 /*----------------------------------------------------------------*/
 
 struct sm_checker {


