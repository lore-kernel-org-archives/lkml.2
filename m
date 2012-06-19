Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754037Ab2FSCS1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 22:18:27 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:43936 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752512Ab2FSCSW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 22:18:22 -0400
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
Subject: [PATCH 5/7] pstore/ram_core: Get rid of prz->ecc_symsize and prz->ecc_poly
Date: Mon, 18 Jun 2012 19:15:54 -0700
Message-Id: <1340072156-6225-5-git-send-email-anton.vorontsov@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <20120619021050.GA19387@lizard>
References: <20120619021050.GA19387@lizard>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The struct members were never used anywhere outside of
persistent_ram_init_ecc(), so there's actually no need for them
to be in the struct.

If we ever want to make polynomial or symbol size configurable,
it would make more sense to just pass initialized rs_decoder
to the persistent_ram init functions.

Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
---
 fs/pstore/ram_core.c       |    7 +++----
 include/linux/pstore_ram.h |    2 --
 2 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/fs/pstore/ram_core.c b/fs/pstore/ram_core.c
index a5a7b13..3f4d6e6 100644
--- a/fs/pstore/ram_core.c
+++ b/fs/pstore/ram_core.c
@@ -177,14 +177,14 @@ static int persistent_ram_init_ecc(struct persistent_ram_zone *prz)
 	struct persistent_ram_buffer *buffer = prz->buffer;
 	int ecc_blocks;
 	size_t ecc_total;
+	int ecc_symsize = 8;
+	int ecc_poly = 0x11d;
 
 	if (!prz->ecc)
 		return 0;
 
 	prz->ecc_block_size = 128;
 	prz->ecc_size = 16;
-	prz->ecc_symsize = 8;
-	prz->ecc_poly = 0x11d;
 
 	ecc_blocks = DIV_ROUND_UP(prz->buffer_size, prz->ecc_block_size);
 	ecc_total = (ecc_blocks + 1) * prz->ecc_size;
@@ -202,8 +202,7 @@ static int persistent_ram_init_ecc(struct persistent_ram_zone *prz)
 	 * first consecutive root is 0
 	 * primitive element to generate roots = 1
 	 */
-	prz->rs_decoder = init_rs(prz->ecc_symsize, prz->ecc_poly, 0, 1,
-				  prz->ecc_size);
+	prz->rs_decoder = init_rs(ecc_symsize, ecc_poly, 0, 1, prz->ecc_size);
 	if (prz->rs_decoder == NULL) {
 		pr_info("persistent_ram: init_rs failed\n");
 		return -EINVAL;
diff --git a/include/linux/pstore_ram.h b/include/linux/pstore_ram.h
index e681af9..a0975c0 100644
--- a/include/linux/pstore_ram.h
+++ b/include/linux/pstore_ram.h
@@ -41,8 +41,6 @@ struct persistent_ram_zone {
 	int bad_blocks;
 	int ecc_block_size;
 	int ecc_size;
-	int ecc_symsize;
-	int ecc_poly;
 
 	char *old_log;
 	size_t old_log_size;
-- 
1.7.10.4

