Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754021Ab0HCDMK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 23:12:10 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:45203 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753654Ab0HCDMI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 23:12:08 -0400
Date: Tue, 3 Aug 2010 13:12:02 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>, Yehuda Sadeh <yehuda@hq.newdream.net>,
        Sage Weil <sage@newdream.net>
Subject: linux-next: build failure after merge of the block tree
Message-Id: <20100803131202.422af85f.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens,

After merging the block tree, today's linux-next build (x86_64
allmodconfig) failed like this:

fs/ceph/rbd.c: In function 'rbd_rq_fn':
fs/ceph/rbd.c:1101: error: implicit declaration of function 'blk_fs_request'
fs/ceph/rbd.c:1101: error: implicit declaration of function 'blk_barrier_rq'

Caused by commit fc734ac98dbce1e3d3e1e1359524c279a336ac49 ("block: remove
wrappers for request type/flags") interacting with commit
e7fdb915217126d23ff2aafb2d5fdce21b763df1 ("ceph-rbd: rados block device")
from the ceph tree.

I applied the following merge fix patch (Christoph, I assume that this
should be directly applicable to the ceph tree, right?):

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 3 Aug 2010 13:08:18 +1000
Subject: [PATCH] ceph: update for removal of request flag wrappers

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 fs/ceph/rbd.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/ceph/rbd.c b/fs/ceph/rbd.c
index 86c8b06..1fa2634 100644
--- a/fs/ceph/rbd.c
+++ b/fs/ceph/rbd.c
@@ -1098,7 +1098,8 @@ static void rbd_rq_fn(struct request_queue *q)
 		dout("fetched request\n");
 
 		/* filter out block requests we don't understand */
-		if (!blk_fs_request(rq) && !blk_barrier_rq(rq)) {
+		if ((rq->cmd_type != REQ_TYPE_FS) &&
+		    !(rq->cmd_flags & REQ_HARDBARRIER)) {
 			__blk_end_request_all(rq, 0);
 			goto next;
 		}
-- 
1.7.1

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
