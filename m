Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755410Ab2BUOa4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 09:30:56 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:24245 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752950Ab2BUOay (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 09:30:54 -0500
Date: Tue, 21 Feb 2012 09:27:24 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: "Liu, Jinsong" <jinsong.liu@intel.com>, lenb@kernel.org,
        len.brown@intel.com
Cc: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "keir.xen@gmail.com" <keir.xen@gmail.com>,
        Jan Beulich <JBeulich@suse.com>, "Li, Shaohua" <shaohua.li@intel.com>,
        "lenb@kernel.org" <lenb@kernel.org>
Subject: Re: [Xen-devel] [PATCH 1/3] PAD helper for native and paravirt
 platform
Message-ID: <20120221142724.GB5652@phenom.dumpdata.com>
References: <DE8DF0795D48FD4CA783C40EC829233509D853@SHSMSX101.ccr.corp.intel.com>
 <20120217142909.GA29110@phenom.dumpdata.com>
 <20120217144742.GA29454@phenom.dumpdata.com>
 <DE8DF0795D48FD4CA783C40EC82923350A097D@SHSMSX101.ccr.corp.intel.com>
 <20120219182339.GA11882@phenom.dumpdata.com>
 <DE8DF0795D48FD4CA783C40EC82923350A3E7C@SHSMSX101.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DE8DF0795D48FD4CA783C40EC82923350A3E7C@SHSMSX101.ccr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090203.4F43AA92.0110,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 21, 2012 at 05:49:58AM +0000, Liu, Jinsong wrote:
> Konrad Rzeszutek Wilk wrote:
> >>>>> +struct pv_pad_ops {
> >>>>> +	int (*acpi_pad_init)(void);
> >>>>> +	void (*acpi_pad_exit)(void);
> >>>>> +};
> >>>>> +
> >>> 
> >>> Looking at this a bit closer I am not sure why you choose the
> >>> paravirt interface for this? There is another one - the x86 that
> >>> could have been choosen. Or introduce a new one that is specific to
> >>> ACPI. 
> >>> 
> >>> I am curious - what was the reason for using the paravirt interface?
> >>> I understand it does get the job done, but it seems a bit overkill
> >>> when something simple could have been used?
> >>> 
> >> 
> >> It uses paravirt interface to avoid some code like 'xen_...' in
> >> native code path (acpi_pad.c). 
> >> I'm not quite sure what does 'x86' here mean? Adding 2 fields
> >> (acpi_pad_init/exit) in arch/x86/xen/enlighten.c --> xen_cpu_ops?
> >> seems it's much simpler.  
> > 
> > arch/x86/include/asm/x86_init.h
> > 
> > But before you go that way let me ask you another question - can ACPI
> > PAD 
> > be used on ARM or IA64? If so, wouldn't this fail compilation as this
> > pvops structure is not defined on IA64?
> 
> Ideally ACPI PAD is not bound to some arch, so IMO it could be used at least on IA64 (through currently no real PAD on IA64 platform as far as I know).
> However, in native acpi_pad implementation, it indeed depends on X86 for reason like mwait.
> So for xen acpi_pad, I think it's OK to choose x86, defining an acpi_pad_ops at x86_init.c which would be overwritten when xen init.

OK, or in osl.c. We need Len to chime in here as I can see this expanding in the future.
> 
> Another choice is to define config ACPI_PROCESSOR_AGGREGATOR as 'bool', which would disable native acpi_pad module.

Ewww. No.
> 
> Your opinion?
> 
> Thanks,
> Jinsong
> 
> > 
> > The other thing I am not comfortable about is that the pvops structure
> > are used for low-level code. Not for higher up, like ACPI. For that
> > another structure seems more prudent. Perhaps something like the x86
> > one, but specific to ACPI?
