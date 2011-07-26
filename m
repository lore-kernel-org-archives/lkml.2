Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752840Ab1GZJaA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 05:30:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59567 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751461Ab1GZJ3z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 05:29:55 -0400
Subject: Preempt & smp_processor_id in __make_request
From: Steven Whitehouse <swhiteho@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Tue, 26 Jul 2011 10:32:06 +0100
Message-ID: <1311672726.2700.5.camel@menhir>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On the latest upstream kernel, I'm getting large quantities of messages
as per the following:

Jul 26 09:54:04 chywoon kernel: BUG: using smp_processor_id() in preemptible [00
000000] code: jbd2/dm-0-8/1546
Jul 26 09:54:04 chywoon kernel: caller is __make_request+0x209/0x350
Jul 26 09:54:04 chywoon kernel: Pid: 1546, comm: jbd2/dm-0-8 Tainted: G        W
   3.0.0+ #252
Jul 26 09:54:04 chywoon kernel: Call Trace:
Jul 26 09:54:04 chywoon kernel: [<ffffffff813db897>] debug_smp_processor_id+0xe7
/0x100
Jul 26 09:54:04 chywoon kernel: [<ffffffff813b6f29>] __make_request+0x209/0x350
Jul 26 09:54:04 chywoon kernel: [<ffffffff8154635e>] ? dm_request+0x2e/0x280
Jul 26 09:54:04 chywoon kernel: [<ffffffff813b3ffb>] generic_make_request+0x27b/
0x550
Jul 26 09:54:04 chywoon kernel: [<ffffffff8123ef7e>] ? jbd2_journal_file_buffer+
0x8e/0x130
Jul 26 09:54:04 chywoon kernel: [<ffffffff813b432f>] submit_bio+0x5f/0xd0
Jul 26 09:54:04 chywoon kernel: [<ffffffff811b14a6>] submit_bh+0xe6/0x120
etc.

The (trivial) fix appears to be the following:

diff --git a/block/blk-core.c b/block/blk-core.c
index f8cb099..f925581 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1283,7 +1283,7 @@ get_rq:
 
 	if (test_bit(QUEUE_FLAG_SAME_COMP, &q->queue_flags) ||
 	    bio_flagged(bio, BIO_CPU_AFFINE))
-		req->cpu = smp_processor_id();
+		req->cpu = raw_smp_processor_id();
 
 	plug = current->plug;
 	if (plug) {

However this fixes the symptoms, rather than the cause, so I'm not at
all sure that this is the correct solution,

Steve.


