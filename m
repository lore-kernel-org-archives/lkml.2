Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756757Ab1HaVap (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 17:30:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58402 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756316Ab1HaVae (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 17:30:34 -0400
From: Mark Salter <msalter@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, ming.lei@canonical.com,
        stern@rowland.harvard.edu, Mark Salter <msalter@redhat.com>
Subject: [PATCH 3/3] add dma_coherent_write_sync calls to USB EHCI driver
Date: Wed, 31 Aug 2011 17:30:14 -0400
Message-Id: <1314826214-22428-4-git-send-email-msalter@redhat.com>
In-Reply-To: <1314826214-22428-1-git-send-email-msalter@redhat.com>
References: <1314826214-22428-1-git-send-email-msalter@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The EHCI driver polls DMA coherent memory for control data written by the
driver. On some architectures, such as ARMv7, the writes from the driver
may get delayed in a write buffer even though it is written to DMA coherent
memory. This delay led to serious performance issues on an ARMv7 based
platform using a USB disk drive. Before using this patch, 'hdparm -t' showed
a read speed of 5.7MB/s. After applying this patch, hdparm showed 23.5MB/s.

Signed-off-by: Mark Salter <msalter@redhat.com>
---
 drivers/usb/host/ehci-q.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/host/ehci-q.c b/drivers/usb/host/ehci-q.c
index 0917e3a..75d9838 100644
--- a/drivers/usb/host/ehci-q.c
+++ b/drivers/usb/host/ehci-q.c
@@ -114,6 +114,7 @@ qh_update (struct ehci_hcd *ehci, struct ehci_qh *qh, struct ehci_qtd *qtd)
 	/* HC must see latest qtd and qh data before we clear ACTIVE+HALT */
 	wmb ();
 	hw->hw_token &= cpu_to_hc32(ehci, QTD_TOGGLE | QTD_STS_PING);
+	dma_coherent_write_sync();
 }
 
 /* if it weren't for a common silicon quirk (writing the dummy into the qh
@@ -404,6 +405,7 @@ qh_completions (struct ehci_hcd *ehci, struct ehci_qh *qh)
 					wmb();
 					hw->hw_token = cpu_to_hc32(ehci,
 							token);
+					dma_coherent_write_sync();
 					goto retry_xacterr;
 				}
 				stopped = 1;
@@ -753,8 +755,10 @@ qh_urb_transaction (
 	}
 
 	/* by default, enable interrupt on urb completion */
-	if (likely (!(urb->transfer_flags & URB_NO_INTERRUPT)))
+	if (likely(!(urb->transfer_flags & URB_NO_INTERRUPT))) {
 		qtd->hw_token |= cpu_to_hc32(ehci, QTD_IOC);
+		dma_coherent_write_sync();
+	}
 	return head;
 
 cleanup:
@@ -1081,6 +1085,7 @@ static struct ehci_qh *qh_append_tds (
 			/* let the hc process these next qtds */
 			wmb ();
 			dummy->hw_token = token;
+			dma_coherent_write_sync();
 
 			urb->hcpriv = qh_get (qh);
 		}
-- 
1.7.6

