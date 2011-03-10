Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754307Ab1CJX6K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 18:58:10 -0500
Received: from kroah.org ([198.145.64.141]:46937 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754237Ab1CJX5f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 18:57:35 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Thu Mar 10 15:55:38 2011
Message-Id: <20110310235538.729623968@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 10 Mar 2011 15:54:33 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Andy Walls <awalls@md.metrocast.net>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [patch 27/29] [media] cx23885: Revert "Check for slave nack on all transactions"
In-Reply-To: <20110310235548.GA10103@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Andy Walls <awalls@md.metrocast.net>

commit 67914b5c400d6c213f9e56d7547a2038ab5c06f4 upstream.

This reverts commit 44835f197bf1e3f57464f23dfb239fef06cf89be.

With the CX23885 hardware I2C master, checking for I2C slave ACK/NAK
is not valid when the I2C_EXTEND or I2C_NOSTOP bits are set.
Revert the commit that checks for I2C slave ACK/NAK on all transactions,
so that XC5000 tuners work with the CX23885 again.

Thanks go to Mark Zimmerman for reporting and bisecting this problem.

Bisected-by: Mark Zimmerman <markzimm@frii.com>

Reported-by: Mark Zimmerman <markzimm@frii.com>
Signed-off-by: Andy Walls <awalls@md.metrocast.net>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/video/cx23885/cx23885-i2c.c |    8 --------
 1 file changed, 8 deletions(-)

--- a/drivers/media/video/cx23885/cx23885-i2c.c
+++ b/drivers/media/video/cx23885/cx23885-i2c.c
@@ -122,10 +122,6 @@ static int i2c_sendbytes(struct i2c_adap
 
 	if (!i2c_wait_done(i2c_adap))
 		goto eio;
-	if (!i2c_slave_did_ack(i2c_adap)) {
-		retval = -ENXIO;
-		goto err;
-	}
 	if (i2c_debug) {
 		printk(" <W %02x %02x", msg->addr << 1, msg->buf[0]);
 		if (!(ctrl & I2C_NOSTOP))
@@ -209,10 +205,6 @@ static int i2c_readbytes(struct i2c_adap
 
 		if (!i2c_wait_done(i2c_adap))
 			goto eio;
-		if (cnt == 0 && !i2c_slave_did_ack(i2c_adap)) {
-			retval = -ENXIO;
-			goto err;
-		}
 		msg->buf[cnt] = cx_read(bus->reg_rdata) & 0xff;
 		if (i2c_debug) {
 			dprintk(1, " %02x", msg->buf[cnt]);


