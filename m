Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754678Ab0IDDnd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 23:43:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62285 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754306Ab0IDDnc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 23:43:32 -0400
Message-ID: <4C81C058.9050105@redhat.com>
Date: Fri, 03 Sep 2010 17:43:20 -1000
From: Zachary Amsden <zamsden@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Zachary Amsden <zamsden@redhat.com>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
CC: kvm@vger.kernel.org, Glauber Costa <glommer@redhat.com>,
        Jan Kiszka <jan.kiszka@web.de>, Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <johnstul@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [KVM timekeeping] Revert getnsboottime() kernel API
References: <1283320624-31262-1-git-send-email-zamsden@redhat.com>
In-Reply-To: <1283320624-31262-1-git-send-email-zamsden@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Never got any feedback on this.  I don't really have a strong opinion on 
it either way, but I'll need to know which way to go with my rebased 
patches.  Also nice if we can avoid polluting upstream with unnecessary 
changes.

I believe it would suffice also to revert these two commits:

2616ac0be4b12bf31cfe8880a5b21c5a2da7d150
b8a578a03d18fab78ea1f79886e32c90f1d071a1

Zach

On 08/31/2010 07:57 PM, Zachary Amsden wrote:
> Turns out this doesn't actually save any math or locking, name
> is chosen rather poorly, it doesn't match the existing kernel
> APIs, and requires kvm-kmod changes.
>
> Signed-off-by: Zachary Amsden<zamsden@redhat.com>
> ---
>   arch/x86/kvm/x86.c        |   18 ++++++++++++++----
>   include/linux/time.h      |    1 -
>   kernel/time/timekeeping.c |   28 +---------------------------
>   3 files changed, 15 insertions(+), 32 deletions(-)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 4014d6c..03605b8 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -919,6 +919,16 @@ static inline u64 nsec_to_cycles(u64 nsec)
>   	return ret;
>   }
>
> +static inline u64 get_kernel_ns(void)
> +{
> +	struct timespec ts;
> +
> +	WARN_ON(preemptible());
> +	ktime_get_ts(&ts);
> +	monotonic_to_bootbased(&ts);
> +	return timespec_to_ns(&ts);
> +}
> +
>   void kvm_write_tsc(struct kvm_vcpu *vcpu, u64 data)
>   {
>   	struct kvm *kvm = vcpu->kvm;
> @@ -928,7 +938,7 @@ void kvm_write_tsc(struct kvm_vcpu *vcpu, u64 data)
>
>   	spin_lock_irqsave(&kvm->arch.tsc_write_lock, flags);
>   	offset = data - native_read_tsc();
> -	ns = getnsboottime();
> +	ns = get_kernel_ns();
>   	elapsed = ns - kvm->arch.last_tsc_nsec;
>   	sdiff = data - kvm->arch.last_tsc_write;
>   	if (sdiff<  0)
> @@ -981,7 +991,7 @@ static int kvm_write_guest_time(struct kvm_vcpu *v)
>   	/* Keep irq disabled to prevent changes to the clock */
>   	local_irq_save(flags);
>   	kvm_get_msr(v, MSR_IA32_TSC,&tsc_timestamp);
> -	kernel_ns = getnsboottime();
> +	kernel_ns = get_kernel_ns();
>   	this_tsc_khz = __get_cpu_var(cpu_tsc_khz);
>   	local_irq_restore(flags);
>
> @@ -3327,7 +3337,7 @@ long kvm_arch_vm_ioctl(struct file *filp,
>   			goto out;
>
>   		r = 0;
> -		now_ns = getnsboottime();
> +		now_ns = get_kernel_ns();
>   		delta = user_ns.clock - now_ns;
>   		kvm->arch.kvmclock_offset = delta;
>   		break;
> @@ -3336,7 +3346,7 @@ long kvm_arch_vm_ioctl(struct file *filp,
>   		struct kvm_clock_data user_ns;
>   		u64 now_ns;
>
> -		now_ns = getnsboottime();
> +		now_ns = get_kernel_ns();
>   		user_ns.clock = kvm->arch.kvmclock_offset + now_ns;
>   		user_ns.flags = 0;
>
> diff --git a/include/linux/time.h b/include/linux/time.h
> index 909e62a..9f15ac7 100644
> --- a/include/linux/time.h
> +++ b/include/linux/time.h
> @@ -160,7 +160,6 @@ extern void getnstimeofday(struct timespec *tv);
>   extern void getrawmonotonic(struct timespec *ts);
>   extern void getboottime(struct timespec *ts);
>   extern void monotonic_to_bootbased(struct timespec *ts);
> -extern s64 getnsboottime(void);
>
>   extern struct timespec timespec_trunc(struct timespec t, unsigned gran);
>   extern int timekeeping_valid_for_hres(void);
> diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
> index 77e930d..dfbe271 100644
> --- a/kernel/time/timekeeping.c
> +++ b/kernel/time/timekeeping.c
> @@ -284,33 +284,6 @@ void ktime_get_ts(struct timespec *ts)
>   }
>   EXPORT_SYMBOL_GPL(ktime_get_ts);
>
> -
> -/**
> - * getnsboottime - get the bootbased clock in nsec format
> - *
> - * The function calculates the bootbased clock from the realtime
> - * clock and the wall_to_monotonic offset and stores the result
> - * in normalized timespec format in the variable pointed to by @ts.
> - */
> -s64 getnsboottime(void)
> -{
> -	unsigned int seq;
> -	s64 secs, nsecs;
> -
> -	WARN_ON(timekeeping_suspended);
> -
> -	do {
> -		seq = read_seqbegin(&xtime_lock);
> -		secs = xtime.tv_sec + wall_to_monotonic.tv_sec;
> -		secs += total_sleep_time.tv_sec;
> -		nsecs = xtime.tv_nsec + wall_to_monotonic.tv_nsec;
> -		nsecs += total_sleep_time.tv_nsec + timekeeping_get_ns();
> -
> -	} while (read_seqretry(&xtime_lock, seq));
> -	return nsecs + (secs * NSEC_PER_SEC);
> -}
> -EXPORT_SYMBOL_GPL(getnsboottime);
> -
>   /**
>    * do_gettimeofday - Returns the time of day in a timeval
>    * @tv:		pointer to the timeval to be set
> @@ -327,6 +300,7 @@ void do_gettimeofday(struct timeval *tv)
>   }
>
>   EXPORT_SYMBOL(do_gettimeofday);
> +
>   /**
>    * do_settimeofday - Sets the time of day
>    * @tv:		pointer to the timespec variable containing the new time
>    

