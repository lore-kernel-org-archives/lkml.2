Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754685Ab1KUJQf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 04:16:35 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:42745 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751916Ab1KUJQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 04:16:33 -0500
Message-ID: <1321866988.2552.10.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Subject: Re: WARNING: at mm/slub.c:3357, kernel BUG at mm/slub.c:3413
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: "Alex,Shi" <alex.shi@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Date: Mon, 21 Nov 2011 10:16:28 +0100
In-Reply-To: <20111121082445.GD1625@x4.trippels.de>
References: <20111118072519.GA1615@x4.trippels.de>
	 <20111118075521.GB1615@x4.trippels.de> <1321605837.30341.551.camel@debian>
	 <20111118085436.GC1615@x4.trippels.de>
	 <20111118120201.GA1642@x4.trippels.de> <1321836285.30341.554.camel@debian>
	 <20111121080554.GB1625@x4.trippels.de>
	 <20111121082445.GD1625@x4.trippels.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 21 novembre 2011 à 09:24 +0100, Markus Trippelsdorf a écrit :
> On 2011.11.21 at 09:05 +0100, Markus Trippelsdorf wrote:
> > On 2011.11.21 at 08:44 +0800, Alex,Shi wrote:
> > > On Fri, 2011-11-18 at 20:02 +0800, Markus Trippelsdorf wrote:
> > > > On 2011.11.18 at 09:54 +0100, Markus Trippelsdorf wrote:
> > > > > On 2011.11.18 at 16:43 +0800, Alex,Shi wrote:
> > > > > > > > 
> > > > > > > > The dirty flag comes from a bunch of unrelated xfs patches from Christoph, that
> > > > > > > > I'm testing right now.
> > > > > > 
> > > > > > Where is the xfs patchset? I am wondering if it is due to slub code. 
> > > > 
> > > > I begin to wonder if this might be the result of a compiler bug. 
> > > > The kernel in question was compiled with gcc version 4.7.0 20111117. And
> > > > there was commit to the gcc repository today that looks suspicious:
> > > > http://gcc.gnu.org/viewcvs?view=revision&revision=181466
> > > > 
> > > 
> > > Tell us if it is still there and you can reproduce it.
> > 
> > Hm, just noticed the "3.2.0-rc1 panic on PowerPC" thread:
> > http://thread.gmane.org/gmane.linux.kernel/1215584
> > 
> > The backtraces look suspiciously similar to mine.
> 
> So everything points to commit 87fb4b7b533:
> "net: more accurate skb truesize"
> 
> Can you take a look Eric?


This commit was followed by a fix (for SLOB, since SLUB/SLAB were not
affected)

Check commit bc417e30f8df (net: Add back alignment for size for
__alloc_skb)

If current kernel still crash, I believe there is a problem elsewhere (a
refcounting problem) that makes underlying page being reused :

The ksize(skb->head) call in pskb_expand_head() assumes skb->head is a
valid zone, not an already freed one...

By the way, we probably can remove (almost dead) code from
pskb_expand_head() since we now place struct skb_shared_info at the end
of skb->head at skb creation.

I'll send this patch later for net-next

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 18a3ceb..5fd67a8 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -892,17 +892,6 @@ int pskb_expand_head(struct sk_buff *skb, int nhead, int ntail,
 		fastpath = atomic_read(&skb_shinfo(skb)->dataref) == delta;
 	}
 
-	if (fastpath &&
-	    size + sizeof(struct skb_shared_info) <= ksize(skb->head)) {
-		memmove(skb->head + size, skb_shinfo(skb),
-			offsetof(struct skb_shared_info,
-				 frags[skb_shinfo(skb)->nr_frags]));
-		memmove(skb->head + nhead, skb->head,
-			skb_tail_pointer(skb) - skb->head);
-		off = nhead;
-		goto adjust_others;
-	}
-
 	data = kmalloc(size + sizeof(struct skb_shared_info), gfp_mask);
 	if (!data)
 		goto nodata;
@@ -935,7 +924,6 @@ int pskb_expand_head(struct sk_buff *skb, int nhead, int ntail,
 	off = (data + nhead) - skb->head;
 
 	skb->head     = data;
-adjust_others:
 	skb->data    += off;
 #ifdef NET_SKBUFF_DATA_USES_OFFSET
 	skb->end      = size;








