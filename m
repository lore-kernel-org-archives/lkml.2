Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754776Ab0JAAbA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 20:31:00 -0400
Received: from gimli.pxnet.com ([89.1.7.7]:34819 "EHLO mail.pxnet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754398Ab0JAAa6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 20:30:58 -0400
X-Greylist: delayed 3367 seconds by postgrey-1.27 at vger.kernel.org; Thu, 30 Sep 2010 20:30:56 EDT
From: Tilman Schmidt <tilman@imap.cc>
To: Karsten Keil <isdn@linux-pingi.de>, David Miller <davem@davemloft.net>
CC: Hansjoerg Lipp <hjlipp@web.de>, Karsten Keil <keil@b1-systems.de>,
        i4ldeveloper@listserv.isdn4linux.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <20100930-patch-gigaset-01.tilman@imap.cc>
In-Reply-To: <20100930-patch-gigaset-00.tilman@imap.cc>
References: <20100930-patch-gigaset-00.tilman@imap.cc>
Subject: [PATCH 1/9] isdn/gigaset: bas_gigaset locking fix
Date: Fri,  1 Oct 2010 01:34:30 +0200 (CEST)
X-Spam-Score: -1.983 () AWL,BAYES_00,RDNS_DYNAMIC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unlock cs->lock before calling error_hangup() which is marked
"cs->lock must not be held".

Signed-off-by: Tilman Schmidt <tilman@imap.cc>
CC: stable <stable@kernel.org>
---
 drivers/isdn/gigaset/bas-gigaset.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/isdn/gigaset/bas-gigaset.c b/drivers/isdn/gigaset/bas-gigaset.c
index 707d9c9..e143050 100644
--- a/drivers/isdn/gigaset/bas-gigaset.c
+++ b/drivers/isdn/gigaset/bas-gigaset.c
@@ -1598,13 +1598,13 @@ static int gigaset_init_bchannel(struct bc_state *bcs)
 
 	ret = starturbs(bcs);
 	if (ret < 0) {
+		spin_unlock_irqrestore(&cs->lock, flags);
 		dev_err(cs->dev,
 			"could not start isochronous I/O for channel B%d: %s\n",
 			bcs->channel + 1,
 			ret == -EFAULT ? "null URB" : get_usb_rcmsg(ret));
 		if (ret != -ENODEV)
 			error_hangup(bcs);
-		spin_unlock_irqrestore(&cs->lock, flags);
 		return ret;
 	}
 
@@ -1614,11 +1614,11 @@ static int gigaset_init_bchannel(struct bc_state *bcs)
 		dev_err(cs->dev, "could not open channel B%d\n",
 			bcs->channel + 1);
 		stopurbs(bcs->hw.bas);
-		if (ret != -ENODEV)
-			error_hangup(bcs);
 	}
 
 	spin_unlock_irqrestore(&cs->lock, flags);
+	if (ret < 0 && ret != -ENODEV)
+		error_hangup(bcs);
 	return ret;
 }
 
-- 
1.7.3.15.g442cb

