Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757901Ab1E3XLY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 19:11:24 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:34826 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754770Ab1E3XLW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 19:11:22 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1+LVy1710yL4zFD+UkikR5x2Yx7YkkPOqXf5TeYfe
	rOBkumtP/Rywxj
From: Peter =?iso-8859-1?q?H=FCwe?= <PeterHuewe@gmx.de>
To: Andre Bartke <andre.bartke@googlemail.com>
Subject: Re: [PATCH] staging: altera-stapl: Fix memory leak of altera_init()
Date: Tue, 31 May 2011 01:11:17 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.38.6; KDE/4.4.5; x86_64; ; )
Cc: devel@linuxdriverproject.org, mchehab@redhat.com,
        devel@driverdev.osuosl.org, Andre Bartke <andre.bartke@gmail.com>,
        linux-kernel@vger.kernel.org
References: <1306788304-21794-1-git-send-email-andre.bartke@gmail.com>
In-Reply-To: <1306788304-21794-1-git-send-email-andre.bartke@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-Id: <201105310111.18056.PeterHuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag 30 Mai 2011, 22:45:04 schrieb Andre Bartke:
> In case kzalloc() fails the second or third time
> we should free the previous allocated resources.

Good catch!
Personally I prefer putting the cleanup logic to the bottom, maybe like this - but that's just personal preference.

>From 1a13a1d7a2bad26f050ecc342741b6c07cac2b8a Mon Sep 17 00:00:00 2001
From: Peter Huewe <peterhuewe@gmx.de>
Date: Tue, 31 May 2011 00:54:27 +0200
Subject: [PATCH] staging: altera-stapl: Fix memory leak of altera_init()

In case kzalloc() fails the second or third time
we should free the previous allocated resources.
In order to keep one return point and to keep the cleanup code to one
place, some reordering was necessary.

Also while at it, removed the *sizeof(char) - to quote Linus:
"" Also removed the silly "* sizeof(u8)".  If that isn't 1, we have way
   deeper problems than a simple multiplication can fix. """

Reported-by: Andre Bartke <andre.bartke@gmail.com>
Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/staging/altera-stapl/altera.c |   33 +++++++++++++++++++++------------
 1 files changed, 21 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/altera-stapl/altera.c b/drivers/staging/altera-stapl/altera.c
index 05aad35..09392ce 100644
--- a/drivers/staging/altera-stapl/altera.c
+++ b/drivers/staging/altera-stapl/altera.c
@@ -2430,16 +2430,23 @@ int altera_init(struct altera_config *config, const struct firmware *fw)
 	int index = 0;
 	s32 offset = 0L;
 	s32 error_address = 0L;
+	int retval = 0;
 
-	key = kzalloc(33 * sizeof(char), GFP_KERNEL);
-	if (!key)
-		return -ENOMEM;
-	value = kzalloc(257 * sizeof(char), GFP_KERNEL);
-	if (!value)
-		return -ENOMEM;
+	key = kzalloc(33, GFP_KERNEL);
+	if (!key) {
+		retval = -ENOMEM;
+		goto out;
+	}
+	value = kzalloc(257, GFP_KERNEL);
+	if (!value) {
+		retval = -ENOMEM;
+		goto free_key;
+	}
 	astate = kzalloc(sizeof(struct altera_state), GFP_KERNEL);
-	if (!astate)
-		return -ENOMEM;
+	if (!astate) {
+		retval = -ENOMEM;
+		goto free_value;
+	}
 
 	astate->config = config;
 	if (!astate->config->jtag_io) {
@@ -2518,10 +2525,12 @@ int altera_init(struct altera_config *config, const struct firmware *fw)
 	} else if (exec_result)
 		printk(KERN_ERR "%s: error %d\n", __func__, exec_result);
 
-	kfree(key);
-	kfree(value);
 	kfree(astate);
-
-	return 0;
+free_value:
+	kfree(value);
+free_key:
+	kfree(key);
+out:
+	return retval;
 }
 EXPORT_SYMBOL(altera_init);
-- 
1.7.3.4

