Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753265Ab0H1MWr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Aug 2010 08:22:47 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:37743 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753031Ab0H1MWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Aug 2010 08:22:46 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 28 Aug 2010 14:22:27 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] firewire: ohci: add some "unlikely" hints
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.8705132a95f3f284@s5r6.in-berlin.de>
Message-ID: <tkrat.3fd9444150751f66@s5r6.in-berlin.de>
References: <4C6909DD.3070002@ladisch.de>
 <tkrat.8705132a95f3f284@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark evt_no_status and evt_bus_reset packet reception events as ones
that occur rarely.

Also, inline the debug flag check of log_ar_at_event().  [The same is
hopefully not necessary for log_irqs() which is only called at a single
site and hence auto-inlined by the compiler.]

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/ohci.c |   28 +++++++++++++++++-----------
 1 file changed, 17 insertions(+), 11 deletions(-)

Index: b/drivers/firewire/ohci.c
===================================================================
--- a/drivers/firewire/ohci.c
+++ b/drivers/firewire/ohci.c
@@ -398,14 +401,11 @@ static const char *phys[] = {
 	[0x2] = "self-id packet",	[0x3] = "-reserved-",
 };
 
-static void log_ar_at_event(char dir, int speed, u32 *header, int evt)
+static void _ar_at_event(char dir, int speed, u32 *header, int evt)
 {
 	int tcode = header[0] >> 4 & 0xf;
 	char specific[12];
 
-	if (likely(!(param_debug & OHCI_PARAM_DEBUG_AT_AR)))
-		return;
-
 	if (unlikely(evt >= ARRAY_SIZE(evts)))
 			evt = 0x1f;
 
@@ -456,6 +456,12 @@ static void log_ar_at_event(char dir, in
 	}
 }
 
+static inline void log_ar_at_event(char dir, int speed, u32 *header, int evt)
+{
+	if (unlikely(param_debug & OHCI_PARAM_DEBUG_AT_AR))
+		_ar_at_event(dir, speed, header, evt);
+}
+
 #else
 
 #define param_debug 0
@@ -697,7 +703,7 @@ static __le32 *handle_ar_packet(struct a
 	 * Several controllers, notably from NEC and VIA, forget to
 	 * write ack_complete status at PHY packet reception.
 	 */
-	if (evt == OHCI1394_evt_no_status &&
+	if (unlikely(evt == OHCI1394_evt_no_status) &&
 	    (p.header[0] & 0xff) == (OHCI1394_phy_tcode << 4))
 		p.ack = ACK_COMPLETE;
 
@@ -714,7 +720,7 @@ static __le32 *handle_ar_packet(struct a
 	 * wrong generation.  We set the correct generation for these
 	 * at a slightly incorrect time (in bus_reset_tasklet).
 	 */
-	if (evt == OHCI1394_evt_bus_reset) {
+	if (unlikely(evt == OHCI1394_evt_bus_reset)) {
 		if (!(ohci->quirks & QUIRK_RESET_PACKET))
 			ohci->request_generation = (p.header[2] >> 16) & 0xff;
 	} else if (ctx == &ohci->ar_request_ctx) {

-- 
Stefan Richter
-=====-==-=- =--- ===--
http://arcgraph.de/sr/

