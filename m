Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758235Ab2CBHa7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 02:30:59 -0500
Received: from mga14.intel.com ([143.182.124.37]:42590 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752069Ab2CBHa5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 02:30:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="113700560"
Subject: Re: change last level cache alignment on x86?
From: Alex Shi <alex.shi@intel.com>
To: tglx@linutronix.de
Cc: hpa@zytor.com, mingo@redhat.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        x86@kernel.org, asit.k.mallick@intel.com
In-Reply-To: <1330590816.21053.1336.camel@debian>
References: <1330590816.21053.1336.camel@debian>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 02 Mar 2012 15:30:25 +0800
Message-ID: <1330673425.21053.1503.camel@debian>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-03-01 at 16:33 +0800, Alex,Shi wrote:
> Currently last level defined in kernel is still 128 bytes, but actually
> I checked intel's core2, NHM, SNB, atom, serial platforms, all of them
> are using 64 bytes. 
> I did not get detailed info on AMD platforms. Guess someone like to give
> the info here. So, Is if it possible to do the similar following changes
> to use 64 byte cache alignment in kernel?
> 
> ===
> diff --git a/arch/x86/Kconfig.cpu b/arch/x86/Kconfig.cpu
> index 3c57033..f342a5a 100644
> --- a/arch/x86/Kconfig.cpu
> +++ b/arch/x86/Kconfig.cpu
> @@ -303,7 +303,7 @@ config X86_GENERIC
>  config X86_INTERNODE_CACHE_SHIFT
>  	int
>  	default "12" if X86_VSMP
> -	default "7" if NUMA
> +	default "7" if NUMA && (MPENTIUM4)
>  	default X86_L1_CACHE_SHIFT
>  
>  config X86_CMPXCHG

In arch/x86/include/asm/cache.h, the INTERNODE_CACHE_SHIFT macro will
transfer to '__cacheline_aligned_in_smp' finally. 

#ifdef CONFIG_X86_VSMP
#ifdef CONFIG_SMP
#define __cacheline_aligned_in_smp                                      \
        __attribute__((__aligned__(INTERNODE_CACHE_BYTES)))             \
        __page_aligned_data
#endif
#endif

look at the following contents in Kconfig.cpu, I wondering if it is
possible to remove 'default "7" if NUMA' line. Then a thin and fit cache
alignment will be potential helpful on performance.
Anyone like to give some comments? 

===
diff --git a/arch/x86/Kconfig.cpu b/arch/x86/Kconfig.cpu
index 3c57033..6443c6f 100644
--- a/arch/x86/Kconfig.cpu
+++ b/arch/x86/Kconfig.cpu
@@ -303,7 +303,6 @@ config X86_GENERIC
 config X86_INTERNODE_CACHE_SHIFT
        int
        default "12" if X86_VSMP
-       default "7" if NUMA
        default X86_L1_CACHE_SHIFT
 
 config X86_CMPXCHG
====

some contents in Kconfig.cpu: 

config X86_INTERNODE_CACHE_SHIFT
        int
        default "12" if X86_VSMP
        default "7" if NUMA && (MPENTIUM4 || MPSC)
        default X86_L1_CACHE_SHIFT

config X86_CMPXCHG
        def_bool X86_64 || (X86_32 && !M386)

config X86_L1_CACHE_SHIFT
        int
        default "7" if MPENTIUM4 || MPSC
        default "6" if MK7 || MK8 || MPENTIUMM || MCORE2 || MATOM || MVIAC7 || X86_GENERIC || GENERIC_CPU
        default "4" if MELAN || M486 || M386 || MGEODEGX1
        default "5" if MWINCHIP3D || MWINCHIPC6 || MCRUSOE || MEFFICEON || MCYRIXIII || MK6 || MPENTIUMIII || MPENTIUMII || M686 || M586MMX || M586TSC || M586 || MVIAC3_2 || MGEODE_LX


> 


