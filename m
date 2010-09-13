Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752611Ab0IMPJH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 11:09:07 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:40319 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752074Ab0IMPJF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 11:09:05 -0400
Subject: Re: [PATCH] perf_events: improve DS/BTS/PEBS buffer allocation
From: Peter Zijlstra <peterz@infradead.org>
To: eranian@google.com
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, paulus@samba.org,
        davem@davemloft.net, fweisbec@gmail.com, perfmon2-devel@lists.sf.net,
        eranian@gmail.com, robert.richter@amd.com, markus.t.metzger@intel.com
In-Reply-To: <4c8e3c0c.12d1d80a.73d9.ffffcf21@mx.google.com>
References: <4c8e3c0c.12d1d80a.73d9.ffffcf21@mx.google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 13 Sep 2010 17:08:50 +0200
Message-ID: <1284390530.2275.327.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-09-13 at 16:55 +0200, Stephane Eranian wrote:
> The DS, BTS, and PEBS memory regions were allocated using kzalloc(), i.e.,
> requesting contiguous physical memory. There is no such restriction on
> DS, PEBS and BTS buffers. Using kzalloc() could lead to error in case
> no contiguous physical memory is available. BTS is requesting 64KB,
> thus it can cause issues. PEBS is currently only requesting one page.
> Both PEBS and BTS are static buffers allocated for each CPU at the
> first user. When the last user exists, the buffers are released.
> 
> All buffers are only accessed on the CPU they are attached to.
> kzalloc() does not take into account NUMA, thus all allocations
> are taking place on the NUMA node where the perf_event_open() is
> made.

I guess that should have been a alloc_pages_node() indeed.

> This patch switches allocation to vmalloc_node() to use non-contiguous
> physical memory and to allocate on the NUMA node corresponding to each
> CPU. We switched DS and PEBS although they do not cause problems today,
> to, at least, make the allocation on the correct NUMA node. In the future,
> the PEBS buffer size may increase. DS may also grow bigger than a page.
> This patch eliminates the memory allocation imbalance.

I'm not really a fan of vmalloc, have you actually observed allocation
failures for these 64k (order-4) allocations?


