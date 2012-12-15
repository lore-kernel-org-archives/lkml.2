Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753155Ab2LOGEi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2012 01:04:38 -0500
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:47230 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751622Ab2LOGDx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2012 01:03:53 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH v2 3/6] staging/fwserial: Limit tx/rx to 1394-2008 spec maximum
Date: Sat, 15 Dec 2012 01:03:17 -0500
Message-Id: <1355551400-8204-4-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.0.1
In-Reply-To: <1355551400-8204-1-git-send-email-peter@hurleysoftware.com>
References: <1355551400-8204-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
X-MT-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
X-MT-INTERNAL-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Per this conversation https://lkml.org/lkml/2012/11/27/587
limit the maximum transmission to the IEEE 1394-2008 specification
maximum size of 4096 bytes for asynchronous packets.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/staging/fwserial/TODO       | 3 ---
 drivers/staging/fwserial/fwserial.c | 8 ++++----
 drivers/staging/fwserial/fwserial.h | 4 ++--
 3 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/fwserial/TODO b/drivers/staging/fwserial/TODO
index 7269005..ffe47d1 100644
--- a/drivers/staging/fwserial/TODO
+++ b/drivers/staging/fwserial/TODO
@@ -12,9 +12,6 @@ TODOs
 1. This driver uses the same unregistered vendor id that the firewire core does
      (0xd00d1e). Perhaps this could be exposed as a define in
      firewire-constants.h?
-2. MAX_ASYNC_PAYLOAD needs to be publicly exposed by core/ohci
-   - otherwise how will this driver know the max size of address window to
-     open for one packet write?
 3. Maybe device_max_receive() and link_speed_to_max_payload() should be
      taken up by the firewire core?
 4. To avoid dropping rx data while still limiting the maximum buffering,
diff --git a/drivers/staging/fwserial/fwserial.c b/drivers/staging/fwserial/fwserial.c
index be5db8a..db1378d 100644
--- a/drivers/staging/fwserial/fwserial.c
+++ b/drivers/staging/fwserial/fwserial.c
@@ -174,10 +174,11 @@ static void dump_profile(struct seq_file *m, struct stats *stats)
 #define dump_profile(m, stats)
 #endif
 
-/* Returns the max receive packet size for the given card */
+/* Returns the max receive packet size for the given node */
 static inline int device_max_receive(struct fw_device *fw_device)
 {
-	return 1 <<  (clamp_t(int, fw_device->max_rec, 8U, 13U) + 1);
+	/* see IEEE 1394-2008 table 8-8 */
+	return 1 <<  (clamp_t(int, fw_device->max_rec, 8U, 11U) + 1);
 }
 
 static void fwtty_log_tx_error(struct fwtty_port *port, int rcode)
@@ -1683,8 +1684,7 @@ static void fwserial_virt_plug_complete(struct fwtty_peer *peer,
 
 	/* reconfigure tx_fifo optimally for this peer */
 	spin_lock_bh(&port->lock);
-	port->max_payload = min3(peer->max_payload, peer->fifo_len,
-				 MAX_ASYNC_PAYLOAD);
+	port->max_payload = min(peer->max_payload, peer->fifo_len);
 	dma_fifo_change_tx_limit(&port->tx_fifo, port->max_payload);
 	spin_unlock_bh(&peer->port->lock);
 
diff --git a/drivers/staging/fwserial/fwserial.h b/drivers/staging/fwserial/fwserial.h
index cb0eea0..953ece6 100644
--- a/drivers/staging/fwserial/fwserial.h
+++ b/drivers/staging/fwserial/fwserial.h
@@ -377,8 +377,8 @@ static inline void fwtty_bind_console(struct fwtty_port *port,
  */
 static inline int link_speed_to_max_payload(unsigned speed)
 {
-	speed = clamp(speed, (unsigned) SCODE_100, (unsigned) SCODE_3200);
-	return 1 << (speed + 9);
+	/* Max async payload is 4096 - see IEEE 1394-2008 tables 6-4, 16-18 */
+	return min(512 << speed, 4096);
 }
 
 #endif /* _FIREWIRE_FWSERIAL_H */
-- 
1.8.0.1

