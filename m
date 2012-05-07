Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755178Ab2EGBU0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2012 21:20:26 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:56825 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755110Ab2EGBUZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2012 21:20:25 -0400
From: Pierre Carrier <pierre@spotify.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Pierre Carrier <pierre@spotify.com>
Subject: [PATCH 1/1] lib/vsprintf.c: "%#o",0 becomes '0' instead of '00'
Date: Mon,  7 May 2012 03:20:14 +0200
Message-Id: <1336353614-7944-1-git-send-email-pierre@spotify.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <20120507101949.e18a8f3e222b178eeb699cf6@canb.auug.org.au>
References: <20120507101949.e18a8f3e222b178eeb699cf6@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

number()'s behaviour is slighly changed:
0 becomes "0" instead of "00" when using the flag SPECIAL and base 8.

Before:
Number\Format  %o    %#o  %x    %#x
            0     0   00    0   0x0
            1     1   01    1   0x1
           16    20  020   10  0x10

After:
Number\Format  %o    %#o  %x    %#x
            0     0    0    0   0x0
            1     1   01    1   0x1
           16    20  020   10  0x10

Signed-off-by: Pierre Carrier <pierre@spotify.com>
---
 lib/vsprintf.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index abbabec..bc8f319 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -284,6 +284,7 @@ char *number(char *buf, char *end, unsigned long long num,
 	char locase;
 	int need_pfx = ((spec.flags & SPECIAL) && spec.base != 10);
 	int i;
+	bool is_zero = num == 0LL;
 
 	/* locase = 0 or 0x20. ORing digits or letters with 'locase'
 	 * produces same digits or (maybe lowercased) letters */
@@ -305,8 +306,9 @@ char *number(char *buf, char *end, unsigned long long num,
 		}
 	}
 	if (need_pfx) {
-		spec.field_width--;
 		if (spec.base == 16)
+			spec.field_width -= 2;
+		else if (!is_zero)
 			spec.field_width--;
 	}
 
@@ -353,9 +355,11 @@ char *number(char *buf, char *end, unsigned long long num,
 	}
 	/* "0x" / "0" prefix */
 	if (need_pfx) {
-		if (buf < end)
-			*buf = '0';
-		++buf;
+		if (spec.base == 16 || !is_zero) {
+			if (buf < end)
+				*buf = '0';
+			++buf;
+		}
 		if (spec.base == 16) {
 			if (buf < end)
 				*buf = ('X' | locase);
-- 
1.7.10.1

