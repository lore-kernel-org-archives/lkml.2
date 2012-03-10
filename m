Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753868Ab2CJI5u (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2012 03:57:50 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:16997 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752704Ab2CJI5q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2012 03:57:46 -0500
Date: Sat, 10 Mar 2012 11:57:29 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [patch] spi: release lock on error path in spi_pump_messages()
Message-ID: <20120310085729.GB4647@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090208.4F5B1783.005D,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We should release the lock here and enable IRQs before returning.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index 5ae1e84..ab1bdce 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -535,6 +535,7 @@ static void spi_pump_messages(struct kthread_work *work)
 			if (ret) {
 				dev_err(&master->dev,
 					"failed to unprepare transfer hardware\n");
+				spin_unlock_irqrestore(&master->queue_lock, flags);
 				return;
 			}
 		}
