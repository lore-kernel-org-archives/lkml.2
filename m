Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752441Ab1EDJ0v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 05:26:51 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:39109 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751689Ab1EDJ0v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 05:26:51 -0400
Date: Wed, 4 May 2011 05:26:43 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost6.localdomain6
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: jim.cromie@gmail.com
Subject: [PATCH] PC8736X: Correct dev_dbg() message showing major number.
Message-ID: <alpine.DEB.2.00.1105040522250.4503@localhost6.localdomain6>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Currently, the debugging info is incorrect, as a successful call to
either register_chrdev_region() or alloc_chrdev_region() returns
simply zero, which appears to be what the following code would print.
Skip the checking, just print the value of "major", which should be
correct.

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>

---

  here's the current code in context, so you can see what i mean:

        if (major) {
                devid = MKDEV(major, 0);
                rc = register_chrdev_region(devid, PC8736X_GPIO_CT, DEVNAME);
        } else {
                rc = alloc_chrdev_region(&devid, 0, PC8736X_GPIO_CT, DEVNAME);
                major = MAJOR(devid);
        }

        if (rc < 0) {
                dev_err(&pdev->dev, "register-chrdev failed: %d\n", rc);
                goto undo_request_region;
        }
        dev_dbg(&pdev->dev, "got dynamic major %d\n", major);


diff --git a/drivers/char/pc8736x_gpio.c b/drivers/char/pc8736x_gpio.c
index b304ec0..a23d6bf 100644
--- a/drivers/char/pc8736x_gpio.c
+++ b/drivers/char/pc8736x_gpio.c
@@ -314,10 +314,7 @@ static int __init pc8736x_gpio_init(void)
 		dev_err(&pdev->dev, "register-chrdev failed: %d\n", rc);
 		goto undo_request_region;
 	}
-	if (!major) {
-		major = rc;
-		dev_dbg(&pdev->dev, "got dynamic major %d\n", major);
-	}
+	dev_dbg(&pdev->dev, "got dynamic major %d\n", major);

 	pc8736x_init_shadow();


-- 

========================================================================
Robert P. J. Day                                 Ottawa, Ontario, CANADA
                        http://crashcourse.ca

Twitter:                                       http://twitter.com/rpjday
LinkedIn:                               http://ca.linkedin.com/in/rpjday
========================================================================
