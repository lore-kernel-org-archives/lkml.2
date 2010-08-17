Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757565Ab0HQOpR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 10:45:17 -0400
Received: from relay3.sgi.com ([192.48.152.1]:55124 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757321Ab0HQOpL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 10:45:11 -0400
Date: Tue, 17 Aug 2010 09:45:09 -0500
From: Jack Steiner <steiner@sgi.com>
To: ykzhao <yakui.zhao@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, "tglx@linutronix.de" <tglx@linutronix.de>,
        "lenb@kernel.org" <lenb@kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC] - Mapping ACPI tables as CACHED
Message-ID: <20100817144509.GC14091@sgi.com>
References: <20100722152220.GA18290@sgi.com> <1279849573.13929.28.camel@localhost.localdomain> <20100723072301.GC23461@elte.hu> <1279895165.13929.61.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1279895165.13929.61.camel@localhost.localdomain>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 23, 2010 at 10:26:05PM +0800, ykzhao wrote:
> On Fri, 2010-07-23 at 15:23 +0800, Ingo Molnar wrote:
> > * ykzhao <yakui.zhao@intel.com> wrote:
> > 
> > > From the above description maybe the E820_ACPI region can be mapped as 
> > > cached. But this still depends on the BIOS. If the some shared data resides 
> > > in the E820_ACPI region on some BIOS, maybe we can't map the E820_ACPI 
> > > region as cached again.
> > 
> > I dont think we can do this safely unless some other OS (Windows) does it as 
> > well. (the reason is that if some BIOS messes this up then it will cause nasty 
> > bugs/problems only on Linux.)
> > 
> 
> Yes. We can't map the corresponding ACPI region as cached under the
> following case:
>     >No E820_ACPI region is reported by BIOS. In such case the ACPI
> table resides in the NVS region     
> 
> But if the BIOS can follow the spec and report the separated
> E820_ACPI/E820_NVS region, maybe we can give a try to map the E820_ACPI
> region as cached type. For example: the server machine.(The spec
> describes the E820_ACPI region as reclaimed memory, which means that it
> can be managed by OS after ACPI table is loaded).

This would work for the problem I'm trying to solve. On our platform, the
majority of the ACPI tables are in E820_ACPI regions. Mapping as cached
solves most of the performance. However, even the E820_NVS regions are
mapped as WB by BIOS on our platform. What is the advantage of having the
OS map this as UC as long as this mapping option is a platform specific?


> 
> Can we add a boot option to control whether the E820_ACPI region can be
> mapped as cached type?

In general, I don't like boot options for thing like this. They are prone
to misuse.  Mapping as WB really is not an option - it is a platform-specific
attribute & should be controlled by the OS or BIOS and transparant to the user.

In the patch I posted, I had the mapping controlled by platform specific
code. I originally had it as a x86_platform callout but other schemes may
be more appropriate.

Would it be better to add an acpi function that is called directly from the
UV initialization code. The new acpi function would set a flag that controls
the mapping done later by acpi_os_map_memory()?


> 
> > But the benefits of caching are very clear and well measured by Jack, so we 
> > want the feature. What we can do is to add an exception for 'known good' hw 
> > vendors - i.e. something quite close to Jack's RFC patch, but implemented a 
> > bit more cleanly:
> > 
> > Exposing x86_platform and e820 details to generic ACPI code isnt particularly 
> > clean - there should be an ACPI accessor function for that or so: a new 
> > acpi_table_can_be_cached(table) function or so.
> 
> Agree. The function of acpi_os_map_memory will also be used on IA64
> platform. It seems more reasonable to use a wrapper function to check
> whether the corresponding region can be mapped as cached type. 
> > 
> > In fact since __acpi_map_table(addr,size) is defined by architectures already, 
> > this could be done purely within x86 code.
> > 
> > Thanks,
> > 
> > 	Ingo
