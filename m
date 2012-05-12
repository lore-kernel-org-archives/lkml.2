Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755019Ab2ELAS4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 20:18:56 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:42602 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754894Ab2ELASx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 20:18:53 -0400
Date: Fri, 11 May 2012 17:17:25 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kees Cook <keescook@chromium.org>, Colin Cross <ccross@android.com>
Cc: Arnd Bergmann <arnd@arndb.de>, John Stultz <john.stultz@linaro.org>,
        arve@android.com, Rebecca Schultz Zavin <rebecca@android.com>,
        Jesper Juhl <jj@chaosbits.net>, Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Boyd <sboyd@codeaurora.org>, Thomas Meyer <thomas@m3y3r.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marco Stornelli <marco.stornelli@gmail.com>,
        WANG Cong <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com
Subject: [PATCH 03/11] persistent_ram: Introduce persistent_ram_post_init()
Message-ID: <20120512001725.GC14782@lizard>
References: <20120512001506.GA8653@lizard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120512001506.GA8653@lizard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Factor post init logic out of __persistent_ram_init(), we'll need
it for the new persistent_ram_new() routine.

Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
---
 drivers/staging/android/persistent_ram.c |   44 ++++++++++++++++++------------
 1 file changed, 27 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/android/persistent_ram.c b/drivers/staging/android/persistent_ram.c
index 13a12bc..ec23822 100644
--- a/drivers/staging/android/persistent_ram.c
+++ b/drivers/staging/android/persistent_ram.c
@@ -378,28 +378,15 @@ static int __init persistent_ram_buffer_init(const char *name,
 	return -EINVAL;
 }
 
-static  __init
-struct persistent_ram_zone *__persistent_ram_init(struct device *dev, bool ecc)
+static int __init persistent_ram_post_init(struct persistent_ram_zone *prz, bool ecc)
 {
-	struct persistent_ram_zone *prz;
-	int ret = -ENOMEM;
-
-	prz = kzalloc(sizeof(struct persistent_ram_zone), GFP_KERNEL);
-	if (!prz) {
-		pr_err("persistent_ram: failed to allocate persistent ram zone\n");
-		goto err;
-	}
-
-	ret = persistent_ram_buffer_init(dev_name(dev), prz);
-	if (ret) {
-		pr_err("persistent_ram: failed to initialize buffer\n");
-		goto err;
-	}
+	int ret;
 
 	prz->ecc = ecc;
+
 	ret = persistent_ram_init_ecc(prz, prz->buffer_size);
 	if (ret)
-		goto err;
+		return ret;
 
 	if (prz->buffer->sig == PERSISTENT_RAM_SIG) {
 		if (buffer_size(prz) > prz->buffer_size ||
@@ -422,6 +409,29 @@ struct persistent_ram_zone *__persistent_ram_init(struct device *dev, bool ecc)
 	atomic_set(&prz->buffer->start, 0);
 	atomic_set(&prz->buffer->size, 0);
 
+	return 0;
+}
+
+static  __init
+struct persistent_ram_zone *__persistent_ram_init(struct device *dev, bool ecc)
+{
+	struct persistent_ram_zone *prz;
+	int ret = -ENOMEM;
+
+	prz = kzalloc(sizeof(struct persistent_ram_zone), GFP_KERNEL);
+	if (!prz) {
+		pr_err("persistent_ram: failed to allocate persistent ram zone\n");
+		goto err;
+	}
+
+	ret = persistent_ram_buffer_init(dev_name(dev), prz);
+	if (ret) {
+		pr_err("persistent_ram: failed to initialize buffer\n");
+		goto err;
+	}
+
+	persistent_ram_post_init(prz, ecc);
+
 	return prz;
 err:
 	kfree(prz);
-- 
1.7.9.2

