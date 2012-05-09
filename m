Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758046Ab2EIGQz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 02:16:55 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39117 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756594Ab2EIFx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 01:53:29 -0400
Message-Id: <20120509055049.873944883@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 09 May 2012 06:52:56 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Grazvydas Ignotas <notasas@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 147/167] [PATCH] wl1251: fix crash on remove due to leftover work item
In-Reply-To: <20120509055029.588587017@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Grazvydas Ignotas <notasas@gmail.com>

commit 4c1bcdb5a3354b250b82a67549f57ac27a3bb85f upstream.

This driver currently leaves elp_work behind when stopping, which
occasionally results in data corruption because work function ends
up accessing freed memory, typical symptoms of this are various
worker_thread crashes. Fix it by cancelling elp_work.

Signed-off-by: Grazvydas Ignotas <notasas@gmail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/wireless/wl1251/main.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/wl1251/main.c b/drivers/net/wireless/wl1251/main.c
index 41302c7..d1afb8e 100644
--- a/drivers/net/wireless/wl1251/main.c
+++ b/drivers/net/wireless/wl1251/main.c
@@ -479,6 +479,7 @@ static void wl1251_op_stop(struct ieee80211_hw *hw)
 	cancel_work_sync(&wl->irq_work);
 	cancel_work_sync(&wl->tx_work);
 	cancel_work_sync(&wl->filter_work);
+	cancel_delayed_work_sync(&wl->elp_work);
 
 	mutex_lock(&wl->mutex);
 
-- 
1.7.10



