Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753134Ab0LFRWC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 12:22:02 -0500
Received: from web31805.mail.mud.yahoo.com ([68.142.207.68]:26292 "HELO
	web31805.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752266Ab0LFRWA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 12:22:00 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:MIME-Version:Content-Type;
  b=SY4EwPquKXI3mF1IH0JSgr043f4lItovPHkbydpxhKbICcs108praEojTE6QAZkH73VNzub5lUMged+9dW9AODkAIyD9uUWHYvo+R+N54pAjBTxK8imWLk36S8W1yArgaOr8nptLXwyhXx8cn+k09pECnEFrQb9jB7AXGh5Lsvo=;
Message-ID: <401889.90968.qm@web31805.mail.mud.yahoo.com>
X-YMail-OSG: ZGIxgeIVM1kMVpCxr1OA4anm6dFbrJ1l8MjjIw7cEyWX7CV
 kcNJsHnaSJCXiHRToI71Y_iVoSUlu.Bz6kWPsn.58CnqNsw5swO4LX8L6EGp
 ycrHOd7C_3PZRtNd0Pq_mDjGvoCHcyu0s2iKWxizY.JJMc6DGK6vqlCzx4IU
 oa5b_ZrQvzcr2VGt_QDLbzF3mMM_S0j7zWQ9X_.V0b_Zzm0cz6BoFCS_bh7c
 zaGQldcA1hoSK6H_8pa4c3V_jGiKJCxf0qigARaNmG2lA5nPCWvhuvmigRxQ
 JrE4obkETxar5fsgHlB_byrtwsLskQaWXe1L8DxnGy_.mICDLhzyPdMyXWFh
 HMuGZ56jesC0Qn.SeRg--
X-Mailer: YahooMailClassic/11.4.20 YahooMailWebService/0.8.107.289296
Date: Mon, 6 Dec 2010 09:21:58 -0800 (PST)
From: Luben Tuikov <ltuikov@yahoo.com>
Reply-To: ltuikov@yahoo.com
Subject: [PATCH preliminary] [BLOCK] Preliminary increasing tag sequence implementation
To: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, jaxboe@fusionio.com, tj@kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Luben Tuikov <ltuikov@yahoo.com>
---
 * This is a preliminary patch. Feel free to apply it for
 inclusion and/or work/modify it to submit a more
 atomically-correct version.
 * Vendors: apply this to see an increasing sequence of tags
 on the wire and at your device, so that error recovery doesn't
 abort a task which isn't intended to be aborted especially in
 full duplex protocols when the command status and TMF can
 cross on the wire. See this thread: http://marc.info/?l=linux-scsi&m=128902337522893&w=2  
 block/blk-tag.c        |   15 +++++++++++++--
 include/linux/blkdev.h |    1 +
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/block/blk-tag.c b/block/blk-tag.c
index ece65fc..f792e98 100644
--- a/block/blk-tag.c
+++ b/block/blk-tag.c
@@ -130,6 +130,7 @@ init_tag_map(struct request_queue *q, struct blk_queue_tag *tags, int depth)
 	tags->max_depth = depth;
 	tags->tag_index = tag_index;
 	tags->tag_map = tag_map;
+	tags->last_tag = 0;
 
 	return 0;
 fail:
@@ -222,7 +223,7 @@ int blk_queue_resize_tags(struct request_queue *q, int new_depth)
 	struct blk_queue_tag *bqt = q->queue_tags;
 	struct request **tag_index;
 	unsigned long *tag_map;
-	int max_depth, nr_ulongs;
+	int max_depth, nr_ulongs, last_tag;
 
 	if (!bqt)
 		return -ENXIO;
@@ -251,6 +252,7 @@ int blk_queue_resize_tags(struct request_queue *q, int new_depth)
 	tag_index = bqt->tag_index;
 	tag_map = bqt->tag_map;
 	max_depth = bqt->real_max_depth;
+	last_tag = bqt->last_tag;
 
 	if (init_tag_map(q, bqt, new_depth))
 		return -ENOMEM;
@@ -258,6 +260,7 @@ int blk_queue_resize_tags(struct request_queue *q, int new_depth)
 	memcpy(bqt->tag_index, tag_index, max_depth * sizeof(struct request *));
 	nr_ulongs = ALIGN(max_depth, BITS_PER_LONG) / BITS_PER_LONG;
 	memcpy(bqt->tag_map, tag_map, nr_ulongs * sizeof(unsigned long));
+	bqt->last_tag = last_tag;
 
 	kfree(tag_index);
 	kfree(tag_map);
@@ -364,12 +367,20 @@ int blk_queue_start_tag(struct request_queue *q, struct request *rq)
 			return 1;
 	}
 
+	if (bqt->last_tag == bqt->max_depth-1)
+		bqt->last_tag = 0;
+
 	do {
-		tag = find_first_zero_bit(bqt->tag_map, max_depth);
+		tag = find_next_zero_bit(bqt->tag_map,
+					 max_depth,
+					 bqt->last_tag+1);
 		if (tag >= max_depth)
 			return 1;
 
 	} while (test_and_set_bit_lock(tag, bqt->tag_map));
+
+	bqt->last_tag = tag;
+
 	/*
 	 * We need lock ordering semantics given by test_and_set_bit_lock.
 	 * See blk_queue_end_tag for details.
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 5027a59..955222e 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -224,6 +224,7 @@ struct blk_queue_tag {
 	int max_depth;			/* what we will send to device */
 	int real_max_depth;		/* what the array can hold */
 	atomic_t refcnt;		/* map can be shared */
+	int last_tag;
 };
 
 #define BLK_SCSI_MAX_CMDS	(256)
-- 
1.7.2.2.165.gbc382

