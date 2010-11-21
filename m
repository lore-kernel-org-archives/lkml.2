Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754628Ab0KURAz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 12:00:55 -0500
Received: from one.firstfloor.org ([213.235.205.2]:58967 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754106Ab0KURAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 12:00:54 -0500
Message-ID: <204f85da5561fcf980a4376f6a611929.squirrel@www.firstfloor.org>
In-Reply-To: <1290348259.2245.172.camel@localhost>
References: <1290340877.2245.124.camel@localhost>
    <8e9ff9280b0c4a059bc82b5c4a629897.squirrel@www.firstfloor.org>
    <1290348259.2245.172.camel@localhost>
Date: Sun, 21 Nov 2010 18:00:53 +0100
Subject: Re: [RFC PATCH 2/3 v2] perf: Implement Nehalem uncore pmu
From: "Andi Kleen" <andi@firstfloor.org>
To: "Lin Ming" <ming.m.lin@intel.com>
Cc: "Andi Kleen" <andi@firstfloor.org>,
        "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
        "Ingo Molnar" <mingo@elte.hu>, "Stephane Eranian" <eranian@google.com>,
        "lkml" <linux-kernel@vger.kernel.org>,
        "Frederic Weisbecker" <fweisbec@gmail.com>,
        "Arjan van de Ven" <arjan@infradead.org>
User-Agent: SquirrelMail/1.4.21
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


BTW another thing I noticed that if you ever add opcode/address
matching you'll need to add the new parameters for the address
at least to the input perf_event structure. opcode could
in theory be encoded in the upper 32bits like offcore does,
but address needs to be extra. It's only a small
incremental step, but may make this more useful.

>> Really for uncore monitoring there is no need to use an NMI handler.
>> You can't profile a core anyways, so you can just delay the reporting
>> a little bit. It may simplify the code to not use one here
>> and just use an ordinary handler.
>
> OK, I can use on ordinary interrupt handler here.

You'll need to allocate a vector, it shouldn't be too difficult.

>>
>> In general since there is already much trouble with overloaded
>> NMI events avoiding new NMIs is a good idea.
>>
>>
>>
>> > +
>> > +static struct node_hw_events *uncore_events[MAX_NUMNODES];
>>
>> Don't declare static arrays with MAX_NUMNODES, that number can be
>> very large and cause unnecessary bloat. Better use per CPU data or
>> similar
>> (e.g. with  alloc_percpu)
>
> I really need is a per physical cpu data here, is alloc_percpu enough?

If you use a per cpu array then each CPU can carry a pointer
to its per socket data structure.

This could use a similar scheme as the per core data I submitted
recently.

>
> Any idea to set this cross-core data?

s/local/atomic/

But if it's just stores/loads without read-modify-write you
can just use normal stores.


>
>>
>> > +static int uncore_pmu_add(struct perf_event *event, int flags)
>> > +{
>> > +	int node = numa_node_id();
>>
>> this should be still package id
>
> Understand, this is in my TODO.

With the per cpu pointer scheme you likely don't even need it,
just check the topology at set up time (similar as in my patch,
just using the package)


-Andi
