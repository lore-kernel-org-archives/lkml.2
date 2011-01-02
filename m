Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753503Ab1ABIBl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 03:01:41 -0500
Received: from mail.windriver.com ([147.11.1.11]:35030 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753364Ab1ABHWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:22:47 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Christian Lamparter <chunkeey@googlemail.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 075/260] p54: fix tx feedback status flag check
Date: Sun,  2 Jan 2011 02:16:11 -0500
Message-Id: <1293952756-15010-76-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:21:29.0742 (UTC) FILETIME=[ACBC5AE0:01CBAA4D]
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
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/net/wireless/p54/txrx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/p54/txrx.c b/drivers/net/wireless/p54/txrx.c
index 6605799..7398c98 100644
--- a/drivers/net/wireless/p54/txrx.c
+++ b/drivers/net/wireless/p54/txrx.c
@@ -445,7 +445,7 @@ static void p54_rx_frame_sent(struct p54_common *priv, struct sk_buff *skb)
 	}
 
 	if (!(info->flags & IEEE80211_TX_CTL_NO_ACK) &&
-	     (!payload->status))
+	     !(payload->status & P54_TX_FAILED))
 		info->flags |= IEEE80211_TX_STAT_ACK;
 	if (payload->status & P54_TX_PSM_CANCELLED)
 		info->flags |= IEEE80211_TX_STAT_TX_FILTERED;
-- 
1.7.3.3

