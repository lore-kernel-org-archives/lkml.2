Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754759Ab0DZTZh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 15:25:37 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:44553 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753917Ab0DZTZe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 15:25:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=Ethq5i5KcfE8Z5jPCTzcM/HRsonL2X+60mkYM5M0Lo4AvY8sikSNgU4Vkb1O0gRVfd
         drK2sJEbAD6YQSJ92IuezpGrCh9/Q6AULco0T9oZ6jhjtQs8YHZqovqHXe29bT7mtzKr
         JYC491EcLXvTw0IqxlaMX5TD5nrwEvQ7hNVjs=
Date: Mon, 26 Apr 2010 21:25:20 +0200
From: Dan Carpenter <error27@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jani Nikula <ext-jani.1.nikula@nokia.com>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Daniel =?iso-8859-1?Q?Gl=F6ckner?= <dg@emlix.com>,
       Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [patch] gpio: potential null dereference
Message-ID: <20100426192520.GU29093@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jani Nikula <ext-jani.1.nikula@nokia.com>,
	David Brownell <dbrownell@users.sourceforge.net>,
	Daniel =?iso-8859-1?Q?Gl=F6ckner?= <dg@emlix.com>,
	Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Smatch found a potential null dereference in gpio_setup_irq().  The 
"pdesc" variable is allocated with idr_find() that can return NULL.  If
gpio_setup_irq() is called with 0 as gpio_flags and "pdesc" is null, it
would OOPs here.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 76be229..eb0c3fe 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -416,7 +416,8 @@ static int gpio_setup_irq(struct gpio_desc *desc, struct device *dev,
 	return 0;
 
 free_sd:
-	sysfs_put(pdesc->value_sd);
+	if (pdesc)
+		sysfs_put(pdesc->value_sd);
 free_id:
 	idr_remove(&pdesc_idr, id);
 	desc->flags &= GPIO_FLAGS_MASK;
