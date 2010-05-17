Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754579Ab0EQRwz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 13:52:55 -0400
Received: from smtp-out.google.com ([74.125.121.35]:42593 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752892Ab0EQRwy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 13:52:54 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=dwfpJ0O8vHrLBNQ22tW0nPqRYEZ+z0iGMBluXQs/OF5fTBmG3378/eatTknLiaiAb
	FnnkRcVmY6LjC+NCdVjRQ==
MIME-Version: 1.0
In-Reply-To: <1274117717.1674.1539.camel@laptop>
References: <1273886490-15627-1-git-send-email-venki@google.com>
	 <1274084399.5605.3655.camel@twins>
	 <AANLkTikWWEYpwmqhQ0oYz30SUFY-y2erqStw2T6h0WXg@mail.gmail.com>
	 <1274117717.1674.1539.camel@laptop>
Date: Mon, 17 May 2010 10:52:50 -0700
Message-ID: <AANLkTik4EvvSwz9rD3zemuaSN3FMAIqsncZ5AKYOdaEn@mail.gmail.com>
Subject: Re: [PATCH] sched: Avoid side-effect of tickless idle on 
	update_cpu_load (v2)
From: Venkatesh Pallipadi <venki@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Ken Chen <kenchen@google.com>, Paul Turner <pjt@google.com>,
       Nikhil Rao <ncrao@google.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 17, 2010 at 10:35 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Mon, 2010-05-17 at 09:52 -0700, Venkatesh Pallipadi wrote:
>
>> >  load_i = ((2^i)-1)/(2^i) * load_i + 1/(2^i) * load_(i-1)
>
>> > So because we're in no_hz, current load == 0 and we could approximate
>> > the thing by:
>> >
>> >  load_i = ((2^i)-1)/(2^i) * load_i
>> >
>> > Because for i ~ 1, there is no new input, and for i >> 1 the fraction is
>> > small.
>>
>> Something like that. But, with total_updates = n and missed_updates = n - 1
>> We do this for (n - 1)
>> load_i = ((2^i)-1)/(2^i) * load_i
>> And do this once.
>> load_i = ((2^i)-1)/(2^i) * load_i + 1/(2^i) * cur_load
>
>> That way we do not differentiate between whether we are in tickless or
>> not and we use the same code path.
>
> But by the above, that's not the same as without, because that does
>
> load_i = ((2^i)-1)/(2^i) * load_i + 1/(2^i) * load_(i-1)
>
> not
>
> load_i = ((2^i)-1)/(2^i) * load_i + 1/(2^i) * cur_load

Hmm. I assumed you meant
load_(i-1) is same as cur_load when you said
>> >Where load_-1 == current load.

No? Or did I miss something?

For the updates done every tick, it is
load = degrade * load + (1-degrade) * cur_load
For updates done with missed ticks
load = degrade^(missed-1) * load
load = degrade * load + (1-degrade) * cur_load

So, cur_load is only accounted for the last tick, and zero load
assumed for all the missed ticks.

>> > But why then do we precalculate these factors? It seems to me
>> > ((2^i)-1)/(2^i) is something that is trivial to compute and doesn't
>> > warrant a lookup table?
>> >
>>
>> Yes. Initially I had a for loop running for missed_updates to calculate
>>  ((2^i)-1)/(2^i) * load_i
>> in a loop.
>
> Ah, right! So you want to calculate:
>
>  (((2^i)-1)/(2^i))^n
>
> Which ends up being a nasty binomial sum: 1/(2^ni) * \Sum_k^n (n choose
> k) * 2^k, so yeah, I don't see a fancy way to quickly compute that.
>
>
> OK, could you summarize our discussion into that comment?
>

OK. Will do.

Thanks,
Venki
