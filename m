Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753952Ab1KQGhx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 01:37:53 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:54139 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751986Ab1KQGhw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 01:37:52 -0500
From: Tomoya MORINAGA <tomoya.rohm@gmail.com>
To: Grant Likely <grant.likely@secretlab.ca>,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Cc: qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, Tomoya MORINAGA <tomoya.rohm@gmail.com>
Subject: [PATCH] spi-topcliff-pch: Fix count calculation issue
Date: Thu, 17 Nov 2011 15:37:21 +0900
Message-Id: <1321511841-12824-1-git-send-email-tomoya.rohm@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, count value is not correct more than len=8193 like below.

len	Current-cnt	New-cnt		Anticipated-cnt
4095	1		1		1
4096	1		1		1
4097	2		2		2

8191	2		2		2
8192	2		2		2
8193	2(NG)		3		3

12287	3		3		3
12288	3		3		3
12289	3(NG)		4		4

This patch fixes the issue.

Signed-off-by: Tomoya MORINAGA <tomoya.rohm@gmail.com>
---
 drivers/spi/spi-topcliff-pch.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/spi/spi-topcliff-pch.c b/drivers/spi/spi-topcliff-pch.c
index 9fb0541..08b5f31 100644
--- a/drivers/spi/spi-topcliff-pch.c
+++ b/drivers/spi/spi-topcliff-pch.c
@@ -1247,7 +1247,9 @@ static void pch_spi_process_messages(struct work_struct *pwork)
 		}
 		spin_unlock(&data->lock);
 
-		cnt = data->cur_trans->len / (PCH_BUF_SIZE + 1) + 1;
+		if (!data->cur_trans->len)
+			goto out;
+		cnt = (data->cur_trans->len - 1) / PCH_BUF_SIZE + 1;
 		data->save_total_len = data->cur_trans->len;
 		if (data->use_dma) {
 			int i;
-- 
1.7.4.4

