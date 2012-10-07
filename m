Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753051Ab2JGXWH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 19:22:07 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38133 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752693Ab2JGXVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 19:21:53 -0400
Message-Id: <20121007225835.978358364@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 07 Oct 2012 23:58:43 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "Stephen M. Cameron" <scameron@beardog.cce.hp.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [ 009/108] cciss: fix handling of protocol error
In-Reply-To: <20121007225834.673681075@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>

commit 2453f5f992717251cfadab6184fbb3ec2f2e8b40 upstream.

If a command completes with a status of CMD_PROTOCOL_ERR, this
information should be conveyed to the SCSI mid layer, not dropped
on the floor.  Unlike a similar bug in the hpsa driver, this bug
only affects tape drives and CD and DVD ROM drives in the cciss
driver, and to induce it, you have to disconnect (or damage) a
cable, so it is not a very likely scenario (which would explain
why the bug has gone undetected for the last 10 years.)

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/block/cciss_scsi.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/block/cciss_scsi.c b/drivers/block/cciss_scsi.c
index 38aa6dd..da33111 100644
--- a/drivers/block/cciss_scsi.c
+++ b/drivers/block/cciss_scsi.c
@@ -795,6 +795,7 @@ static void complete_scsi_command(CommandList_struct *c, int timeout,
 				}
 			break;
 			case CMD_PROTOCOL_ERR:
+				cmd->result = DID_ERROR << 16;
 				dev_warn(&h->pdev->dev,
 					"%p has protocol error\n", c);
                         break;


