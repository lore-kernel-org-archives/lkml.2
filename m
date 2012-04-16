Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755110Ab2DPSSH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 14:18:07 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58314 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754244Ab2DPSSC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 14:18:02 -0400
From: Grant Likely <grant.likely@secretlab.ca>
To: linux-kernel@vger.kernel.org
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] vsprintf: Correctly handle width when '#' flag used in %#p format.
Date: Mon, 16 Apr 2012 12:17:54 -0600
Message-Id: <1334600274-9436-1-git-send-email-grant.likely@secretlab.ca>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adjusts the default width of pointer output to include the
'0x' characters when the '#' flag is included in the format string.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 lib/vsprintf.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index abbabec..1043827 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -866,13 +866,15 @@ static noinline_for_stack
 char *pointer(const char *fmt, char *buf, char *end, void *ptr,
 	      struct printf_spec spec)
 {
+	int default_width = 2 * sizeof(void*) + (spec.flags & SPECIAL ? 2 : 0);
+
 	if (!ptr && *fmt != 'K') {
 		/*
 		 * Print (null) with the same width as a pointer so it makes
 		 * tabular output look nice.
 		 */
 		if (spec.field_width == -1)
-			spec.field_width = 2 * sizeof(void *);
+			spec.field_width = default_width;
 		return string(buf, end, "(null)", spec);
 	}
 
@@ -927,7 +929,7 @@ char *pointer(const char *fmt, char *buf, char *end, void *ptr,
 		 */
 		if (in_irq() || in_serving_softirq() || in_nmi()) {
 			if (spec.field_width == -1)
-				spec.field_width = 2 * sizeof(void *);
+				spec.field_width = default_width;
 			return string(buf, end, "pK-error", spec);
 		}
 		if (!((kptr_restrict == 0) ||
@@ -944,7 +946,7 @@ char *pointer(const char *fmt, char *buf, char *end, void *ptr,
 	}
 	spec.flags |= SMALL;
 	if (spec.field_width == -1) {
-		spec.field_width = 2 * sizeof(void *);
+		spec.field_width = default_width;
 		spec.flags |= ZEROPAD;
 	}
 	spec.base = 16;
-- 
1.7.9.5

