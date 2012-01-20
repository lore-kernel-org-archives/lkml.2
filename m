Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753994Ab2ATPPl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 10:15:41 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:49119 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753919Ab2ATPPj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 10:15:39 -0500
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH] sysctl: use bitmap library functions
Date: Sat, 21 Jan 2012 00:15:28 +0900
Message-Id: <1327072528-8479-6-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1327072528-8479-1-git-send-email-akinobu.mita@gmail.com>
References: <1327072528-8479-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use bitmap_set() instead of using set_bit() for each bit.  This conversion
is valid because the bitmap is private in the function call and atomic
bitops was unnecessary.

This also includes minor change.
- Use bitmap_copy() for shorter typing

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 kernel/sysctl.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index f487f25..57c92a7 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -58,6 +58,7 @@
 #include <linux/oom.h>
 #include <linux/kmod.h>
 #include <linux/capability.h>
+#include <linux/bitmap.h>
 
 #include <asm/uaccess.h>
 #include <asm/processor.h>
@@ -2884,9 +2885,7 @@ int proc_do_large_bitmap(struct ctl_table *table, int write,
 				}
 			}
 
-			while (val_a <= val_b)
-				set_bit(val_a++, tmp_bitmap);
-
+			bitmap_set(tmp_bitmap, val_a, val_b - val_a + 1);
 			first = 0;
 			proc_skip_char(&kbuf, &left, '\n');
 		}
@@ -2929,8 +2928,7 @@ int proc_do_large_bitmap(struct ctl_table *table, int write,
 			if (*ppos)
 				bitmap_or(bitmap, bitmap, tmp_bitmap, bitmap_len);
 			else
-				memcpy(bitmap, tmp_bitmap,
-					BITS_TO_LONGS(bitmap_len) * sizeof(unsigned long));
+				bitmap_copy(bitmap, tmp_bitmap, bitmap_len);
 		}
 		kfree(tmp_bitmap);
 		*lenp -= left;
-- 
1.7.4.4

