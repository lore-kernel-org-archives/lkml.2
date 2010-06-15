Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750915Ab0FOEiy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 00:38:54 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:45757 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750710Ab0FOEix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 00:38:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=AJBn1PzaqjCpjZ7h5r55Up786Dyo43NnZP2DqC656hb9RbwxI1UYLRThGQFV5ih/HY
         hylNm40Q1HflmjOzuTx27s5SndG9lM6IhujTPdIj0OusWoiHU5/+oqz29GB4bCOg567J
         DoVfb2F70aP6gMznGxIZjoPRlZIU1Wrgl4biI=
Subject: Re: [PATCH] Fix a race in pid generation that causes pids to be
 reused immediately.
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Paul Mackerras <paulus@samba.org>, tytso@mit.edu,
       Salman <sqazi@google.com>, mingo@elte.hu, linux-kernel@vger.kernel.org,
       peterz@infradead.org, tytso@google.com, torvalds@linux-foundation.org,
       walken@google.com, Chen Liqin <liqin.chen@sunplusct.com>,
       Lennox Wu <lennox.wu@gmail.com>
In-Reply-To: <20100614212150.4dcb1feb.akpm@linux-foundation.org>
References: <AANLkTinlnb-HsDia4X2qgRjkTL_Z5CfVKYHRFwREoyIn@mail.gmail.com>
	 <20100611224902.5039.60134.stgit@bumblebee1.mtv.corp.google.com>
	 <20100614165851.6bdfe485.akpm@linux-foundation.org>
	 <20100615005619.GI6666@thunk.org>
	 <20100614185556.afdc5304.akpm@linux-foundation.org>
	 <20100615032608.GB30479@drongo>
	 <20100614212150.4dcb1feb.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 15 Jun 2010 06:38:46 +0200
Message-ID: <1276576726.30434.209.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 14 juin 2010 à 21:21 -0700, Andrew Morton a écrit :
> On Tue, 15 Jun 2010 13:26:08 +1000 Paul Mackerras <paulus@samba.org> wrote:
> 
> > On Mon, Jun 14, 2010 at 06:55:56PM -0700, Andrew Morton wrote:
> > 
> > > > kernel/sched_clock.c:   if (cmpxchg64(&scd->clock, old_clock, clock) != old_cloc
> > > 
> > > I guess that'll flush out any stragglers.
> > 
> > And break most non-x86 32-bit architectures, including 32-bit powerpc.
> 
> If CONFIG_SMP=y, yes.  On UP there's a generic implementation
> (include/asm-generic/cmpxchg-local.h, include/asm-generic/cmpxchg.h)
> 
> > Fortunately that code is only used if CONFIG_HAVE_UNSTABLE_SCHED_CLOCK
> > is set, and it looks like only x86 and ia64 set it.
> > 
> 
> If that happens then the best fix is for those architectures to get
> themselves a cmpxchg64().  Unless for some reason it's simply
> unimplementable?  Worst case I guess one could use a global spinlock. 
> Second-worst-case: hashed spinlocks.

Hmm, this reminds me a patch I had somewhere, not yet sent to David :)

1) cmpxchg() was not available for all arches, maybe
atomic_long_cmpxchg() is ?

2) I am not sure atomic_long_t quarantee that all 32 or 64 bits of the
underlying long container are available.

Thanks !

diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index a291edb..335ca89 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -1268,17 +1268,18 @@ skip_hashing:
 
 void rt_bind_peer(struct rtable *rt, int create)
 {
-	static DEFINE_SPINLOCK(rt_peer_lock);
 	struct inet_peer *peer;
 
 	peer = inet_getpeer(rt->rt_dst, create);
 
-	spin_lock_bh(&rt_peer_lock);
-	if (rt->peer == NULL) {
-		rt->peer = peer;
+#if defined(__HAVE_ARCH_CMPXCHG)
+	if (!cmpxchg(&rt->peer, NULL, peer))
 		peer = NULL;
-	}
-	spin_unlock_bh(&rt_peer_lock);
+#else
+	BUILD_BUG_ON(sizeof(rt->peer) != sizeof(atomic_long_t));
+	if (!atomic_long_cmpxchg((atomic_long_t *)&rt->peer, 0, (long)peer))
+		peer = NULL;
+#endif
 	if (peer)
 		inet_putpeer(peer);
 }


