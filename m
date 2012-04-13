Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757295Ab2DMNj1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 09:39:27 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:20307 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755088Ab2DMNjZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 09:39:25 -0400
Date: Fri, 13 Apr 2012 16:39:06 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: Markus Franke <franm@hrz.tu-chemnitz.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] w1: w1_ds28e04: unlock on error path in w1_f1C_write_pio()
Message-ID: <20120413133906.GB26645@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090202.4F882C85.00E8,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We should unlock here before returning.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/w1/slaves/w1_ds28e04.c b/drivers/w1/slaves/w1_ds28e04.c
index f652db3..4aa1aa9 100644
--- a/drivers/w1/slaves/w1_ds28e04.c
+++ b/drivers/w1/slaves/w1_ds28e04.c
@@ -309,8 +309,10 @@ static ssize_t w1_f1C_write_pio(struct file *filp, struct kobject *kobj,
 	mutex_lock(&sl->master->mutex);
 
 	/* Write the PIO data */
-	if (w1_reset_select_slave(sl))
+	if (w1_reset_select_slave(sl)) {
+		mutex_unlock(&sl->master->mutex);
 		return -1;
+	}
 
 	/* set bit 7..2 to value '1' */
 	*buf = *buf | 0xFC;
