Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751649Ab2GYFLD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 01:11:03 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:45581 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750984Ab2GYFLB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 01:11:01 -0400
Message-ID: <1343193053.3139.6.camel@dabdike>
Subject: Re: [next:akpm 129/309] net/core/sock.c:274:36: error: initializer
 element is not constant
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: John David Anglin <dave.anglin@bell.net>
Cc: Fengguang Wu <fengguang.wu@intel.com>, Mel Gorman <mgorman@suse.de>,
        kernel-janitors@vger.kernel.org, Kyle McMartin <kyle@parisc-linux.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Parisc List <linux-parisc@vger.kernel.org>
Date: Wed, 25 Jul 2012 09:10:53 +0400
In-Reply-To: <BLU0-SMTP6C7CFCFF734FE10A39B6E97DC0@phx.gbl>
References: <20120722163058.GB13376@localhost>
	 <20120723111619.GT9222@suse.de>
	 <1343042420.3027.11.camel@dabdike.int.hansenpartnership.com>
	 <20120723114258.GV9222@suse.de> <20120723122905.GA22476@localhost>
	 <BLU0-SMTP2254F8872DDE5FA6035CDE97DD0@phx.gbl>
	 <20120724074844.GA9519@localhost>
	 <BLU0-SMTP6C7CFCFF734FE10A39B6E97DC0@phx.gbl>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-07-24 at 17:08 -0400, John David Anglin wrote:
> Removing "(atomic_t)" from the define results in a constant expression.

OK, so this is what I'll queue for fixes:

From: Mel Gorman <mgorman@suse.de> Date: Mon, 23 Jul 2012 12:16:19
Subject: [PATCH] [PARISC] Redefine ATOMIC_INIT and ATOMIC64_INIT to drop the  casts

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
Cc: <stable@vger.kernel.org>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>

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


