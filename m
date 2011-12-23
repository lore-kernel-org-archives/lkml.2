Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757718Ab1LWUMo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 15:12:44 -0500
Received: from smtpauth03.mfg.siteprotect.com ([64.26.60.137]:42584 "EHLO
	smtpauth03.mfg.siteprotect.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757699Ab1LWUMm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 15:12:42 -0500
Date: Fri, 23 Dec 2011 15:12:40 -0500 (EST)
From: Vince Weaver <vince@deater.net>
X-X-Sender: vince@pianoman.cluster.toy
To: Ingo Molnar <mingo@elte.hu>
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Vince Weaver <vweaver1@eecs.utk.edu>,
        William Cohen <wcohen@redhat.com>,
        Stephane Eranian <eranian@google.com>, Arun Sharma <asharma@fb.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 0/6] perf: x86 RDPMC and RDTSC support
In-Reply-To: <20111221131511.GA31186@elte.hu>
Message-ID: <alpine.DEB.2.02.1112231507120.26100@pianoman.cluster.toy>
References: <20111121145114.049265181@chello.nl> <alpine.DEB.2.00.1112161731570.6060@cl320.eecs.utk.edu> <1324472337.10752.11.camel@twins> <20111221131511.GA31186@elte.hu>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Dec 2011, Ingo Molnar wrote:

> Here's "pinned events" variant i've measured:
> 
> static u64 mmap_read_self(void *addr)
> {
>         struct perf_event_mmap_page *pc = addr;
>         u32 seq, idx;
>         u64 count;
> 
>         do {
>                 seq = pc->lock;
>                 barrier();
> 
>                 idx = pc->index;
>                 count = pc->offset;
>                 if (idx)
>                         count += rdpmc(idx - 1);
> 
>                 barrier();
>         } while (pc->lock != seq);
> 
>         return count;
> }

currently you need to do at least two rdpmc() calls when doing a 
start/read/stop (I use this as a benchmark as it's what PAPI code commonly 
does).

This is because the pc->offset value isn't initalized to 0 on start,
but to max_period & cntrval_mask.

I'm not sure what perf_event can do about this short of having a separate
field in the mmap structure that doesn't have the overflow offset 
considerations.


As an aside, I notice that the internal perf_event read() routine on x86 
seems to use rdmsrl() instead of the equivelent rdpmc().  From what I 
understand, at least through core2 (and maybe later) rdpmc() is faster 
than the equivelent rdmsr() call.  I'm not sure if would be worth
replacing the calls though.

Vince




