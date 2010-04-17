Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753580Ab0DQSsU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Apr 2010 14:48:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45034 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751946Ab0DQSsS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Apr 2010 14:48:18 -0400
Message-ID: <4BCA026D.3070309@redhat.com>
Date: Sat, 17 Apr 2010 21:48:13 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Glauber Costa <glommer@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Marcelo Tosatti <mtosatti@redhat.com>,
       Zachary Amsden <zamsden@redhat.com>
Subject: Re: [PATCH 1/5] Add a global synchronization point for pvclock
References: <1271356648-5108-1-git-send-email-glommer@redhat.com> <1271356648-5108-2-git-send-email-glommer@redhat.com>
In-Reply-To: <1271356648-5108-2-git-send-email-glommer@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/15/2010 09:37 PM, Glauber Costa wrote:
> In recent stress tests, it was found that pvclock-based systems
> could seriously warp in smp systems. Using ingo's time-warp-test.c,
> I could trigger a scenario as bad as 1.5mi warps a minute in some systems.
> (to be fair, it wasn't that bad in most of them). Investigating further, I
> found out that such warps were caused by the very offset-based calculation
> pvclock is based on.
>
> This happens even on some machines that report constant_tsc in its tsc flags,
> specially on multi-socket ones.
>
> Two reads of the same kernel timestamp at approx the same time, will likely
> have tsc timestamped in different occasions too. This means the delta we
> calculate is unpredictable at best, and can probably be smaller in a cpu
> that is legitimately reading clock in a forward ocasion.
>
> Some adjustments on the host could make this window less likely to happen,
> but still, it pretty much poses as an intrinsic problem of the mechanism.
>
> A while ago, I though about using a shared variable anyway, to hold clock
> last state, but gave up due to the high contention locking was likely
> to introduce, possibly rendering the thing useless on big machines. I argue,
> however, that locking is not necessary.
>
> We do a read-and-return sequence in pvclock, and between read and return,
> the global value can have changed. However, it can only have changed
> by means of an addition of a positive value. So if we detected that our
> clock timestamp is less than the current global, we know that we need to
> return a higher one, even though it is not exactly the one we compared to.
>
> OTOH, if we detect we're greater than the current time source, we atomically
> replace the value with our new readings. This do causes contention on big
> boxes (but big here means *BIG*), but it seems like a good trade off, since
> it provide us with a time source guaranteed to be stable wrt time warps.
>
> After this patch is applied, I don't see a single warp in time during 5 days
> of execution, in any of the machines I saw them before.
>
>    

Please define a cpuid bit that makes this optional.  When we eventually 
enable it in the future, it will allow a wider range of guests to enjoy it.

>
> +static u64 last_value = 0;
>    

Needs to be atomic64_t.

> +
>   cycle_t pvclock_clocksource_read(struct pvclock_vcpu_time_info *src)
>   {
>   	struct pvclock_shadow_time shadow;
>   	unsigned version;
>   	cycle_t ret, offset;
> +	u64 last;
>
>
> +	do {
> +		last = last_value;
>    

Otherwise, this assignment can see a partial update.

> +		if (ret<  last)
> +			return last;
> +	} while (unlikely(cmpxchg64(&last_value, last, ret) != ret));
> +
>   	return ret;
>   }
>
>    


-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

