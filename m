Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933396Ab2EPMov (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 08:44:51 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:34312 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933337Ab2EPMos (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 08:44:48 -0400
Date: Wed, 16 May 2012 05:43:19 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kees Cook <keescook@chromium.org>, Colin Cross <ccross@android.com>
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
Subject: [PATCH 3/6] persistent_ram: Prepare for modular builds
Message-ID: <20120516124318.GC18345@lizard>
References: <20120516124109.GA14658@lizard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120516124109.GA14658@lizard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a transition patch to keep things bisectable, just moves
some routines under '#ifndef MODULE'. The code inside the #ifndef
will go away soon, but so far we must support pstore and ram_console.

So, we are about to use persistent_ram with pstore, with the ability
to compile persistent_ram routines as modules. Some parts of
persistent_ram uses memblock_reserve() routine, which is should be
only used built-in code, and thus it is not exported.

These persistent_ram bits are only used by Android's ram_console,
which is always built-in.

Without this patch, we won't able to compile persistent_ram as a
module:

ERROR: "memblock_reserve" [fs/pstore/ramoops.ko] undefined!
make[1]: *** [__modpost] Error 1
make: *** [modules] Error 2

(As alternative, we could export memblock_reserve, but the thing
is: we won't need it later.)

Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
---
 drivers/staging/android/persistent_ram.c |   46 ++++++++++++++++--------------
 1 file changed, 24 insertions(+), 22 deletions(-)

diff --git a/drivers/staging/android/persistent_ram.c b/drivers/staging/android/persistent_ram.c
index 63481da..4b46eaa 100644
--- a/drivers/staging/android/persistent_ram.c
+++ b/drivers/staging/android/persistent_ram.c
@@ -384,28 +384,6 @@ static int persistent_ram_buffer_map(phys_addr_t start, phys_addr_t size,
 	return 0;
 }
 
-static int __init persistent_ram_buffer_init(const char *name,
-		struct persistent_ram_zone *prz)
-{
-	int i;
-	struct persistent_ram *ram;
-	struct persistent_ram_descriptor *desc;
-	phys_addr_t start;
-
-	list_for_each_entry(ram, &persistent_ram_list, node) {
-		start = ram->start;
-		for (i = 0; i < ram->num_descs; i++) {
-			desc = &ram->descs[i];
-			if (!strcmp(desc->name, name))
-				return persistent_ram_buffer_map(start,
-						desc->size, prz);
-			start += desc->size;
-		}
-	}
-
-	return -EINVAL;
-}
-
 static int __init persistent_ram_post_init(struct persistent_ram_zone *prz, bool ecc)
 {
 	int ret;
@@ -478,6 +456,29 @@ err:
 	return ERR_PTR(ret);
 }
 
+#ifndef MODULE
+static int __init persistent_ram_buffer_init(const char *name,
+		struct persistent_ram_zone *prz)
+{
+	int i;
+	struct persistent_ram *ram;
+	struct persistent_ram_descriptor *desc;
+	phys_addr_t start;
+
+	list_for_each_entry(ram, &persistent_ram_list, node) {
+		start = ram->start;
+		for (i = 0; i < ram->num_descs; i++) {
+			desc = &ram->descs[i];
+			if (!strcmp(desc->name, name))
+				return persistent_ram_buffer_map(start,
+						desc->size, prz);
+			start += desc->size;
+		}
+	}
+
+	return -EINVAL;
+}
+
 static  __init
 struct persistent_ram_zone *__persistent_ram_init(struct device *dev, bool ecc)
 {
@@ -528,3 +529,4 @@ int __init persistent_ram_early_init(struct persistent_ram *ram)
 
 	return 0;
 }
+#endif
-- 
1.7.9.2

