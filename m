Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752242Ab2ABKeb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jan 2012 05:34:31 -0500
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:56197 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751930Ab2ABKe2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jan 2012 05:34:28 -0500
From: Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>
To: Avi Kivity <avi@redhat.com>, Rik van Riel <riel@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, peterz@infradead.org,
        linux-kernel@vger.kernel.org, vatsa@linux.vnet.ibm.com,
        bharata@linux.vnet.ibm.com
Subject: Re: [RFC PATCH 0/4] Gang scheduling in CFS
In-Reply-To: <4F017AD2.3090504@redhat.com>
References: <20111219083141.32311.9429.stgit@abhimanyu.in.ibm.com> <20111219112326.GA15090@elte.hu> <87sjke1a53.fsf@abhimanyu.in.ibm.com> <4EF1B85F.7060105@redhat.com> <877h1o9dp7.fsf@linux.vnet.ibm.com> <20111223103620.GD4749@elte.hu> <4EF701C7.9080907@redhat.com> <20111230095147.GA10543@elte.hu> <878vlu4bgh.fsf@linux.vnet.ibm.com> <87pqf5mqg4.fsf@abhimanyu.in.ibm.com> <4F017AD2.3090504@redhat.com>
User-Agent: Notmuch/0.10.2+70~gf0e0053 (http://notmuchmail.org) Emacs/23.3.1 (x86_64-redhat-linux-gnu)
Date: Mon, 02 Jan 2012 16:00:18 +0530
Message-ID: <87obumqtvp.fsf@abhimanyu.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
x-cbid: 12010210-8256-0000-0000-000000B430A9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 02 Jan 2012 11:37:22 +0200, Avi Kivity <avi@redhat.com> wrote:
> On 12/31/2011 04:21 AM, Nikunj A Dadhania wrote:

> >
> >     non-PLE - Test Setup:
> >     =====================

> >
> >     ebizzy 8vm (improved 331%)
[...]
> >     GangV2:
> >     27.96%       ebizzy  libc-2.12.so            [.] __memcpy_ssse3_back
> >     12.13%       ebizzy  [kernel.kallsyms]       [k] clear_page
> >     11.66%       ebizzy  [kernel.kallsyms]       [k] __bitmap_empty
> >     11.54%       ebizzy  [kernel.kallsyms]       [k] flush_tlb_others_ipi
> >      5.93%       ebizzy  [kernel.kallsyms]       [k] __do_page_fault
> >
> >     GangBase;
> >     36.34%       ebizzy  [kernel.kallsyms]  [k] __bitmap_empty
> >     35.95%       ebizzy  [kernel.kallsyms]  [k] flush_tlb_others_ipi
> >      8.52%       ebizzy  libc-2.12.so       [.] __memcpy_ssse3_back
> 
> Same thing.  __bitmap_empty() is likely the cpumask_empty() called from
> flush_tlb_others_ipi(), so 70% of time is spent in this loop.
> 
> Xen works around this particular busy loop by having a hypercall for
> flushing the tlb, but this is very fragile (and broken wrt
> get_user_pages_fast() IIRC).
> 
> >
> >     dbench 8vm (degraded -30%)
> >     +------------+--------------------+--------------------+----------+
> >     |                               Dbench                            |
> >     +------------+--------------------+--------------------+----------+
> >     | Parameter  | GangBase           |   Gang V2          | % imprv  |
> >     +------------+--------------------+--------------------+----------+
> >     |      dbench|               2.01 |               1.38 |      -30 |
> >     |     BwUsage|    100408068913.00 |    176095548113.00 |       75 |
> >     |    HostIdle|              82.00 |              74.00 |        9 |
> >     |      IOWait|              25.00 |              23.00 |        8 |
> >     |    IdleTime|              74.00 |              71.00 |       -4 |
> >     |         TPS|              13.00 |              13.00 |        0 |
> >     | CacheMisses|       137351386.00 |       267116184.00 |      -94 |
> >     |   CacheRefs|      4347880250.00 |      5830408064.00 |       34 |
> >     |BranchMisses|       602120546.00 |      1110592466.00 |      -84 |
> >     |    Branches|     22275747114.00 |     39163309805.00 |       75 |
> >     |Instructions|    107942079625.00 |    195313721170.00 |      -80 |
> >     |      Cycles|    271014283494.00 |    481886203993.00 |      -77 |
> >     |     PageFlt|           44373.00 |           47679.00 |       -7 |
> >     |   ContextSW|         3318033.00 |        11598234.00 |     -249 |
> >     |   CPUMigrat|           82475.00 |          423066.00 |     -412 |
> >     +-----------------------------------------------------------------+
> >
> 
> Rik, what's going on?  ContextSW is relatively low in the base load,
> looks like PLE is asleep on the wheel.
> 
Avi, the above dbench result is from a non-PLE machine. So PLE will not
come into picture here.

