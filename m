Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934037Ab0D3Sth (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 14:49:37 -0400
Received: from smtp.nokia.com ([192.100.122.230]:61923 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932810Ab0D3RNN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:13:13 -0400
From: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
To: linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>,
       "Richard Russon (FlatCap)" <ldm@flatcap.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 08/10] fs: ldm: don't use own implementation of hex_to_bin()
Date: Fri, 30 Apr 2010 12:34:07 +0300
Message-Id: <ce5ee38b2d01568cd56ffc9598d7ceaa24738e65.1272617852.git.ext-andriy.shevchenko@nokia.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <d6886a8b94bf8726d7bde807b3ca19f65739ce4d.1272617852.git.ext-andriy.shevchenko@nokia.com>
References: <cover.1272617852.git.ext-andriy.shevchenko@nokia.com>
 <d5c4e26cc74458dd77102c4274d3260149717328.1272617852.git.ext-andriy.shevchenko@nokia.com>
 <1a326db89859eec030859e4905c515e0817bd2ea.1272617852.git.ext-andriy.shevchenko@nokia.com>
 <d4a1df27bf2c83ee84c3d74bcff0f2768146eb7e.1272617852.git.ext-andriy.shevchenko@nokia.com>
 <c1ca828fb308042aa32428b345abcb43ccb02c39.1272617852.git.ext-andriy.shevchenko@nokia.com>
 <2eb558b7b0b20dfea0b61223db6146cb8fdbe52d.1272617852.git.ext-andriy.shevchenko@nokia.com>
 <7cd86c01ad4a376fb8a48ffe307ce7c0510cecc0.1272617852.git.ext-andriy.shevchenko@nokia.com>
 <d6886a8b94bf8726d7bde807b3ca19f65739ce4d.1272617852.git.ext-andriy.shevchenko@nokia.com>
In-Reply-To: <cover.1272617852.git.ext-andriy.shevchenko@nokia.com>
References: <cover.1272617852.git.ext-andriy.shevchenko@nokia.com>
X-OriginalArrivalTime: 30 Apr 2010 09:34:10.0161 (UTC) FILETIME=[497BA610:01CAE848]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get rid of own implementation of hex_to_bin().

Signed-off-by: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
Cc: "Richard Russon (FlatCap)" <ldm@flatcap.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 fs/partitions/ldm.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/partitions/ldm.c b/fs/partitions/ldm.c
index 8652fb9..cb445fb 100644
--- a/fs/partitions/ldm.c
+++ b/fs/partitions/ldm.c
@@ -26,6 +26,7 @@
 #include <linux/slab.h>
 #include <linux/pagemap.h>
 #include <linux/stringify.h>
+#include <linux/kernel.h>
 #include "ldm.h"
 #include "check.h"
 #include "msdos.h"
@@ -77,17 +78,16 @@ static int ldm_parse_hexbyte (const u8 *src)
 	int h;
 
 	/* high part */
-	if      ((x = src[0] - '0') <= '9'-'0') h = x;
-	else if ((x = src[0] - 'a') <= 'f'-'a') h = x+10;
-	else if ((x = src[0] - 'A') <= 'F'-'A') h = x+10;
-	else return -1;
-	h <<= 4;
+	x = h = hex_to_bin(src[0]);
+	if (h < 0)
+		return -1;
 
 	/* low part */
-	if ((x = src[1] - '0') <= '9'-'0') return h | x;
-	if ((x = src[1] - 'a') <= 'f'-'a') return h | (x+10);
-	if ((x = src[1] - 'A') <= 'F'-'A') return h | (x+10);
-	return -1;
+	h = hex_to_bin(src[1]);
+	if (h < 0)
+		return -1;
+
+	return (x << 4) + h;
 }
 
 /**
-- 
1.6.3.3

