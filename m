Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753204Ab0IMPla (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 11:41:30 -0400
Received: from casper.infradead.org ([85.118.1.10]:52744 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752417Ab0IMPl3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 11:41:29 -0400
Subject: Re: [PATCH] perf_events: improve DS/BTS/PEBS buffer allocation
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        linux-kernel@vger.kernel.org, mingo@elte.hu, paulus@samba.org,
        davem@davemloft.net, perfmon2-devel@lists.sf.net, eranian@gmail.com,
        robert.richter@amd.com,
        "markus.t.metzger" <markus.t.metzger@intel.com>
In-Reply-To: <AANLkTik8r4moPy5muNyT2oKGH5aEaMOLL0Zqn=-hkpos@mail.gmail.com>
References: <4c8e3c0c.12d1d80a.73d9.ffffcf21@mx.google.com>
	 <20100913150914.GA6155@nowhere>
	 <AANLkTi=OR69sDbUMkSnx_-bpF=yHF_xNY1v=-BJgLpp5@mail.gmail.com>
	 <1284391000.2275.338.camel@laptop>
	 <AANLkTin35TXPcs9u3pLfo8QRUmGnftT1DPfswRUVEvJW@mail.gmail.com>
	 <1284391480.2275.350.camel@laptop>
	 <AANLkTik8r4moPy5muNyT2oKGH5aEaMOLL0Zqn=-hkpos@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 13 Sep 2010 17:41:16 +0200
Message-ID: <1284392476.2275.369.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-09-13 at 17:31 +0200, Stephane Eranian wrote:
> On Mon, Sep 13, 2010 at 5:24 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Mon, 2010-09-13 at 17:20 +0200, Stephane Eranian wrote:
> >
> >> That is the case we the sizes you have chosen today. For DS, we
> >> could round up to one page for now.
> >
> > Markus chose the BTS size, for PEBS a single page was plenty since we do
> > single event things (although we could do multiple for attr.precise_ip <
> > 2).
> >
> > For DS there's:
> >  kmalloc_node(sizeof(struct ds), GFP_KERNEL | __GFP_ZERO, cpu_node(cpu));
> >
> Ok, let try again with alloc_pages_node() + kmalloc_node().
> I think we can stick with kmalloc() for DS because we are far from
> consuming a page.

Thing is, if you're really seeing allocation failures,
alloc_pages_node() isn't going to help. And the problem is, these
allocations aren't movable, so memory compaction and all the other fancy
stuff aren't really going to help much :/

There was some talk about a function that should sync all of vmalloc
space, but iirc it was broken for some configs.
