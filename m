Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753265Ab2E0Uzy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 16:55:54 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:34773 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750871Ab2E0Uzv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 16:55:51 -0400
Date: Sun, 27 May 2012 22:55:41 +0200
From: Alessandro Rubini <rubini@gnudd.com>
To: linux-kernel@vger.kernel.org
Cc: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH] gpio-sta2x11: don't use pdata if null
Message-ID: <20120527205541.GA3164@mail.gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If there is no platform data available, the driver shouldn't use the
pointer or it will oops.  Since things will mostly work nonetheless,
(the BIOS may have set up the pins properly), I'd better not fail the
probe even in this case.

Signed-off-by: Alessandro Rubini <rubini@gnudd.com>
Acked-by: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>
---

(yes, I'm aware I have to patch this file to use irq_domain_add_linear)

 drivers/gpio/gpio-sta2x11.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/gpio/gpio-sta2x11.c b/drivers/gpio/gpio-sta2x11.c
index 38416be..6064fb3 100644
--- a/drivers/gpio/gpio-sta2x11.c
+++ b/drivers/gpio/gpio-sta2x11.c
@@ -383,8 +383,9 @@ static int __devinit gsta_probe(struct platform_device *dev)
 	}
 	spin_lock_init(&chip->lock);
 	gsta_gpio_setup(chip);
-	for (i = 0; i < GSTA_NR_GPIO; i++)
-		gsta_set_config(chip, i, gpio_pdata->pinconfig[i]);
+	if (gpio_pdata)
+		for (i = 0; i < GSTA_NR_GPIO; i++)
+			gsta_set_config(chip, i, gpio_pdata->pinconfig[i]);
 
 	/* 384 was used in previous code: be compatible for other drivers */
 	err = irq_alloc_descs(-1, 384, GSTA_NR_GPIO, NUMA_NO_NODE);
-- 
1.7.7.2
