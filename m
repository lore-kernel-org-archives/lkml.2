Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932818Ab0JXOBc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Oct 2010 10:01:32 -0400
Received: from element.ksp.sk ([158.195.16.154]:45096 "EHLO ksp.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932473Ab0JXOBb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Oct 2010 10:01:31 -0400
X-Greylist: delayed 585 seconds by postgrey-1.27 at vger.kernel.org; Sun, 24 Oct 2010 10:01:30 EDT
Message-ID: <4CC439ED.8090400@dcs.fmph.uniba.sk>
Date: Sun, 24 Oct 2010 15:51:41 +0200
From: Richard Kralovic <Richard.Kralovic@dcs.fmph.uniba.sk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100917 Icedove/3.0.8
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: CFQ and dm-crypt
X-Enigmail-Version: 1.0.1
Content-Type: multipart/mixed;
 boundary="------------020505070807060200000005"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020505070807060200000005
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit

CFQ io scheduler relies on using task_struct current to determine which
process makes the io request. On the other hand, some dm modules (such
as dm-crypt) use separate threads for doing io. As CFQ sees only these
threads, it provides a very poor performance in such a case.

IMHO the correct solution for this would be to store, for every io
request, the process that initiated it (and preserve this information
while the request is processed by device mapper). Would that be feasible?

Other possibility is to avoid using separate threads for doing io in dm
modules. The attached patch (against 2.6.36) modifies dm-crypt in this
way, what results into much better behavior of cfq (e.g., io priorities
work correctly).

Greets
	Richard

(Please CC replies to me.)


--------------020505070807060200000005
Content-Type: text/plain;
 name="patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="patch"

>From c563d67a43fc61ce8e9716d3344655a907b1e975 Mon Sep 17 00:00:00 2001
From: Richard Kralovic <riso@ksp.sk>
Date: Wed, 20 Oct 2010 17:11:25 +0200
Subject: [PATCH] Avoid io queue in dm-crypt

Process io requests from the calling process, not from the io queue. Should
improve cfq scheduler behaviour with dm-crypt.

Signed-off-by: Richard Kralovic <riso@ksp.sk>
---
 drivers/md/dm-crypt.c |   42 +++++++++++++-----------------------------
 1 files changed, 13 insertions(+), 29 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 368e8e9..7e2d3a5 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -22,6 +22,7 @@
 #include <linux/scatterlist.h>
 #include <asm/page.h>
 #include <asm/unaligned.h>
+#include <linux/semaphore.h>
 
 #include <linux/device-mapper.h>
 
@@ -57,6 +58,7 @@ struct dm_crypt_io {
 	int error;
 	sector_t sector;
 	struct dm_crypt_io *base_io;
+	struct semaphore notify;
 };
 
 struct dm_crypt_request {
@@ -104,7 +106,6 @@ struct crypt_config {
 	mempool_t *page_pool;
 	struct bio_set *bs;
 
-	struct workqueue_struct *io_queue;
 	struct workqueue_struct *crypt_queue;
 
 	char *cipher;
@@ -728,26 +729,16 @@ static void kcryptd_io_write(struct dm_crypt_io *io)
 	generic_make_request(clone);
 }
 
-static void kcryptd_io(struct work_struct *work)
+static void kcryptd_io(struct dm_crypt_io *io)
 {
-	struct dm_crypt_io *io = container_of(work, struct dm_crypt_io, work);
-
 	if (bio_data_dir(io->base_bio) == READ)
 		kcryptd_io_read(io);
 	else
 		kcryptd_io_write(io);
 }
 
-static void kcryptd_queue_io(struct dm_crypt_io *io)
-{
-	struct crypt_config *cc = io->target->private;
-
-	INIT_WORK(&io->work, kcryptd_io);
-	queue_work(cc->io_queue, &io->work);
-}
-
 static void kcryptd_crypt_write_io_submit(struct dm_crypt_io *io,
-					  int error, int async)
+					  int error)
 {
 	struct bio *clone = io->ctx.bio_out;
 	struct crypt_config *cc = io->target->private;
@@ -765,10 +756,7 @@ static void kcryptd_crypt_write_io_submit(struct dm_crypt_io *io,
 
 	clone->bi_sector = cc->start + io->sector;
 
-	if (async)
-		kcryptd_queue_io(io);
-	else
-		generic_make_request(clone);
+	up(&io->notify);
 }
 
 static void kcryptd_crypt_write_convert(struct dm_crypt_io *io)
@@ -811,7 +799,7 @@ static void kcryptd_crypt_write_convert(struct dm_crypt_io *io)
 
 		/* Encryption was already finished, submit io now */
 		if (crypt_finished) {
-			kcryptd_crypt_write_io_submit(io, r, 0);
+			kcryptd_crypt_write_io_submit(io, r);
 
 			/*
 			 * If there was an error, do not try next fragments.
@@ -909,13 +897,12 @@ static void kcryptd_async_done(struct crypto_async_request *async_req,
 	if (bio_data_dir(io->base_bio) == READ)
 		kcryptd_crypt_read_done(io, error);
 	else
-		kcryptd_crypt_write_io_submit(io, error, 1);
+		kcryptd_crypt_write_io_submit(io, error);
 }
 
 static void kcryptd_crypt(struct work_struct *work)
 {
 	struct dm_crypt_io *io = container_of(work, struct dm_crypt_io, work);
-
 	if (bio_data_dir(io->base_bio) == READ)
 		kcryptd_crypt_read_convert(io);
 	else
@@ -1005,8 +992,6 @@ static void crypt_dtr(struct dm_target *ti)
 	if (!cc)
 		return;
 
-	if (cc->io_queue)
-		destroy_workqueue(cc->io_queue);
 	if (cc->crypt_queue)
 		destroy_workqueue(cc->crypt_queue);
 
@@ -1252,11 +1237,6 @@ static int crypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	cc->start = tmpll;
 
 	ret = -ENOMEM;
-	cc->io_queue = create_singlethread_workqueue("kcryptd_io");
-	if (!cc->io_queue) {
-		ti->error = "Couldn't create kcryptd io queue";
-		goto bad;
-	}
 
 	cc->crypt_queue = create_singlethread_workqueue("kcryptd");
 	if (!cc->crypt_queue) {
@@ -1287,9 +1267,13 @@ static int crypt_map(struct dm_target *ti, struct bio *bio,
 	io = crypt_io_alloc(ti, bio, dm_target_offset(ti, bio->bi_sector));
 
 	if (bio_data_dir(io->base_bio) == READ)
-		kcryptd_queue_io(io);
-	else
+		kcryptd_io(io);
+	else {
+		sema_init(&io->notify, 0);
 		kcryptd_queue_crypt(io);
+		down(&io->notify);
+		kcryptd_io(io);
+	}
 
 	return DM_MAPIO_SUBMITTED;
 }
-- 
1.7.2.3




--------------020505070807060200000005--
