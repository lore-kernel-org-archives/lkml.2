Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754138Ab0IMRYi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 13:24:38 -0400
Received: from smtp-out.google.com ([216.239.44.51]:44963 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751771Ab0IMRYh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 13:24:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=KEhbv07D3W46RhjtEd9uc8LrcwUgyk/2UO4yZiKkhO0TjqJpFdn99IQArxdn9ObOb8
         DYYfZ9UhP7SO66n9MkHA==
MIME-Version: 1.0
In-Reply-To: <1284392476.2275.369.camel@laptop>
References: <4c8e3c0c.12d1d80a.73d9.ffffcf21@mx.google.com>
	<20100913150914.GA6155@nowhere>
	<AANLkTi=OR69sDbUMkSnx_-bpF=yHF_xNY1v=-BJgLpp5@mail.gmail.com>
	<1284391000.2275.338.camel@laptop>
	<AANLkTin35TXPcs9u3pLfo8QRUmGnftT1DPfswRUVEvJW@mail.gmail.com>
	<1284391480.2275.350.camel@laptop>
	<AANLkTik8r4moPy5muNyT2oKGH5aEaMOLL0Zqn=-hkpos@mail.gmail.com>
	<1284392476.2275.369.camel@laptop>
Date: Mon, 13 Sep 2010 19:24:19 +0200
Message-ID: <AANLkTimi8=5LM+sx3OgzNCa8V0jG040qZLu=KdWOH945@mail.gmail.com>
Subject: Re: [PATCH] perf_events: improve DS/BTS/PEBS buffer allocation
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        linux-kernel@vger.kernel.org, mingo@elte.hu, paulus@samba.org,
        davem@davemloft.net, perfmon2-devel@lists.sf.net, eranian@gmail.com,
        robert.richter@amd.com,
        "markus.t.metzger" <markus.t.metzger@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 13, 2010 at 5:41 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Mon, 2010-09-13 at 17:31 +0200, Stephane Eranian wrote:
>> On Mon, Sep 13, 2010 at 5:24 PM, Peter Zijlstra <peterz@infradead.org> wrote:
>> > On Mon, 2010-09-13 at 17:20 +0200, Stephane Eranian wrote:
>> >
>> >> That is the case we the sizes you have chosen today. For DS, we
>> >> could round up to one page for now.
>> >
>> > Markus chose the BTS size, for PEBS a single page was plenty since we do
>> > single event things (although we could do multiple for attr.precise_ip <
>> > 2).
>> >
>> > For DS there's:
>> >  kmalloc_node(sizeof(struct ds), GFP_KERNEL | __GFP_ZERO, cpu_node(cpu));
>> >
>> Ok, let try again with alloc_pages_node() + kmalloc_node().
>> I think we can stick with kmalloc() for DS because we are far from
>> consuming a page.
>
> Thing is, if you're really seeing allocation failures,
> alloc_pages_node() isn't going to help. And the problem is, these
> allocations aren't movable, so memory compaction and all the other fancy
> stuff aren't really going to help much :/
>
Based on this comment, I assume that the only reason the allocation
of the sampling buffer in perf_buffer_alloc() is immune to this is because
you are allocating each page individually (order 0). Right?
