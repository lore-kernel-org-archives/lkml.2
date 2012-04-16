Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755363Ab2DPTYx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 15:24:53 -0400
Received: from masquerade.micron.com ([137.201.242.130]:42742 "EHLO
	masquerade.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754196Ab2DPTYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 15:24:51 -0400
Message-ID: <4F8C71FD.70204@micron.com>
Date: Mon, 16 Apr 2012 12:24:45 -0700
From: Asai Thambi S P <asamymuthupa@micron.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
CC: Dan Carpenter <dan.carpenter@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sam Bradshaw <sbradshaw@micron.com>
Subject: [PATCH] mtip32xx: release the semaphore on an error path
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-TM-AS-Product-Ver: SMEX-10.0.0.4152-6.800.1017-18844.001
X-TM-AS-Result: No--7.201000-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-MT-CheckInternalSenderRule: True
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Release the semaphore in an error path in mtip_hw_get_scatterlist(). This
fixes the smatch warning inconsistent returns.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Asai Thambi S P <asamymuthupa@micron.com>
---
 drivers/block/mtip32xx/mtip32xx.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/block/mtip32xx/mtip32xx.c b/drivers/block/mtip32xx/mtip32xx.c
index 00f9fc9..304000c 100644
--- a/drivers/block/mtip32xx/mtip32xx.c
+++ b/drivers/block/mtip32xx/mtip32xx.c
@@ -2510,8 +2510,10 @@ static struct scatterlist *mtip_hw_get_scatterlist(struct driver_data *dd,
 		up(&dd->port->cmd_slot);
 		return NULL;
 	}
-	if (unlikely(*tag < 0))
+	if (unlikely(*tag < 0)) {
+		up(&dd->port->cmd_slot);
 		return NULL;
+	}
 
 	return dd->port->commands[*tag].sg;
 }
-- 
1.7.1
