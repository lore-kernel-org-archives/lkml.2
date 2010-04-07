Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932857Ab0DGQWT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 12:22:19 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:62987 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932672Ab0DGQWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 12:22:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=gDI7M7NlrcU0OEc3LzS262kyNTChM1DugqUg2xR4S2yLRkE/TDOw2StAyf4Fw7Sfms
         0lb3CPLIysQD9+ajiBBvNHmUxw4z5popgv0KROdHtzyH3wNagVpWgbCeKjF+XOv2xv9L
         uYJ3OHFrMjSlF96Z1i2EqyuYk4FaD8oRCcfNc=
Date: Wed, 7 Apr 2010 19:22:46 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: kaber@trash.net
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       shemminger@vyatta.com, bhutchings@solarflare.com, andreas@fatal.se,
       hadi@cyberus.ca, hideaki@yoshifuji.org
Subject: [PATCH] xtables: make XT_ALIGN() usable in exported headers by
 exporting __ALIGN_KERNEL()
Message-ID: <20100407162245.GA4557@x200>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

XT_ALIGN() was rewritten through ALIGN() by commit 42107f5009da223daa800d6da6904d77297ae829
"netfilter: xtables: symmetric COMPAT_XT_ALIGN definition".
ALIGN() is not exported in userspace headers, which created compile problem for tc(8)
and will create problem for iptables(8).

We can't export generic looking name ALIGN() but we can export less generic
__ALIGN_KERNEL() (suggested by Ben Hutchings).
Google knows nothing about __ALIGN_KERNEL().

COMPAT_XT_ALIGN() changed for symmetry.

Reported-by: Andreas Henriksson <andreas@fatal.se>
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 include/linux/kernel.h             |    5 +++--
 include/linux/netfilter/x_tables.h |    6 +++---
 2 files changed, 6 insertions(+), 5 deletions(-)

--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -4,6 +4,8 @@
 /*
  * 'kernel.h' contains some often-used function prototypes etc
  */
+#define __ALIGN_KERNEL(x, a)		__ALIGN_KERNEL_MASK(x, (typeof(x))(a) - 1)
+#define __ALIGN_KERNEL_MASK(x, mask)	(((x) + (mask)) & ~(mask))
 
 #ifdef __KERNEL__
 
@@ -37,8 +39,7 @@ extern const char linux_proc_banner[];
 
 #define STACK_MAGIC	0xdeadbeef
 
-#define ALIGN(x,a)		__ALIGN_MASK(x,(typeof(x))(a)-1)
-#define __ALIGN_MASK(x,mask)	(((x)+(mask))&~(mask))
+#define ALIGN(x, a)		__ALIGN_KERNEL((x), (a))
 #define PTR_ALIGN(p, a)		((typeof(p))ALIGN((unsigned long)(p), (a)))
 #define IS_ALIGNED(x, a)		(((x) & ((typeof(x))(a) - 1)) == 0)
 
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -1,6 +1,6 @@
 #ifndef _X_TABLES_H
 #define _X_TABLES_H
-
+#include <linux/kernel.h>
 #include <linux/types.h>
 
 #define XT_FUNCTION_MAXNAMELEN 30
@@ -93,7 +93,7 @@ struct _xt_align {
 	__u64 u64;
 };
 
-#define XT_ALIGN(s) ALIGN((s), __alignof__(struct _xt_align))
+#define XT_ALIGN(s) __ALIGN_KERNEL((s), __alignof__(struct _xt_align))
 
 /* Standard return verdict, or do jump. */
 #define XT_STANDARD_TARGET ""
@@ -598,7 +598,7 @@ struct _compat_xt_align {
 	compat_u64 u64;
 };
 
-#define COMPAT_XT_ALIGN(s) ALIGN((s), __alignof__(struct _compat_xt_align))
+#define COMPAT_XT_ALIGN(s) __ALIGN_KERNEL((s), __alignof__(struct _compat_xt_align))
 
 extern void xt_compat_lock(u_int8_t af);
 extern void xt_compat_unlock(u_int8_t af);
