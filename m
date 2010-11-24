Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932149Ab0KXT4N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 14:56:13 -0500
Received: from mail.openrapids.net ([64.15.138.104]:33381 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932106Ab0KXT4K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 14:56:10 -0500
Date: Wed, 24 Nov 2010 14:56:06 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        akpm@linux-foundation.org, Pekka Enberg <penberg@cs.helsinki.fi>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [thiscpuops upgrade 10/10] Lockless (and preemptless)
	fastpaths for slub
Message-ID: <20101124195606.GA18766@Krystal>
References: <20101123235139.908255844@linux.com> <20101123235201.758191189@linux.com> <AANLkTikVFWYS9UeCP1DJxhzYn9_rMcrovSfbQpNmXsvk@mail.gmail.com> <alpine.DEB.2.00.1011241012180.14268@router.home> <4CED695E.5050502@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CED695E.5050502@goop.org>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 14:53:22 up 1 day, 56 min,  4 users,  load average: 0.07, 0.04,
	0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jeremy Fitzhardinge (jeremy@goop.org) wrote:
> On 11/24/2010 08:17 AM, Christoph Lameter wrote:
> > On Wed, 24 Nov 2010, Pekka Enberg wrote:
> >
> >>> +       /*
> >>> +        * The transaction ids are globally unique per cpu and per operation on
> >>> +        * a per cpu queue. Thus they can be guarantee that the cmpxchg_double
> >>> +        * occurs on the right processor and that there was no operation on the
> >>> +        * linked list in between.
> >>> +        */
> >>> +       tid = c->tid;
> >>> +       barrier();
> >> You're using a compiler barrier after every load from c->tid. Why?
> > To make sure that the compiler does not do something like loading the tid
> > later. The tid must be obtained before the rest of the information from
> > the per cpu slab data is retrieved in order to ensure that we have a
> > consistent set of data to operate on.
> 
> Isn't that best expressed with ACCESS_ONCE()?

ACCESS_ONCE() use of volatile only ensures that volatile accesses are not
reordered wrt each other. It does not ensure anything about other unrelated
memory accesses (which we want to make sure the compiler won't move before the
c->tid read). The compiler barrier() is really what seems to be needed here.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
