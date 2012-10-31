Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933860Ab2JaKsL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 06:48:11 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:37677 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752283Ab2JaKsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 06:48:08 -0400
From: Xiaotian Feng <xtfeng@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Xiaotian Feng <xtfeng@gmail.com>, Xiaotian Feng <dannyfeng@tencent.com>,
        Ben Dooks <ben-linux@fluff.org>, Chris Ball <cjb@laptop.org>,
        linux-arm-kernel@lists.infradead.org, linux-mmc@vger.kernel.org
Subject: [PATCH] mmc: s3cmci: use tasklet_kill in device remove/release process
Date: Wed, 31 Oct 2012 18:48:45 +0800
Message-Id: <1351680525-27253-1-git-send-email-xtfeng@gmail.com>
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
Cc: Ben Dooks <ben-linux@fluff.org>
Cc: Chris Ball <cjb@laptop.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-mmc@vger.kernel.org
---
 drivers/mmc/host/s3cmci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mmc/host/s3cmci.c b/drivers/mmc/host/s3cmci.c
index 4638dda..d70d0cc 100644
--- a/drivers/mmc/host/s3cmci.c
+++ b/drivers/mmc/host/s3cmci.c
@@ -1830,7 +1830,7 @@ static int __devexit s3cmci_remove(struct platform_device *pdev)
 
 	clk_put(host->clk);
 
-	tasklet_disable(&host->pio_tasklet);
+	tasklet_kill(&host->pio_tasklet);
 
 	if (s3cmci_host_usedma(host))
 		s3c2410_dma_free(host->dma, &s3cmci_dma_client);
-- 
1.7.9.5

