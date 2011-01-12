Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932668Ab1ALN3x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 08:29:53 -0500
Received: from mail.atmel.fr ([81.80.104.162]:36333 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932419Ab1ALN3O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 08:29:14 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: dan.j.williams@intel.com, linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, hong.xu@atmel.com,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH 6/6] dmaengine: at_hdmac: fix race while monitoring channel status
Date: Wed, 12 Jan 2011 15:39:10 +0100
Message-Id: <1294843150-6962-5-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.3
In-Reply-To: <1292435416-16927-1-git-send-email-nicolas.ferre@atmel.com>
References: <1292435416-16927-1-git-send-email-nicolas.ferre@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We were reading channel status then taking a lock. This lead to a race because
this lock may delay us and then make this channel not idle anymore.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 drivers/dma/at_hdmac.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/at_hdmac.c b/drivers/dma/at_hdmac.c
index 99942a5..3d7d705 100644
--- a/drivers/dma/at_hdmac.c
+++ b/drivers/dma/at_hdmac.c
@@ -853,11 +853,11 @@ static void atc_issue_pending(struct dma_chan *chan)
 
 	dev_vdbg(chan2dev(chan), "issue_pending\n");
 
+	spin_lock_bh(&atchan->lock);
 	if (!atc_chan_is_enabled(atchan)) {
-		spin_lock_bh(&atchan->lock);
 		atc_advance_work(atchan);
-		spin_unlock_bh(&atchan->lock);
 	}
+	spin_unlock_bh(&atchan->lock);
 }
 
 /**
-- 
1.7.3

