Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754674Ab0EQQwY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 12:52:24 -0400
Received: from smtp-out.google.com ([74.125.121.35]:18322 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753514Ab0EQQwX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 12:52:23 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=i2hqz65seHF4E1518a4jYBlIY1Ak1cU6vhxxO75ELl9NnlqUq0i18+RfW20dp3nVZ
	DjXoFWpYiFAvSrECa3SBw==
MIME-Version: 1.0
In-Reply-To: <1274084399.5605.3655.camel@twins>
References: <1273886490-15627-1-git-send-email-venki@google.com>
	 <1274084399.5605.3655.camel@twins>
Date: Mon, 17 May 2010 09:52:15 -0700
Message-ID: <AANLkTikWWEYpwmqhQ0oYz30SUFY-y2erqStw2T6h0WXg@mail.gmail.com>
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

On Mon, May 17, 2010 at 1:19 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Fri, 2010-05-14 at 18:21 -0700, Venkatesh Pallipadi wrote:
>
>
>>  /*
>> + * The exact cpu_load decay at various idx values would be
>> + * [0] new = 0 * old + 1 * new
>> + * [1] new = 1/2 * old + 1/2 * new
>> + * [2] new = 3/4 * old + 1/4 * new
>> + * [3] new = 7/8 * old + 1/8 * new
>> + * [4] new = 15/16 * old + 1/16 * new
>
> Would that be something like?
>
>  load_i = ((2^i)-1)/(2^i) * load_i + 1/(2^i) * load_(i-1)
>
> Where load_-1 == current load.

Yes.

>> + * Load degrade calculations below are approximated on a 128 point scale.
>> + * degrade_zero_ticks is the number of ticks after which old_load at any
>> + * particular idx is approximated to be zero.
>> + * degrade_factor is a precomputed table, a row for each load idx.
>> + * Each column corresponds to degradation factor for a power of two ticks,
>> + * based on 128 point scale.
>> + * Example:
>> + * row 2, col 3 (=12) says that the degradation at load idx 2 after
>> + * 8 ticks is 12/128 (which is an approximation of exact factor 3^8/4^8).
>
> So because we're in no_hz, current load == 0 and we could approximate
> the thing by:
>
>  load_i = ((2^i)-1)/(2^i) * load_i
>
> Because for i ~ 1, there is no new input, and for i >> 1 the fraction is
> small.

Something like that. But, with total_updates = n and missed_updates = n - 1
We do this for (n - 1)
load_i = ((2^i)-1)/(2^i) * load_i
And do this once.
load_i = ((2^i)-1)/(2^i) * load_i + 1/(2^i) * cur_load

That way we do not differentiate between whether we are in tickless or
not and we use the same code path.

> But why then do we precalculate these factors? It seems to me
> ((2^i)-1)/(2^i) is something that is trivial to compute and doesn't
> warrant a lookup table?
>

Yes. Initially I had a for loop running for missed_updates to calculate
 ((2^i)-1)/(2^i) * load_i
in a loop.
But, it did seem sub-optimal. Specifically, if we have 10's of missed
ticks (which seems to be happening under low utilization), we do this
loop tens of times, just to degrade the load. And we do this on
multiple of the idle CPUs.
Using the look up table allows us to reduce the overhead (in terms of
missed ticks) from n to log_n or lower (as we look at only 1 bits in
missed_ticks).

Thanks,
Venki
