Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755239Ab2GWXzM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 19:55:12 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59848 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755194Ab2GWXvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 19:51:49 -0400
From: Kent Overstreet <koverstreet@google.com>
To: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com
Cc: Kent Overstreet <koverstreet@google.com>, tj@kernel.org, vgoyal@redhat.com,
        joe@perches.com
Subject: [Bcache v15 06/16] Add human-readable units modifier to vsnprintf()
Date: Mon, 23 Jul 2012 16:50:49 -0700
Message-Id: <1343087459-17645-7-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1343087459-17645-1-git-send-email-koverstreet@google.com>
References: <1343087459-17645-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Kent Overstreet <koverstreet@google.com>
---
 lib/vsprintf.c |   24 +++++++++++++++++++++++-
 1 files changed, 23 insertions(+), 1 deletions(-)

diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index c3f36d41..16149dd 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -338,6 +338,7 @@ int num_to_str(char *buf, int size, unsigned long long num)
 #define LEFT	16		/* left justified */
 #define SMALL	32		/* use lowercase in hex (must be 32 == 0x20) */
 #define SPECIAL	64		/* prefix hex with "0x", octal with "0" */
+#define HUNITS	128		/* Human readable units, i.e. k/M/G/T */
 
 enum format_type {
 	FORMAT_TYPE_NONE, /* Just a string part */
@@ -377,6 +378,7 @@ char *number(char *buf, char *end, unsigned long long num,
 {
 	/* we are called with base 8, 10 or 16, only, thus don't need "G..."  */
 	static const char digits[16] = "0123456789ABCDEF"; /* "GHIJKLMNOPQRSTUVWXYZ"; */
+	static const char units[] = "?kMGTPEZY";
 
 	char tmp[66];
 	char sign;
@@ -431,7 +433,26 @@ char *number(char *buf, char *end, unsigned long long num,
 			num >>= shift;
 		} while (num);
 	} else { /* base 10 */
-		i = put_dec(tmp, num) - tmp;
+		if (spec.flags & HUNITS) {
+			int u, rem = 0;
+
+			for (u = 0; num >= 1024; u++) {
+				rem = num & ~(~0 << 10);
+				num >>= 10;
+			}
+
+			if (u) {
+				tmp[i++] = units[u];
+
+				if (num < 100) {
+					rem /= 100;
+					i = put_dec(tmp + i, rem) - tmp;
+					tmp[i++] = '.';
+				}
+			}
+		}
+
+		i = put_dec(tmp + i, num) - tmp;
 	}
 
 	/* printing 100 using %2d gives "100", not "00" */
@@ -1127,6 +1148,7 @@ int format_decode(const char *fmt, struct printf_spec *spec)
 		case ' ': spec->flags |= SPACE;   break;
 		case '#': spec->flags |= SPECIAL; break;
 		case '0': spec->flags |= ZEROPAD; break;
+		case 'h': spec->flags |= HUNITS;  break;
 		default:  found = false;
 		}
 
-- 
1.7.7.3

