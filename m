Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754692Ab1BBQrS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 11:47:18 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:47312 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752959Ab1BBQrP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 11:47:15 -0500
From: Julia Lawall <julia@diku.dk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: kernel-janitors@vger.kernel.org, Torben Hohn <torbenh@gmx.de>,
        Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] drivers/char/bfin_jtag_comm.c: avoid calling put_tty_driver on NULL
Date: Wed,  2 Feb 2011 18:07:30 +0100
Message-Id: <1296666450-15563-1-git-send-email-julia@diku.dk>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

put_tty_driver calls tty_driver_kref_put on its argument, and then
tty_driver_kref_put calls kref_put on the address of a field of this
argument.  kref_put checks for NULL, but in this case the field is likely
to have some offset and so the result of taking its address will not be
NULL.  Labels are added to be able to skip over the call to put_tty_driver
when the argument will be NULL.

The semantic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression *x;
@@

*if (x == NULL)
{ ...
* put_tty_driver(x);
  ...
  return ...;
}
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/char/bfin_jtag_comm.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/char/bfin_jtag_comm.c b/drivers/char/bfin_jtag_comm.c
index 1640244..03c285b 100644
--- a/drivers/char/bfin_jtag_comm.c
+++ b/drivers/char/bfin_jtag_comm.c
@@ -251,11 +251,11 @@ static int __init bfin_jc_init(void)
 	bfin_jc_write_buf.head = bfin_jc_write_buf.tail = 0;
 	bfin_jc_write_buf.buf = kmalloc(CIRC_SIZE, GFP_KERNEL);
 	if (!bfin_jc_write_buf.buf)
-		goto err;
+		goto err_buf;
 
 	bfin_jc_driver = alloc_tty_driver(1);
 	if (!bfin_jc_driver)
-		goto err;
+		goto err_driver;
 
 	bfin_jc_driver->owner        = THIS_MODULE;
 	bfin_jc_driver->driver_name  = DRV_NAME;
@@ -275,7 +275,9 @@ static int __init bfin_jc_init(void)
 
  err:
 	put_tty_driver(bfin_jc_driver);
+ err_driver:
 	kfree(bfin_jc_write_buf.buf);
+ err_buf:
 	kthread_stop(bfin_jc_kthread);
 	return ret;
 }

