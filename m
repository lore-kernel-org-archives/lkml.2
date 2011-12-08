Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752138Ab1LHTYZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 14:24:25 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:64199 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750817Ab1LHTYX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 14:24:23 -0500
Date: Thu, 8 Dec 2011 22:24:02 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Sjur =?utf-8?B?QnLvv71uZGVsYW5k?= 
	<sjur.brandeland@stericsson.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch -next] xshm: calling unlock improperly in xshmchr_chrpoll()
Message-ID: <20111208192402.GA8810@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4EE10EE3.013A,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We got interrupted before we could take the lock here, and so we
shouldn't call unlock.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/xshm/xshm_chr.c b/drivers/xshm/xshm_chr.c
index 8593367..4df1287 100644
--- a/drivers/xshm/xshm_chr.c
+++ b/drivers/xshm/xshm_chr.c
@@ -620,7 +620,7 @@ static unsigned int xshmchr_chrpoll(struct file *filp, poll_table *waittab)
 	if (mutex_lock_interruptible(&dev->mutex)) {
 		xdev_dbg(dev, "mutex_lock_interruptible got signalled\n");
 		mask |= POLLERR;
-		goto out;
+		goto out_unlocked;
 	}
 	xshmchr_get(dev);
 
@@ -644,6 +644,7 @@ static unsigned int xshmchr_chrpoll(struct file *filp, poll_table *waittab)
 
 out:
 	mutex_unlock(&dev->mutex);
+out_unlocked:
 	xdev_devl(dev, "poll return mask=0x%04x\n", mask);
 	xshmchr_put(dev);
 	return mask;
