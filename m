Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757366Ab1IABOG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 21:14:06 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:59835 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752307Ab1IABOC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 21:14:02 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-11.tower-209.messagelabs.com!1314839641!15151416!1
X-Originating-IP: [216.166.12.31]
X-StarScan-Version: 6.3.6; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: lib/bitmap.c: quiet sparse noise about address space
Date: Wed, 31 Aug 2011 18:13:38 -0700
User-Agent: KMail/1.9.9
CC: <akpm@linux-foundation.org>, <len.brown@intel.com>, <ying.huang@intel.com>,
        <andy.shevchenko@gmail.com>, <ak@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201108311813.39282.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The functions __bitmap_parse and __bitmap_parselist both take a pointer
to a kernel buffer as a parameter and then cast it to a pointer to user
buffer for use in cases when the parameter is_user indicates that the
buffer is actually located in user space. This casting, and the casts
in the callers, results in sparse noise like the following:

	warning: incorrect type in initializer (different address spaces)
	  expected char const [noderef] <asn:1>*ubuf
	  got char const *buf
	warning: cast removes address space of expression

Since these casts are intentional, use __force to quiet the noise.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Len Brown <len.brown@intel.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Andi Kleen <ak@linux.intel.com>

---

diff --git a/lib/bitmap.c b/lib/bitmap.c
index 2f4412e..b7b71bd 100644
--- a/lib/bitmap.c
+++ b/lib/bitmap.c
@@ -419,7 +419,7 @@ int __bitmap_parse(const char *buf, unsigned int buflen,
 {
 	int c, old_c, totaldigits, ndigits, nchunks, nbits;
 	u32 chunk;
-	const char __user *ubuf = buf;
+	const char __user __force *ubuf = buf;
 
 	bitmap_zero(maskp, nmaskbits);
 
@@ -504,7 +504,9 @@ int bitmap_parse_user(const char __user *ubuf,
 {
 	if (!access_ok(VERIFY_READ, ubuf, ulen))
 		return -EFAULT;
-	return __bitmap_parse((const char *)ubuf, ulen, 1, maskp, nmaskbits);
+	return __bitmap_parse((const char __force *)ubuf,
+				ulen, 1, maskp, nmaskbits);
+
 }
 EXPORT_SYMBOL(bitmap_parse_user);
 
@@ -594,7 +596,7 @@ static int __bitmap_parselist(const char *buf, unsigned int buflen,
 {
 	unsigned a, b;
 	int c, old_c, totaldigits;
-	const char __user *ubuf = buf;
+	const char __user __force *ubuf = buf;
 	int exp_digit, in_range;
 
 	totaldigits = c = 0;
@@ -694,7 +696,7 @@ int bitmap_parselist_user(const char __user *ubuf,
 {
 	if (!access_ok(VERIFY_READ, ubuf, ulen))
 		return -EFAULT;
-	return __bitmap_parselist((const char *)ubuf,
+	return __bitmap_parselist((const char __force *)ubuf,
 					ulen, 1, maskp, nmaskbits);
 }
 EXPORT_SYMBOL(bitmap_parselist_user);
