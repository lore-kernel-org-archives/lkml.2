Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755974Ab2F0JHD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 05:07:03 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:34857 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754598Ab2F0JHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 05:07:00 -0400
Date: Wed, 27 Jun 2012 12:06:44 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Jose Alberto Reguero <jareguero@telefonica.net>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [patch -resend] [media] az6007: precedence bug in az6007_i2c_xfer()
Message-ID: <20120627090644.GP31212@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120627085800.GA3007@mwanda>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The intent here was to test that the flag was clear but the '!' has
higher precedence than the '&'.  I2C_M_RD is 0x1 so the current code is
equivalent to "&& (!sgs[i].flags) ..."

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
I sent this originally on Wed, 25 Jan 2012 and Emil Goode sent the same
fix on Thu, May 3, 2012.

diff --git a/drivers/media/dvb/dvb-usb/az6007.c b/drivers/media/dvb/dvb-usb/az6007.c
index 4008b9c..f6f0cf9 100644
--- a/drivers/media/dvb/dvb-usb/az6007.c
+++ b/drivers/media/dvb/dvb-usb/az6007.c
@@ -711,7 +711,7 @@ static int az6007_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msgs[],
 		addr = msgs[i].addr << 1;
 		if (((i + 1) < num)
 		    && (msgs[i].len == 1)
-		    && (!msgs[i].flags & I2C_M_RD)
+		    && (!(msgs[i].flags & I2C_M_RD))
 		    && (msgs[i + 1].flags & I2C_M_RD)
 		    && (msgs[i].addr == msgs[i + 1].addr)) {
 			/*
