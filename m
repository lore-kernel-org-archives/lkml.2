Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754038Ab1LFUxA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 15:53:00 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:56737 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753382Ab1LFUw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 15:52:59 -0500
Date: Tue, 6 Dec 2011 12:52:56 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Shaohua Li <shaohua.li@intel.com>
cc: lkml <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>, ak@linux.intel.com,
        Jens Axboe <axboe@kernel.dk>, Christoph Lameter <cl@linux.com>,
        lee.schermerhorn@hp.com
Subject: Re: [patch v2]numa: add a sysctl to control interleave allocation
 granularity from each node
In-Reply-To: <1323055846.22361.362.camel@sli10-conroe>
Message-ID: <alpine.DEB.2.00.1112061248500.28251@chino.kir.corp.google.com>
References: <1323055846.22361.362.camel@sli10-conroe>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Dec 2011, Shaohua Li wrote:

> If mem plicy is interleaves, we will allocated pages from nodes in a round
> robin way. This surely can do interleave fairly, but not optimal.
> 
> Say the pages will be used for I/O later. Interleave allocation for two pages
> are allocated from two nodes, so the pages are not physically continuous. Later
> each page needs one segment for DMA scatter-gathering. But maxium hardware
> segment number is limited. The non-continuous pages will use up maxium
> hardware segment number soon and we can't merge I/O to bigger DMA. Allocating
> pages from one node hasn't such issue. The memory allocator pcp list makes
> we can get physically continuous pages in several alloc quite likely.
> 
> Below patch adds a sysctl to control the allocation granularity from each node.
> 
> Run a sequential read workload which accesses disk sdc - sdf. The test uses
> a LSI SAS1068E card. iostat -x -m 5 shows:
> 
> without numactl --interleave=0,1:
> Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await  svctm  %util
> sdc              13.40     0.00  259.00    0.00    67.05     0.00   530.19     5.00   19.38   3.86 100.00
> sdd              13.00     0.00  249.00    0.00    64.95     0.00   534.21     5.05   19.73   4.02 100.00
> sde              13.60     0.00  258.60    0.00    67.40     0.00   533.78     4.96   18.98   3.87 100.00
> sdf              13.00     0.00  261.60    0.00    67.50     0.00   528.44     5.24   19.77   3.82 100.00
> 
> with numactl --interleave=0,1:
> sdc               6.80     0.00  419.60    0.00    64.90     0.00   316.77    14.17   34.04   2.38 100.00
> sdd               6.00     0.00  423.40    0.00    65.58     0.00   317.23    17.33   41.14   2.36 100.00
> sde               5.60     0.00  419.60    0.00    64.90     0.00   316.77    17.29   40.94   2.38 100.00
> sdf               5.20     0.00  417.80    0.00    64.17     0.00   314.55    16.69   39.42   2.39 100.00
> 
> with numactl --interleave=0,1 and below patch, setting numa_interleave_granularity to 8
> (setting it to 2 gives similar result, I only recorded the data with 8):
> sdc              13.00     0.00  261.20    0.00    68.20     0.00   534.74     5.05   19.19   3.83 100.00
> sde              13.40     0.00  259.00    0.00    67.85     0.00   536.52     4.85   18.80   3.86 100.00
> sdf              13.00     0.00  260.60    0.00    68.20     0.00   535.97     4.85   18.61   3.84 100.00
> sdd              13.20     0.00  251.60    0.00    66.00     0.00   537.23     4.95   19.45   3.97 100.00
> 
> The avgrq-sz is increased a lot. performance boost a little too.
> 

I really like being able to control the interleave granularity, but I 
think it can be done even better: instead of having a strict count on the 
number of allocations (slab or otherwise) to allocate on a single node 
before moving on to another, which could result in large asymmetries 
between nodes which is the antagonist of any interleaved mempolicy, have 
you considered basing the granularity on size instead?  interleave_nodes() 
would then only move onto the next node when a size threshold has been 
reached.
