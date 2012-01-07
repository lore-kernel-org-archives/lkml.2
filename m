Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752690Ab2AGNaR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jan 2012 08:30:17 -0500
Received: from mga14.intel.com ([143.182.124.37]:10150 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751887Ab2AGNaP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jan 2012 08:30:15 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="93404985"
Date: Sat, 7 Jan 2012 21:30:09 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH -next] fs: fix fs/fs-writeback.c build error
Message-ID: <20120107133008.GA21128@localhost>
References: <20120105191218.42825638a431bc1aba4879de@canb.auug.org.au>
 <4F063DD6.5050403@xenotime.net>
 <CA+55aFx7vzez6C5M6EmZPDmkHig-mY=p64vZWWmWWe-nmxH4=w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+55aFx7vzez6C5M6EmZPDmkHig-mY=p64vZWWmWWe-nmxH4=w@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 06, 2012 at 03:01:09PM -0800, Linus Torvalds wrote:
> On Thu, Jan 5, 2012 at 4:18 PM, Randy Dunlap <rdunlap@xenotime.net> wrote:
> >
> > In linux-next, fs/fs-writeback.c no longer #includes <linux/buffer_head.h>,
> > which #included <linux/pagemap.h>, so add that latter header file to
> > <linux/writeback.h> to fix the build error:
> >
> > fs/fs-writeback.c:510:11: error: 'PAGE_CACHE_SHIFT' undeclared (first use in this function)
> 
> I would actually suggest:
> 
>  - move the whole MIN_WRITEBACK_PAGES #define from the header file to
> fs/writeback.c

Done.

> (why expose such a random #define to outside users that
> have nothing to do with it?)
 
Yeah, there were some early patches that reference MIN_WRITEBACK_PAGES
from other files, which are dropped later..

>  - make sure that fs/fs-writeback.c has that pagemap.h #include.

Done. (otherwise it won't compile)

> There's no reason why <linux/writeback.h> should include filemap.h per
> se, and there is no reason why it should expose some internal chunking
> #define to anybody else.

Good point. I'll queue this patch to writeback-for-next:

Subject: writeback: move MIN_WRITEBACK_PAGES to fs-writeback.c
Date: Sat Jan 07 20:41:55 CST 2012

Fix compile error

 fs/fs-writeback.c:515:33: error: ‘PAGE_CACHE_SHIFT’ undeclared (first use in this function)

Reported-by: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/fs-writeback.c         |    6 ++++++
 include/linux/writeback.h |    5 -----
 2 files changed, 6 insertions(+), 5 deletions(-)

--- next.orig/fs/fs-writeback.c	2012-01-07 21:01:34.552000061 +0800
+++ next/fs/fs-writeback.c	2012-01-07 21:22:45.504000051 +0800
@@ -20,6 +20,7 @@
 #include <linux/sched.h>
 #include <linux/fs.h>
 #include <linux/mm.h>
+#include <linux/pagemap.h>
 #include <linux/kthread.h>
 #include <linux/freezer.h>
 #include <linux/writeback.h>
@@ -29,6 +30,11 @@
 #include "internal.h"
 
 /*
+ * 4MB minimal write chunk size
+ */
+#define MIN_WRITEBACK_PAGES	(4096UL >> (PAGE_CACHE_SHIFT - 10))
+
+/*
  * Passed into wb_writeback(), essentially a subset of writeback_control
  */
 struct wb_writeback_work {
--- next.orig/include/linux/writeback.h	2012-01-07 21:01:34.544000059 +0800
+++ next/include/linux/writeback.h	2012-01-07 21:13:09.008000026 +0800
@@ -25,11 +25,6 @@ DECLARE_PER_CPU(int, dirty_throttle_leak
 #define DIRTY_SCOPE		8
 #define DIRTY_FULL_SCOPE	(DIRTY_SCOPE / 2)
 
-/*
- * 4MB minimal write chunk size
- */
-#define MIN_WRITEBACK_PAGES	(4096UL >> (PAGE_CACHE_SHIFT - 10))
-
 struct backing_dev_info;
 
 /*
