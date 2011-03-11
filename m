Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755051Ab1CKUnU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 15:43:20 -0500
Received: from kroah.org ([198.145.64.141]:46615 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754909Ab1CKUnN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 15:43:13 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Mar 11 12:41:10 2011
Message-Id: <20110311204110.858185108@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 11 Mar 2011 12:40:16 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ivan Vecera <ivecera@redhat.com>,
        Francois Romieu <romieu@fr.zoreil.com>, Hayes <hayeswang@realtek.com>
Subject: [15/17] r8169: use RxFIFO overflow workaround for 8168c chipset.
In-Reply-To: <20110311204126.GA7223@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Ivan Vecera <ivecera@redhat.com>

commit b5ba6d12bdac21bc0620a5089e0f24e362645efd upstream.

I found that one of the 8168c chipsets (concretely XID 1c4000c0) starts
generating RxFIFO overflow errors. The result is an infinite loop in
interrupt handler as the RxFIFOOver is handled only for ...MAC_VER_11.
With the workaround everything goes fine.

Signed-off-by: Ivan Vecera <ivecera@redhat.com>
Acked-by: Francois Romieu <romieu@fr.zoreil.com>
Cc: Hayes <hayeswang@realtek.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/r8169.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/net/r8169.c
+++ b/drivers/net/r8169.c
@@ -3741,7 +3741,8 @@ static void rtl_hw_start_8168(struct net
 	RTL_W16(IntrMitigate, 0x5151);
 
 	/* Work around for RxFIFO overflow. */
-	if (tp->mac_version == RTL_GIGA_MAC_VER_11) {
+	if (tp->mac_version == RTL_GIGA_MAC_VER_11 ||
+	    tp->mac_version == RTL_GIGA_MAC_VER_22) {
 		tp->intr_event |= RxFIFOOver | PCSTimeout;
 		tp->intr_event &= ~RxOverflow;
 	}
@@ -4633,7 +4634,8 @@ static irqreturn_t rtl8169_interrupt(int
 
 		/* Work around for rx fifo overflow */
 		if (unlikely(status & RxFIFOOver) &&
-		(tp->mac_version == RTL_GIGA_MAC_VER_11)) {
+		    (tp->mac_version == RTL_GIGA_MAC_VER_11 ||
+		     tp->mac_version == RTL_GIGA_MAC_VER_22)) {
 			netif_stop_queue(dev);
 			rtl8169_tx_timeout(dev);
 			break;


