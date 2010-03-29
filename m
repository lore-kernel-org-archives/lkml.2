Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753933Ab0C2VJw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 17:09:52 -0400
Received: from mail.perches.com ([173.55.12.10]:1236 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753051Ab0C2VJv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 17:09:51 -0400
Subject: [PATCH] kernel.h: Convert rounding macros to statement
 expressions, add ADD_MOD
From: Joe Perches <joe@perches.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Jiri Kosina <trivial@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1269892842.4558.7.camel@Joe-Laptop.home>
References: <1269813447.1500.69.camel@Joe-Laptop.home>
	 <20100329124708.898b617c.randy.dunlap@oracle.com>
	 <1269892842.4558.7.camel@Joe-Laptop.home>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 29 Mar 2010 14:09:49 -0700
Message-ID: <1269896989.4558.18.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-03-29 at 13:00 -0700, Joe Perches wrote:
> On Mon, 2010-03-29 at 12:47 -0700, Randy Dunlap wrote:
> > On Sun, 28 Mar 2010 14:57:27 -0700 Joe Perches wrote:
> > > Add a macro for the somewhat common use of
> > > 	(something + value) % value
> > > because the test uses ADD_MOD
> > > --- a/include/linux/kernel.h
> > > +++ b/include/linux/kernel.h
> > > +#define ADD_MOD(x, y) (((x) + (y)) % (y))
> > It would be better not to evaluate y more than one time.

Do you prefer something like this?

Convert rounding macros to statement expressions
so arguments are only evaluated once.
Add kernel-doc to rounding macros
Add ADD_MOD statement expression for "(x + y) % y"

Signed-off-by: Joe Perches <joe@perches.com>
---
 include/linux/kernel.h |   65 +++++++++++++++++++++++++++++++++++++++++------
 1 files changed, 56 insertions(+), 9 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index c96b1ac..6b92b20 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -55,15 +55,62 @@ extern const char linux_proc_banner[];
 #define round_down(x, y) ((x) & ~__round_mask(x, y))
 
 #define FIELD_SIZEOF(t, f) (sizeof(((t*)0)->f))
-#define DIV_ROUND_UP(n,d) (((n) + (d) - 1) / (d))
-#define roundup(x, y) ((((x) + ((y) - 1)) / (y)) * (y))
-#define DIV_ROUND_CLOSEST(x, divisor)(			\
-{							\
-	typeof(divisor) __divisor = divisor;		\
-	(((x) + ((__divisor) / 2)) / (__divisor));	\
-}							\
-)
-#define ADD_MOD(x, y) (((x) + (y)) % (y))
+
+/**
+ * roundup() - Returns x rounded up to the next whole multiple of y
+ * @x:	dividend
+ * @y:	divisor
+ *
+ * ie: roundup(4, 2) is 4, roundup(5, 2) is 6
+ * c type conversion rules apply when x and y types differ
+ */
+#define roundup(x, y)				\
+({						\
+	typeof(y) _y = y;			\
+	((x) + (_y - 1) / _y) * _y;		\
+})
+
+/**
+ * DIV_ROUND_UP() - Returns x/y rounded up to the next whole number
+ * @x:	dividend
+ * @y:	divisor
+ *
+ * ie: DIV_ROUND_UP(4, 2) is 2, DIV_ROUND_UP(5, 2) is 3
+ * c type conversion rules apply when x and y types differ
+ */
+#define DIV_ROUND_UP(x, y)			\
+({						\
+	typeof(y) _y = y;			\
+	((x) + _y - 1) / _y;			\
+})
+
+/**
+ * DIV_ROUND_CLOSEST() - Returns x/y rounded to the nearest whole number
+ * @x:	dividend
+ * @y:	divisor
+ *
+ * ie: DIV_ROUND_CLOSEST(4, 3) is 1, DIV_ROUND_CLOSEST(5, 3) is 2
+ * c type conversion rules apply when x and y types differ
+ */
+#define DIV_ROUND_CLOSEST(x, y)			\
+({						\
+	typeof(y) _y = y;			\
+	((x) + (_y / 2)) / _y;			\
+})
+
+/**
+ * ADD_MOD() - Returns (x + y) % y
+ * @x:	initial value
+ * @y:	value added to x then used as modulo
+ *
+ * ie: ADD_MOD(4, 2) is 0, ADD_MOD(5, 2) is 1
+ * c type conversion rules apply when x and y types differ
+ */
+#define ADD_MOD(x, y)				\
+({						\
+	typeof(y) _y = y;			\
+	((x) + _y) % _y;			\
+})
 
 #define _RET_IP_		(unsigned long)__builtin_return_address(0)
 #define _THIS_IP_  ({ __label__ __here; __here: (unsigned long)&&__here; })



