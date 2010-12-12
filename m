Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754162Ab0LMA3S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 19:29:18 -0500
Received: from one.firstfloor.org ([213.235.205.2]:44703 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753886Ab0LLXp0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:45:26 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: tilman@imap.cc, davem@davemloft.net, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [29/223] isdn/gigaset: bas_gigaset locking fix
Message-Id: <20101212234525.6579EB27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:45:25 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Tilman Schmidt <tilman@imap.cc>

commit b33ffa5cbf52ee751bb8068218ebb3c742c5a515 upstream.

Unlock cs->lock before calling error_hangup() which is marked
"cs->lock must not be held".

Signed-off-by: Tilman Schmidt <tilman@imap.cc>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/isdn/gigaset/bas-gigaset.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: linux/drivers/isdn/gigaset/bas-gigaset.c
===================================================================
--- linux.orig/drivers/isdn/gigaset/bas-gigaset.c
+++ linux/drivers/isdn/gigaset/bas-gigaset.c
@@ -1599,13 +1599,13 @@ static int gigaset_init_bchannel(struct
 
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
 
@@ -1615,11 +1615,11 @@ static int gigaset_init_bchannel(struct
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
 
