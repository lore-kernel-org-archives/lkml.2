Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752847Ab1LQW4s (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Dec 2011 17:56:48 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:62062 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752096Ab1LQW4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Dec 2011 17:56:45 -0500
Message-ID: <1324162600.3323.54.camel@edumazet-laptop>
Subject: Re: [PATCH] slub: prefetch next freelist pointer in slab_alloc()
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Christoph Lameter <cl@linux.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>, "Alex,Shi" <alex.shi@intel.com>,
        Shaohua Li <shaohua.li@intel.com>, Matt Mackall <mpm@selenic.com>
Date: Sat, 17 Dec 2011 23:56:40 +0100
In-Reply-To: <1324055915.25554.69.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
References: <1324049134.25554.29.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <alpine.DEB.2.00.1112161030270.26651@router.home>
	 <1324055915.25554.69.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 16 décembre 2011 à 18:18 +0100, Eric Dumazet a écrit :

> I wouldnt expect TCP being a huge win (most of cpu is consumed in tcp
> stack, not really memory allocations), but still...
> 
> [I expect much better gain on an UDP load, where memory allocator costs
> are higher ]

Update on benches. UDP results are really good.

UDP test : One cpu (cpu0) handling NIC irqs, one cpu (cpu1) running a
mono threaded UDP receiver (only receives UDP messages, no xmits)

NUMA machine, feeded with 1.000.000 64bytes packets per second (from
another pktgen machine)

cpu0/cpu1 are on different sockets, to force cache line bouncings and
stress SLUB (allocations done on cpu0, frees on cpu1)

bnx2x adapter (using new build_skb() service for low memory latencies,
available in net-next tree)


Before slub prefetch patch :
	590.000 messages received per second by application,
	410.000 drops per second.


After slub prefetch patch :
	740.000 messages received per second by application,
	260.000 drops per second.


[ If application runs on cpu2 (same socket than cpu0), it can receive
920.000 pps (after patch) instead of 890.000 pps (before patch) ]

Thanks


