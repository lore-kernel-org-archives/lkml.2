Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758413Ab0GVMPt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 08:15:49 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:44023 "EHLO
	TX2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757974Ab0GVMPl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 08:15:41 -0400
X-SpamScore: -16
X-BigFish: VPS-16(zz1432N98dN936eMzz1202hzzz32i2a8h43h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L5YKPK-02-286-02
X-M-MSG: 
Date: Thu, 22 Jul 2010 14:15:22 +0200
From: Robert Richter <robert.richter@amd.com>
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Suresh Siddha <suresh.b.siddha@intel.com>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/7] x86, xsave: introduce xstate enable functions
Message-ID: <20100722121522.GT26154@erda.amd.com>
References: <1279731838-1522-1-git-send-email-robert.richter@amd.com>
 <1279731838-1522-3-git-send-email-robert.richter@amd.com>
 <4C476236.1020302@zytor.com>
 <1279747225.2812.37.camel@sbs-t61.sc.intel.com>
 <4C476C5B.8020604@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4C476C5B.8020604@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21.07.10 17:53:31, H. Peter Anvin wrote:

> From 55b936c7a359a14d72bcba6c3fceba4cfbe3fedf Mon Sep 17 00:00:00 2001
> From: H. Peter Anvin <hpa@linux.intel.com>
> Date: Wed, 21 Jul 2010 14:23:10 -0700
> Subject: [PATCH] x86, xsave: Make xstate_enable_boot_cpu() __init, protect on CPU 0
> 
> xstate_enable_boot_cpu() is, as the name implies, only used on the
> boot CPU; furthermore, it invokes alloc_bootmem(), which is __init;
> hence it needs to be tagged __init rather than __cpuinit.
> 
> Furthermore, it is *not* safe in the long run to rely on CPU 0 only
> coming online during the early boot -- at some point we're going to
> support offlining (and re-onlining) the boot CPU, and at that point we
> must not call xstate_enable_boot_cpu() again.
> 
> The code is a fair bit more obscure than one would like, because the
> __ref overrides aren't quite powerful enough.
> 
> Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
> Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>
> Cc: Robert Richter <robert.richter@amd.com>
> LKML-Reference: <4C476236.1020302@zytor.com>

I am fine with your changes.

>  void __cpuinit xsave_init(void)
>  {
> +	static __refdata void (*next_func)(void) = xstate_enable_boot_cpu;
> +	void (*this_func)(void);
> +
>  	if (!cpu_has_xsave)
>  		return;
>  
> -	/*
> -	 * Boot processor to setup the FP and extended state context info.
> -	 */
> -	if (!smp_processor_id())
> -		xstate_enable_boot_cpu();
> -	else
> -		xstate_enable(pcntxt_mask);
> +	this_func = next_func;
> +	next_func = xstate_enable;
> +	this_func();
>  }

Just wondering why you are using this_func()? Instead, you could
simply do:

	next_func();
	next_func = xstate_enable;

Do you see races when bringing up multiple cpus in parallel?

Thanks.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

