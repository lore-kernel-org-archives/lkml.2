Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754892Ab0KUApU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Nov 2010 19:45:20 -0500
Received: from smtp-out.google.com ([216.239.44.51]:6795 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753445Ab0KUApS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Nov 2010 19:45:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=DZ+I+RcpBX2z24IIgAs62PcMbBsFCN9r0v+H02D6hSAZZ69cYnY68MPaDjX+J4HOTb
         TO4/68vDxtk/JvyV36Iw==
Date: Sat, 20 Nov 2010 16:45:06 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Shaohui Zheng <shaohui.zheng@intel.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, haicheng.li@linux.intel.com,
        lethal@linux-sh.org, Andi Kleen <ak@linux.intel.com>,
        Yinghai Lu <yinghai@kernel.org>, Haicheng Li <haicheng.li@intel.com>
Subject: Re: [1/8,v3] NUMA Hotplug Emulator: add function to hide memory
 region via e820 table.
In-Reply-To: <20101119001218.GA3327@shaohui>
Message-ID: <alpine.DEB.2.00.1011201642200.10618@chino.kir.corp.google.com>
References: <20101117020759.016741414@intel.com> <20101117021000.479272928@intel.com> <alpine.DEB.2.00.1011162354390.16875@chino.kir.corp.google.com> <20101118092052.GE2408@shaohui> <alpine.DEB.2.00.1011181313140.26680@chino.kir.corp.google.com>
 <20101119001218.GA3327@shaohui>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Nov 2010, Shaohui Zheng wrote:

> > > > > Index: linux-hpe4/arch/x86/kernel/e820.c
> > > > > ===================================================================
> > > > > --- linux-hpe4.orig/arch/x86/kernel/e820.c	2010-11-15 17:13:02.483461667 +0800
> > > > > +++ linux-hpe4/arch/x86/kernel/e820.c	2010-11-15 17:13:07.083461581 +0800
> > > > > @@ -971,6 +971,7 @@
> > > > >  }
> > > > >  
> > > > >  static int userdef __initdata;
> > > > > +static u64 max_mem_size __initdata = ULLONG_MAX;
> > > > >  
> > > > >  /* "mem=nopentium" disables the 4MB page tables. */
> > > > >  static int __init parse_memopt(char *p)
> > > > > @@ -989,12 +990,28 @@
> > > > >  
> > > > >  	userdef = 1;
> > > > >  	mem_size = memparse(p, &p);
> > > > > -	e820_remove_range(mem_size, ULLONG_MAX - mem_size, E820_RAM, 1);
> > > > > +	e820_remove_range(mem_size, max_mem_size - mem_size, E820_RAM, 1);
> > > > > +	max_mem_size = mem_size;
> > > > >  
> > > > >  	return 0;
> > > > >  }
> > > > 
> > > > This needs memmap= support as well, right?
> > > we did not do the testing after combine both memmap and numa=hide paramter, 
> > > I think that the result should similar with mem=XX, they both remove a memory
> > > region from the e820 table.
> > > 
> > 
> > You've modified the parser for mem= but not memmap= so the change needs 
> > additional support for the latter.
> > 
> 
> the parser for mem= is not modified, the changed parser is numa=, I add a addtional
> option numa=hide=.
> 

The above hunk is modifying the x86 parser for the mem= parameter.

> > Your patchset doesn't do that, I'm talking specifically about the amount 
> > of memory left behind so that the kernel at least still boots.  That seems 
> > to be a function of e820_hide_mem() to do some sanity checking so we 
> > actually still get a kernel rather than the responsibility of the 
> > command-line parser.
> 
> How much memory is enough to make sure the kernel can still boot, it is very 
> hard to measure. it is almost impossible to get the exact data. I try to leave very 
> few memory to kernel(hide most memory with numa=hide), it cause a panic directly.
> 
> I have no idea about it, do you have any suggestions?
> 

Yes, I think we should use FAKE_NODE_MIN_SIZE to represent the smallest 
node that may be added and so the appropriate behavior or e820_hide_mem() 
would be to leave at least this quantity behind for the kernel to be 
loaded.
