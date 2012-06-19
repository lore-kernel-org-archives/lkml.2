Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754007Ab2FSCSU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 22:18:20 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:50286 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752512Ab2FSCSQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 22:18:16 -0400
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
Subject: [PATCH 4/7] pstore/ram_core: Better ECC size checking
Date: Mon, 18 Jun 2012 19:15:53 -0700
Message-Id: <1340072156-6225-4-git-send-email-anton.vorontsov@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <20120619021050.GA19387@lizard>
References: <20120619021050.GA19387@lizard>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- Instead of exploiting unsigned overflows (which doesn't work for all
  sizes), use straightforward checking for ECC total size not exceeding
  initial buffer size;

- Printing overflowed buffer_size is not informative. Instead, print
  ecc_size and buffer_size;

- No need for buffer_size argument in persistent_ram_init_ecc(),
  we can address prz->buffer_size directly.

Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
---
 fs/pstore/ram_core.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/pstore/ram_core.c b/fs/pstore/ram_core.c
index f62ebf2..a5a7b13 100644
--- a/fs/pstore/ram_core.c
+++ b/fs/pstore/ram_core.c
@@ -171,12 +171,12 @@ static void persistent_ram_ecc_old(struct persistent_ram_zone *prz)
 	}
 }
 
-static int persistent_ram_init_ecc(struct persistent_ram_zone *prz,
-	size_t buffer_size)
+static int persistent_ram_init_ecc(struct persistent_ram_zone *prz)
 {
 	int numerr;
 	struct persistent_ram_buffer *buffer = prz->buffer;
 	int ecc_blocks;
+	size_t ecc_total;
 
 	if (!prz->ecc)
 		return 0;
@@ -187,14 +187,14 @@ static int persistent_ram_init_ecc(struct persistent_ram_zone *prz,
 	prz->ecc_poly = 0x11d;
 
 	ecc_blocks = DIV_ROUND_UP(prz->buffer_size, prz->ecc_block_size);
-	prz->buffer_size -= (ecc_blocks + 1) * prz->ecc_size;
-
-	if (prz->buffer_size > buffer_size) {
-		pr_err("persistent_ram: invalid size %zu, non-ecc datasize %zu\n",
-		       buffer_size, prz->buffer_size);
+	ecc_total = (ecc_blocks + 1) * prz->ecc_size;
+	if (ecc_total >= prz->buffer_size) {
+		pr_err("%s: invalid ecc_size %u (total %zu, buffer size %zu)\n",
+		       __func__, prz->ecc_size, ecc_total, prz->buffer_size);
 		return -EINVAL;
 	}
 
+	prz->buffer_size -= ecc_total;
 	prz->par_buffer = buffer->data + prz->buffer_size;
 	prz->par_header = prz->par_buffer + ecc_blocks * prz->ecc_size;
 
@@ -397,7 +397,7 @@ static int __devinit persistent_ram_post_init(struct persistent_ram_zone *prz,
 
 	prz->ecc = ecc;
 
-	ret = persistent_ram_init_ecc(prz, prz->buffer_size);
+	ret = persistent_ram_init_ecc(prz);
 	if (ret)
 		return ret;
 
-- 
1.7.10.4

