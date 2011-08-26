Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755239Ab1HZUea (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 16:34:30 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37038 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755088Ab1HZUe0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 16:34:26 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Vijay Badawadagi <bvijay@ti.com>, Pavan Savoy <pavan_savoy@ti.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 09/13] drivers:misc: ti-st: fail-safe on wrong pkt type
Date: Fri, 26 Aug 2011 13:33:50 -0700
Message-Id: <1314390834-3411-9-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.6.1
In-Reply-To: <1314390834-3411-1-git-send-email-gregkh@suse.de>
References: <20110826191130.GA5557@kroah.com>
 <1314390834-3411-1-git-send-email-gregkh@suse.de>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
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
1.7.6.1

