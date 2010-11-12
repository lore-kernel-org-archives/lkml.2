Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757124Ab0KLKtV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 05:49:21 -0500
Received: from smtp-out.google.com ([216.239.44.51]:2571 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756352Ab0KLKtT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 05:49:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=J5792S4tEO+6aRY58WC8VAqwoqjr9ZgstoCV7eRXIudHtpDFkuAFzb6R9W6Wz5eel/
         KyGMvpZ5GBRQT8R1TyOg==
MIME-Version: 1.0
In-Reply-To: <20101112102748.GA8020@basil.fritz.box>
References: <1289492117-18066-1-git-send-email-andi@firstfloor.org>
	<1289492117-18066-2-git-send-email-andi@firstfloor.org>
	<4CDC2DDD.50508@linux.vnet.ibm.com>
	<4CDC3845.4030104@linux.intel.com>
	<4CDC4628.8020109@linux.vnet.ibm.com>
	<20101111194936.GJ18718@basil.fritz.box>
	<1289505587.2084.193.camel@laptop>
	<20101111201259.GL18718@basil.fritz.box>
	<1289507858.2084.195.camel@laptop>
	<20101112102748.GA8020@basil.fritz.box>
Date: Fri, 12 Nov 2010 11:49:16 +0100
Message-ID: <AANLkTi=idvNVyccD53Xwjp5mWfJb=S8UXekhXNqhzRPC@mail.gmail.com>
Subject: Re: [PATCH 2/3] perf: Add support for extra parameters for raw events
From: Stephane Eranian <eranian@google.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, mingo@elte.hu, acme@redhat.com
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 12, 2010 at 11:27 AM, Andi Kleen <andi@firstfloor.org> wrote:
> On Thu, Nov 11, 2010 at 09:37:38PM +0100, Peter Zijlstra wrote:
>> On Thu, 2010-11-11 at 21:12 +0100, Andi Kleen wrote:
>> > > Also, I think we can use the same mechanism to program the
>> > > PEBS-load-latency MSR, right?
>> >
>> > I haven't looked at that, but if it's a per core resource
>> > the infrastructure can be reused at least.
>>
>> Can't remember if the load-latency msr is per-core, but its an extra reg
>> that needs to be set.
>
> Ok. I guess it shouldn't be too hard to add.
>
> Load-latency is pretty useful too.
>
Yes, it is to figure out where cache misses are.

>>
>> The nhm/wsm LBR config msr is per-core though, so that could use your
>> infrastructure too.
>
> Stephane mentioned that too. Not right now, but perhaps later I'll
> look at using this.
>
The difficulty with PEBS-LL (load latency) is not so much the encoding of the
latency. It is more how to expose the data back to user. You get a full PEBS
record for each miss. So you get the PEBS machine state + data addr, miss
latency, and data source (where did the line come from). We have already
discussed how to expose machine state in general. I'll work on a patch for this.
So we can get the general PEBS machine state out. However, the question is
how do we expose data addr, latency, data source? We can reuse the
SAMPLE_ADDR for the data address. Sample IP would point to the load
instruction (with help from LBR to correct the off by one issue). For
the latency
and data source, I proposed using pseudo regs and leveraging the sampled machine
state mechanism. An alternative may be to define a new record type that would b
generic enough to be reusable, for instance { instr_addr, data_addr,
latency, data_src, flags; }.

But let's fix OFFCORE_RESPONSE_* first.
