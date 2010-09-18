Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757821Ab0IRTut (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:50:49 -0400
Received: from kroah.org ([198.145.64.141]:51444 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755447Ab0IRTBr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:01:47 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 11:59:57 2010
Message-Id: <20100918185957.694900500@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 11:58:21 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Christian Lamparter <chunkeey@googlemail.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [057/123] p54: fix tx feedback status flag check
References: <20100918185724.290702750@clark.site>
Content-Disposition: inline; filename=p54-fix-tx-feedback-status-flag-check.patch
In-Reply-To: <20100918190024.GA14388@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christian Lamparter <chunkeey@googlemail.com>

commit f880c2050f30b23c9b6f80028c09f76e693bf309 upstream.

Michael reported that p54* never really entered power
save mode, even tough it was enabled.

It turned out that upon a power save mode change the
firmware will set a special flag onto the last outgoing
frame tx status (which in this case is almost always the
designated PSM nullfunc frame). This flag confused the
driver; It erroneously reported transmission failures
to the stack, which then generated the next nullfunc.
and so on...

Reported-by: Michael Buesch <mb@bu3sch.de>
Tested-by: Michael Buesch <mb@bu3sch.de>
Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/p54/txrx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/p54/txrx.c
+++ b/drivers/net/wireless/p54/txrx.c
@@ -445,7 +445,7 @@ static void p54_rx_frame_sent(struct p54
 	}
 
 	if (!(info->flags & IEEE80211_TX_CTL_NO_ACK) &&
-	     (!payload->status))
+	     !(payload->status & P54_TX_FAILED))
 		info->flags |= IEEE80211_TX_STAT_ACK;
 	if (payload->status & P54_TX_PSM_CANCELLED)
 		info->flags |= IEEE80211_TX_STAT_TX_FILTERED;


