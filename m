Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756203Ab2E3BnU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 21:43:20 -0400
Received: from masquerade.micron.com ([137.201.242.130]:23066 "EHLO
	masquerade.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756127Ab2E3BnS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 21:43:18 -0400
Message-ID: <4FC57B34.3020405@micron.com>
Date: Tue, 29 May 2012 18:43:16 -0700
From: Asai Thambi S P <asamymuthupa@micron.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sam Bradshaw <sbradshaw@micron.com>
Subject: [PATCH 06/11] mtip32xx: Use plain spinlock for 'cmd_issue_lock'
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-TM-AS-Product-Ver: SMEX-10.0.0.4152-6.800.1017-18936.003
X-TM-AS-Result: No--3.245000-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-MT-CheckInternalSenderRule: True
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


'cmd_issue_lock' is for only acquiring a free slot, and it is not used
in interrupt context. So replaced irq version with non-irq version of spinlock.

Signed-off-by: Asai Thambi S P <asamymuthupa@micron.com>
---
 drivers/block/mtip32xx/mtip32xx.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/block/mtip32xx/mtip32xx.c b/drivers/block/mtip32xx/mtip32xx.c
index 801e70c..a8a5522 100644
--- a/drivers/block/mtip32xx/mtip32xx.c
+++ b/drivers/block/mtip32xx/mtip32xx.c
@@ -294,18 +294,16 @@ static int hba_reset_nosleep(struct driver_data *dd)
  */
 static inline void mtip_issue_ncq_command(struct mtip_port *port, int tag)
 {
-	unsigned long flags = 0;
-
 	atomic_set(&port->commands[tag].active, 1);
 
-	spin_lock_irqsave(&port->cmd_issue_lock, flags);
+	spin_lock(&port->cmd_issue_lock);
 
 	writel((1 << MTIP_TAG_BIT(tag)),
 			port->s_active[MTIP_TAG_INDEX(tag)]);
 	writel((1 << MTIP_TAG_BIT(tag)),
 			port->cmd_issue[MTIP_TAG_INDEX(tag)]);
 
-	spin_unlock_irqrestore(&port->cmd_issue_lock, flags);
+	spin_unlock(&port->cmd_issue_lock);
 
 	/* Set the command's timeout value.*/
 	port->commands[tag].comp_time = jiffies + msecs_to_jiffies(
-- 
1.7.1

