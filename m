Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932764Ab2HIN5z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 09:57:55 -0400
Received: from smtp.ispras.ru ([83.149.198.202]:52406 "EHLO smtp.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932262Ab2HIN5x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 09:57:53 -0400
From: Marina Makienko <makienko@ispras.ru>
To: Peter Osterlund <petero2@telia.com>
Cc: Marina Makienko <makienko@ispras.ru>, ldv-project@ispras.ru,
        linux-kernel@vger.kernel.org
Subject: [PATCH 02/13] block: Potential null pointer dereference in pkt_generic_packet()
Date: Thu,  9 Aug 2012 17:54:06 +0400
Message-Id: <1344520446-13824-2-git-send-email-makienko@ispras.ru>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1344520446-13824-1-git-send-email-makienko@ispras.ru>
References: <1344520446-13824-1-git-send-email-makienko@ispras.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function blk_get_request() can return NULL in some cases. There are
checks on it if function is called with argumetns one of which is
GFP_ATOMIC/GFP_NOIO/etc. If system couldn't find request
blk_get_request() return NULL.

But if there is function call with argument __GFP_WAIT
the system will wait until get request or the queue becomes
dead. If something kills the queue, blk_get_request()
return NULL and next operations will lead to errors.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Marina Makienko <makienko@ispras.ru>
---
 drivers/block/pktcdvd.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
index ba66e44..be477aa 100644
--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -743,6 +743,9 @@ static int pkt_generic_packet(struct pktcdvd_device *pd, struct packet_command *
 	rq = blk_get_request(q, (cgc->data_direction == CGC_DATA_WRITE) ?
 			     WRITE : READ, __GFP_WAIT);
 
+	if (!rq)
+		return -EIO;
+
 	if (cgc->buflen) {
 		if (blk_rq_map_kern(q, rq, cgc->buffer, cgc->buflen, __GFP_WAIT))
 			goto out;
-- 
1.7.7

