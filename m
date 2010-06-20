Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757191Ab0FTUv3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jun 2010 16:51:29 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:51899 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757102Ab0FTUv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jun 2010 16:51:27 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 20 Jun 2010 22:50:35 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 1/8] firewire: remove an unused function argument
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.ba0692c55cd50593@s5r6.in-berlin.de>
Message-ID: <tkrat.21cad29c23b5e375@s5r6.in-berlin.de>
References: <tkrat.ba0692c55cd50593@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

void (*fw_address_callback_t)(..., int speed, ...) is the speed that a
remote node chose to transmit a request to us.  In case of split
transactions, firewire-core will transmit the response at that speed.

Upper layer drivers on the other hand (firewire-net, -sbp2, firedtv, and
userspace drivers) cannot do anything useful with that speed datum,
except log it for debug purposes.  But data that is merely potentially
(not even actually) used for debug purposes does not belong into the API.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/core-cdev.c            |    3 +--
 drivers/firewire/core-transaction.c     |   14 +++++++-------
 drivers/firewire/net.c                  |    4 ++--
 drivers/firewire/sbp2.c                 |    3 +--
 drivers/media/dvb/firewire/firedtv-fw.c |    4 ++--
 include/linux/firewire.h                |    2 +-
 6 files changed, 14 insertions(+), 16 deletions(-)

Index: b/drivers/firewire/core-cdev.c
===================================================================
--- a/drivers/firewire/core-cdev.c
+++ b/drivers/firewire/core-cdev.c
@@ -633,8 +633,7 @@ static void release_request(struct clien
 
 static void handle_request(struct fw_card *card, struct fw_request *request,
 			   int tcode, int destination, int source,
-			   int generation, int speed,
-			   unsigned long long offset,
+			   int generation, unsigned long long offset,
 			   void *payload, size_t length, void *callback_data)
 {
 	struct address_handler_resource *handler = callback_data;
Index: b/drivers/firewire/core-transaction.c
===================================================================
--- a/drivers/firewire/core-transaction.c
+++ b/drivers/firewire/core-transaction.c
@@ -802,7 +802,7 @@ static void handle_exclusive_region_requ
 	else
 		handler->address_callback(card, request,
 					  tcode, destination, source,
-					  p->generation, p->speed, offset,
+					  p->generation, offset,
 					  request->data, request->length,
 					  handler->callback_data);
 }
@@ -840,8 +840,8 @@ static void handle_fcp_region_request(st
 		if (is_enclosing_handler(handler, offset, request->length))
 			handler->address_callback(card, NULL, tcode,
 						  destination, source,
-						  p->generation, p->speed,
-						  offset, request->data,
+						  p->generation, offset,
+						  request->data,
 						  request->length,
 						  handler->callback_data);
 	}
@@ -951,8 +951,8 @@ static const struct fw_address_region to
 
 static void handle_topology_map(struct fw_card *card, struct fw_request *request,
 		int tcode, int destination, int source, int generation,
-		int speed, unsigned long long offset,
-		void *payload, size_t length, void *callback_data)
+		unsigned long long offset, void *payload, size_t length,
+		void *callback_data)
 {
 	int start;
 
@@ -996,8 +996,8 @@ static void update_split_timeout(struct 
 
 static void handle_registers(struct fw_card *card, struct fw_request *request,
 		int tcode, int destination, int source, int generation,
-		int speed, unsigned long long offset,
-		void *payload, size_t length, void *callback_data)
+		unsigned long long offset, void *payload, size_t length,
+		void *callback_data)
 {
 	int reg = offset & ~CSR_REGISTER_BASE;
 	__be32 *data = payload;
Index: b/drivers/firewire/net.c
===================================================================
--- a/drivers/firewire/net.c
+++ b/drivers/firewire/net.c
@@ -806,8 +806,8 @@ static int fwnet_incoming_packet(struct 
 
 static void fwnet_receive_packet(struct fw_card *card, struct fw_request *r,
 		int tcode, int destination, int source, int generation,
-		int speed, unsigned long long offset, void *payload,
-		size_t length, void *callback_data)
+		unsigned long long offset, void *payload, size_t length,
+		void *callback_data)
 {
 	struct fwnet_device *dev = callback_data;
 	int rcode;
Index: b/drivers/firewire/sbp2.c
===================================================================
--- a/drivers/firewire/sbp2.c
+++ b/drivers/firewire/sbp2.c
@@ -410,8 +410,7 @@ static void free_orb(struct kref *kref)
 
 static void sbp2_status_write(struct fw_card *card, struct fw_request *request,
 			      int tcode, int destination, int source,
-			      int generation, int speed,
-			      unsigned long long offset,
+			      int generation, unsigned long long offset,
 			      void *payload, size_t length, void *callback_data)
 {
 	struct sbp2_logical_unit *lu = callback_data;
Index: b/drivers/media/dvb/firewire/firedtv-fw.c
===================================================================
--- a/drivers/media/dvb/firewire/firedtv-fw.c
+++ b/drivers/media/dvb/firewire/firedtv-fw.c
@@ -194,8 +194,8 @@ static const struct firedtv_backend back
 
 static void handle_fcp(struct fw_card *card, struct fw_request *request,
 		       int tcode, int destination, int source, int generation,
-		       int speed, unsigned long long offset,
-		       void *payload, size_t length, void *callback_data)
+		       unsigned long long offset, void *payload, size_t length,
+		       void *callback_data)
 {
 	struct firedtv *f, *fdtv = NULL;
 	struct fw_device *device;
Index: b/include/linux/firewire.h
===================================================================
--- a/include/linux/firewire.h
+++ b/include/linux/firewire.h
@@ -265,7 +265,7 @@ typedef void (*fw_transaction_callback_t
 typedef void (*fw_address_callback_t)(struct fw_card *card,
 				      struct fw_request *request,
 				      int tcode, int destination, int source,
-				      int generation, int speed,
+				      int generation,
 				      unsigned long long offset,
 				      void *data, size_t length,
 				      void *callback_data);

-- 
Stefan Richter
-=====-==-=- -==- =-=--
http://arcgraph.de/sr/

