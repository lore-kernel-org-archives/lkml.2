Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933320Ab0FBXza (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 19:55:30 -0400
Received: from mga11.intel.com ([192.55.52.93]:42507 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758812Ab0FBXz3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 19:55:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,349,1272870000"; 
   d="scan'208";a="572842755"
From: "Duyck, Alexander H" <alexander.h.duyck@intel.com>
To: Eric Dumazet <eric.dumazet@gmail.com>,
       "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>
CC: "davem@davemloft.net" <davem@davemloft.net>,
       "mingo@redhat.com" <mingo@redhat.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "hpa@zytor.com" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "gospo@redhat.com" <gospo@redhat.com>
Date: Wed, 2 Jun 2010 16:55:16 -0700
Subject: RE: [net-next-2.6 PATCH 2/2] x86: Align skb w/ start of cache line
 on newer core 2/Xeon Arch
Thread-Topic: [net-next-2.6 PATCH 2/2] x86: Align skb w/ start of cache line
 on newer core 2/Xeon Arch
Thread-Index: AcsCpSR7xsNIACYvQx+2CWrpnJfO1wAAVuhA
Message-ID: <80769D7B14936844A23C0C43D9FBCF0F2562CD2555@orsmsx501.amr.corp.intel.com>
References: <20100602222230.12962.97260.stgit@localhost.localdomain>
	 <20100602222506.12962.49240.stgit@localhost.localdomain>
 <1275518650.29413.43.camel@edumazet-laptop>
In-Reply-To: <1275518650.29413.43.camel@edumazet-laptop>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id o52Ntdim003490

Eric Dumazet wrote:
> Le mercredi 02 juin 2010 Ã  15:25 -0700, Jeff Kirsher a Ã©crit :
>> From: Alexander Duyck <alexander.h.duyck@intel.com>
>> 
>> x86 architectures can handle unaligned accesses in hardware, and it
>> has been shown that unaligned DMA accesses can be expensive on
>> Nehalem architectures.  As such we should overwrite NET_IP_ALIGN and
>> NET_SKB_PAD to resolve this issue. 
>> 
>> Signed-off-by: Alexander Duyck <alexander.h.duyck@intel.com>
>> Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com> ---
>> 
>>  arch/x86/include/asm/system.h |   12 ++++++++++++
>>  1 files changed, 12 insertions(+), 0 deletions(-)
>> 
>> diff --git a/arch/x86/include/asm/system.h
>> b/arch/x86/include/asm/system.h index b8fe48e..8acb44e 100644 ---
>> a/arch/x86/include/asm/system.h +++ b/arch/x86/include/asm/system.h
>> @@ -457,4 +457,16 @@ static inline void rdtsc_barrier(void)
>>  	alternative(ASM_NOP3, "lfence", X86_FEATURE_LFENCE_RDTSC);  }
>> 
>> +#ifdef CONFIG_MCORE2
>> +/*
>> + * We handle most unaligned accesses in hardware.  On the other hand
>> + * unaligned DMA can be quite expensive on some Nehalem processors.
>> + * + * Based on this we disable the IP header alignment in network
>> drivers. + * We also modify NET_SKB_PAD to be a cacheline in size,
>> thus maintaining + * cacheline alignment of buffers.
>> + */
>> +#define NET_IP_ALIGN	0
>> +#define NET_SKB_PAD	L1_CACHE_BYTES
>> +#endif
>>  #endif /* _ASM_X86_SYSTEM_H */
>> 
>> --
> 
> But... L1_CACHE_BYTES is 64 on MCORE2, so this matches current
> NET_SKB_PAD definition...
> 
> #ifndef NET_SKB_PAD
> #define NET_SKB_PAD 64
> #endif

I admit the current definition is redundant, but NET_SKB_PAD had been 32 until your recent change of the value, and prior to 2.6.30 the value was 16.  If the value were to change again it would silently break the cacheline alignment which is provided by this patch.  If we were to define NET_SKB_PAD using L1_CACHE_BYTES in skbuff.h then I might be more inclined to to pull the NET_SKB_PAD change, but right now I would prefer to treat NET_SKB_PAD as a magic number that coincidently is the same size as the L1 cache on MCORE2.

Thanks,

Alex
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
