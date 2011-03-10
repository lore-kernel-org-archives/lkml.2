Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754712Ab1CJX5f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 18:57:35 -0500
Received: from kroah.org ([198.145.64.141]:46903 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754204Ab1CJX53 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 18:57:29 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Thu Mar 10 15:55:38 2011
Message-Id: <20110310235538.137989036@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 10 Mar 2011 15:54:27 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ivan Vecera <ivecera@redhat.com>,
        Francois Romieu <romieu@fr.zoreil.com>, Hayes <hayeswang@realtek.com>
Subject: [patch 21/29] r8169: use RxFIFO overflow workaround for 8168c chipset.
In-Reply-To: <20110310235548.GA10103@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

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
@@ -3725,7 +3725,8 @@ static void rtl_hw_start_8168(struct net
 	RTL_W16(IntrMitigate, 0x5151);
 
 	/* Work around for RxFIFO overflow. */
-	if (tp->mac_version == RTL_GIGA_MAC_VER_11) {
+	if (tp->mac_version == RTL_GIGA_MAC_VER_11 ||
+	    tp->mac_version == RTL_GIGA_MAC_VER_22) {
 		tp->intr_event |= RxFIFOOver | PCSTimeout;
 		tp->intr_event &= ~RxOverflow;
 	}
@@ -4604,7 +4605,8 @@ static irqreturn_t rtl8169_interrupt(int
 
 		/* Work around for rx fifo overflow */
 		if (unlikely(status & RxFIFOOver) &&
-		(tp->mac_version == RTL_GIGA_MAC_VER_11)) {
+		    (tp->mac_version == RTL_GIGA_MAC_VER_11 ||
+		     tp->mac_version == RTL_GIGA_MAC_VER_22)) {
 			netif_stop_queue(dev);
 			rtl8169_tx_timeout(dev);
 			break;


