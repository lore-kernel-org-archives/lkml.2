Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754523Ab0F0IuQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jun 2010 04:50:16 -0400
Received: from sh.osrg.net ([192.16.179.4]:46112 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753226Ab0F0IuM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jun 2010 04:50:12 -0400
Date: Sun, 27 Jun 2010 17:49:29 +0900
To: snitzer@redhat.com
Cc: hch@lst.de, axboe@kernel.dk, dm-devel@redhat.com, James.Bottomley@suse.de,
       linux-kernel@vger.kernel.org, martin.petersen@oracle.com,
       akpm@linux-foundation.org
Subject: Re: [PATCH 1/2] block: fix leaks associated with discard request
 payload
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1277582211-10725-1-git-send-email-snitzer@redhat.com>
References: <20100622180029.GA15950@redhat.com>
	<1277582211-10725-1-git-send-email-snitzer@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100627174721D.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Sun, 27 Jun 2010 17:49:32 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 26 Jun 2010 15:56:50 -0400
Mike Snitzer <snitzer@redhat.com> wrote:

> Fix leaks introduced via "block: don't allocate a payload for discard
> request" commit a1d949f5f44.
> 
> sd_done() is not called for REQ_TYPE_BLOCK_PC commands so cleanup
> discard request's payload directly in scsi_finish_command().

Instead of adding another discard hack to scsi_finish_command(), how
about converting discard to REQ_TYPE_FS request? discard is FS request
from the perspective of the block layer. It also fixes a problem that
discard isn't retried in the case of UNIT ATTENTION.

I think that we can get more cleaner code if we handle discard as
normal (fs) request in the block layer (and scsi-ml). We need more
changes but this patch is the first step.

This patch depends on the patchset to convert flush request to
REQ_TYPE_FS:

http://marc.info/?l=linux-kernel&m=127730591527424&w=2

The git tree is also available:

git://git.kernel.org/pub/scm/linux/kernel/git/tomo/linux-2.6-misc.git flush


> Also cleanup page allocated for discard payload in
> scsi_setup_discard_cmnd's scsi_setup_blk_pc_cmnd error path.

This patch doesn't address on this (since it's a different problem). I
think that scsi_setup_discard_cmnd() sees if it already allocates a
page before allocating a page. That's similar to how other prep
functions work, I think.

=
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] convert discard request to REQ_TYPE_FS instead of BLOCK_PC

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 block/blk-lib.c   |    4 ++++
 drivers/scsi/sd.c |   11 +----------
 2 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/block/blk-lib.c b/block/blk-lib.c
index e16185b..9e15c46 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -20,6 +20,10 @@ static void blkdev_discard_end_io(struct bio *bio, int err)
 	if (bio->bi_private)
 		complete(bio->bi_private);
 
+	/* free the page that the lower layer allocated */
+	if (bio_page(bio))
+		__free_page(bio_page(bio));
+
 	bio_put(bio);
 }
 
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index d447726..1b182de 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -432,7 +432,7 @@ static int scsi_setup_discard_cmnd(struct scsi_device *sdp, struct request *rq)
 		nr_sectors >>= 3;
 	}
 
-	rq->cmd_type = REQ_TYPE_BLOCK_PC;
+	rq->cmd_type = REQ_TYPE_FS;
 	rq->timeout = SD_TIMEOUT;
 
 	memset(rq->cmd, 0, rq->cmd_len);
@@ -1177,15 +1177,6 @@ static int sd_done(struct scsi_cmnd *SCpnt)
 	int sense_valid = 0;
 	int sense_deferred = 0;
 
-	/*
-	 * If this is a discard request that originated from the kernel
-	 * we need to free our payload here.  Note that we need to check
-	 * the request flag as the normal payload rules apply for
-	 * pass-through UNMAP / WRITE SAME requests.
-	 */
-	if (SCpnt->request->cmd_flags & REQ_DISCARD)
-		__free_page(bio_page(SCpnt->request->bio));
-
 	if (result) {
 		sense_valid = scsi_command_normalize_sense(SCpnt, &sshdr);
 		if (sense_valid)
-- 
1.6.5

