Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760567Ab1CEBAy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 20:00:54 -0500
Received: from kroah.org ([198.145.64.141]:50449 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760357Ab1CEBAw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 20:00:52 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Mar  4 16:56:40 2011
Message-Id: <20110305005640.341495313@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Fri, 04 Mar 2011 16:56:04 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Matt Carlson <mcarlson@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [59/73] tg3: Restrict phy ioctl access
In-Reply-To: <20110305005720.GA16162@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Matt Carlson <mcarlson@broadcom.com>

commit ed199facd070f8e551dc16a2ae1baa01d8d28ed4 upstream.

If management firmware is present and the device is down, the firmware
will assume control of the phy.  If a phy access were allowed from the
host, it will collide with firmware phy accesses, resulting in
unpredictable behavior.  This patch fixes the problem by disallowing phy
accesses during the problematic condition.

Signed-off-by: Matt Carlson <mcarlson@broadcom.com>
Reviewed-by: Michael Chan <mchan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/tg3.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/net/tg3.c
+++ b/drivers/net/tg3.c
@@ -11165,7 +11165,9 @@ static int tg3_ioctl(struct net_device *
 		if (tp->phy_flags & TG3_PHYFLG_PHY_SERDES)
 			break;			/* We have no PHY */
 
-		if (tp->phy_flags & TG3_PHYFLG_IS_LOW_POWER)
+		if ((tp->phy_flags & TG3_PHYFLG_IS_LOW_POWER) ||
+		    ((tp->tg3_flags & TG3_FLAG_ENABLE_ASF) &&
+		     !netif_running(dev)))
 			return -EAGAIN;
 
 		spin_lock_bh(&tp->lock);
@@ -11181,7 +11183,9 @@ static int tg3_ioctl(struct net_device *
 		if (tp->phy_flags & TG3_PHYFLG_PHY_SERDES)
 			break;			/* We have no PHY */
 
-		if (tp->phy_flags & TG3_PHYFLG_IS_LOW_POWER)
+		if ((tp->phy_flags & TG3_PHYFLG_IS_LOW_POWER) ||
+		    ((tp->tg3_flags & TG3_FLAG_ENABLE_ASF) &&
+		     !netif_running(dev)))
 			return -EAGAIN;
 
 		spin_lock_bh(&tp->lock);


