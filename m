Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757451Ab2HIJmi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 05:42:38 -0400
Received: from smtp.ispras.ru ([83.149.198.202]:52282 "EHLO smtp.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751270Ab2HIJmh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 05:42:37 -0400
From: Marina Makienko <makienko@ispras.ru>
To: Thomas Maier <balagi@justmail.de>
Cc: Marina Makienko <makienko@ispras.ru>, Peter Osterlund <petero2@telia.com>,
        linux-kernel@vger.kernel.org, ldv-project@ispras.ru
Subject: [PATCH] block: Potential null pointer dereference in pkt_generic_packet()
Date: Thu,  9 Aug 2012 13:38:50 +0400
Message-Id: <1344505130-17757-1-git-send-email-makienko@ispras.ru>
X-Mailer: git-send-email 1.7.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function blk_get_request() can return NULL. It can lead to further error in pkt_generic_packet().

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Marina Makienko <makienko@ispras.ru>
---
 drivers/block/pktcdvd.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
index ba66e44..db3192e 100644
--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -743,6 +743,11 @@ static int pkt_generic_packet(struct pktcdvd_device *pd, struct packet_command *
 	rq = blk_get_request(q, (cgc->data_direction == CGC_DATA_WRITE) ?
 			     WRITE : READ, __GFP_WAIT);
 
+	if (!rq) {
+		printk(DRIVER_NAME"pkt_generic_packet: blk_get_request failed. \n");
+		return NULL;
+	}
+
 	if (cgc->buflen) {
 		if (blk_rq_map_kern(q, rq, cgc->buffer, cgc->buflen, __GFP_WAIT))
 			goto out;
-- 
1.7.7

