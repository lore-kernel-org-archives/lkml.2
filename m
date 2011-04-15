Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754246Ab1DOFLT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 01:11:19 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:52707 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752938Ab1DOFLS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 01:11:18 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: [PATCH] define __must_be_array() for __CHECKER__
Cc: kosaki.motohiro@jp.fujitsu.com, Dave Hansen <dave@linux.vnet.ibm.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20110415140952.F7AE.A69D9226@jp.fujitsu.com>
References: <20110415121424.F7A6.A69D9226@jp.fujitsu.com> <20110415140952.F7AE.A69D9226@jp.fujitsu.com>
Message-Id: <20110415141110.F7B2.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
X-Mailer: Becky! ver. 2.56.05 [ja]
Date: Fri, 15 Apr 2011 14:11:15 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes another sparse splat.


>From 711131e2e16925970a67103156af1296993dbc93 Mon Sep 17 00:00:00 2001
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Date: Fri, 15 Apr 2011 13:28:16 +0900
Subject: [PATCH] define __must_be_array() for __CHECKER__

commit c5e631cf65f (ARRAY_SIZE: check for type) added __must_be_array().
but sparse can't parse this gcc extention.

Then, now make C=2 makes following sparse errors a lot.

  kernel/futex.c:2699:25: error: No right hand side of '+'-expression

Because __must_be_array() is used for ARRAY_SIZE() macro and it is
used very widely.

This patch fixes it.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 include/linux/compiler-gcc.h |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/include/linux/compiler-gcc.h b/include/linux/compiler-gcc.h
index cb4c1eb..59e4028 100644
--- a/include/linux/compiler-gcc.h
+++ b/include/linux/compiler-gcc.h
@@ -34,8 +34,12 @@
     __asm__ ("" : "=r"(__ptr) : "0"(ptr));		\
     (typeof(ptr)) (__ptr + (off)); })
 
+#ifdef __CHECKER__
+#define __must_be_array(arr) 0
+#else
 /* &a[0] degrades to a pointer: a different type from an array */
 #define __must_be_array(a) BUILD_BUG_ON_ZERO(__same_type((a), &(a)[0]))
+#endif
 
 /*
  * Force always-inline if the user requests it so via the .config,
-- 
1.7.3.1



