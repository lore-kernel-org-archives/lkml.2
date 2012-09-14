Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753006Ab2INNPQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 09:15:16 -0400
Received: from fieldses.org ([174.143.236.118]:56975 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751306Ab2INNPN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 09:15:13 -0400
Date: Fri, 14 Sep 2012 09:14:57 -0400
From: "J. Bruce Fields" <bfields@fieldses.org>
To: Jim Rees <rees@umich.edu>
Cc: Bernd Petrovitsch <bernd@petrovitsch.priv.at>,
        Jan Engelhardt <jengelh@inai.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] strings: helper for maximum decimal encoding of an
 unsigned integer
Message-ID: <20120914131457.GA19666@fieldses.org>
References: <20120821212910.GD18637@fieldses.org>
 <alpine.LNX.2.01.1209100803060.22738@frira.zrqbmnf.qr>
 <1347614276.26071.15.camel@thorin>
 <20120914123014.GB29160@umich.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120914123014.GB29160@umich.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 14, 2012 at 08:30:14AM -0400, Jim Rees wrote:
> But I still like my way better.

Yeah.  It looks less mysterious once you realize it's just a
straightforward application of the usual coincidence

	2^10 = 1024 ~ 1000 = 10^3

How about this?  Also with some more defines because I like typing

	char buf[ULONG_STR_MAX + 1];

better than

	char bug[base10len(unsigned long) + 1];

--b.

commit 59a620640cd05d3d29e678ff893cfe266091fba7
Author: J. Bruce Fields <bfields@redhat.com>
Date:   Wed Aug 15 17:41:47 2012 -0400

    strings: helper for maximum decimal encoding of an unsigned integer
    
    I've seen a couple examples recently where we've gotten this wrong.
    Maybe something like this would help?
    
    Suggested-by: Jim Rees <rees@umich.edu>
    Signed-off-by: J. Bruce Fields <bfields@redhat.com>

diff --git a/include/linux/string.h b/include/linux/string.h
index ffe0442..38da7a0 100644
--- a/include/linux/string.h
+++ b/include/linux/string.h
@@ -126,6 +126,27 @@ extern void argv_free(char **argv);
 extern bool sysfs_streq(const char *s1, const char *s2);
 extern int strtobool(const char *s, bool *res);
 
+/*
+ * length of the decimal representation of an integer, not including any
+ * sign or null termination.  Just an approximation, but it's right for
+ * unsigned types of size 1 to 26 bytes:
+ */
+#define base10len(i) (sizeof(i) * 8 * 3 / 10 + 1)
+
+/* Actually a slight overestimate in the signed 64-bit case: */
+
+#define UCHAR_STR_MAX	base10len(char)
+#define CHAR_STR_MAX	base10len(char) + 1
+#define UINT_STR_MAX	base10len(int)
+#define INT_STR_MAX	base10len(int) + 1
+#define ULONG_STR_MAX	base10len(long)
+#define LONG_STR_MAX	base10len(long) + 1
+
+#define U32_STR_MAX	base10len(u32)
+#define S32_STR_MAX	base10len(u32) + 1
+#define U64_STR_MAX	base10len(u64)
+#define S64_STR_MAX	base10len(u64) + 1
+
 #ifdef CONFIG_BINARY_PRINTF
 int vbin_printf(u32 *bin_buf, size_t size, const char *fmt, va_list args);
 int bstr_printf(char *buf, size_t size, const char *fmt, const u32 *bin_buf);
diff --git a/net/sunrpc/cache.c b/net/sunrpc/cache.c
index 2afd2a8..d80d482 100644
--- a/net/sunrpc/cache.c
+++ b/net/sunrpc/cache.c
@@ -1409,7 +1409,7 @@ static ssize_t read_flush(struct file *file, char __user *buf,
 			  size_t count, loff_t *ppos,
 			  struct cache_detail *cd)
 {
-	char tbuf[20];
+	char tbuf[ULONG_STR_MAX + 1];
 	unsigned long p = *ppos;
 	size_t len;
 
