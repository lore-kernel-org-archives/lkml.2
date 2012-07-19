Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752545Ab2GSXwY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 19:52:24 -0400
Received: from mga02.intel.com ([134.134.136.20]:59862 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751580Ab2GSXwU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 19:52:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="174516482"
Message-ID: <50089DC2.5040508@intel.com>
Date: Fri, 20 Jul 2012 07:52:34 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, arnd@arndb.de,
        rostedt@goodmis.org, fweisbec@gmail.com, jeremy@goop.org, luto@mit.edu,
        yinghai@kernel.org, riel@redhat.com, avi@redhat.com,
        len.brown@intel.com, tj@kernel.org, akpm@linux-foundation.org,
        cl@gentwo.org, borislav.petkov@amd.com, ak@linux.intel.com,
        jbeulich@suse.com, eric.dumazet@gmail.com, akinobu.mita@gmail.com,
        vapier@gentoo.org, cpw@sgi.com, steiner@sgi.com,
        viro@zeniv.linux.org.uk, kamezawa.hiroyu@jp.fujitsu.com,
        rientjes@google.com, aarcange@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v10 7/9] x86/tlb: enable tlb flush range support for x86
References: <1340845344-27557-1-git-send-email-alex.shi@intel.com> <1340845344-27557-8-git-send-email-alex.shi@intel.com> <20120719122057.GA21666@aftab.osrc.amd.com>
In-Reply-To: <20120719122057.GA21666@aftab.osrc.amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



>> +static inline void flush_tlb_mm_range(struct vm_area_struct *vma,
>> +	   unsigned long start, unsigned long end, unsigned long vmflag)
>> +{
>> +	if (vma->vm_mm == current->active_mm)
>> +		__flush_tlb();
>> +}
> 
> There's a problem with this in one of my randconfig tests. It has
> !CONFIG_SMP and the warning is:
> 
> mm/memory.c: In function ‘tlb_flush_mmu’:
> mm/memory.c:230:2: warning: passing argument 1 of ‘flush_tlb_mm_range’ from incompatible pointer type
> /usr/src/linux-2.6/arch/x86/include/asm/tlbflush.h:108:20: note: expected ‘struct vm_area_struct *’ but argument is of type ‘struct mm_struct *’
> mm/memory.c:230:2: warning: passing argument 1 of ‘flush_tlb_mm_range’ from incompatible pointer type
> /usr/src/linux-2.6/arch/x86/include/asm/tlbflush.h:108:20: note: expected ‘struct vm_area_struct *’ but argument is of type ‘struct mm_struct *’
> 
> 
> Due to the fact that the macro flush_tlb actually resolves to
> flush_tlb_mm_range and this function has a different signature based on
> CONFIG_SMP. On !SMP expects struct vm_area_struct * as a first argument
> but on SMP its first argument is struct mm_struct *.
> 
> So two different function signatures based on a config option? Now
> that's a first. What is going on?


Sure, it is a bug, the fix had sent:
https://lkml.org/lkml/2012/7/6/350

> 


