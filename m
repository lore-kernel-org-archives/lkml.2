Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932715Ab2HGDqG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 23:46:06 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:59846 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964812Ab2HGDiy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 23:38:54 -0400
Message-Id: <20120807032800.941403326@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Tue, 07 Aug 2012 04:28:28 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Tony Luck <tony.luck@intel.com>
Subject: [ 33/70] [IA64] Redefine ATOMIC_INIT and ATOMIC64_INIT to drop the casts
In-Reply-To: <20120807032755.803571133@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tony Luck <tony.luck@intel.com>

commit a119365586b0130dfea06457f584953e0ff6481d upstream.

The following build error occured during a ia64 build with
swap-over-NFS patches applied.

net/core/sock.c:274:36: error: initializer element is not constant
net/core/sock.c:274:36: error: (near initialization for 'memalloc_socks')
net/core/sock.c:274:36: error: initializer element is not constant

This is identical to a parisc build error. Fengguang Wu, Mel Gorman
and James Bottomley did all the legwork to track the root cause of
the problem. This fix and entire commit log is shamelessly copied
from them with one extra detail to change a dubious runtime use of
ATOMIC_INIT() to atomic_set() in drivers/char/mspec.c

Dave Anglin says:
> Here is the line in sock.i:
>
> struct static_key memalloc_socks = ((struct static_key) { .enabled =
> ((atomic_t) { (0) }) });

The above line contains two compound literals.  It also uses a designated
initializer to initialize the field enabled.  A compound literal is not a
constant expression.

The location of the above statement isn't fully clear, but if a compound
literal occurs outside the body of a function, the initializer list must
consist of constant expressions.

Signed-off-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/ia64/include/asm/atomic.h |    4 ++--
 drivers/char/mspec.c           |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/arch/ia64/include/asm/atomic.h
+++ b/arch/ia64/include/asm/atomic.h
@@ -18,8 +18,8 @@
 #include <asm/system.h>
 
 
-#define ATOMIC_INIT(i)		((atomic_t) { (i) })
-#define ATOMIC64_INIT(i)	((atomic64_t) { (i) })
+#define ATOMIC_INIT(i)		{ (i) }
+#define ATOMIC64_INIT(i)	{ (i) }
 
 #define atomic_read(v)		(*(volatile int *)&(v)->counter)
 #define atomic64_read(v)	(*(volatile long *)&(v)->counter)
--- a/drivers/char/mspec.c
+++ b/drivers/char/mspec.c
@@ -284,7 +284,7 @@ mspec_mmap(struct file *file, struct vm_
 	vdata->flags = flags;
 	vdata->type = type;
 	spin_lock_init(&vdata->lock);
-	vdata->refcnt = ATOMIC_INIT(1);
+	atomic_set(&vdata->refcnt, 1);
 	vma->vm_private_data = vdata;
 
 	vma->vm_flags |= (VM_IO | VM_RESERVED | VM_PFNMAP | VM_DONTEXPAND);


