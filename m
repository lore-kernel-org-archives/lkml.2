Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760576Ab0KRVQQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 16:16:16 -0500
Received: from smtp-out.google.com ([74.125.121.35]:30558 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757178Ab0KRVQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 16:16:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=xPlzOhanwVzhBRMgttXgEINmAamRjQqfZ93+/tBY6cabxr5fq/tvlLFEvWQhzhCSIB
         VikWKeMA5BjSR7JSlbLg==
Date: Thu, 18 Nov 2010 13:16:07 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Shaohui Zheng <shaohui.zheng@intel.com>
cc: akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, haicheng.li@linux.intel.com,
        lethal@linux-sh.org, ak@linux.intel.com, shaohui.zheng@linux.intel.com,
        Yinghai Lu <yinghai@kernel.org>, Haicheng Li <haicheng.li@intel.com>
Subject: Re: [1/8,v3] NUMA Hotplug Emulator: add function to hide memory
 region via e820 table.
In-Reply-To: <20101118092052.GE2408@shaohui>
Message-ID: <alpine.DEB.2.00.1011181313140.26680@chino.kir.corp.google.com>
References: <20101117020759.016741414@intel.com> <20101117021000.479272928@intel.com> <alpine.DEB.2.00.1011162354390.16875@chino.kir.corp.google.com> <20101118092052.GE2408@shaohui>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Nov 2010, Shaohui Zheng wrote:

> > > Index: linux-hpe4/arch/x86/kernel/e820.c
> > > ===================================================================
> > > --- linux-hpe4.orig/arch/x86/kernel/e820.c	2010-11-15 17:13:02.483461667 +0800
> > > +++ linux-hpe4/arch/x86/kernel/e820.c	2010-11-15 17:13:07.083461581 +0800
> > > @@ -971,6 +971,7 @@
> > >  }
> > >  
> > >  static int userdef __initdata;
> > > +static u64 max_mem_size __initdata = ULLONG_MAX;
> > >  
> > >  /* "mem=nopentium" disables the 4MB page tables. */
> > >  static int __init parse_memopt(char *p)
> > > @@ -989,12 +990,28 @@
> > >  
> > >  	userdef = 1;
> > >  	mem_size = memparse(p, &p);
> > > -	e820_remove_range(mem_size, ULLONG_MAX - mem_size, E820_RAM, 1);
> > > +	e820_remove_range(mem_size, max_mem_size - mem_size, E820_RAM, 1);
> > > +	max_mem_size = mem_size;
> > >  
> > >  	return 0;
> > >  }
> > 
> > This needs memmap= support as well, right?
> we did not do the testing after combine both memmap and numa=hide paramter, 
> I think that the result should similar with mem=XX, they both remove a memory
> region from the e820 table.
> 

You've modified the parser for mem= but not memmap= so the change needs 
additional support for the latter.

> > >  early_param("mem", parse_memopt);
> > >  
> > > +#ifdef CONFIG_NODE_HOTPLUG_EMU
> > > +u64 __init e820_hide_mem(u64 mem_size)
> > > +{
> > > +	u64 start, end_pfn;
> > > +
> > > +	userdef = 1;
> > > +	end_pfn = e820_end_of_ram_pfn();
> > > +	start = (end_pfn << PAGE_SHIFT) - mem_size;
> > > +	e820_remove_range(start, max_mem_size - start, E820_RAM, 1);
> > > +	max_mem_size = start;
> > > +
> > > +	return start;
> > > +}
> > > +#endif
> > 
> > This doesn't have any sanity checking for whether e820_remove_range() will 
> > leave any significant amount of memory behind so the kernel will even boot 
> > (probably should have a guaranteed FAKE_NODE_MIN_SIZE left behind?).
> 
> it should not be checked here, it should be checked by the function who call
>  e820_hide_mem, and truncate the mem_size with FAKE_NODE_MIN_SIZE.
> 

Your patchset doesn't do that, I'm talking specifically about the amount 
of memory left behind so that the kernel at least still boots.  That seems 
to be a function of e820_hide_mem() to do some sanity checking so we 
actually still get a kernel rather than the responsibility of the 
command-line parser.
