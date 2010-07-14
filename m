Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757648Ab0GNW0l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 18:26:41 -0400
Received: from smtp-out.google.com ([74.125.121.35]:21731 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754522Ab0GNW0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 18:26:39 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=HcPQcr/8znShnqy+C6r55gk8pTSHcvI45WgYMuUhH9br8QLpXxj1rZSIX8hjKKBOJ
	0R3Jq4DBQb/STaB/kCYjw==
Date: Wed, 14 Jul 2010 15:26:33 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Christoph Lameter <cl@linux-foundation.org>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Nick Piggin <npiggin@suse.de>
Subject: Re: [S+Q2 00/19] SLUB with queueing (V2) beats SLAB netperf TCP_RR
In-Reply-To: <20100709190706.938177313@quilx.com>
Message-ID: <alpine.DEB.2.00.1007141518030.17291@chino.kir.corp.google.com>
References: <20100709190706.938177313@quilx.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Jul 2010, Christoph Lameter wrote:

> SLUB+Q also wins against SLAB in netperf:
> 
> Script:
> 
> #!/bin/bash
> 
> TIME=60  # seconds
> HOSTNAME=localhost       # netserver
> 
> NR_CPUS=$(grep ^processor /proc/cpuinfo | wc -l)
> echo NR_CPUS=$NR_CPUS
> 
> run_netperf() {
> for i in $(seq 1 $1); do
> netperf -H $HOSTNAME -t TCP_RR -l $TIME &
> done
> }
> 
> ITERATIONS=0
> while [ $ITERATIONS -lt 12 ]; do
> RATE=0
> ITERATIONS=$[$ITERATIONS + 1]   
> THREADS=$[$NR_CPUS * $ITERATIONS]
> RESULTS=$(run_netperf $THREADS | grep -v '[a-zA-Z]' | awk '{ print $6 }')
> 
> for j in $RESULTS; do
> RATE=$[$RATE + ${j/.*}]
> done
> echo threads=$THREADS rate=$RATE
> done
> 
> 
> Dell Dual Quad Penryn on Linux 2.6.35-rc4
> 
> Loop counts: Larger is better.
> 
> Threads		SLAB		SLUB+Q		%
>  8		690869		714788		+ 3.4
> 16		680295		711771		+ 4.6
> 24		672677		703014		+ 4.5
> 32		676780		703914		+ 4.0
> 40		668458		699806		+ 4.6
> 48		667017		698908		+ 4.7
> 56		671227		696034		+ 3.6
> 64		667956		696913		+ 4.3
> 72		668332		694931		+ 3.9
> 80		667073		695658		+ 4.2
> 88		682866		697077		+ 2.0
> 96		668089		694719		+ 3.9
> 

I see you're using my script for collecting netperf TCP_RR benchmark data, 
thanks very much for looking into this workload for slab allocator 
performance!

There are a couple differences between how you're using it compared to how 
I showed the initial regression between slab and slub, however: you're 
using localhost for your netserver which isn't representative of a real 
networking round-robin workload and you're using a smaller system with 
eight cores.  We never measured a _significant_ performance problem with 
slub compared to slab with four or eight cores, the problem only emerges 
on larger systems.

When running this patchset on two (client and server running 
netperf-2.4.5) four 2.2GHz quad-core AMD processors with 64GB of memory, 
here's the results:

		threads	SLAB	SLUB+Q	diff
		16	205580	179109	-12.9%
		32	264024	215613	-18.3%
		48	286175	237036	-17.2%
		64	305309	253222	-17.1%
		80	308248	243848	-20.9%
		96	299845	243848	-18.7%
		112	305560	259427	-15.1%
		128	312668	263803	-15.6%
		144	329671	271335	-17.7%
		160	318737	280290	-12.1%
		176	325295	287918	-11.5%
		192	333356	287995	-13.6%

If you'd like to add statistics to your patchset that are enabled with 
CONFIG_SLUB_STATS, I'd be happy to run it on this setup and collect more 
data for you.
