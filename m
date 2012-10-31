Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756928Ab2JaKwT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 06:52:19 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:45747 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752894Ab2JaKwR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 06:52:17 -0400
From: Xiaotian Feng <xtfeng@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Xiaotian Feng <xtfeng@gmail.com>, Xiaotian Feng <dannyfeng@tencent.com>,
        Matt Porter <mporter@kernel.crashing.org>,
        Alexandre Bounine <alexandre.bounine@idt.com>
Subject: [PATCH] rapidio/tsi721: use tasklet_kill in device remove/release process
Date: Wed, 31 Oct 2012 18:52:49 +0800
Message-Id: <1351680769-27306-1-git-send-email-xtfeng@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some driver uses tasklet_disable in device remove/release process,
tasklet_disable will inc tasklet->count and return. If the tasklet
is not handled yet under some softirq pressure, the tasklet will be
placed on the tasklet_vec, never have a chance to be excuted. This might
lead to a heavy loaded ksoftirqd, wakeup with pending_softirq, but
tasklet is disabled. tasklet_kill should be used in this case.

Signed-off-by: Xiaotian Feng <dannyfeng@tencent.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Andrew Morton <akpm@linux-foundation.org> 
---
 drivers/rapidio/devices/tsi721_dma.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/rapidio/devices/tsi721_dma.c b/drivers/rapidio/devices/tsi721_dma.c
index 92e06a5..a098fbc 100644
--- a/drivers/rapidio/devices/tsi721_dma.c
+++ b/drivers/rapidio/devices/tsi721_dma.c
@@ -589,7 +589,7 @@ static void tsi721_free_chan_resources(struct dma_chan *dchan)
 	BUG_ON(!list_empty(&bdma_chan->active_list));
 	BUG_ON(!list_empty(&bdma_chan->queue));
 
-	tasklet_disable(&bdma_chan->tasklet);
+	tasklet_kill(&bdma_chan->tasklet);
 
 	spin_lock_bh(&bdma_chan->lock);
 	list_splice_init(&bdma_chan->free_list, &list);
-- 
1.7.9.5

