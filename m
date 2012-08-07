Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757393Ab2HGWjS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 18:39:18 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56801 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030573Ab2HGWjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 18:39:06 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Michael Chan <mchan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 056/109] tg3: Fix race condition in tg3_get_stats64()
Date: Tue,  7 Aug 2012 15:35:15 -0700
Message-Id: <20120807222047.999705354@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120807222043.089735600@linuxfoundation.org>
References: <20120807222043.089735600@linuxfoundation.org>
User-Agent: quilt/0.60-20.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Chan <mchan@broadcom.com>

commit 0f566b208b41918053b2e67399673aaec02dde5d upstream.

Spinlock should be taken before checking for tp->hw_stats.

Signed-off-by: Michael Chan <mchan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/broadcom/tg3.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -12255,10 +12255,12 @@ static struct rtnl_link_stats64 *tg3_get
 {
 	struct tg3 *tp = netdev_priv(dev);
 
-	if (!tp->hw_stats)
+	spin_lock_bh(&tp->lock);
+	if (!tp->hw_stats) {
+		spin_unlock_bh(&tp->lock);
 		return &tp->net_stats_prev;
+	}
 
-	spin_lock_bh(&tp->lock);
 	tg3_get_nstats(tp, stats);
 	spin_unlock_bh(&tp->lock);
 


