Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752446Ab2GWLQ3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 07:16:29 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48718 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752231Ab2GWLQ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 07:16:27 -0400
Date: Mon, 23 Jul 2012 12:16:19 +0100
From: Mel Gorman <mgorman@suse.de>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: kernel-janitors@vger.kernel.org, Kyle McMartin <kyle@parisc-linux.org>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [next:akpm 129/309] net/core/sock.c:274:36: error: initializer
 element is not constant
Message-ID: <20120723111619.GT9222@suse.de>
References: <20120722163058.GB13376@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20120722163058.GB13376@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 23, 2012 at 12:30:58AM +0800, Fengguang Wu wrote:
> Hi Mel,
> 
> To be frank, I don't quite understand this build failure..
> 
> tree:   next/akpm akpm
> head:   37e2ad4953983527f7bdb6831bf478eedcc84082
> commit: 799dc3a908b1df8b766c35aefc24c1b5356aa051 [129/309] netvm: allow skb allocation to use PFMEMALLOC reserves
> config: parisc-defconfig (attached as .config)
> 
> All related error/warning messages:
> 
> net/core/sock.c:274:36: error: initializer element is not constant
> net/core/sock.c:274:36: error: (near initialization for 'memalloc_socks')
> net/core/sock.c:274:36: error: initializer element is not constant
> 

It looks parisc specific so am adding some parisc because this builds but
I am less sure if it is actually correct. If it's correct, it should be
appear before the swap-over-nfs patches to avoid bisection problems.
I've added some parisc folk for review.

---8<---
parisc: Redefine ATOMIC_INIT and ATOMIC64_INIT like other architectures

The following build error occured during a parisc build with
swap-over-NFS patches applied.

net/core/sock.c:274:36: error: initializer element is not constant
net/core/sock.c:274:36: error: (near initialization for 'memalloc_socks')
net/core/sock.c:274:36: error: initializer element is not constant

It's not obvious but this is due to how ATOMIC_INIT is defined on
parisc. It should affect any user of STATIC_KEY_INIT_FALSE on that
platform.

This patch makes the definition of ATOMIC_INIT on parisc to look like
other arches definition.

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 arch/parisc/include/asm/atomic.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/parisc/include/asm/atomic.h b/arch/parisc/include/asm/atomic.h
index 6c6defc..af9cf30 100644
--- a/arch/parisc/include/asm/atomic.h
+++ b/arch/parisc/include/asm/atomic.h
@@ -141,7 +141,7 @@ static __inline__ int __atomic_add_unless(atomic_t *v, int a, int u)
 
 #define atomic_sub_and_test(i,v)	(atomic_sub_return((i),(v)) == 0)
 
-#define ATOMIC_INIT(i)	((atomic_t) { (i) })
+#define ATOMIC_INIT(i)	{ (i) }
 
 #define smp_mb__before_atomic_dec()	smp_mb()
 #define smp_mb__after_atomic_dec()	smp_mb()
@@ -150,7 +150,7 @@ static __inline__ int __atomic_add_unless(atomic_t *v, int a, int u)
 
 #ifdef CONFIG_64BIT
 
-#define ATOMIC64_INIT(i) ((atomic64_t) { (i) })
+#define ATOMIC64_INIT(i) { (i) }
 
 static __inline__ s64
 __atomic64_add_return(s64 i, atomic64_t *v)
