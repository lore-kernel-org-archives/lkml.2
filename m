Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753725Ab2FLPno (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 11:43:44 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:61603 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753515Ab2FLPjs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 11:39:48 -0400
From: Kent Overstreet <koverstreet@google.com>
To: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com
Cc: Kent Overstreet <koverstreet@google.com>, tejun@google.com, agk@redhat.com,
        dan.j.williams@intel.com
Subject: [Bcache v14 04/16] Add human-readable units modifier to vsnprintf()
Date: Tue, 12 Jun 2012 08:39:10 -0700
Message-Id: <1339515562-14638-5-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.7.9.3.327.g2980b
In-Reply-To: <1339515562-14638-1-git-send-email-koverstreet@google.com>
References: <1339515562-14638-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Kent Overstreet <koverstreet@google.com>
---
 lib/vsprintf.c |   24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

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
1.7.9.3.327.g2980b

