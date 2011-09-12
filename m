Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758187Ab1ILPnq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 11:43:46 -0400
Received: from static-76-160-165-106.dsl.cavtel.net ([76.160.165.106]:51444
	"EHLO static-76-160-165-106.dsl.cavtel.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757971Ab1ILPnp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 11:43:45 -0400
Message-ID: <4E6E28AE.4040608@metrics.net>
Date: Mon, 12 Sep 2011 11:43:42 -0400
From: Anthony DeRobertis <aderobertis@metrics.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.21) Gecko/20110831 Icedove/3.1.13
MIME-Version: 1.0
To: Linux-kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: RFC: [PATCH] Add a sysfs entry queue/ignore_flushes.
References: <4E6A783D.9040708@metrics.net> <20110911050829.GA15269@kroah.com>
In-Reply-To: <20110911050829.GA15269@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/11/2011 01:08 AM, Greg KH wrote:
> If you add/remove/change sysfs attributes, you also need to do the same
> to Documentation/ABI.

I've added in documentation. Not sure who to set Contact: to, if that
should be the maintainer of the block layer or me, or...

Here is the updated patch, with documentation:

commit bd69b2eea10cfa217e91f82bac62b32800cb26bb
Author: Anthony DeRobertis <anthony@derobert.net>
Date:   Fri Sep 9 10:54:25 2011 -0400

    Add a sysfs entry queue/ignore_flushes.
    
    Set to ignore_flushes to 1 to have the block layer silently discard
    REQ_FLUSH and REQ_FUA. Great speed increase at the risk of great data
    loss.
    
    Defaults to 0, of course.
    
    Signed-off-by: Anthony DeRobertis <aderobertis@metrics.net>

diff --git a/Documentation/ABI/testing/sysfs-block b/Documentation/ABI/testing/sysfs-block
index c1eb41c..b0da935 100644
--- a/Documentation/ABI/testing/sysfs-block
+++ b/Documentation/ABI/testing/sysfs-block
@@ -206,3 +206,14 @@ Description:
 		when a discarded area is read the discard_zeroes_data
 		parameter will be set to one. Otherwise it will be 0 and
 		the result of reading a discarded area is undefined.
+
+What:		/sys/block/<disk>/queue/ignore_flushes
+Date:		September 2011
+Contact:	
+Description:
+		When this is set to 0 (the default), the device will
+		honor flush and force unit access (FUA) requests. When
+		set to 1, flush and FUA requests will be silently
+		ignored. Ignoring these requests potentially bosts
+		performance at the cost of data integrity if the machine
+		crashes or loses power.
diff --git a/block/blk-core.c b/block/blk-core.c
index 90e1ffd..fd4f1c1 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1515,9 +1515,11 @@ static inline void __generic_make_request(struct bio *bio)
 		/*
 		 * Filter flush bio's early so that make_request based
 		 * drivers without flush support don't have to worry
-		 * about them.
+		 * about them. Also filter if configured to ignore flushes.
 		 */
-		if ((bio->bi_rw & (REQ_FLUSH | REQ_FUA)) && !q->flush_flags) {
+		if ((bio->bi_rw & (REQ_FLUSH | REQ_FUA)) &&
+			(!q->flush_flags ||
+			 test_bit(QUEUE_FLAG_IGNORE_FLUSH, &q->queue_flags))) {
 			bio->bi_rw &= ~(REQ_FLUSH | REQ_FUA);
 			if (!nr_sectors) {
 				err = 0;
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 0ee17b5..8f19827 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -214,6 +214,7 @@ queue_store_##name(struct request_queue *q, const char *page, size_t count) \
 
 QUEUE_SYSFS_BIT_FNS(nonrot, NONROT, 1);
 QUEUE_SYSFS_BIT_FNS(random, ADD_RANDOM, 0);
+QUEUE_SYSFS_BIT_FNS(ignore_flushes, IGNORE_FLUSH, 0);
 QUEUE_SYSFS_BIT_FNS(iostats, IO_STAT, 0);
 #undef QUEUE_SYSFS_BIT_FNS
 
@@ -385,6 +386,12 @@ static struct queue_sysfs_entry queue_random_entry = {
 	.store = queue_store_random,
 };
 
+static struct queue_sysfs_entry queue_ignore_flushes_entry = {
+	.attr = {.name = "ignore_flushes", .mode = S_IRUGO | S_IWUSR },
+	.show = queue_show_ignore_flushes,
+	.store = queue_store_ignore_flushes,
+};
+
 static struct attribute *default_attrs[] = {
 	&queue_requests_entry.attr,
 	&queue_ra_entry.attr,
@@ -407,6 +414,7 @@ static struct attribute *default_attrs[] = {
 	&queue_rq_affinity_entry.attr,
 	&queue_iostats_entry.attr,
 	&queue_random_entry.attr,
+	&queue_ignore_flushes_entry.attr,
 	NULL,
 };
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 84b15d5..61b39e0 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -408,6 +408,7 @@ struct request_queue {
 #define QUEUE_FLAG_ADD_RANDOM  16	/* Contributes to random pool */
 #define QUEUE_FLAG_SECDISCARD  17	/* supports SECDISCARD */
 #define QUEUE_FLAG_SAME_FORCE  18	/* force complete on same CPU */
+#define QUEUE_FLAG_IGNORE_FLUSH 19	/* ignore REQ_FLUSH and REQ_FUA */
 
 #define QUEUE_FLAG_DEFAULT	((1 << QUEUE_FLAG_IO_STAT) |		\
 				 (1 << QUEUE_FLAG_STACKABLE)	|	\


