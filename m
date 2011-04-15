Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753748Ab1DOFKH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 01:10:07 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:52649 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751093Ab1DOFKF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 01:10:05 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: [PATCH] define dummy BUILD_BUG_ON definition for sparse
Cc: kosaki.motohiro@jp.fujitsu.com, Dave Hansen <dave@linux.vnet.ibm.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20110415121424.F7A6.A69D9226@jp.fujitsu.com>
References: <20110414234216.9E31DBD9@kernel> <20110415121424.F7A6.A69D9226@jp.fujitsu.com>
Message-Id: <20110415140952.F7AE.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
X-Mailer: Becky! ver. 2.56.05 [ja]
Date: Fri, 15 Apr 2011 14:09:59 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hello,
> 
> > diff -puN include/linux/gfp.h~make-sparse-happy-with-gfp_h include/linux/gfp.h
> > --- linux-2.6.git/include/linux/gfp.h~make-sparse-happy-with-gfp_h	2011-04-14 14:47:02.629275904 -0700
> > +++ linux-2.6.git-dave/include/linux/gfp.h	2011-04-14 14:47:38.813272674 -0700
> > @@ -249,14 +249,9 @@ static inline enum zone_type gfp_zone(gf
> >  
> >  	z = (GFP_ZONE_TABLE >> (bit * ZONES_SHIFT)) &
> >  					 ((1 << ZONES_SHIFT) - 1);
> > -
> > -	if (__builtin_constant_p(bit))
> > -		BUILD_BUG_ON((GFP_ZONE_BAD >> bit) & 1);
> > -	else {
> >  #ifdef CONFIG_DEBUG_VM
> > -		BUG_ON((GFP_ZONE_BAD >> bit) & 1);
> > +	BUG_ON((GFP_ZONE_BAD >> bit) & 1);
> >  #endif
> > -	}
> >  	return z;
> 
> Why don't you use VM_BUG_ON?

After while thinking, I decided to make another patch. If we take your
approach we will remove all BUILD_BUG_ON eventually. It's no happy result.


>From 2da32b2875a6bd0bb0166993b4663eac0c5d1d6d Mon Sep 17 00:00:00 2001
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Date: Fri, 15 Apr 2011 13:37:24 +0900
Subject: [PATCH] define dummy BUILD_BUG_ON definition for sparse

BUILD_BUG_ON() makes syntax error to detect coding error. Then it
naturally makes sparse error too. It reduce sparse usefulness.

Then, this patch makes dummy BUILD_BUG_ON() definition for sparse.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 include/linux/kernel.h |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 00cec4d..9ac44b8 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -637,6 +637,14 @@ struct sysinfo {
 	char _f[20-2*sizeof(long)-sizeof(int)];	/* Padding: libc5 uses this.. */
 };
 
+#ifdef __CHECKER__
+#define BUILD_BUG_ON_NOT_POWER_OF_2(n)
+#define BUILD_BUG_ON_ZERO(e)
+#define BUILD_BUG_ON_NULL(e)
+#define BUILD_BUG_ON(condition)
+#else /* __CHECKER__ */
+
 /* Force a compilation error if a constant expression is not a power of 2 */
 #define BUILD_BUG_ON_NOT_POWER_OF_2(n)			\
 	BUILD_BUG_ON((n) == 0 || (((n) & ((n) - 1)) != 0))
@@ -673,6 +681,7 @@ extern int __build_bug_on_failed;
 		if (condition) __build_bug_on_failed = 1;	\
 	} while(0)
 #endif
+#endif /* __CHECKER__ */
 
 /* Trap pasters of __FUNCTION__ at compile-time */
 #define __FUNCTION__ (__func__)
-- 
1.7.3.1





