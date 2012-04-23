Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755154Ab2DWNLO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 09:11:14 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:56854 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752526Ab2DWNLN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 09:11:13 -0400
Date: Mon, 23 Apr 2012 16:11:06 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Add kabs()
Message-ID: <20120423131106.GA27574@p183.telecom.by>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is abs() and abs64().
They have following unwanted or suprising properties:
1) They return signed value
	in math norms et al are unsigned

2) In finest Unix tradition they do not work reliably.
   Quoting abs(3).
	"Trying to take the absolute value of the most negative integer is not defined."

3) They expand type needlessly

4) There are 2 of them with different names
	with gcc extensions __builtin_choose_expr(),
	__builtin_types_compatible_p() we can mimic type dispatch as found
	in modern programming languages.

Enter kabs().

kabs() has the following nice properties which should have been there
from day 1.

kabs() return unsigned value.
kabs() works for all integer types and return correct result.
sizeof(kabs(x)) == sizeof(x)

Mention kabs() in checkpatch.pl so people would gradually convert.
abs() and abs64() will eventually dissapear.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 include/linux/kernel.h |   29 +++++++++++++++++++++++++++++
 scripts/checkpatch.pl  |    6 ++++++
 2 files changed, 35 insertions(+)

--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -188,6 +188,35 @@ extern int _cond_resched(void);
 		(__x < 0) ? -__x : __x;		\
 	})
 
+#define kabs(x)								\
+({									\
+	typeof(x) _x = (x);						\
+									\
+	/*								\
+	 * "char", "signed char", "unsigned char" aren't compatible	\
+	 * regardless of -f{un,}signed-char.				\
+	 */
+	__builtin_choose_expr(						\
+		__builtin_types_compatible_p(typeof(_x), signed char),	\
+		(unsigned char)({ _x < 0 ? -_x : _x; }),		\
+	__builtin_choose_expr(						\
+		__builtin_types_compatible_p(typeof(_x), char),		\
+		(unsigned char)({ _x < 0 ? -_x : _x; }),		\
+	__builtin_choose_expr(						\
+		__builtin_types_compatible_p(typeof(_x), short),	\
+		(unsigned short)({ _x < 0 ? -_x : _x; }),		\
+	__builtin_choose_expr(						\
+		__builtin_types_compatible_p(typeof(_x), int),		\
+		(unsigned int)({ _x < 0 ? -_x : _x; }),			\
+	__builtin_choose_expr(						\
+		__builtin_types_compatible_p(typeof(_x), long),		\
+		(unsigned long)({ _x < 0 ? -_x : _x; }),		\
+	__builtin_choose_expr(						\
+		__builtin_types_compatible_p(typeof(_x), long long),	\
+		(unsigned long long)({ _x < 0 ? -_x : _x; }),		\
+	_x))))));							\
+})
+
 #ifdef CONFIG_PROVE_LOCKING
 void might_fault(void);
 #else
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -3347,6 +3347,12 @@ sub process {
 			     "__func__ should be used instead of gcc specific __FUNCTION__\n"  . $herecurr);
 		}
 
+# check for abs(), abs64()
+		if ($line =~ /\b(abs64|abs)\s*\(/) {
+			WARN("CONSIDER_KABS",
+			     "$1 is obsolete, use kabs\n" . $herecurr);
+		}
+
 # check for use of yield()
 		if ($line =~ /\byield\s*\(\s*\)/) {
 			WARN("YIELD",
