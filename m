Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757781Ab1LNRdR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 12:33:17 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:59303 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757750Ab1LNRdN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 12:33:13 -0500
Message-ID: <1323883989.2334.68.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Subject: RE: [PATCH 1/3] slub: set a criteria for slub node partial adding
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Christoph Lameter <cl@linux.com>
Cc: "Alex,Shi" <alex.shi@intel.com>, David Rientjes <rientjes@google.com>,
        "penberg@kernel.org" <penberg@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Date: Wed, 14 Dec 2011 18:33:09 +0100
In-Reply-To: <alpine.DEB.2.00.1112140853540.12235@router.home>
References: <1322814189-17318-1-git-send-email-alex.shi@intel.com>
	  <alpine.DEB.2.00.1112020842280.10975@router.home>
	  <1323419402.16790.6105.camel@debian>
	  <alpine.DEB.2.00.1112090203370.12604@chino.kir.corp.google.com>
	  <6E3BC7F7C9A4BF4286DD4C043110F30B67236EED18@shsmsx502.ccr.corp.intel.com>
	  <alpine.DEB.2.00.1112131734070.8593@chino.kir.corp.google.com>
	  <alpine.DEB.2.00.1112131835100.31514@chino.kir.corp.google.com>
	  <1323842761.16790.8295.camel@debian>
	  <1323845054.2846.18.camel@edumazet-laptop>
	 <1323845812.16790.8307.camel@debian>
	 <alpine.DEB.2.00.1112140853540.12235@router.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 14 décembre 2011 à 08:59 -0600, Christoph Lameter a écrit :

> Many people have done patchsets like this. 

Things changed a lot recently. There is room for improvements.

At least we can exchange ideas _before_ coding a new patchset ?

> There are various permutations
> on SL?B (I dont remember them all SLEB, SLXB, SLQB etc) that have been
> proposed over the years. Caches tend to grow and get rather numerous (see
> SLAB) and the design of SLUB was to counter that. There is a reason it was
> called SLUB. The U stands for Unqueued and was intended to avoid the
> excessive caching problems that I ended up when reworking SLAB for NUMA
> support.

Current 'one active slab' per cpu is a one level cache.

It really is a _queue_ containing a fair amount of objects.

'Unqueued' in SLUB is marketing hype :=)

When we have one producer (say network interrupt handler) feeding
millions of network packets to N consumers (other cpus), each free is
slowpath. They all want to touch page->freelist and slow the producer as
well because of false sharing.

Furthermore, when the producer hits socket queue limits, it mostly frees
skbs that were allocated in the 'not very recent past', and its own
freeing also hit slow path (because memory blocks of the skb are no
longer in the current active slab). It competes with frees done by
consumers as well.

Adding a second _small_ cache to queue X objects per cpu would help to
keep the active slab longer and more 'private' (its 'struct page' not
touched too often by other cpus) for a given cpu.

It would limit number of cache line misses we currently have because of
conflicting accesses to page->freelist just to push one _single_ object
(and n->list_lock in less extent)

My initial idea would be to use a cache of 4 slots per cpu, but be able
to queue many objects per slot, if they all belong to same slab/page.

In case we must make room in the cache (all slots occupied), we take one
slot and dequeue all objects in one round. No extra latency compared to
current schem.



