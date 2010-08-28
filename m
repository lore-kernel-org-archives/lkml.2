Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753200Ab0H1MVp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Aug 2010 08:21:45 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:37737 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753031Ab0H1MVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Aug 2010 08:21:44 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 28 Aug 2010 14:21:26 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] firewire: ohci: work around VIA and NEC PHY packet reception
 bug
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org, Clemens Ladisch <clemens@ladisch.de>
In-Reply-To: <4C6909DD.3070002@ladisch.de>
Message-ID: <tkrat.8705132a95f3f284@s5r6.in-berlin.de>
References: <4C6909DD.3070002@ladisch.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

VIA VT6306, VIA VT6308, and NEC OrangeLink controllers do not write
packet event codes for received PHY packets (or perhaps write
evt_no_status, hard to tell).  Work around it by overwriting the
packet's ACK by ack_complete, so that upper layers that listen to PHY
packet reception get to see these packets.

(Also tested:  TI TSB82AA2, TI TSB43AB22/A, TI XIO2213A, Agere FW643,
JMicron JMB381 --- these do not exhibit this bug.)

Clemens proposed a quirks flag for that, IOW whitelist known misbehaving
controllers for this workaround.  Though to me it seems harmless enough
to enable for all controllers.

The log_ar_at_event() debug log will continue to show the original
status from the DMA unit.

Reported-by: Clemens Ladisch <clemens@ladisch.de> (VT6308)
Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/ohci.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

Index: b/drivers/firewire/ohci.c
===================================================================
--- a/drivers/firewire/ohci.c
+++ b/drivers/firewire/ohci.c
@@ -694,7 +694,15 @@ static __le32 *handle_ar_packet(struct a
 	log_ar_at_event('R', p.speed, p.header, evt);
 
 	/*
-	 * The OHCI bus reset handler synthesizes a phy packet with
+	 * Several controllers, notably from NEC and VIA, forget to
+	 * write ack_complete status at PHY packet reception.
+	 */
+	if (evt == OHCI1394_evt_no_status &&
+	    (p.header[0] & 0xff) == (OHCI1394_phy_tcode << 4))
+		p.ack = ACK_COMPLETE;
+
+	/*
+	 * The OHCI bus reset handler synthesizes a PHY packet with
 	 * the new generation number when a bus reset happens (see
 	 * section 8.4.2.3).  This helps us determine when a request
 	 * was received and make sure we send the response in the same

-- 
Stefan Richter
-=====-==-=- =--- ===--
http://arcgraph.de/sr/

