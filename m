Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755706Ab2IFN6i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 09:58:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1864 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752838Ab2IFN6g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 09:58:36 -0400
Message-ID: <5048AC08.5050100@redhat.com>
Date: Thu, 06 Sep 2012 16:58:32 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: "Liu, Jinsong" <jinsong.liu@intel.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, kvm <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: tsc deadline timer works only when hrtimer high
 resolution configured
References: <DE8DF0795D48FD4CA783C40EC829233531F0E4@SHSMSX101.ccr.corp.intel.com>
In-Reply-To: <DE8DF0795D48FD4CA783C40EC829233531F0E4@SHSMSX101.ccr.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/04/2012 06:07 PM, Liu, Jinsong wrote:
> From 728a17e2de591b557c3c8ba31076b4bf2ca5ab42 Mon Sep 17 00:00:00 2001
> From: Liu, Jinsong <jinsong.liu@intel.com>
> Date: Wed, 5 Sep 2012 03:18:15 +0800
> Subject: [PATCH] KVM: tsc deadline timer works only when hrtimer high resolution configured
> 
> This is for 2 reasons:
> 1. it's pointless to enable tsc deadline timer to guest when kernel hrtimer
> not configured as high resolution, since that would be un-precise based on wheel;
> 2. tsc deadline timer based on hrtimer, setting a leftmost node to rb tree
> and then do hrtimer reprogram. If hrtimer not configured as high resolution,
> hrtimer_enqueue_reprogram do nothing and would make tsc deadline timer fail.
> 
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 148ed66..0e64997 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -2210,7 +2210,11 @@ int kvm_dev_ioctl_check_extension(long ext)
>  		r = kvm_has_tsc_control;
>  		break;
>  	case KVM_CAP_TSC_DEADLINE_TIMER:
> +#ifdef CONFIG_HIGH_RES_TIMERS
>  		r = boot_cpu_has(X86_FEATURE_TSC_DEADLINE_TIMER);
> +#else
> +		r = 0;
> +#endif
>  		break;

I prefer a patch making kvm for x86 depend on hrtimers.  kvm already
provides a high resolution timer to the guest in the local apic, backing
it with the jiffies event source will likely cause some guests to
malfunction.


-- 
error compiling committee.c: too many arguments to function
