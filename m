Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753047Ab1KXLrd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 06:47:33 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:62434 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752559Ab1KXLrc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 06:47:32 -0500
Date: Thu, 24 Nov 2011 14:47:02 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Asai Thambi S P <asamymuthupa@micron.com>,
        Sam Bradshaw <sbradshaw@micron.com>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [patch] mtip32xx: uninitialized variable in mtip_quiesce_io()
Message-ID: <20111124114702.GA32522@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090208.4ECE2ECE.001A,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We recently introduce new continue in the loop which make gcc complain.
In theory if MTIP_FLAG_SVC_THD_ACTIVE_BIT is set, we could hit continue
over and over until eventually we time out of the loop.  In that case
"active" should be set as true, but right now it's uninitialized.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/block/mtip32xx/mtip32xx.c b/drivers/block/mtip32xx/mtip32xx.c
index b5d843a..9bc10e3 100644
--- a/drivers/block/mtip32xx/mtip32xx.c
+++ b/drivers/block/mtip32xx/mtip32xx.c
@@ -1026,7 +1026,8 @@ static void mtip_issue_non_ncq_command(struct mtip_port *port, int tag)
 static int mtip_quiesce_io(struct mtip_port *port, unsigned long timeout)
 {
 	unsigned long to;
-	unsigned int n, active;
+	unsigned int n;
+	unsigned int active = 1;
 
 	to = jiffies + msecs_to_jiffies(timeout);
 	do {
