Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758071Ab2IRLcC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 07:32:02 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:59575 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751619Ab2IRLcA convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:3:1>);
	Tue, 18 Sep 2012 07:32:00 -0400
Message-Id: <505877CE020000780009C02B@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Tue, 18 Sep 2012 12:31:58 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: <akpm@linux-foundation.org>
Cc: "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] improve standard conformance of sscanf()
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Xen's pciback points out a couple of deficiencies with vsscanf()'s
standard conformance:

- Trailing character matching cannot be checked by the caller: With a
  format string of "(%x:%x.%x) %n" absence of the closing parenthesis
  cannot be checked, as input of "(00:00.0)" doesn't cause the %n to be
  evaluated (because of the code not skipping white space before the
  trailing %n).
- The parameter corresponding to a trailing %n could get filled even if
  there was a matching error: With a format string of "(%x:%x.%x)%n",
  input of "(00:00.0]" would still fill the respective variable pointed
  to (and hence again make the mismatch non-detectable by the caller).

This patch aims at fixing those, but leaves other non-conforming
aspects of it untouched, among them these possibly relevant ones:
- improper handling of the assignment suppression character '*'
  (blindly discarding all succeeding non-white space from the format
  and input strings),
- not honoring conversion specifiers for %n,
- not recognizing the C99 conversion specifier 't' (recognized by
  vsprintf()).

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

---
 lib/vsprintf.c |   33 ++++++++++++++-------------------
 1 file changed, 14 insertions(+), 19 deletions(-)

--- 3.6-rc6/lib/vsprintf.c
+++ 3.6-rc6-sscanf-conformance/lib/vsprintf.c
@@ -2017,7 +2017,7 @@ int vsscanf(const char *buf, const char 
 	s16 field_width;
 	bool is_sign;
 
-	while (*fmt && *str) {
+	while (*fmt) {
 		/* skip any white space in format */
 		/* white space in format matchs any amount of
 		 * white space, including none, in the input.
@@ -2042,6 +2042,8 @@ int vsscanf(const char *buf, const char 
 		 * advance both strings to next white space
 		 */
 		if (*fmt == '*') {
+			if (!*str)
+				break;
 			while (!isspace(*fmt) && *fmt != '%' && *fmt)
 				fmt++;
 			while (!isspace(*str) && *str)
@@ -2070,7 +2072,17 @@ int vsscanf(const char *buf, const char 
 			}
 		}
 
-		if (!*fmt || !*str)
+		if (!*fmt)
+			break;
+
+		if (*fmt == 'n') {
+			/* return number of characters read so far */
+			*va_arg(args, int *) = str - buf;
+			++fmt;
+			continue;
+		}
+
+		if (!*str)
 			break;
 
 		base = 10;
@@ -2103,13 +2115,6 @@ int vsscanf(const char *buf, const char 
 			num++;
 		}
 		continue;
-		case 'n':
-			/* return number of characters read so far */
-		{
-			int *i = (int *)va_arg(args, int*);
-			*i = str - buf;
-		}
-		continue;
 		case 'o':
 			base = 8;
 			break;
@@ -2210,16 +2215,6 @@ int vsscanf(const char *buf, const char 
 		str = next;
 	}
 
-	/*
-	 * Now we've come all the way through so either the input string or the
-	 * format ended. In the former case, there can be a %n at the current
-	 * position in the format that needs to be filled.
-	 */
-	if (*fmt == '%' && *(fmt + 1) == 'n') {
-		int *p = (int *)va_arg(args, int *);
-		*p = str - buf;
-	}
-
 	return num;
 }
 EXPORT_SYMBOL(vsscanf);



