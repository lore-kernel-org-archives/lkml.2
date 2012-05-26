Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753015Ab2EZNK7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 09:10:59 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:52049 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752575Ab2EZNK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 09:10:26 -0400
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kees Cook <keescook@chromium.org>, Colin Cross <ccross@android.com>,
        Tony Luck <tony.luck@intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>, John Stultz <john.stultz@linaro.org>,
        Shuah Khan <shuahkhan@gmail.com>, arve@android.com,
        Rebecca Schultz Zavin <rebecca@android.com>,
        Jesper Juhl <jj@chaosbits.net>, Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Boyd <sboyd@codeaurora.org>, Thomas Meyer <thomas@m3y3r.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marco Stornelli <marco.stornelli@gmail.com>,
        WANG Cong <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com
Subject: [PATCH 3/5] pstore/ram_core: Factor persistent_ram_zap() out of post_init()
Date: Sat, 26 May 2012 06:07:51 -0700
Message-Id: <1338037673-19909-3-git-send-email-anton.vorontsov@linaro.org>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <20120526130650.GA6242@lizard>
References: <20120526130650.GA6242@lizard>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A handy function that we will use outside of ram_core soon. But
so far just factor it out and start using it in post_init().

Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
Acked-by: Kees Cook <keescook@chromium.org>
---
 fs/pstore/ram_core.c       |   11 ++++++++---
 include/linux/pstore_ram.h |    1 +
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/fs/pstore/ram_core.c b/fs/pstore/ram_core.c
index f6650d1..c5fbdbb 100644
--- a/fs/pstore/ram_core.c
+++ b/fs/pstore/ram_core.c
@@ -320,6 +320,13 @@ void persistent_ram_free_old(struct persistent_ram_zone *prz)
 	prz->old_log_size = 0;
 }
 
+void persistent_ram_zap(struct persistent_ram_zone *prz)
+{
+	atomic_set(&prz->buffer->start, 0);
+	atomic_set(&prz->buffer->size, 0);
+	persistent_ram_update_header_ecc(prz);
+}
+
 static void *persistent_ram_vmap(phys_addr_t start, size_t size)
 {
 	struct page **pages;
@@ -414,8 +421,7 @@ static int __init persistent_ram_post_init(struct persistent_ram_zone *prz, bool
 	}
 
 	prz->buffer->sig = PERSISTENT_RAM_SIG;
-	atomic_set(&prz->buffer->start, 0);
-	atomic_set(&prz->buffer->size, 0);
+	persistent_ram_zap(prz);
 
 	return 0;
 }
@@ -450,7 +456,6 @@ struct persistent_ram_zone * __init persistent_ram_new(phys_addr_t start,
 		goto err;
 
 	persistent_ram_post_init(prz, ecc);
-	persistent_ram_update_header_ecc(prz);
 
 	return prz;
 err:
diff --git a/include/linux/pstore_ram.h b/include/linux/pstore_ram.h
index 4491e8f..3b823d4 100644
--- a/include/linux/pstore_ram.h
+++ b/include/linux/pstore_ram.h
@@ -69,6 +69,7 @@ struct persistent_ram_zone * __init persistent_ram_new(phys_addr_t start,
 						       size_t size,
 						       bool ecc);
 void persistent_ram_free(struct persistent_ram_zone *prz);
+void persistent_ram_zap(struct persistent_ram_zone *prz);
 struct persistent_ram_zone *persistent_ram_init_ringbuffer(struct device *dev,
 		bool ecc);
 
-- 
1.7.9.2

