Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933000Ab1IIIwg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 04:52:36 -0400
Received: from charybdis-ext.suse.de ([195.135.221.2]:58460 "EHLO
	nat.nue.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932827Ab1IIIwf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 04:52:35 -0400
X-Greylist: delayed 1200 seconds by postgrey-1.27 at vger.kernel.org; Fri, 09 Sep 2011 04:52:34 EDT
From: Anders Johansson <ajohansson@suse.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] elevator use after free
Date: Fri, 09 Sep 2011 10:32:26 +0200
Message-ID: <2829897.yZgTmxoDjA@grindwal>
Organization: SUSE LINUX GmbH
User-Agent: KMail/4.7.0 (Linux/2.6.37.6-0.7-desktop; KDE/4.7.0; x86_64; ; )
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="nextPart1872851.qoI9RvSFTJ"
Content-Transfer-Encoding: 7Bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart1872851.qoI9RvSFTJ
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Hi,

Attached is a patch for a crash we have seen where an elevator is used after 
it has been killed.

Reply with me in cc. please, I'm not subscribed

Thanks,

Anders
--nextPart1872851.qoI9RvSFTJ
Content-Disposition: attachment; filename="elevator-dont-use-dead-elv"
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="UTF-8"; name="elevator-dont-use-dead-elv"

If a device disappears, the elevator may in some cases be used
after free, similar to 0a58e077eb600d1efd7e54ad9926a75a39d7f8ae

Several crashes were seen with the trace

[<ffffffff80196657>] elv_drain_elevator+0x17/0x60
[<ffffffff80197009>] elv_insert+0x129/0x260
[<ffffffff80198323>] blk_insert_cloned_request+0x53/0x70
[<ffffffffa018c62f>] dm_dispatch_request+0x2f/0x60 [dm_mod]
[<ffffffffa014c0b0>] dispatch_queued_ios+0x110/0x150 [dm_multipath]
[<ffffffff800530b3>] run_workqueue+0xa3/0x1f0
[<ffffffff80053296>] worker_thread+0x96/0x110
[<ffffffff80056946>] kthread+0x96/0xa0
[<ffffffff80007f0a>] child_rip+0xa/0x20

This patch adds more tests to ensure a dead queue isn't used

Signed-off-by: Anders Johansson <ajohansson@suse.com>

diff -upr a/block/elevator.c b/block/elevator.c
--- a/block/elevator.c	2011-08-24 18:44:20.000000000 +0200
+++ b/block/elevator.c	2011-09-05 15:04:08.000000000 +0200
@@ -622,7 +622,7 @@ void elv_drain_elevator(struct request_q
  */
 void elv_quiesce_start(struct request_queue *q)
 {
-	if (!q->elevator)
+	if (!q->elevator || test_bit(QUEUE_FLAG_DEAD, &q->queue_flags))
 		return;
 
 	queue_flag_set(QUEUE_FLAG_ELVSWITCH, q);
@@ -649,6 +649,9 @@ void elv_insert(struct request_qu
 {
 	trace_block_rq_insert(q, rq);
 
+	if(test_bit(QUEUE_FLAG_DEAD, &q->queue_flags))
+		return;
+
 	rq->q = q;
 
 	if (rq->cmd_flags & REQ_SOFTBARRIER) {

--nextPart1872851.qoI9RvSFTJ--

