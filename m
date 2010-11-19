Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760202Ab0KSBdZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 20:33:25 -0500
Received: from mga02.intel.com ([134.134.136.20]:13477 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758363Ab0KSBdX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 20:33:23 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,220,1288594800"; 
   d="scan'208";a="575348203"
Date: Fri, 19 Nov 2010 08:12:18 +0800
From: Shaohui Zheng <shaohui.zheng@intel.com>
To: David Rientjes <rientjes@google.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, haicheng.li@linux.intel.com,
        lethal@linux-sh.org, ak@linux.intel.com, shaohui.zheng@linux.intel.com,
        Yinghai Lu <yinghai@kernel.org>, Haicheng Li <haicheng.li@intel.com>
Subject: Re: [1/8,v3] NUMA Hotplug Emulator: add function to hide memory
 region via e820 table.
Message-ID: <20101119001218.GA3327@shaohui>
References: <20101117020759.016741414@intel.com>
 <20101117021000.479272928@intel.com>
 <alpine.DEB.2.00.1011162354390.16875@chino.kir.corp.google.com>
 <20101118092052.GE2408@shaohui>
 <alpine.DEB.2.00.1011181313140.26680@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1011181313140.26680@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 18, 2010 at 01:16:07PM -0800, David Rientjes wrote:
> On Thu, 18 Nov 2010, Shaohui Zheng wrote:
> 
> > > > Index: linux-hpe4/arch/x86/kernel/e820.c
> > > > ===================================================================
> > > > --- linux-hpe4.orig/arch/x86/kernel/e820.c	2010-11-15 17:13:02.483461667 +0800
> > > > +++ linux-hpe4/arch/x86/kernel/e820.c	2010-11-15 17:13:07.083461581 +0800
> > > > @@ -971,6 +971,7 @@
> > > >  }
> > > >  
> > > >  static int userdef __initdata;
> > > > +static u64 max_mem_size __initdata = ULLONG_MAX;
> > > >  
> > > >  /* "mem=nopentium" disables the 4MB page tables. */
> > > >  static int __init parse_memopt(char *p)
> > > > @@ -989,12 +990,28 @@
> > > >  
> > > >  	userdef = 1;
> > > >  	mem_size = memparse(p, &p);
> > > > -	e820_remove_range(mem_size, ULLONG_MAX - mem_size, E820_RAM, 1);
> > > > +	e820_remove_range(mem_size, max_mem_size - mem_size, E820_RAM, 1);
> > > > +	max_mem_size = mem_size;
> > > >  
> > > >  	return 0;
> > > >  }
> > > 
> > > This needs memmap= support as well, right?
> > we did not do the testing after combine both memmap and numa=hide paramter, 
> > I think that the result should similar with mem=XX, they both remove a memory
> > region from the e820 table.
> > 
> 
> You've modified the parser for mem= but not memmap= so the change needs 
> additional support for the latter.
> 

the parser for mem= is not modified, the changed parser is numa=, I add a addtional
option numa=hide=.

>From current discussion, numa=hide= interface should be removed, we will use mem=
to hide memory.

> > > >  early_param("mem", parse_memopt);
> > > >  
> > > > +#ifdef CONFIG_NODE_HOTPLUG_EMU
> > > > +u64 __init e820_hide_mem(u64 mem_size)
> > > > +{
> > > > +	u64 start, end_pfn;
> > > > +
> > > > +	userdef = 1;
> > > > +	end_pfn = e820_end_of_ram_pfn();
> > > > +	start = (end_pfn << PAGE_SHIFT) - mem_size;
> > > > +	e820_remove_range(start, max_mem_size - start, E820_RAM, 1);
> > > > +	max_mem_size = start;
> > > > +
> > > > +	return start;
> > > > +}
> > > > +#endif
> > > 
> > > This doesn't have any sanity checking for whether e820_remove_range() will 
> > > leave any significant amount of memory behind so the kernel will even boot 
> > > (probably should have a guaranteed FAKE_NODE_MIN_SIZE left behind?).
> > 
> > it should not be checked here, it should be checked by the function who call
> >  e820_hide_mem, and truncate the mem_size with FAKE_NODE_MIN_SIZE.
> > 
> 
> Your patchset doesn't do that, I'm talking specifically about the amount 
> of memory left behind so that the kernel at least still boots.  That seems 
> to be a function of e820_hide_mem() to do some sanity checking so we 
> actually still get a kernel rather than the responsibility of the 
> command-line parser.

How much memory is enough to make sure the kernel can still boot, it is very 
hard to measure. it is almost impossible to get the exact data. I try to leave very 
few memory to kernel(hide most memory with numa=hide), it cause a panic directly.

I have no idea about it, do you have any suggestions?

Another example,  
I try to add paramter "mem=1M", it compains "Select item can not fit into memory", 
and I did not find where the error message comes from, I guess that it should 
be printed by grub.
