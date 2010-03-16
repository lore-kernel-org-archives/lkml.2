Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937388Ab0CPBl6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 21:41:58 -0400
Received: from mga14.intel.com ([143.182.124.37]:5056 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932833Ab0CPBlq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 21:41:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,647,1262592000"; 
   d="scan'208";a="255024392"
Message-Id: <20100316013841.130182179@intel.com>
User-Agent: quilt/0.48-1
Date: Tue, 16 Mar 2010 09:36:54 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>, LKML <linux-kernel@vger.kernel.org>,
       David Miller <davem@davemloft.net>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Al Viro <viro@zeniv.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>, Eric Paris <eparis@redhat.com>,
       Roland Dreier <rdreier@cisco.com>, Jamie Lokier <jamie@shareable.org>,
       Andreas Schwab <schwab@linux-m68k.org>
Subject: [PATCH 1/3] vfs: O_* bit numbers uniqueness check
References: <20100316013653.367442879@intel.com>
Content-Disposition: inline; filename=mutt-wfg-t61-1000-6194-5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The O_* bit numbers are defined in 20+ arch/*, and can silently overlap.
Add a compile time check to ensure the uniqueness as suggested by David
Miller.

Cc: David Miller <davem@davemloft.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Eric Paris <eparis@redhat.com>
Cc: Roland Dreier <rdreier@cisco.com>
Cc: Jamie Lokier <jamie@shareable.org>
Cc: Andreas Schwab <schwab@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---

 fs/fcntl.c                  |   14 ++++++++++++--
 include/asm-generic/fcntl.h |    4 ++++
 2 files changed, 16 insertions(+), 2 deletions(-)

--- linux-mm.orig/fs/fcntl.c	2010-03-16 09:18:28.000000000 +0800
+++ linux-mm/fs/fcntl.c	2010-03-16 09:32:17.000000000 +0800
@@ -739,11 +739,21 @@ void kill_fasync(struct fasync_struct **
 }
 EXPORT_SYMBOL(kill_fasync);
 
-static int __init fasync_init(void)
+static int __init fcntl_init(void)
 {
+	/* please add new bits here to ensure allocation uniqueness */
+	BUILD_BUG_ON(17 != HWEIGHT32(
+		O_RDONLY	| O_WRONLY	| O_RDWR	|
+		O_CREAT		| O_EXCL	| O_NOCTTY	|
+		O_TRUNC		| O_APPEND	| O_NONBLOCK	|
+		__O_SYNC	| O_DSYNC	| FASYNC	|
+		O_DIRECT	| O_LARGEFILE	| O_DIRECTORY	|
+		O_NOFOLLOW	| O_NOATIME	| O_CLOEXEC
+		));
+
 	fasync_cache = kmem_cache_create("fasync_cache",
 		sizeof(struct fasync_struct), 0, SLAB_PANIC, NULL);
 	return 0;
 }
 
-module_init(fasync_init)
+module_init(fcntl_init)
--- linux-mm.orig/include/asm-generic/fcntl.h	2010-03-16 09:31:16.000000000 +0800
+++ linux-mm/include/asm-generic/fcntl.h	2010-03-16 09:33:30.000000000 +0800
@@ -3,6 +3,10 @@
 
 #include <linux/types.h>
 
+/*
+ * When introducing new O_* bits, please check its uniqueness in fcntl_init().
+ */
+
 #define O_ACCMODE	00000003
 #define O_RDONLY	00000000
 #define O_WRONLY	00000001


