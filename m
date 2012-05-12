Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761500Ab2ELATJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 20:19:09 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55013 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761481Ab2ELATD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 20:19:03 -0400
Date: Fri, 11 May 2012 17:17:34 -0700
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
Subject: [PATCH 04/11] persistent_ram: Introduce persistent_ram_new()
Message-ID: <20120512001734.GD14782@lizard>
References: <20120512001506.GA8653@lizard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120512001506.GA8653@lizard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The routine just creates a persistent ram zone at a specified address.

For persistent_ram_init_ringbuffer() we'd need to add a
'struct persistent_ram' to the global list, and associate it with a
device. We don't need all this complexity in pstore_ram, so we introduce
the simple function.

Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
---
 drivers/staging/android/persistent_ram.c |   26 ++++++++++++++++++++++++++
 drivers/staging/android/persistent_ram.h |    4 ++++
 2 files changed, 30 insertions(+)

diff --git a/drivers/staging/android/persistent_ram.c b/drivers/staging/android/persistent_ram.c
index ec23822..c0c3d32 100644
--- a/drivers/staging/android/persistent_ram.c
+++ b/drivers/staging/android/persistent_ram.c
@@ -412,6 +412,32 @@ static int __init persistent_ram_post_init(struct persistent_ram_zone *prz, bool
 	return 0;
 }
 
+struct persistent_ram_zone * __init persistent_ram_new(phys_addr_t start,
+						       size_t size,
+						       bool ecc)
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
+	ret = persistent_ram_buffer_map(start, size, prz);
+	if (ret)
+		goto err;
+
+	persistent_ram_post_init(prz, ecc);
+	persistent_ram_update_header_ecc(prz);
+
+	return prz;
+err:
+	kfree(prz);
+	return ERR_PTR(ret);
+}
+
 static  __init
 struct persistent_ram_zone *__persistent_ram_init(struct device *dev, bool ecc)
 {
diff --git a/drivers/staging/android/persistent_ram.h b/drivers/staging/android/persistent_ram.h
index 5635355..8154d15 100644
--- a/drivers/staging/android/persistent_ram.h
+++ b/drivers/staging/android/persistent_ram.h
@@ -19,6 +19,7 @@
 #include <linux/kernel.h>
 #include <linux/list.h>
 #include <linux/types.h>
+#include <linux/init.h>
 
 struct persistent_ram_buffer;
 
@@ -62,6 +63,9 @@ struct persistent_ram_zone {
 
 int persistent_ram_early_init(struct persistent_ram *ram);
 
+struct persistent_ram_zone * __init persistent_ram_new(phys_addr_t start,
+						       size_t size,
+						       bool ecc);
 struct persistent_ram_zone *persistent_ram_init_ringbuffer(struct device *dev,
 		bool ecc);
 
-- 
1.7.9.2

