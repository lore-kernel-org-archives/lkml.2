Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758394Ab2CBPKC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 10:10:02 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:46667 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752215Ab2CBPKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 10:10:00 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of santoshprasadnayak@gmail.com designates 10.68.232.103 as permitted sender) smtp.mail=santoshprasadnayak@gmail.com; dkim=pass header.i=santoshprasadnayak@gmail.com
From: santosh nayak <santoshprasadnayak@gmail.com>
To: jitendra.kalsaria@qlogic.com
Cc: ron.mercer@qlogic.com, linux-driver@qlogic.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Santosh Nayak <santoshprasadnayak@gmail.com>
Subject: [PATCH 1/3] qla3xxx: ethernet: Fix bogus interrupt state flag.
Date: Fri,  2 Mar 2012 20:39:05 +0530
Message-Id: <1330700945-18195-1-git-send-email-santoshprasadnayak@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Santosh Nayak <santoshprasadnayak@gmail.com>

In 'ql_adapter_initialize'
the first call for 'spin_unlock_irqrestore()' is with hw_flags = 0,
which is as good as 'spin_unlock_irq()' (unconditional interrupt
enabling). If this is intended, then for better performance
'spin_unlock_irqrestore()' can be replaced with 'spin_unlock_irq()'
and 'spin_lock_irqsave()' can be replaced by 'spin_lock_irq()

Signed-off-by: Santosh Nayak <santoshprasadnayak@gmail.com>
---
 drivers/net/ethernet/qlogic/qla3xxx.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qla3xxx.c b/drivers/net/ethernet/qlogic/qla3xxx.c
index d49f6da..8da3e41 100644
--- a/drivers/net/ethernet/qlogic/qla3xxx.c
+++ b/drivers/net/ethernet/qlogic/qla3xxx.c
@@ -3017,7 +3017,6 @@ static int ql_adapter_initialize(struct ql3_adapter *qdev)
 		(void __iomem *)port_regs;
 	u32 delay = 10;
 	int status = 0;
-	unsigned long hw_flags = 0;
 
 	if (ql_mii_setup(qdev))
 		return -1;
@@ -3228,9 +3227,9 @@ static int ql_adapter_initialize(struct ql3_adapter *qdev)
 		value = ql_read_page0_reg(qdev, &port_regs->portStatus);
 		if (value & PORT_STATUS_IC)
 			break;
-		spin_unlock_irqrestore(&qdev->hw_lock, hw_flags);
+		spin_unlock_irq(&qdev->hw_lock);
 		msleep(500);
-		spin_lock_irqsave(&qdev->hw_lock, hw_flags);
+		spin_lock_irq(&qdev->hw_lock);
 	} while (--delay);
 
 	if (delay == 0) {
-- 
1.7.4.4

