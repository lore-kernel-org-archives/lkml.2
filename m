Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933487Ab2KZRKM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:10:12 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47770 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933365Ab2KZRKE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:10:04 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Felipe Balbi <balbi@ti.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 163/270] usb: dwc3: gadget: fix 'endpoint always busy' bug
Date: Mon, 26 Nov 2012 14:57:33 -0200
Message-Id: <1353949160-26803-164-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felipe Balbi <balbi@ti.com>

commit 041d81f493d90c940ec41f0ec98bc7c4f2fba431 upstream.

If a USB transfer has already been started, meaning
we have already issued StartTransfer command to that
particular endpoint, DWC3_EP_BUSY flag has also
already been set.

When we try to cancel this transfer which is already
in controller's cache, we will not receive XferComplete
event and we must clear DWC3_EP_BUSY in order to allow
subsequent requests to be properly started.

The best place to clear that flag is right after issuing
DWC3_DEPCMD_ENDTRANSFER.

Reported-by: Moiz Sonasath <m-sonasath@ti.com>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/usb/dwc3/gadget.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 0b24d9d..c7721db 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -1832,6 +1832,7 @@ static void dwc3_stop_active_transfer(struct dwc3 *dwc, u32 epnum)
 		ret = dwc3_send_gadget_ep_cmd(dwc, dep->number, cmd, &params);
 		WARN_ON_ONCE(ret);
 		dep->res_trans_idx = 0;
+		dep->flags &= ~DWC3_EP_BUSY;
 	}
 }
 
-- 
1.7.9.5

