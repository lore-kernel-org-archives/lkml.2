Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760369Ab2DKOVW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 10:21:22 -0400
Received: from kamaji.grokhost.net ([87.117.218.43]:54897 "EHLO
	kamaji.grokhost.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760356Ab2DKOVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 10:21:20 -0400
From: Chris Boot <bootc@bootc.net>
To: linux1394-devel@lists.sourceforge.net, target-devel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, agrover@redhat.com, clemens@ladisch.de,
        nab@linux-iscsi.org, stefanr@s5r6.in-berlin.de,
        Chris Boot <bootc@bootc.net>
Subject: [PATCH 01/11] firewire: Add function to get speed from opaque struct fw_request
Date: Wed, 11 Apr 2012 15:20:33 +0100
Message-Id: <1334154043-69076-2-git-send-email-bootc@bootc.net>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1334154043-69076-1-git-send-email-bootc@bootc.net>
References: <1329317248-94128-1-git-send-email-bootc@bootc.net>
 <1334154043-69076-1-git-send-email-bootc@bootc.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
Acked-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Clemens Ladisch <clemens@ladisch.de>
---
 drivers/firewire/core-transaction.c |    9 +++++++++
 include/linux/firewire.h            |    1 +
 2 files changed, 10 insertions(+)

diff --git a/drivers/firewire/core-transaction.c b/drivers/firewire/core-transaction.c
index dea2dcc..db8a965 100644
--- a/drivers/firewire/core-transaction.c
+++ b/drivers/firewire/core-transaction.c
@@ -820,6 +820,15 @@ void fw_send_response(struct fw_card *card,
 }
 EXPORT_SYMBOL(fw_send_response);
 
+/**
+ * fw_get_request_speed() - returns speed at which the @request was received
+ */
+int fw_get_request_speed(struct fw_request *request)
+{
+	return request->response.speed;
+}
+EXPORT_SYMBOL(fw_get_request_speed);
+
 static void handle_exclusive_region_request(struct fw_card *card,
 					    struct fw_packet *p,
 					    struct fw_request *request,
diff --git a/include/linux/firewire.h b/include/linux/firewire.h
index cdc9b71..4683130 100644
--- a/include/linux/firewire.h
+++ b/include/linux/firewire.h
@@ -325,6 +325,7 @@ int fw_core_add_address_handler(struct fw_address_handler *handler,
 void fw_core_remove_address_handler(struct fw_address_handler *handler);
 void fw_send_response(struct fw_card *card,
 		      struct fw_request *request, int rcode);
+int fw_get_request_speed(struct fw_request *request);
 void fw_send_request(struct fw_card *card, struct fw_transaction *t,
 		     int tcode, int destination_id, int generation, int speed,
 		     unsigned long long offset, void *payload, size_t length,
-- 
1.7.9.5

