Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752185Ab1GTOah (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 10:30:37 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:39866 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751659Ab1GTOab (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 10:30:31 -0400
From: <pavan_savoy@ti.com>
To: <greg@kroah.com>, <linux-kernel@vger.kernel.org>
CC: pavan_savoy@sify.com, Vijay Badawadagi <bvijay@ti.com>,
        Pavan Savoy <pavan_savoy@ti.com>
Subject: [PATCH 4/4] drivers:misc: ti-st: fail-safe on wrong pkt type
Date: Wed, 20 Jul 2011 09:30:20 -0500
Message-ID: <1311172225-17678-5-git-send-email-pavan_savoy@ti.com>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1311172225-17678-4-git-send-email-pavan_savoy@ti.com>
References: <1311172225-17678-1-git-send-email-pavan_savoy@ti.com>
 <1311172225-17678-2-git-send-email-pavan_savoy@ti.com>
 <1311172225-17678-3-git-send-email-pavan_savoy@ti.com>
 <1311172225-17678-4-git-send-email-pavan_savoy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vijay Badawadagi <bvijay@ti.com>

Texas Instrument's shared transport driver interpret incoming data from the
UART based on the various protocol drivers registered to the driver such as
btwilink driver or FM or GPS driver which provide logical channel IDs.

In case of bad-behavior from chip such as HCI Event response for a GPS command
or a HCI Event (h/w error event) for a FM response & In case of bad-behavior
from UART driver such as dropping data bytes a fail-safe is required to avoid
kernel panic.

Signed-off-by: Pavan Savoy <pavan_savoy@ti.com>
Signed-off-by: Vijay Badawadagi <bvijay@ti.com>
---
 drivers/misc/ti-st/st_core.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/misc/ti-st/st_core.c b/drivers/misc/ti-st/st_core.c
index c8e335d..1f973ce 100644
--- a/drivers/misc/ti-st/st_core.c
+++ b/drivers/misc/ti-st/st_core.c
@@ -338,6 +338,12 @@ void st_int_recv(void *disc_data,
 			/* Unknow packet? */
 		default:
 			type = *ptr;
+			if (st_gdata->list[type] == NULL) {
+				pr_err("chip/interface misbehavior dropping"
+					" frame starting with 0x%02x", type);
+				goto done;
+
+			}
 			st_gdata->rx_skb = alloc_skb(
 					st_gdata->list[type]->max_frame_size,
 					GFP_ATOMIC);
@@ -354,6 +360,7 @@ void st_int_recv(void *disc_data,
 		ptr++;
 		count--;
 	}
+done:
 	spin_unlock_irqrestore(&st_gdata->lock, flags);
 	pr_debug("done %s", __func__);
 	return;
-- 
1.7.4.1

