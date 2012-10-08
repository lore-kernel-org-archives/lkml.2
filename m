Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751911Ab2JHPgo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 11:36:44 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:43325 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751080Ab2JHPgi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 11:36:38 -0400
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Alex Dubov <oakad@yahoo.com>, Linux-Next <linux-next@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Maxim Levitsky <maximlevitsky@gmail.com>
Subject: [PATCH 2/2] memstick: ms_block: fix complile issue.
Date: Mon,  8 Oct 2012 17:36:22 +0200
Message-Id: <1349710582-5410-3-git-send-email-maximlevitsky@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1349710582-5410-1-git-send-email-maximlevitsky@gmail.com>
References: <CAMuHMdW7zfM1CxkXTCq2=ErkaAAxGVFyQSZdH3jwvUXr_8oOsg@mail.gmail.com>
 <1349710582-5410-1-git-send-email-maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As suggested by Geert Uytterhoeven

http://kisskb.ellerman.id.au/kisskb/buildresult/7280352/
arch/m68k/include/asm/hardirq.h:23:20: error: expected ')' before 'DRIVER_NAME'
make[4]: *** [drivers/memstick/core/ms_block.o] Error 1

The reason for this is that pr_fmt() references DRIVER_NAME and is defined
before the first include, while DRIVER_NAME is only defined in ms_block.h,
which is the last included file. If any subsequent include file uses pr_fmt()
(e.g. the call to pr_crit() in arch/m68k/include/asm/hardirq.h), this
causes a build
failure.

I suggest moving the DRIVER_NAME define to ms_block.c.
Cfr. memstick.c and mspro_block.c, who already have their own definition.


CC: Geert Uytterhoeven <geert@linux-m68k.org>

Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
---
 drivers/memstick/core/ms_block.c |    2 +-
 drivers/memstick/core/ms_block.h |    2 --
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/memstick/core/ms_block.c b/drivers/memstick/core/ms_block.c
index c815fe5..71e5937 100644
--- a/drivers/memstick/core/ms_block.c
+++ b/drivers/memstick/core/ms_block.c
@@ -11,7 +11,7 @@
  * Copyright (C) 2007 Alex Dubov <oakad@yahoo.com>
  *
  */
-
+#define DRIVER_NAME "ms_block"
 #define pr_fmt(fmt) DRIVER_NAME ": " fmt
 
 #include <linux/module.h>
diff --git a/drivers/memstick/core/ms_block.h b/drivers/memstick/core/ms_block.h
index a2b2765..546b55e 100644
--- a/drivers/memstick/core/ms_block.h
+++ b/drivers/memstick/core/ms_block.h
@@ -277,8 +277,6 @@ static int msb_reset(struct msb_data *msb, bool full);
 static int h_msb_default_bad(struct memstick_dev *card,
 						struct memstick_request **mrq);
 
-#define DRIVER_NAME "ms_block"
-
 #define __dbg(level, format, ...) \
 	do { \
 		if (debug >= level) \
-- 
1.7.9.5

