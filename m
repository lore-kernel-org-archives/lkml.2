Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753782Ab2J1T5s (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 15:57:48 -0400
Received: from 1010ds2-suoe.0.fullrate.dk ([90.184.90.115]:15635 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752401Ab2J1T5q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 15:57:46 -0400
Date: Tue, 25 Nov 2008 15:57:30 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
cc: =?ISO-8859-15?Q?Beno=EEt_Th=E9baudeau?= 
	<benoit.thebaudeau@advansee.com>,
        Trilok Soni <tsoni@codeaurora.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "Du, Changbin" <changbin.du@gmail.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] [media] rc: Fix double free in gpio_ir_recv_probe()
Message-ID: <alpine.LNX.2.00.0811251553500.1109@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At the 'err_request_irq' label, rc_unregister_device(rcdev) frees its
argument. So when we fall through to the 'err_gpio_request' label
further down and call rc_free_device(rcdev) then that's a double free.

Fix that by moving 'rcdev = NULL' from after the call to
rc_free_device() to after rc_unregister_device(). That fixes the
problem since rc_free_device() just does nothing if passed NULL and
there's no further use of 'rcdev' after the call to rc_free_device()
so it's not needed there.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/media/rc/gpio-ir-recv.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/rc/gpio-ir-recv.c b/drivers/media/rc/gpio-ir-recv.c
index 04cb272..c698408 100644
--- a/drivers/media/rc/gpio-ir-recv.c
+++ b/drivers/media/rc/gpio-ir-recv.c
@@ -129,12 +129,12 @@ static int __devinit gpio_ir_recv_probe(struct platform_device *pdev)
 err_request_irq:
 	platform_set_drvdata(pdev, NULL);
 	rc_unregister_device(rcdev);
+	rcdev = NULL;
 err_register_rc_device:
 err_gpio_direction_input:
 	gpio_free(pdata->gpio_nr);
 err_gpio_request:
 	rc_free_device(rcdev);
-	rcdev = NULL;
 err_allocate_device:
 	kfree(gpio_dev);
 	return rc;
-- 
1.7.1


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

