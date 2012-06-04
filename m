Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761096Ab2FDW6q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 18:58:46 -0400
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:9416 "EHLO
	va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757187Ab2FDW6p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 18:58:45 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -13
X-BigFish: VS-13(zzbb2dI9371I168aJ1432N98dKzz1202hzzz2dh2a8h668h839hd25he5bhf0ah)
Message-ID: <4FCD3D9E.9010509@freescale.com>
Date: Mon, 4 Jun 2012 17:58:38 -0500
From: Scott Wood <scottwood@freescale.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Zhao Chenhui <chenhui.zhao@freescale.com>
CC: <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <galak@kernel.crashing.org>, <leoli@freescale.com>
Subject: Re: [PATCH v5 3/5] powerpc/85xx: add sleep and deep sleep support
References: <1336737235-15370-1-git-send-email-chenhui.zhao@freescale.com> <1336737235-15370-3-git-send-email-chenhui.zhao@freescale.com> <4FC93A1B.8060209@freescale.com> <20120604111206.GB20676@localhost.localdomain>
In-Reply-To: <20120604111206.GB20676@localhost.localdomain>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/04/2012 06:12 AM, Zhao Chenhui wrote:
> On Fri, Jun 01, 2012 at 04:54:35PM -0500, Scott Wood wrote:
>> On 05/11/2012 06:53 AM, Zhao Chenhui wrote:
>>> diff --git a/arch/powerpc/include/asm/cacheflush.h b/arch/powerpc/include/asm/cacheflush.h
>>> index 94ec20a..baa000c 100644
>>> --- a/arch/powerpc/include/asm/cacheflush.h
>>> +++ b/arch/powerpc/include/asm/cacheflush.h
>>> @@ -33,6 +33,11 @@ extern void flush_dcache_page(struct page *page);
>>>  #if defined(CONFIG_FSL_BOOKE) || defined(CONFIG_6xx)
>>>  extern void __flush_disable_L1(void);
>>>  #endif
>>> +#if defined(CONFIG_FSL_BOOKE)
>>> +extern void flush_dcache_L1(void);
>>> +#else
>>> +#define flush_dcache_L1()	do { } while (0)
>>> +#endif
>>
>> It doesn't seem right to no-op this on other platforms.
> 
> The pmc_suspend_enter() in fsl_pmc.c used by mpc85xx and mpc86xx,
> but flush_dcache_L1() have no definition in mpc86xx platform.
> I will write flush_dcache_L1() for mpc86xx platform.

How about only calling the function when it's needed?  If we didn't need
an L1 flush here on 86xx before, why do we need it now?

>>>  extern void __flush_icache_range(unsigned long, unsigned long);
>>>  static inline void flush_icache_range(unsigned long start, unsigned long stop)
>>> diff --git a/arch/powerpc/kernel/Makefile b/arch/powerpc/kernel/Makefile
>>> index f5808a3..cb70dba 100644
>>> --- a/arch/powerpc/kernel/Makefile
>>> +++ b/arch/powerpc/kernel/Makefile
>>> @@ -64,6 +64,9 @@ obj-$(CONFIG_FA_DUMP)		+= fadump.o
>>>  ifeq ($(CONFIG_PPC32),y)
>>>  obj-$(CONFIG_E500)		+= idle_e500.o
>>>  endif
>>> +ifneq ($(CONFIG_PPC_E500MC),y)
>>> +obj-$(CONFIG_PPC_85xx)		+= l2cache_85xx.o
>>> +endif
>>
>> Can we introduce a symbol that specifically means pre-e500mc e500,
>> rather than using negative logic?
>>
>> I think something like CONFIG_PPC_E500_V1_V2 has been proposed before.
> 
> Agree. But CONFIG_PPC_E500_V1_V2 haven't been merged.

Has the concept been NACKed, or just forgotten?  If the latter, you
could include it in this patchset.

-Scott

