Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933454Ab2ILXp1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 19:45:27 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:58620 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933437Ab2ILXpX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 19:45:23 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Fengguang Wu <fengguang.wu@intel.com>, Mel Gorman <mgorman@suse.de>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [ 44/46] PARISC: Redefine ATOMIC_INIT and ATOMIC64_INIT to drop the casts
Date: Wed, 12 Sep 2012 16:39:34 -0700
Message-Id: <20120912233822.280525638@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120912233817.662663809@linuxfoundation.org>
References: <20120912233817.662663809@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mel Gorman <mgorman@suse.de>

commit bba3d8c3b3c0f2123be5bc687d1cddc13437c923 upstream.

The following build error occured during a parisc build with
swap-over-NFS patches applied.

net/core/sock.c:274:36: error: initializer element is not constant
net/core/sock.c:274:36: error: (near initialization for 'memalloc_socks')
net/core/sock.c:274:36: error: initializer element is not constant

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

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/parisc/include/asm/atomic.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/parisc/include/asm/atomic.h
+++ b/arch/parisc/include/asm/atomic.h
@@ -248,7 +248,7 @@ static __inline__ int atomic_add_unless(
 
 #define atomic_sub_and_test(i,v)	(atomic_sub_return((i),(v)) == 0)
 
-#define ATOMIC_INIT(i)	((atomic_t) { (i) })
+#define ATOMIC_INIT(i)	{ (i) }
 
 #define smp_mb__before_atomic_dec()	smp_mb()
 #define smp_mb__after_atomic_dec()	smp_mb()
@@ -257,7 +257,7 @@ static __inline__ int atomic_add_unless(
 
 #ifdef CONFIG_64BIT
 
-#define ATOMIC64_INIT(i) ((atomic64_t) { (i) })
+#define ATOMIC64_INIT(i) { (i) }
 
 static __inline__ s64
 __atomic64_add_return(s64 i, atomic64_t *v)


