Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932201Ab0LHBua (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:50:30 -0500
Received: from kroah.org ([198.145.64.141]:48649 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932117Ab0LHA74 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 19:59:56 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:27 2010
Message-Id: <20101208005727.632515177@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:57:20 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Tilman Schmidt <tilman@imap.cc>,
        "David S. Miller" <davem@davemloft.net>
Subject: [063/289] isdn/gigaset: bas_gigaset locking fix
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Tilman Schmidt <tilman@imap.cc>

commit b33ffa5cbf52ee751bb8068218ebb3c742c5a515 upstream.

Unlock cs->lock before calling error_hangup() which is marked
"cs->lock must not be held".

Signed-off-by: Tilman Schmidt <tilman@imap.cc>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/isdn/gigaset/bas-gigaset.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/isdn/gigaset/bas-gigaset.c
+++ b/drivers/isdn/gigaset/bas-gigaset.c
@@ -1581,13 +1581,13 @@ static int gigaset_init_bchannel(struct
 
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
 
@@ -1597,11 +1597,11 @@ static int gigaset_init_bchannel(struct
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
 


