Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755075Ab0IMTb0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 15:31:26 -0400
Received: from mail.openrapids.net ([64.15.138.104]:46264 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754783Ab0IMTbX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 15:31:23 -0400
Date: Mon, 13 Sep 2010 15:31:20 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Stephane Eranian <eranian@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, paulus@samba.org, davem@davemloft.net,
        perfmon2-devel@lists.sf.net, eranian@gmail.com, robert.richter@amd.com,
        "markus.t.metzger" <markus.t.metzger@intel.com>
Subject: Re: [PATCH] perf_events: improve DS/BTS/PEBS buffer allocation
Message-ID: <20100913193120.GA28294@Krystal>
References: <20100913150914.GA6155@nowhere> <AANLkTi=OR69sDbUMkSnx_-bpF=yHF_xNY1v=-BJgLpp5@mail.gmail.com> <1284391000.2275.338.camel@laptop> <AANLkTin35TXPcs9u3pLfo8QRUmGnftT1DPfswRUVEvJW@mail.gmail.com> <1284391480.2275.350.camel@laptop> <AANLkTik8r4moPy5muNyT2oKGH5aEaMOLL0Zqn=-hkpos@mail.gmail.com> <1284392476.2275.369.camel@laptop> <AANLkTimZTzCjea3KFxGcaQ7kscod7sOrz13LkNF_u38w@mail.gmail.com> <1284399329.2275.387.camel@laptop> <AANLkTi=DGnP-r++PhzWFMdwdu_ReUKAmGLCA2zPNBG5J@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=DGnP-r++PhzWFMdwdu_ReUKAmGLCA2zPNBG5J@mail.gmail.com>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 15:25:27 up 233 days, 22:02,  4 users,  load average: 0.04, 0.07,
	0.06
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Stephane Eranian (eranian@google.com) wrote:
> On Mon, Sep 13, 2010 at 7:35 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Mon, 2010-09-13 at 17:55 +0200, Stephane Eranian wrote:
> >>
> >> Ok, so you're saying there is no allocator that will give non-contiguous
> >> physical memory WITHOUT requiring a page fault to populate the pte.
> >>
> >> On the other hand, with vmalloc_node() the pte are populated when
> >> you first touch the memory. That happens as part of memset() right after
> >> the allocation and thus outside of NMI interrupt handler.
> >>
> >> Does this sound right?
> >
> > Nope, in particular read: http://lkml.org/lkml/2010/7/14/465
> >
> > The issue is that the vmalloc space can be mapped in different
> > processes, and that memset() will only ensure its mapped in the current
> > process, but the next one might need that fault to populate.
> >
> Ok, so can we play the same trick you're playing with the sampling
> buffer, i.e., you use alloc_pages_node() for one page at a time, and
> then you stitch them on demand via SW?

Well, a thought is striking me: it sounds like you are re-doing YAORB (short
for Yet Another Ring Buffer, which I start to expect will become a frequently
used acronym). Have you looked at my "generic ring buffer library" ? It's at:

git://git.kernel.org/pub/scm/linux/kernel/git/compudj/linux-2.6-ringbuffer.git
current branch: tip-current-ringbuffer-0.248

documentation is under Documentation/ringbuffer/.

I think it can save you a lot of trouble. E.g., it does stitch pages togeter by
software.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
