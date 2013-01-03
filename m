Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753592Ab3ACRRB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 12:17:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43873 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753463Ab3ACRRA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 12:17:00 -0500
Message-ID: <50E5BD0F.9040004@redhat.com>
Date: Thu, 03 Jan 2013 12:17:03 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Michel Lespinasse <walken@google.com>
CC: linux-kernel@vger.kernel.org, aquini@redhat.com, eric.dumazet@gmail.com,
        lwoodman@redhat.com, jeremy@goop.org,
        Jan Beulich <JBeulich@novell.com>,
        Thomas Gleixner <tglx@linutronix.de>, knoel@redhat.com
Subject: Re: [RFC PATCH 3/5] x86,smp: auto tune spinlock backoff delay factor
References: <20130103001536.7fd1e952@annuminas.surriel.com> <20130103002341.3cc4b7b4@annuminas.surriel.com> <CANN689Hd01BNYhcBJJBfz7VXJiFM5QikGOLVnokS4Gbq7cT=1g@mail.gmail.com>
In-Reply-To: <CANN689Hd01BNYhcBJJBfz7VXJiFM5QikGOLVnokS4Gbq7cT=1g@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/03/2013 07:31 AM, Michel Lespinasse wrote:

> I'll see if I can make a more concrete proposal and still keep it
> short enough :)

Looking forward to that. I have thought about it some more,
and am still not sure about a better description for the
changelog...

>> +#define MIN_SPINLOCK_DELAY 1
>> +#define MAX_SPINLOCK_DELAY 16000
>> +DEFINE_PER_CPU(int, spinlock_delay) = { MIN_SPINLOCK_DELAY };
>
> unsigned would seem more natural here, though it's only a tiny detail

I might as well make that change while addressing the issues
you found :)

>> +
>> +               /*
>> +                * The lock is still busy; slowly increase the delay. If we
>> +                * end up sleeping too long, the code below will reduce the
>> +                * delay. Ideally we acquire the lock in the tight loop above.
>> +                */
>> +               if (!(head % 7) && delay < MAX_SPINLOCK_DELAY)
>> +                       delay++;
>> +
>> +               loops = delay * waiters_ahead;
>
> I don't like the head % 7 thing. I think using fixed point arithmetic
> would be nicer:
>
> if (delay < MAX_SPINLOCK_DELAY)
>    delay += 256/7; /* Or whatever constant we choose */
>
> loops = (delay * waiter_ahead) >> 8;

I'll do that. That could get completely rid of any artifacts
caused by incrementing sometimes, and not other times.

> Also, we should probably skip the delay increment on the first loop
> iteration - after all, we haven't waited yet, so we can't say that the
> delay was too short.

Good point. I will do that.

>> -               if (head == ticket)
>> +               if (head == ticket) {
>> +                       /*
>> +                        * We overslept and have no idea how long the lock
>> +                        * went idle. Reduce the delay as a precaution.
>> +                        */
>> +                       delay -= delay/32 + 1;
>
> There is a possibility of integer underflow here.

Fixed in my local code base now.

I will build a kernel with the things you pointed out fixed,
and will give it a spin this afternoon.

Expect new patches soonish :)

