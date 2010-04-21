Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754549Ab0DUNVl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 09:21:41 -0400
Received: from smtp-out.google.com ([216.239.44.51]:27271 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754515Ab0DUNVj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 09:21:39 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:x-system-of-record;
	b=tPgfe+iJwenGIJaCRNFYdCg7Q2IFVVjfXvFKu6am3UHRx8YRolZdOpOCpm9CzaWC2
	YVDYxw3jVSk29wXDA6R8Q==
MIME-Version: 1.0
In-Reply-To: <1271851865.4807.10284.camel@twins>
References: <1271190201-25705-1-git-send-email-robert.richter@amd.com>
	 <1271317461.32749.67.camel@laptop>
	 <20100415151633.GN11907@erda.amd.com>
	 <1271851865.4807.10284.camel@twins>
Date: Wed, 21 Apr 2010 15:21:35 +0200
Message-ID: <u2kbd4cb8901004210621gd8b453cg6b41f1ee3effaa99@mail.gmail.com>
Subject: Re: [PATCH 00/12] perf: introduce model specific events and AMD IBS
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Robert Richter <robert.richter@amd.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 21, 2010 at 2:11 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Thu, 2010-04-15 at 17:16 +0200, Robert Richter wrote:
>> On 15.04.10 09:44:21, Peter Zijlstra wrote:
>> > On Tue, 2010-04-13 at 22:23 +0200, Robert Richter wrote:
>> > > This patch series introduces model specific events and impments AMD
>> > > IBS (Instruction Based Sampling) for perf_events.
>> >
>> > I would much rather it uses the ->precise thing PEBS also uses,
>> > otherwise we keep growing funny arch extensions and end up with a
>> > totally fragmented trainwreck of an ABI.
>>
>> I agree that an exiting flag could be reused. But the naming 'precise'
>> could be misleading. Maybe we rename it to 'model_spec' or something
>> else that underlines the idea of having model specific setups.
>
> Right, so I really hate PERF_SAMPLE_RAW, and I'm considering simply
> removing that for PEBS as well, its just too ugly. If we want the
> register set we need to work on getting PERF_SAMPLE_REGS in a sensible
> shape.
>
I wonder why SAMPLE_RAW went in in the first place, then. What was the
justification for it, traces?

Okay, so you're suggesting everything is exposed via PERF_SAMPLE_REGS.
PEBS does capture machine state which is easily mapped onto PERF_SAMPLE_REGS.
Well, that's until you look at PEB-LL on Nehalem where is captures
latencies and data
addresses.

IBS does not capture machine state in the sense of general purpose registers.
IBS captures micro-architectural info about an instruction and stores
this into a
handful of IBS registers. Those could be funneled through PERF_SAMPLE_REGS
as well, I believe. But that means, PERF_SAMPLE_REGS would need some
configuration
bitmask to name the registers of interest, e.g. EAX, EDX, IBSOP_DATA,
IBSOP_PHYSAD,
and so on.

As you pointed out a long time ago, IBS returns to much information to
be abstracted
easily unless you're willing to drop part of the information it
returns, e.g., concentrate
on cache miss info only. But this goes back to a point I made early
on: there are
many usage models, different metrics need different data. You don't
want to prevent
any usage model.

> As to the meaning for ->precise, its meant to convey the counters are
> not affected by skid and the like, I thought IBS provided exact IPs as
> well (/me should re-read the IBS docs).
>
By construction it is given that it tracks an instruction. Thus, the
IP is always
that of the monitored instruction: no skid. The difference, though, it
that is not
associated with an actual counter+event. IBS keeps its own counter. You can
easily create a pseudo event (which is what Robert does in his patch).

> The thing with something like ->model_spec and PERF_SAMPLE_RAW is that
> it doesn't provide a clear model, the user doesn't know what to expect
> of it, it could be anything.
>
I think we can avoid model_spec.

> We want the ABI to express clear concepts, and things like lets bypass
> everything and just dump stuff out to userspace really are to be avoided
> at all costs.
>
> Sadly IBS seems to be an utter trainwreck in the concept department (I'm
> still struggling how to make a sensible interpretation of the data it
> gathers).
>
Concept is simple: track an instruction (uop) as it traverses the pipeline and
gather all sort of micro-architectural info. When the instruction retires,
interrupt the CPU and deliver the info via registers. The current implementation
is not without problems, but you can already gather useful info such as instrs
latencies, data cache misses.

Speaking of data cache misses, I believe there may be a way to abstract
sampling on cache misses, i.e, capture where they occur, that would work
with both IBS and PEBS-LL. That may be a good way to start exposing
some of the IBS features.

> Also not using sample_period for the sample period is of course utterly
> unacceptable.
>
That is fixed now.
