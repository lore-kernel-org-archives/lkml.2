Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753876Ab2BRVf4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Feb 2012 16:35:56 -0500
Received: from kamaji.grokhost.net ([87.117.218.43]:59126 "EHLO
	kamaji.grokhost.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752870Ab2BRVfy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Feb 2012 16:35:54 -0500
From: Chris Boot <bootc@bootc.net>
To: linux1394-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Chris Boot <bootc@bootc.net>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] firewire-sbp2: Initialise sbp2_orb->rcode for management ORBs
Date: Sat, 18 Feb 2012 21:35:49 +0000
Message-Id: <1329600949-55157-1-git-send-email-bootc@bootc.net>
X-Mailer: git-send-email 1.7.9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When sending ORBs the struct sbp2_orb->rcode field should be initialised
to -1 otherwise complete_transaction() assumes the request is successful
(RCODE_COMPLETE is 0). When sending managament ORBs, such as LOGIN or
LOGOUT, this was not done and so the initiator would wait for the
request to time out before trying again.

Without this, LOGINs are only retried when the management ORB times out,
rather than the initiator noticing an error occurred and retrying soon
after. For targets that advertise more than one LUN per unit, and can
only accept one management request at a time, this means LUNs are only
logged in one per timeout period.

Signed-off-by: Chris Boot <bootc@bootc.net>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/sbp2.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/firewire/sbp2.c b/drivers/firewire/sbp2.c
index b12c6ba..7776c18 100644
--- a/drivers/firewire/sbp2.c
+++ b/drivers/firewire/sbp2.c
@@ -572,6 +572,9 @@ static int sbp2_send_management_orb(struct sbp2_logical_unit *lu, int node_id,
 	if (dma_mapping_error(device->card->device, orb->response_bus))
 		goto fail_mapping_response;
 
+	/* Initialize rcode to something not RCODE_COMPLETE. */
+	orb->base.rcode = -1;
+
 	orb->request.response.high = 0;
 	orb->request.response.low  = cpu_to_be32(orb->response_bus);
 
-- 
1.7.9

