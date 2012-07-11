Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756792Ab2GKJt4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 05:49:56 -0400
Received: from casper.infradead.org ([85.118.1.10]:56273 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752790Ab2GKJty convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 05:49:54 -0400
Message-ID: <1342000187.3462.134.camel@twins>
Subject: Re: perf with precise attribute kills all KVM based VMs
From: Peter Zijlstra <peterz@infradead.org>
To: Gleb Natapov <gleb@redhat.com>
Cc: David Ahern <dsahern@gmail.com>, Avi Kivity <avi@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Wed, 11 Jul 2012 11:49:47 +0200
In-Reply-To: <20120711071006.GF23898@redhat.com>
References: <4FFAE6D8.5050609@gmail.com> <20120709141904.GC7298@redhat.com>
	 <1341843844.3462.75.camel@twins> <4FFAED16.7050204@redhat.com>
	 <4FFAEF13.7010108@gmail.com> <1341845396.3462.81.camel@twins>
	 <4FFAEFF1.9000706@redhat.com> <1341845999.3462.86.camel@twins>
	 <4FFCBD00.1030109@gmail.com> <20120711071006.GF23898@redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-07-11 at 10:10 +0300, Gleb Natapov wrote:

> Looks like Avi is right about the overshoot. Can you test something like this?
> 
> diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
> index 166546e..5fb371a 100644
> --- a/arch/x86/kernel/cpu/perf_event_intel.c
> +++ b/arch/x86/kernel/cpu/perf_event_intel.c
> @@ -1374,8 +1374,11 @@ static struct perf_guest_switch_msr *intel_guest_get_msrs(int *nr)
>  	arr[0].msr = MSR_CORE_PERF_GLOBAL_CTRL;
>  	arr[0].host = x86_pmu.intel_ctrl & ~cpuc->intel_ctrl_guest_mask;
>  	arr[0].guest = x86_pmu.intel_ctrl & ~cpuc->intel_ctrl_host_mask;
> +	arr[1].msr = MSR_IA32_PEBS_ENABLE;
> +	arr[1].host = cpuc->pebs_enabled;
> +	arr[1].guest = 0;
> +	*nr = 2;
>  
> -	*nr = 1;
>  	return arr;
>  }


You also need to clear TR, BTS, BTINT from MSR_IA32_DEBUGCTLMSR and
ideally you'd also clear MSR_IA32_DS_AREA so that any write will be a
proper NULL deref or such.
