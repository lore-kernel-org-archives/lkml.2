Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751926Ab0CRKT7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 06:19:59 -0400
Received: from lon1-post-1.mail.demon.net ([195.173.77.148]:42504 "EHLO
	lon1-post-1.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751184Ab0CRKT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 06:19:58 -0400
Subject: [PATCH]  block: remove 16 bytes of padding from struct request on
 64bits
From: Richard Kennedy <richard@rsk.demon.co.uk>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 18 Mar 2010 10:19:52 +0000
Message-ID: <1268907592.2047.6.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove alignment padding to shrink struct request from 336 to 320 bytes
so needing one fewer cacheline and therefore removing 48 bytes from
struct request_queue.


Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>
---
patch against 2.6.34-rc1
compiled & tested on x86_64

regards
Richard


diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index ebd22db..6b66438 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -158,7 +158,6 @@ enum rq_flag_bits {
 struct request {
 	struct list_head queuelist;
 	struct call_single_data csd;
-	int cpu;
 
 	struct request_queue *q;
 
@@ -166,9 +165,11 @@ struct request {
 	enum rq_cmd_type_bits cmd_type;
 	unsigned long atomic_flags;
 
+	int cpu;
+
 	/* the following two fields are internal, NEVER access directly */
-	sector_t __sector;		/* sector cursor */
 	unsigned int __data_len;	/* total data len */
+	sector_t __sector;		/* sector cursor */
 
 	struct bio *bio;
 	struct bio *biotail;
@@ -201,20 +202,20 @@ struct request {
 
 	unsigned short ioprio;
 
+	int ref_count;
+
 	void *special;		/* opaque pointer available for LLD use */
 	char *buffer;		/* kaddr of the current segment if available */
 
 	int tag;
 	int errors;
 
-	int ref_count;
-
 	/*
 	 * when request is used as a packet command carrier
 	 */
-	unsigned short cmd_len;
 	unsigned char __cmd[BLK_MAX_CDB];
 	unsigned char *cmd;
+	unsigned short cmd_len;
 
 	unsigned int extra_len;	/* length of alignment and padding */
 	unsigned int sense_len;


