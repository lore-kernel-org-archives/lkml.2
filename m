Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755482Ab1EDTeO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 15:34:14 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:29255 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753668Ab1EDTeN (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Wed, 4 May 2011 15:34:13 -0400
Date: Wed, 4 May 2011 15:33:53 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Daniel Kiper <dkiper@net-space.pl>
Cc: linux-kernel@vger.kernel.org, stefano.stabellini@eu.citrix.com,
        yinghai@kernel.org, hpa@zytor.com, xen-devel@lists.xensource.com
Subject: Re: [Xen-devel] Re: [PATCH 1/2] xen/mmu: Add workaround "x86-64, mm:
 Put early page table high"
Message-ID: <20110504193353.GA24996@dumpdata.com>
References: <1304356942-17656-1-git-send-email-konrad.wilk@oracle.com>
 <1304356942-17656-2-git-send-email-konrad.wilk@oracle.com>
 <20110503005527.GA6735@router-fw-old.local.net-space.pl>
 <20110503151206.GA8868@dumpdata.com>
 <20110503195141.GA15775@router-fw-old.local.net-space.pl>
 <20110504185903.GA29903@router-fw-old.local.net-space.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110504185903.GA29903@router-fw-old.local.net-space.pl>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4DC1AA28.0050:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 04, 2011 at 08:59:03PM +0200, Daniel Kiper wrote:
> On Tue, May 03, 2011 at 09:51:41PM +0200, Daniel Kiper wrote:
> > On Tue, May 03, 2011 at 11:12:06AM -0400, Konrad Rzeszutek Wilk wrote:
> > > On Tue, May 03, 2011 at 02:55:27AM +0200, Daniel Kiper wrote:
> > > > On Mon, May 02, 2011 at 01:22:21PM -0400, Konrad Rzeszutek Wilk wrote:
> 
> [...]
> 
> > > > I think that (Stefano please confirm or not) this patch was prepared
> > > > as workaround for similar issues. However, I do not like this patch

It was actually to fix SandyBridge boxes. Their last E820 reserved
region was around fed40000 and then the RAM region started at
100000000. Which meant that we misinterpreted the gap (starting at fed40 mfn)
as the start of RAM.

> > > > because on systems with small amount of memory it leaves huge (to some
> > > > extent) hole between max_low_pfn and 4G. Additionally, it affects
> > > > memory hotplug a bit because it allocates memory starting from current
> > > > max_mfn. It also breaks memory hotplug on i386 (maybe also others
> > > > thinks, however, I could not confirm that). If it stay for some
> > > > reason it should be amended in follwing way:
> > > >
> > > > #ifdef CONFIG_X86_32
> > > >         xen_extra_mem_start = mem_end;
> > > > #else
> > > >         xen_extra_mem_start = max((1ULL << 32), mem_end);
> > > > #endif
> > > >
> > > > Regarding comment for this patch it should be mentioned that without this
> > > > patch e820_end_of_low_ram_pfn() is not broken. It is not called simply.

Hmm. What is max_pfn set to?
Can you send the full dmesg of your guest?

> > > >
> > > > Last but least. I found that memory sizes below and including exactly 1 GiB and
> > > > exactly 2 GiB, 3 GiB (maybe higher, i.e. 4 GiB, 5 GiB, ...; I was not able to test
> > > > them because I do not have sufficient memory) are magic. It means that if memory
> > > > is set with those sizes everything is working good (without 4b239f458c229de044d6905c2b0f9fe16ed9e01e
> > > > and 24bdb0b62cc82120924762ae6bc85afc8c3f2b26 applied). It means that domU
> > > > should be tested with sizes which are not power of two nor multiple of that.
> > >
> > > Hmm, I thought I did test 1500M.
> >
> > It does not work on my machine (24bdb0b62cc82120924762ae6bc85afc8c3f2b26
> > removed and 4b239f458c229de044d6905c2b0f9fe16ed9e01e applied).
> 
> It does not work on my machine (x86_64) with Linux Kernel Ver. 2.6.39-rc6 without
> git commit 24bdb0b62cc82120924762ae6bc85afc8c3f2b26 (xen: do not create the extra
> e820 region at an addr lower than 4G). As I said ealier bug introduced by git
> commit 4b239f458c229de044d6905c2b0f9fe16ed9e01e (x86-64, mm: Put early page table
> high) is probably hidden (repaird/workarounded ???) by git commit
> 24bdb0b62cc82120924762ae6bc85afc8c3f2b26 (xen: do not create the extra
> e820 region at an addr lower than 4G).

There are a couple of things that have been going to fix "x86-64, mm: Put
early page table high" and also .. "cleanup highmem" (something) - which
has been plaguing us since 2.6.32 (and was the one you hit long time ago).

Anyhow, regarding the setting xen_extra_mem_start to 4GB or higher should
be reworked. Not sure yet how. 
> 
> Konrad, Stefano could you confirm that ??? If it is true
> how could I help you in removing this bug ???
> 
> Daniel
> 
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xensource.com
> http://lists.xensource.com/xen-devel
