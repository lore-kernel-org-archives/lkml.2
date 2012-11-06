Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753286Ab2KFVzq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 16:55:46 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:51881 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752834Ab2KFVzm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 16:55:42 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, Arnd Bergmann <arnd@arndb.de>,
        David Woodhouse <dwmw2@infradead.org>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        linux-mtd@lists.infradead.org
Subject: [PATCH 3/8] mtd: uninitialized variable warning in map.h
Date: Tue,  6 Nov 2012 22:55:28 +0100
Message-Id: <1352238933-4886-4-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1352238933-4886-1-git-send-email-arnd@arndb.de>
References: <1352238933-4886-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:k3Tj2nQ00OgWcrL1pAZ83cxbnvg9l5nhpPDe9NvEwho
 XLnQBaMKyn1C7ZSS3JrjzZ6JnSazB0GGi4qDtZxI7srhEW7F7R
 oxjHzU83NK/pwz3d6IZQcbWGHvDQ0TGnL4jSN3KtRwniDEGbXW
 myfKOleb7vZH0GLONZsjx71MoTXNqIAJoJGbuVR328JeDfaYRm
 mODqiqn5bVcTZmxLqs2wc3mPWTN2MMwHk1esLL6JEB5mCfKDTY
 rGXEb2EATXpi3PTGpFH1RaUqZQREQWDHucm2x9Fx0uL4dFQLVO
 CZRIxXz5k2mMJ6e8Rseta2BwPpFCsJS6yeZAV2+aaGaiaOIomR
 f7WAoTagJSHOQpiogTuRvViITQry9OeO5p9VzKTL4ro/kfYqd8
 U4bYkfFrVWZZw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The map_word_load() function initializes exactly
as many words in the buffer as required, but gcc
cannot figure this out and gives a misleading
warning. Marking the local variable as
uninitialized_var shuts up that warning.

Without this patch, building acs5k_defconfig results in:

drivers/mtd/chips/cfi_cmdset_0002.c: In function 'cfi_amdstd_panic_write':
include/linux/mtd/map.h:331:11: warning: 'r.x[0]' may be used uninitialized in this function [-Wuninitialized]
drivers/mtd/chips/cfi_cmdset_0002.c: In function 'cfi_amdstd_write_words':
include/linux/mtd/map.h:331:11: warning: 'r.x[0]' may be used uninitialized in this function [-Wuninitialized]
drivers/mtd/chips/cfi_cmdset_0001.c: In function 'cfi_intelext_write_words':
include/linux/mtd/map.h:331:11: warning: 'r.x[0]' may be used uninitialized in this function [-Wuninitialized]

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Cc: linux-mtd@lists.infradead.org
---
 include/linux/mtd/map.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/mtd/map.h b/include/linux/mtd/map.h
index 3595a02..e3559ba 100644
--- a/include/linux/mtd/map.h
+++ b/include/linux/mtd/map.h
@@ -328,7 +328,7 @@ static inline int map_word_bitsset(struct map_info *map, map_word val1, map_word
 
 static inline map_word map_word_load(struct map_info *map, const void *ptr)
 {
-	map_word r;
+	map_word uninitialized_var(r);
 
 	if (map_bankwidth_is_1(map))
 		r.x[0] = *(unsigned char *)ptr;
-- 
1.7.10

