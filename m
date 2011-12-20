Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752780Ab1LTPcV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 10:32:21 -0500
Received: from andromeda.dapyr.net ([206.212.254.10]:32875 "EHLO
	andromeda.dapyr.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751414Ab1LTPcO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 10:32:14 -0500
Date: Tue, 20 Dec 2011 11:31:45 -0400
From: Konrad Rzeszutek Wilk <konrad@darnok.org>
To: "Tian, Kevin" <kevin.tian@intel.com>
Cc: "jeremy@goop.org" <jeremy@goop.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "Ian.Campbell@citrix.com" <Ian.Campbell@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "mike.mcclurg@citrix.com" <mike.mcclurg@citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stefan.bader@canonical.com" <stefan.bader@canonical.com>,
        "rjw@sisk.pl" <rjw@sisk.pl>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "liang.tang@oracle.com" <liang.tang@oracle.com>,
        "Yu, Ke" <ke.yu@intel.com>, "konrad@kernel.org" <konrad@kernel.org>,
        "lenb@kernel.org" <lenb@kernel.org>
Subject: Re: [Xen-devel] [PATCH 3/8] ACPI: processor: add __acpi_processor_[un]register_driver helpers.
Message-ID: <20111220153145.GB13253@andromeda.dapyr.net>
References: <1322673664-14642-1-git-send-email-konrad.wilk@oracle.com> <1322673664-14642-4-git-send-email-konrad.wilk@oracle.com> <20111216220342.GC9832@phenom.dumpdata.com> <625BA99ED14B2D499DC4E29D8138F1506E01AABC7A@shsmsx502.ccr.corp.intel.com> <20111219142626.GB27772@andromeda.dapyr.net> <625BA99ED14B2D499DC4E29D8138F1506E01AAC03A@shsmsx502.ccr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <625BA99ED14B2D499DC4E29D8138F1506E01AAC03A@shsmsx502.ccr.corp.intel.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 20, 2011 at 10:29:12AM +0800, Tian, Kevin wrote:
> > From: Konrad Rzeszutek Wilk [mailto:konrad@darnok.org]
> > Sent: Monday, December 19, 2011 10:26 PM
> > 
> > On Mon, Dec 19, 2011 at 01:48:01PM +0800, Tian, Kevin wrote:
> > > > From: Konrad Rzeszutek Wilk [mailto:konrad.wilk@oracle.com]
> > > > Sent: Saturday, December 17, 2011 6:04 AM
> > > >
> > > > On Wed, Nov 30, 2011 at 12:20:59PM -0500, Konrad Rzeszutek Wilk wrote:
> > > > > From: Tang Liang <liang.tang@oracle.com>
> > > > >
> > > > > This patch implement __acpi_processor_[un]register_driver helper,
> > > > > so we can registry override processor driver function. Specifically
> > > > > the Xen processor driver.
> > > >
> > > > Liang,
> > > >
> > > > Is the reason we are doing this b/c we need to call acpi_bus_register_driver
> > > > and inhibit the registration of 'acpi_processor_driver' ?
> > > >
> > > > And the reason we don't want 'acpi_processor_driver' to run is b/c of what?
> > > > If the cpuidle is disabled what is the harm of running the
> > > > 'acpi_processor_driver'
> > > > driver?
> > >
> > > IIRC, the reason why we want a Xen specific driver is because current driver
> > > is integrated with OS logic too tightly, e.g. the various checks on VCPU related
> > > structures. Long time ago the 1st version in Xen was to use same driver, by
> > > adding various tweaking lines inside which makes it completely messed. Then
> > > later it's found that it's clearer to create a Xen specific wrapping driver, by
> > > invoking some exported functions from existing one.
> > 
> > What I am asking is does it matter "if the current driver is integrated
> > with OS logic to tighly" - as it is not running anyhow (b/c cpuidle is
> > disabled).
> > 
> > And if Xen specific driver can run along-side the generic one - since
> > the generic one is not doing any work (b/c cpuidle is disabled).
> > 
> > That is what I am trying to figure out - since this patch purpose is to
> > thwart the generic driver from running and allowing the xen one to run.
> 
> It's a separate issue from cpuidle case. Here we're talking about acpi processor
> driver, not the acpi cpuidle driver. ACPI processor driver is responsible for 
> discovering ACPI processor projects, and then enumerate various methods 
> such as _PPC, _CST, etc. under those objects. So far this driver depends on 
> VCPU presence in various places, which causes trouble when dom0 is configured
> with less VCPU number than physical present one.
> 
> One example you can see from acpi_processor_add:
> 
>         result = acpi_processor_get_info(device); // call acpi_get_cpuid
>         if (result) {
>                 /* Processor is physically not present */
>                 return 0;
>         }
> 
> #ifdef CONFIG_SMP
>         if (pr->id >= setup_max_cpus && pr->id != 0)
>                 return 0;
> #endif 
> 
>         BUG_ON((pr->id >= nr_cpu_ids) || (pr->id < 0));
> 
> The binding between ACPI processor objects and VCPU presence would only parse
> partial objects to Xen. And there're various places within driver validating pr->id
> making it messy to workaround for Xen within same driver.
> 
> That's the major reason for coming up a Xen specific driver, which always parses
> all present objects regardless of VCPU presence. :-)

OK. Lets put the # VCPU != PCPU aside. Say dom0 will boot with all
CPUs and then later on the admin starts unplugging them.

With that in mind, could we use a slim driver (like the one in: "ACPI:
 add processor driver for Xen virtual CPUs.") that would just
take the _Pxx, Cxx data and shove them to the hypervisor (handwaving
aside the checking for quirks and such). And lets assume that we use the
unmodified acpi_processor_[add|remove|notify] code that is present in
processor_driver.c.

Oh, and the processor-driver.c did try to load (with the understanding
that it would load, but won't do much since cpuidle is turned off).

Would that still get the Pxx, Cxx data to the hypervisor?
