Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755942Ab2BFW0d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 17:26:33 -0500
Received: from kamaji.grokhost.net ([87.117.218.43]:59874 "EHLO
	kamaji.grokhost.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755055Ab2BFW0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 17:26:32 -0500
X-Greylist: delayed 488 seconds by postgrey-1.27 at vger.kernel.org; Mon, 06 Feb 2012 17:26:31 EST
From: Chris Boot <bootc@bootc.net>
To: linux1394-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Chris Boot <bootc@bootc.net>,
        Clemens Ladisch <clemens@ladisch.de>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [RFC][PATCH] firewire: Add function to get speed from opaque struct fw_request
Date: Mon,  6 Feb 2012 22:17:41 +0000
Message-Id: <1328566661-80768-1-git-send-email-bootc@bootc.net>
X-Mailer: git-send-email 1.7.8.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Would something like the following be acceptable as an addition to the
FireWire stack? This would be enough for me to get the speed of the
request for my work on the SBP-2 target code. ]

Sometimes it's useful to know the FireWire speed of the request that has
just come in to a fw_address_handler callback. As struct fw_request is
opaque we can't peek inside to get the speed out of the struct fw_packet
that's just inside. For example, the SBP-2 spec says:

"The speed at which the block write request to the MANAGEMENT_AGENT
register is received shall determine the speed used by the target for
all subsequent requests to read the initiator’s configuration ROM, fetch
ORB’s from initiator memory or store status at the initiator’s
status_FIFO. Command block ORB’s separately specify the speed for
requests addressed to the data buffer or page table."

[ ANSI T10/1155D Revision 4 page 53/54 ]

Signed-off-by: Chris Boot <bootc@bootc.net>
Cc: Clemens Ladisch <clemens@ladisch.de>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/core-transaction.c |    6 ++++++
 include/linux/firewire.h            |    1 +
 2 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/firewire/core-transaction.c b/drivers/firewire/core-transaction.c
index 855ab3f..89c882d 100644
--- a/drivers/firewire/core-transaction.c
+++ b/drivers/firewire/core-transaction.c
@@ -820,6 +820,12 @@ void fw_send_response(struct fw_card *card,
 }
 EXPORT_SYMBOL(fw_send_response);
 
+int fw_request_speed(struct fw_request *request)
+{
+	return request->response.speed;
+}
+EXPORT_SYMBOL(fw_request_speed);
+
 static void handle_exclusive_region_request(struct fw_card *card,
 					    struct fw_packet *p,
 					    struct fw_request *request,
diff --git a/include/linux/firewire.h b/include/linux/firewire.h
index 84ccf8e..eded4e4 100644
--- a/include/linux/firewire.h
+++ b/include/linux/firewire.h
@@ -340,6 +340,7 @@ int fw_core_add_address_handler(struct fw_address_handler *handler,
 void fw_core_remove_address_handler(struct fw_address_handler *handler);
 void fw_send_response(struct fw_card *card,
 		      struct fw_request *request, int rcode);
+int fw_request_speed(struct fw_request *request);
 void fw_send_request(struct fw_card *card, struct fw_transaction *t,
 		     int tcode, int destination_id, int generation, int speed,
 		     unsigned long long offset, void *payload, size_t length,
-- 
1.7.8.3

