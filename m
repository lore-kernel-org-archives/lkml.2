Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756360Ab0IYKpt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Sep 2010 06:45:49 -0400
Received: from mx2.fusionio.com ([64.244.102.31]:51201 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756210Ab0IYKpr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Sep 2010 06:45:47 -0400
X-ASG-Debug-ID: 1285411546-08b76bbb0001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4C9DD2D5.8090807@fusionio.com>
Date: Sat, 25 Sep 2010 12:45:41 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] One important block fix for 2.6.36-rc
Content-Type: text/plain; charset="ISO-8859-1"
X-ASG-Orig-Subj: [GIT PULL] One important block fix for 2.6.36-rc
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1285411546
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.50
X-Barracuda-Spam-Status: No, SCORE=0.50 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=BSF_RULE7568M
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.41842
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
	0.50 BSF_RULE7568M          Custom Rule 7568M
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Adrian Hunter just discovered that we may inadvertently merge writes
with discards, since discards are now of the same type as file system
requests. This is very problematic, as it may turn a write into a
discard or vice versa.

Please pull asap, thanks.

are available in the git repository at:
  git://git.kernel.dk/linux-2.6-block.git for-linus

Adrian Hunter (1):
      block: prevent merges of discard and write requests

 block/blk-merge.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/block/blk-merge.c b/block/blk-merge.c
index 3b0cd42..eafc94f 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -362,6 +362,18 @@ static int attempt_merge(struct request_queue *q, struct request *req,
 		return 0;
 
 	/*
+	 * Don't merge file system requests and discard requests
+	 */
+	if ((req->cmd_flags & REQ_DISCARD) != (next->cmd_flags & REQ_DISCARD))
+		return 0;
+
+	/*
+	 * Don't merge discard requests and secure discard requests
+	 */
+	if ((req->cmd_flags & REQ_SECURE) != (next->cmd_flags & REQ_SECURE))
+		return 0;
+
+	/*
 	 * not contiguous
 	 */
 	if (blk_rq_pos(req) + blk_rq_sectors(req) != blk_rq_pos(next))

-- 
Jens Axboe

