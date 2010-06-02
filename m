Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758903Ab0FBWoR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 18:44:17 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:40619 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758732Ab0FBWoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 18:44:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=AFYzqeT8OtgX4WFGdl4N7Ii1ILx+rRpqHDflXPl7H8C1L5lJA2Q9rMiSc4B3WuIahS
         IJLxS7efrerd9dG1ujNYLlXCmYhoDuwGfof48aPYDhFBj2c7uBwZKBYgSr8YLHMmMRVr
         UuaJcGoMBi4Lybmg6bMLHVOCN3WxjXxwACmfo=
Subject: Re: [net-next-2.6 PATCH 2/2] x86: Align skb w/ start of cache line
 on newer core 2/Xeon Arch
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc: davem@davemloft.net, mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com,
       x86@kernel.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       gospo@redhat.com, Alexander Duyck <alexander.h.duyck@intel.com>
In-Reply-To: <20100602222506.12962.49240.stgit@localhost.localdomain>
References: <20100602222230.12962.97260.stgit@localhost.localdomain>
	 <20100602222506.12962.49240.stgit@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 03 Jun 2010 00:44:10 +0200
Message-ID: <1275518650.29413.43.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 02 juin 2010 à 15:25 -0700, Jeff Kirsher a écrit :
> From: Alexander Duyck <alexander.h.duyck@intel.com>
> 
> x86 architectures can handle unaligned accesses in hardware, and it has
> been shown that unaligned DMA accesses can be expensive on Nehalem
> architectures.  As such we should overwrite NET_IP_ALIGN and NET_SKB_PAD
> to resolve this issue.
> 
> Signed-off-by: Alexander Duyck <alexander.h.duyck@intel.com>
> Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
> ---
> 
>  arch/x86/include/asm/system.h |   12 ++++++++++++
>  1 files changed, 12 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/include/asm/system.h b/arch/x86/include/asm/system.h
> index b8fe48e..8acb44e 100644
> --- a/arch/x86/include/asm/system.h
> +++ b/arch/x86/include/asm/system.h
> @@ -457,4 +457,16 @@ static inline void rdtsc_barrier(void)
>  	alternative(ASM_NOP3, "lfence", X86_FEATURE_LFENCE_RDTSC);
>  }
>  
> +#ifdef CONFIG_MCORE2
> +/*
> + * We handle most unaligned accesses in hardware.  On the other hand
> + * unaligned DMA can be quite expensive on some Nehalem processors.
> + *
> + * Based on this we disable the IP header alignment in network drivers.
> + * We also modify NET_SKB_PAD to be a cacheline in size, thus maintaining
> + * cacheline alignment of buffers.
> + */
> +#define NET_IP_ALIGN	0
> +#define NET_SKB_PAD	L1_CACHE_BYTES
> +#endif
>  #endif /* _ASM_X86_SYSTEM_H */
> 
> --

But... L1_CACHE_BYTES is 64 on MCORE2, so this matches current
NET_SKB_PAD definition...

#ifndef NET_SKB_PAD
#define NET_SKB_PAD 64
#endif



