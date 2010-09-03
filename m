Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756654Ab0ICLxE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 07:53:04 -0400
Received: from smtp-out.google.com ([74.125.121.35]:52053 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756007Ab0ICLxC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 07:53:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=SVNFokucaNZYLlNErH0sbPISbP7bffJjPA7Fm0vqOSMPyCzyOGPyi8FYiVWfFP769e
         xHC4CywZAzQYIuNciW0Q==
MIME-Version: 1.0
In-Reply-To: <1283512292.1783.350.camel@laptop>
References: <AANLkTimA-AZWJugaLR3VPGVhBaJid=t=a1rPVNUE_8Dh@mail.gmail.com>
	<20100901145728.GM22783@erda.amd.com>
	<AANLkTikOaCL8FqQuUQsYPxm19WZOdarp8AMAugN0mnqQ@mail.gmail.com>
	<20100902141900.GG4879@redhat.com>
	<AANLkTin2KVPpkQWUa_GQ66q+wvZpfYHOKAfWbG-+K5FD@mail.gmail.com>
	<1283502783.1783.172.camel@laptop>
	<AANLkTimyk1PvCBQzqcmcqL7HetXso=_akKvrUM0+hOoD@mail.gmail.com>
	<1283512292.1783.350.camel@laptop>
Date: Fri, 3 Sep 2010 13:52:57 +0200
Message-ID: <AANLkTin9uD7bp36WfUS9-9PaKrn+T5STAxuFdJ4b8Nao@mail.gmail.com>
Subject: Re: [PATCH 4/4] [x86] perf: fix accidentally ack'ing a second event
 on intel perf counter
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Don Zickus <dzickus@redhat.com>, Robert Richter <robert.richter@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@elte.hu" <mingo@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 3, 2010 at 1:11 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Fri, 2010-09-03 at 13:02 +0200, Stephane Eranian wrote:
>>
>> > One thing we still need to do is on init detect if the BIOS is using one
>> > of the PMCs and simply disable all of perf and print a nice big message
>> > to the user to request a new BIOS from their vendor.
>> >
>> Given then way perf_events operate, that is your only choice at this point.
>
> Well, it wouldn't be too hard to cure that, but the BIOS should simply
> keep its grubby paws of the PMU -- I'm really not interested in
> co-operating on that point.
>
>> But I am sure neither my system nor yours is subject to this particular issue
>
> Sure, worth checking though, not sure Don did on his machine.
>
>> yet there is some unexplained errors with OVF_STATUS.
>
> Right.
>
>> Here is an example of what I gathered on a Westmere:
>>
>> This is coming into the interrupt handler:
>> - status   = overflow status coming from GLOBAL_OVF_STATUS
>> - status2 = inspection of the counters
>> - act = cpuc->active_mask[0]
>>
>> In case both status don't match, I dump the state of the active events
>> incl. the counter values(val).
>>
>> [  822.813808] CPU2 irqin status=0x6 status2=0x4 act=0x7
>> [  822.813818] CPU2 cfg=0x13003c idx=0 sel=53003c val=ffffa833f298
>> [  822.813821] CPU2 cfg=0x12003c idx=1 sel=52003c val=fffffe130229
>> [  822.813823] CPU2 cfg=0x11003c idx=2 sel=51003c val=5e9
>>
>> Here only counter2 has overflowed, yet the handler will also process counter1
>> which is wrong.
>
> Right, we could easily revert to scanning all counters like we do for
> all other interrupt handlers.
>
Well, that's the question! Looks like this may be more reliable, yet more
costly. And also you'd have to deal with PEBS separately, though using
OVF_STATUS for that may be sufficient.

>> The other thing I noticed is that in intel_pmu_disable_event(), the event
>> stopped sometimes has overflowed. Looks like OVF_STAUS is stale.
>> Maybe OVF_STATUS is not cleared properly somewhere, possibly when
>> an event gets disabled.
>
> Right, the code pretty much assumes that if it overflows a PMI will be
> generated. So you're saying a pending PMI might get canceled when we
> clear the EN bit? Most icky.
>
No, I don't think that cancels it. But that may be a reason why there are
back-to-back NMIs, with nothing to process sometimes (event not in the
active_mask anymore).
