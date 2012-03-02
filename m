Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964853Ab2CBOnQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 09:43:16 -0500
Received: from mga09.intel.com ([134.134.136.24]:39394 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751296Ab2CBOnP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 09:43:15 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="113845460"
Message-ID: <4F50DC42.3090300@intel.com>
Date: Fri, 02 Mar 2012 22:42:10 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: tglx@linutronix.de, hpa@zytor.com, mingo@redhat.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        x86@kernel.org, asit.k.mallick@intel.com
Subject: Re: change last level cache alignment on x86?
References: <1330590816.21053.1336.camel@debian> <1330673425.21053.1503.camel@debian> <20120302081208.GA24504@elte.hu>
In-Reply-To: <20120302081208.GA24504@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> #ifdef CONFIG_X86_VSMP

>> #ifdef CONFIG_SMP
>> #define __cacheline_aligned_in_smp                                      \
>>         __attribute__((__aligned__(INTERNODE_CACHE_BYTES)))             \
>>         __page_aligned_data
>> #endif
>> #endif
> 
> Note the #ifdef CONFIG_X86_VSMP - so the 128 bytes does not 
> actually transform into __cacheline_aligned_in_smp.


Oh, sorry, I used a inappropriate example here, actually there are lot
places reference to this value, like in cscope show
INTERNODE_CACHE_BYTES usages:

   1     13  arch/x86/include/asm/cache.h <<GLOBAL>>
             #define INTERNODE_CACHE_BYTES (1 << INTERNODE_CACHE_SHIFT)
   2    148  arch/x86/kernel/vmlinux.lds.S <<GLOBAL>>
             READ_MOSTLY_DATA(INTERNODE_CACHE_BYTES)
   3    190  arch/x86/kernel/vmlinux.lds.S <<GLOBAL>>
             PERCPU_VADDR(INTERNODE_CACHE_BYTES, 0, :percpu)
   4    285  arch/x86/kernel/vmlinux.lds.S <<GLOBAL>>
             PERCPU_SECTION(INTERNODE_CACHE_BYTES)
   5     48  arch/x86/mm/tlb.c <<GLOBAL>>
             char pad[INTERNODE_CACHE_BYTES];
   6     18  arch/x86/include/asm/cache.h <<__cacheline_aligned_in_smp>>
             __attribute__((__aligned__(INTERNODE_CACHE_BYTES))) \

and also many references to INTERNODE_CACHE_SHIFT,

> 
>> look at the following contents in Kconfig.cpu, I wondering if 
>> it is possible to remove 'default "7" if NUMA' line. Then a 
>> thin and fit cache alignment will be potential helpful on 
>> performance. Anyone like to give some comments?
> 
>>  config X86_INTERNODE_CACHE_SHIFT
>>         int
>>         default "12" if X86_VSMP
>> -       default "7" if NUMA
>>         default X86_L1_CACHE_SHIFT
> 
> Yes, removing that line would be fine I think - I think it was 
> copied from the old L1 alignment of 128 bytes (which was a P4 
> artifact when that CPU was the dominant platform - that's not 
> been the case for a long time already).


Thanks! I will write a patch later.

> 
> Could you please also do a before/after build of an x86 
> defconfig with NUMA enabled and see what the alignments in the 
> before/after System.map are?


So, with defconfig on x86_64, I saw much changes in System.map:
	before patched			after patched
  ...
  000000000000b000 d tlb_vector_|  000000000000b000 d tlb_vector
  000000000000b080 d cpu_loops_p|  000000000000b040 d cpu_loops_
  ...

> 
> Thanks,
> 
> 	Ingo


