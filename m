Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753017Ab0LWLh5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 06:37:57 -0500
Received: from canuck.infradead.org ([134.117.69.58]:50662 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752645Ab0LWLh4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 06:37:56 -0500
Subject: Re: [RFC PATCH] perf: Add load latency monitoring on Intel
 Nehalem/Westmere
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: Lin Ming <ming.m.lin@intel.com>, Ingo Molnar <mingo@elte.hu>,
        Andi Kleen <andi@firstfloor.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arjan van de Ven <arjan@infradead.org>,
        lkml <linux-kernel@vger.kernel.org>, paulus <paulus@samba.org>
In-Reply-To: <AANLkTi==HfPX1J7yRW=9nbDJfY7Bd4=kZhphq+SoU+-k@mail.gmail.com>
References: <1293005543.2565.156.camel@minggr.sh.intel.com>
	 <1293008431.2170.63.camel@laptop>
	 <AANLkTintfpyvx=Pj1+uu8kCkFn3zT6b36h27Hb7pm=ZF@mail.gmail.com>
	 <1293014701.2170.111.camel@laptop> <1293014967.2170.114.camel@laptop>
	 <1293094781.2565.197.camel@minggr.sh.intel.com>
	 <1293099498.2170.452.camel@laptop>
	 <AANLkTi=LJB1zA-Kt8KE_qaSNga9iJqnR=FMDRq38Zq5_@mail.gmail.com>
	 <1293101280.2170.501.camel@laptop>
	 <AANLkTi==HfPX1J7yRW=9nbDJfY7Bd4=kZhphq+SoU+-k@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 23 Dec 2010 12:37:50 +0100
Message-ID: <1293104270.2170.580.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-12-23 at 12:05 +0100, Stephane Eranian wrote:

> > Value   Intel                           Perf
> > 0x0     Unknown L3                      Unknown
> >
> > 0x1     L1                              L1-local
> >
> > 0x2     Pending core cache HIT          L2-snoop
> >        Outstanding core cache miss to
> 
> Not clear how you know this is snoop or L2?
> 
> I suspect this one is saying you have a request for a line
> for which there is already a pending request underway. Could
> be the first came from prefetchers, the 2nd is actual demand.
> 
> Let me check with Intel. The table is unclear.

Right, so cache snoops as used by Intel are data transfer operations
(not only the watching for remote modifications and local invalidation
as per the strict definition), they typically short-circuit a complete
fetch, get it from a neighboring cache, or otherwise in-flight data.

Since this is a pending fetch, the data is in-flight, and snoop seemed
to apply, but I admit it is somewhat of a stretch.

The L2 came from the usage of "core cache", I might be wrong on that.

Anyway, its a bit of an odd one out, you can have the exact same
'problem' of pending fetches on the same line on all levels, yet they
don't provide this 'source' for other levels.

Strictly speaking, this is a stall, not a source, and we could simply
map it to 'unknown' and be done with it.

> >        the same line was underway
> > 0x3     L2                              L2-local
> >
> > 0x4     L3-snoop, no coherency actions  L3-snoop-I
> 
> I am not sure I understand what you mean by local vs. remote
> in your terminology.

Local being the cache nearest to the cpu, remote being all others.

Admittedly that doesn't really make too much sense for L[12], but
imagine threads having their own L1, then I could imagine a thread
trying to peek in a sibling's L1 since its so near. In that case it
would make sense to use local vs remote on the L1.

