Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758280Ab0JYXaZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 19:30:25 -0400
Received: from claw.goop.org ([74.207.240.146]:44233 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752049Ab0JYXaY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 19:30:24 -0400
Message-ID: <4CC6130B.8020908@goop.org>
Date: Mon, 25 Oct 2010 16:30:19 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.4
MIME-Version: 1.0
To: Glauber Costa <glommer@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Zachary Amsden <zamsden@redhat.com>,
        "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>
Subject: Re: [PATCH 1/5] Add a global synchronization point for pvclock
References: <1271356648-5108-1-git-send-email-glommer@redhat.com> <1271356648-5108-2-git-send-email-glommer@redhat.com>
In-Reply-To: <1271356648-5108-2-git-send-email-glommer@redhat.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 On 04/15/2010 11:37 AM, Glauber Costa wrote:
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

Unfortunately this is breaking Xen save/restore: if you restore on a
host which was booted more recently than the save host, causing the
system time to be smaller.  The effect is that the domain's time leaps
forward to a fixed point, and stays there until the host catches up to
the source host...

I guess last_time needs to be reset on this type of event.  I guess the
cleanest way would be for pvclock.c to register a sysdev suspend/resume
handler.

    J

> Signed-off-by: Glauber Costa <glommer@redhat.com>
> CC: Jeremy Fitzhardinge <jeremy@goop.org>
> CC: Avi Kivity <avi@redhat.com>
> CC: Marcelo Tosatti <mtosatti@redhat.com>
> CC: Zachary Amsden <zamsden@redhat.com>
> ---
>  arch/x86/kernel/pvclock.c |   23 +++++++++++++++++++++++
>  1 files changed, 23 insertions(+), 0 deletions(-)
>
> diff --git a/arch/x86/kernel/pvclock.c b/arch/x86/kernel/pvclock.c
> index 03801f2..b7de0e6 100644
> --- a/arch/x86/kernel/pvclock.c
> +++ b/arch/x86/kernel/pvclock.c
> @@ -109,11 +109,14 @@ unsigned long pvclock_tsc_khz(struct pvclock_vcpu_time_info *src)
>  	return pv_tsc_khz;
>  }
>  
> +static u64 last_value = 0;
> +
>  cycle_t pvclock_clocksource_read(struct pvclock_vcpu_time_info *src)
>  {
>  	struct pvclock_shadow_time shadow;
>  	unsigned version;
>  	cycle_t ret, offset;
> +	u64 last;
>  
>  	do {
>  		version = pvclock_get_time_values(&shadow, src);
> @@ -123,6 +126,26 @@ cycle_t pvclock_clocksource_read(struct pvclock_vcpu_time_info *src)
>  		barrier();
>  	} while (version != src->version);
>  
> +	/*
> +	 * Assumption here is that last_value, a global accumulator, always goes
> +	 * forward. If we are less than that, we should not be much smaller.
> +	 * We assume there is an error marging we're inside, and then the correction
> +	 * does not sacrifice accuracy.
> +	 *
> +	 * For reads: global may have changed between test and return,
> +	 * but this means someone else updated poked the clock at a later time.
> +	 * We just need to make sure we are not seeing a backwards event.
> +	 *
> +	 * For updates: last_value = ret is not enough, since two vcpus could be
> +	 * updating at the same time, and one of them could be slightly behind,
> +	 * making the assumption that last_value always go forward fail to hold.
> +	 */
> +	do {
> +		last = last_value;
> +		if (ret < last)
> +			return last;
> +	} while (unlikely(cmpxchg64(&last_value, last, ret) != ret));
> +
>  	return ret;
>  }
>  

