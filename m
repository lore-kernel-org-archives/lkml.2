Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753975Ab0C2WSh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 18:18:37 -0400
Received: from mail.perches.com ([173.55.12.10]:1240 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751156Ab0C2WSg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 18:18:36 -0400
Subject: [PATCH V2] kernel.h: Convert rounding macros to statement
 expressions, add ADD_MOD
From: Joe Perches <joe@perches.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Jiri Kosina <trivial@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20100329144924.d00f0680.randy.dunlap@oracle.com>
References: <1269813447.1500.69.camel@Joe-Laptop.home>
	 <20100329124708.898b617c.randy.dunlap@oracle.com>
	 <1269892842.4558.7.camel@Joe-Laptop.home>
	 <1269896989.4558.18.camel@Joe-Laptop.home>
	 <20100329144924.d00f0680.randy.dunlap@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 29 Mar 2010 15:18:34 -0700
Message-ID: <1269901114.4558.47.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-03-29 at 14:49 -0700, Randy Dunlap wrote:
> > Do you prefer something like this?
> Yes, thanks.
> > +#define roundup(x, y)				\
> > +({						\
> > +	typeof(y) _y = y;			\
> > +	((x) + (_y - 1) / _y) * _y;		\
> Above needs an extra set of parens:
> 	(((x) + (_y - 1)) / _y) * _y;		\

Thanks.  I think it's clearer matched to the DIV_ROUND_UP style:
	(((x) + _y - 1) / _y) * _y;

----------------

Convert rounding macros to statement expressions
so arguments are only evaluated once.
Add kernel-doc to rounding macros
Add ADD_MOD statement expression for "(x + y) % y"

Signed-off-by: Joe Perches <joe@perches.com>
Reviewed-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 include/linux/kernel.h |   66 +++++++++++++++++++++++++++++++++++++++++------
 1 files changed, 57 insertions(+), 9 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index c96b1ac..029db3b 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -55,15 +55,63 @@ extern const char linux_proc_banner[];
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
+	(((x) + _y - 1) / _y) * _y;		\
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
+ * Rounds up when .5, ie: DIV_ROUND_CLOSEST(5, 2) is 3
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


