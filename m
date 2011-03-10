Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754419Ab1CJX5g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 18:57:36 -0500
Received: from kroah.org ([198.145.64.141]:46907 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754601Ab1CJX5a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 18:57:30 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Thu Mar 10 15:55:38 2011
Message-Id: <20110310235538.248787999@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 10 Mar 2011 15:54:28 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Francois Romieu <romieu@fr.zoreil.com>,
        Ivan Vecera <ivecera@redhat.com>, Hayes <hayeswang@realtek.com>
Subject: [patch 22/29] r8169: RxFIFO overflow oddities with 8168 chipsets.
In-Reply-To: <20110310235548.GA10103@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Francois Romieu <romieu@fr.zoreil.com>

commit 1519e57fe81c14bb8fa4855579f19264d1ef63b4 upstream.

Some experiment-based action to prevent my 8168 chipsets locking-up hard
in the irq handler under load (pktgen ~1Mpps). Apparently a reset is not
always mandatory (is it at all ?).

- RTL_GIGA_MAC_VER_12
- RTL_GIGA_MAC_VER_25
  Missed ~55% packets. Note:
  - this is an old SiS 965L motherboard
  - the 8168 chipset emits (lots of) control frames towards the sender

- RTL_GIGA_MAC_VER_26
  The chipset does not go into a frenzy of mac control pause when it
  crashes yet but it can still be crashed. It needs more work.

Signed-off-by: Francois Romieu <romieu@fr.zoreil.com>
Cc: Ivan Vecera <ivecera@redhat.com>
Cc: Hayes <hayeswang@realtek.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/r8169.c |   30 +++++++++++++++++++++---------
 1 file changed, 21 insertions(+), 9 deletions(-)

--- a/drivers/net/r8169.c
+++ b/drivers/net/r8169.c
@@ -758,7 +758,8 @@ static void __rtl8169_check_link_status(
 		if (pm)
 			pm_request_resume(&tp->pci_dev->dev);
 		netif_carrier_on(dev);
-		netif_info(tp, ifup, dev, "link up\n");
+		if (net_ratelimit())
+			netif_info(tp, ifup, dev, "link up\n");
 	} else {
 		netif_carrier_off(dev);
 		netif_info(tp, ifdown, dev, "link down\n");
@@ -4603,13 +4604,24 @@ static irqreturn_t rtl8169_interrupt(int
 			break;
 		}
 
-		/* Work around for rx fifo overflow */
-		if (unlikely(status & RxFIFOOver) &&
-		    (tp->mac_version == RTL_GIGA_MAC_VER_11 ||
-		     tp->mac_version == RTL_GIGA_MAC_VER_22)) {
-			netif_stop_queue(dev);
-			rtl8169_tx_timeout(dev);
-			break;
+		if (unlikely(status & RxFIFOOver)) {
+			switch (tp->mac_version) {
+			/* Work around for rx fifo overflow */
+			case RTL_GIGA_MAC_VER_11:
+			case RTL_GIGA_MAC_VER_22:
+			case RTL_GIGA_MAC_VER_26:
+				netif_stop_queue(dev);
+				rtl8169_tx_timeout(dev);
+				goto done;
+			/* Experimental science. Pktgen proof. */
+			case RTL_GIGA_MAC_VER_12:
+			case RTL_GIGA_MAC_VER_25:
+				if (status == RxFIFOOver)
+					goto done;
+				break;
+			default:
+				break;
+			}
 		}
 
 		if (unlikely(status & SYSErr)) {
@@ -4645,7 +4657,7 @@ static irqreturn_t rtl8169_interrupt(int
 			(status & RxFIFOOver) ? (status | RxOverflow) : status);
 		status = RTL_R16(IntrStatus);
 	}
-
+done:
 	return IRQ_RETVAL(handled);
 }
 


