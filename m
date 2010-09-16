Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753405Ab0IPCE6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 22:04:58 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:56953 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752542Ab0IPCEv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 22:04:51 -0400
Date: Thu, 16 Sep 2010 12:04:49 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>, Tejun Heo <tj@kernel.org>
Subject: linux-next: manual merge of the block tree with Linus' tree
Message-Id: <20100916120449.3d4f2c5f.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens,

Today's linux-next merge of the block tree got a conflict in
block/blk-core.c between commit 5e00d1b5b4c10fb839afd5ce61db8e24339454b0
("BLOCK: fix bio.bi_rw handling") from Linus' tree (v2.6.36-rc4) and
commit 28e7d1845216538303bb95d679d8fd4de50e2f1a ("block: drop barrier
ordering by queue draining") from the block tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc block/blk-core.c
index 32a1c12,4df8e84..0000000
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@@ -1198,13 -1182,15 +1182,15 @@@ static int __make_request(struct reques
  	int el_ret;
  	unsigned int bytes = bio->bi_size;
  	const unsigned short prio = bio_prio(bio);
 -	const bool sync = (bio->bi_rw & REQ_SYNC);
 -	const bool unplug = (bio->bi_rw & REQ_UNPLUG);
 -	const unsigned int ff = bio->bi_rw & REQ_FAILFAST_MASK;
 +	const bool sync = !!(bio->bi_rw & REQ_SYNC);
 +	const bool unplug = !!(bio->bi_rw & REQ_UNPLUG);
 +	const unsigned long ff = bio->bi_rw & REQ_FAILFAST_MASK;
+ 	int where = ELEVATOR_INSERT_SORT;
  	int rw_flags;
  
- 	if ((bio->bi_rw & REQ_HARDBARRIER) &&
- 	    (q->next_ordered == QUEUE_ORDERED_NONE)) {
+ 	/* REQ_HARDBARRIER is no more */
+ 	if (WARN_ONCE(bio->bi_rw & REQ_HARDBARRIER,
+ 		"block: HARDBARRIER is deprecated, use FLUSH/FUA instead\n")) {
  		bio_endio(bio, -EOPNOTSUPP);
  		return 0;
  	}
