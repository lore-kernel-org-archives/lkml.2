Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753415Ab1ABICU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 03:02:20 -0500
Received: from mail.windriver.com ([147.11.1.11]:34980 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753205Ab1ABHWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:22:43 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, "John W. Linville" <linville@tuxdriver.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 076/260] ath5k: check return value of ieee80211_get_tx_rate
Date: Sun,  2 Jan 2011 02:16:12 -0500
Message-Id: <1293952756-15010-77-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:21:30.0664 (UTC) FILETIME=[AD490A80:01CBAA4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: John W. Linville <linville@tuxdriver.com>

commit d8e1ba76d619dbc0be8fbeee4e6c683b5c812d3a upstream.

This avoids a NULL pointer dereference as reported here:

	https://bugzilla.redhat.com/show_bug.cgi?id=625889

When the WARN condition is hit in ieee80211_get_tx_rate, it will return
NULL.  So, we need to check the return value and avoid dereferencing it
in that case.

Signed-off-by: John W. Linville <linville@tuxdriver.com>
Acked-by: Bob Copeland <me@bobcopeland.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/net/wireless/ath/ath5k/base.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index db84169..61023e9 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -1316,6 +1316,10 @@ ath5k_txbuf_setup(struct ath5k_softc *sc, struct ath5k_buf *bf,
 			PCI_DMA_TODEVICE);
 
 	rate = ieee80211_get_tx_rate(sc->hw, info);
+	if (!rate) {
+		ret = -EINVAL;
+		goto err_unmap;
+	}
 
 	if (info->flags & IEEE80211_TX_CTL_NO_ACK)
 		flags |= AR5K_TXDESC_NOACK;
-- 
1.7.3.3

