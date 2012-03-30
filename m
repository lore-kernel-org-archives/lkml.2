Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966286Ab2C3VkJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 17:40:09 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:55525 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936196Ab2C3VcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:32:00 -0400
X-Sasl-enc: l+W107ciThlbdVdp8J6bmcKdd7DLnw3pWUgxKUzE+AG5 1333143119
X-Mailbox-Line: From gregkh@linuxfoundation.org Fri Mar 30 12:48:56 2012
Message-Id: <20120330194856.241090990@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 30 Mar 2012 12:50:54 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Mikulas Patocka <mpatocka@redhat.com>,
        Milan Broz <mbroz@redhat.com>, Alasdair G Kergon <agk@redhat.com>
Subject: [ 149/175] dm crypt: add missing error handling
In-Reply-To: <20120330195801.GA31806@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit 72c6e7afc43e19f68a31dea204fc366624d6eee9 upstream.

Always set io->error to -EIO when an error is detected in dm-crypt.

There were cases where an error code would be set only if we finish
processing the last sector. If there were other encryption operations in
flight, the error would be ignored and bio would be returned with
success as if no error happened.

This bug is present in kcryptd_crypt_write_convert, kcryptd_crypt_read_convert
and kcryptd_async_done.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Reviewed-by: Milan Broz <mbroz@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm-crypt.c |   28 ++++++++++++++++------------
 1 file changed, 16 insertions(+), 12 deletions(-)

--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -1044,16 +1044,14 @@ static void kcryptd_queue_io(struct dm_c
 	queue_work(cc->io_queue, &io->work);
 }
 
-static void kcryptd_crypt_write_io_submit(struct dm_crypt_io *io,
-					  int error, int async)
+static void kcryptd_crypt_write_io_submit(struct dm_crypt_io *io, int async)
 {
 	struct bio *clone = io->ctx.bio_out;
 	struct crypt_config *cc = io->target->private;
 
-	if (unlikely(error < 0)) {
+	if (unlikely(io->error < 0)) {
 		crypt_free_buffer_pages(cc, clone);
 		bio_put(clone);
-		io->error = -EIO;
 		crypt_dec_pending(io);
 		return;
 	}
@@ -1104,12 +1102,16 @@ static void kcryptd_crypt_write_convert(
 		sector += bio_sectors(clone);
 
 		crypt_inc_pending(io);
+
 		r = crypt_convert(cc, &io->ctx);
+		if (r < 0)
+			io->error = -EIO;
+
 		crypt_finished = atomic_dec_and_test(&io->ctx.pending);
 
 		/* Encryption was already finished, submit io now */
 		if (crypt_finished) {
-			kcryptd_crypt_write_io_submit(io, r, 0);
+			kcryptd_crypt_write_io_submit(io, 0);
 
 			/*
 			 * If there was an error, do not try next fragments.
@@ -1160,11 +1162,8 @@ static void kcryptd_crypt_write_convert(
 	crypt_dec_pending(io);
 }
 
-static void kcryptd_crypt_read_done(struct dm_crypt_io *io, int error)
+static void kcryptd_crypt_read_done(struct dm_crypt_io *io)
 {
-	if (unlikely(error < 0))
-		io->error = -EIO;
-
 	crypt_dec_pending(io);
 }
 
@@ -1179,9 +1178,11 @@ static void kcryptd_crypt_read_convert(s
 			   io->sector);
 
 	r = crypt_convert(cc, &io->ctx);
+	if (r < 0)
+		io->error = -EIO;
 
 	if (atomic_dec_and_test(&io->ctx.pending))
-		kcryptd_crypt_read_done(io, r);
+		kcryptd_crypt_read_done(io);
 
 	crypt_dec_pending(io);
 }
@@ -1202,15 +1203,18 @@ static void kcryptd_async_done(struct cr
 	if (!error && cc->iv_gen_ops && cc->iv_gen_ops->post)
 		error = cc->iv_gen_ops->post(cc, iv_of_dmreq(cc, dmreq), dmreq);
 
+	if (error < 0)
+		io->error = -EIO;
+
 	mempool_free(req_of_dmreq(cc, dmreq), cc->req_pool);
 
 	if (!atomic_dec_and_test(&ctx->pending))
 		return;
 
 	if (bio_data_dir(io->base_bio) == READ)
-		kcryptd_crypt_read_done(io, error);
+		kcryptd_crypt_read_done(io);
 	else
-		kcryptd_crypt_write_io_submit(io, error, 1);
+		kcryptd_crypt_write_io_submit(io, 1);
 }
 
 static void kcryptd_crypt(struct work_struct *work)


