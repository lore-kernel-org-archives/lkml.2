Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965180Ab1C3VcP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:32:15 -0400
Received: from mga14.intel.com ([143.182.124.37]:49299 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964998Ab1C3VIr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:08:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="411278421"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: ivecera@redhat.com, romieu@fr.zoreil.com, ak@linux.intel.com,
        hayeswang@realtek.com, gregkh@suse.de, linux-kernel@vger.kernel.org,
        stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [181/275] r8169: use RxFIFO overflow workaround for 8168c chipset.
Message-Id: <20110330210704.4A8033E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:07:04 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Ivan Vecera <ivecera@redhat.com>

commit b5ba6d12bdac21bc0620a5089e0f24e362645efd upstream.

I found that one of the 8168c chipsets (concretely XID 1c4000c0) starts
generating RxFIFO overflow errors. The result is an infinite loop in
interrupt handler as the RxFIFOOver is handled only for ...MAC_VER_11.
With the workaround everything goes fine.

Signed-off-by: Ivan Vecera <ivecera@redhat.com>
Acked-by: Francois Romieu <romieu@fr.zoreil.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Hayes <hayeswang@realtek.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/r8169.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

Index: linux-2.6.35.y/drivers/net/r8169.c
===================================================================
--- linux-2.6.35.y.orig/drivers/net/r8169.c	2011-03-29 23:03:01.765255002 -0700
+++ linux-2.6.35.y/drivers/net/r8169.c	2011-03-29 23:03:01.995249117 -0700
@@ -3750,7 +3750,8 @@
 	RTL_W16(IntrMitigate, 0x5151);
 
 	/* Work around for RxFIFO overflow. */
-	if (tp->mac_version == RTL_GIGA_MAC_VER_11) {
+	if (tp->mac_version == RTL_GIGA_MAC_VER_11 ||
+	    tp->mac_version == RTL_GIGA_MAC_VER_22) {
 		tp->intr_event |= RxFIFOOver | PCSTimeout;
 		tp->intr_event &= ~RxOverflow;
 	}
@@ -4637,7 +4638,8 @@
 
 		/* Work around for rx fifo overflow */
 		if (unlikely(status & RxFIFOOver) &&
-		(tp->mac_version == RTL_GIGA_MAC_VER_11)) {
+		    (tp->mac_version == RTL_GIGA_MAC_VER_11 ||
+		     tp->mac_version == RTL_GIGA_MAC_VER_22)) {
 			netif_stop_queue(dev);
 			rtl8169_tx_timeout(dev);
 			break;
