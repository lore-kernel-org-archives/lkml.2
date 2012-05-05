Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756088Ab2EEOdU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 10:33:20 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:53442 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755590Ab2EEOcm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 10:32:42 -0400
From: Pierre Carrier <pierre@spotify.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Pierre Carrier <pierre@spotify.com>
Subject: [PATCH 1/1] lib/vsprintf.c: "%#o",0 becomes '0' instead of '00'
Date: Sat,  5 May 2012 16:32:30 +0200
Message-Id: <1336228350-31148-1-git-send-email-pierre@spotify.com>
X-Mailer: git-send-email 1.7.10.1
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
 lib/vsprintf.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index abbabec..7129383 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -284,6 +284,7 @@ char *number(char *buf, char *end, unsigned long long num,
 	char locase;
 	int need_pfx = ((spec.flags & SPECIAL) && spec.base != 10);
 	int i;
+	bool is_null = num == 0LL;
 
 	/* locase = 0 or 0x20. ORing digits or letters with 'locase'
 	 * produces same digits or (maybe lowercased) letters */
@@ -353,9 +354,11 @@ char *number(char *buf, char *end, unsigned long long num,
 	}
 	/* "0x" / "0" prefix */
 	if (need_pfx) {
-		if (buf < end)
-			*buf = '0';
-		++buf;
+		if (spec.base == 16 || !is_null) {
+			if (buf < end)
+				*buf = '0';
+			++buf;
+		}
 		if (spec.base == 16) {
 			if (buf < end)
 				*buf = ('X' | locase);
-- 
1.7.10.1

