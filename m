Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754059Ab2FSCSh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 22:18:37 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:50286 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752512Ab2FSCSe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 22:18:34 -0400
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
Subject: [PATCH 7/7] pstore/ram_core: Get rid of prz->ecc enable/disable flag
Date: Mon, 18 Jun 2012 19:15:56 -0700
Message-Id: <1340072156-6225-7-git-send-email-anton.vorontsov@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <20120619021050.GA19387@lizard>
References: <20120619021050.GA19387@lizard>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nowadays we can use prz->ecc_size as a flag, no need for the special
member in the prz struct.

Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
---
 fs/pstore/ram_core.c       |   10 ++++------
 include/linux/pstore_ram.h |    1 -
 2 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/fs/pstore/ram_core.c b/fs/pstore/ram_core.c
index 7e5a2a9..4dabbb8 100644
--- a/fs/pstore/ram_core.c
+++ b/fs/pstore/ram_core.c
@@ -114,7 +114,7 @@ static void notrace persistent_ram_update_ecc(struct persistent_ram_zone *prz,
 	int ecc_size = prz->ecc_size;
 	int size = prz->ecc_block_size;
 
-	if (!prz->ecc)
+	if (!prz->ecc_size)
 		return;
 
 	block = buffer->data + (start & ~(ecc_block_size - 1));
@@ -133,7 +133,7 @@ static void persistent_ram_update_header_ecc(struct persistent_ram_zone *prz)
 {
 	struct persistent_ram_buffer *buffer = prz->buffer;
 
-	if (!prz->ecc)
+	if (!prz->ecc_size)
 		return;
 
 	persistent_ram_encode_rs8(prz, (uint8_t *)buffer, sizeof(*buffer),
@@ -146,7 +146,7 @@ static void persistent_ram_ecc_old(struct persistent_ram_zone *prz)
 	uint8_t *block;
 	uint8_t *par;
 
-	if (!prz->ecc)
+	if (!prz->ecc_size)
 		return;
 
 	block = buffer->data;
@@ -181,7 +181,7 @@ static int persistent_ram_init_ecc(struct persistent_ram_zone *prz,
 	int ecc_symsize = 8;
 	int ecc_poly = 0x11d;
 
-	if (!prz->ecc)
+	if (!ecc_size)
 		return 0;
 
 	prz->ecc_block_size = 128;
@@ -395,8 +395,6 @@ static int __devinit persistent_ram_post_init(struct persistent_ram_zone *prz,
 {
 	int ret;
 
-	prz->ecc = ecc_size;
-
 	ret = persistent_ram_init_ecc(prz, ecc_size);
 	if (ret)
 		return ret;
diff --git a/include/linux/pstore_ram.h b/include/linux/pstore_ram.h
index 94b79f1..dcf805f 100644
--- a/include/linux/pstore_ram.h
+++ b/include/linux/pstore_ram.h
@@ -33,7 +33,6 @@ struct persistent_ram_zone {
 	size_t buffer_size;
 
 	/* ECC correction */
-	bool ecc;
 	char *par_buffer;
 	char *par_header;
 	struct rs_control *rs_decoder;
-- 
1.7.10.4

