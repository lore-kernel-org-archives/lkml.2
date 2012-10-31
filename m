Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935580Ab2JaOEf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 10:04:35 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:16412 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932647Ab2JaOEd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 10:04:33 -0400
Date: Wed, 31 Oct 2012 09:51:50 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: "Liu, Jinsong" <jinsong.liu@intel.com>
Cc: Konrad Rzeszutek Wilk <konrad@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jan Beulich <jbeulich@suse.com>,
        "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>
Subject: Re: [Xen-devel] [PATCH 1/2] Xen acpi pad implement
Message-ID: <20121031135150.GA28699@phenom.dumpdata.com>
References: <DE8DF0795D48FD4CA783C40EC82923353723C7@SHSMSX101.ccr.corp.intel.com>
 <508A89CB020000780008E6ED@nat28.tlf.novell.com>
 <DE8DF0795D48FD4CA783C40EC8292335372883@SHSMSX101.ccr.corp.intel.com>
 <DE8DF0795D48FD4CA783C40EC829233537292E@SHSMSX101.ccr.corp.intel.com>
 <20121026201409.GF2708@phenom.dumpdata.com>
 <DE8DF0795D48FD4CA783C40EC8292335373918@SHSMSX101.ccr.corp.intel.com>
 <20121029123950.GK2708@phenom.dumpdata.com>
 <DE8DF0795D48FD4CA783C40EC8292335374C86@SHSMSX101.ccr.corp.intel.com>
 <20121030133720.GA27463@phenom.dumpdata.com>
 <DE8DF0795D48FD4CA783C40EC82923353755E1@SHSMSX101.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DE8DF0795D48FD4CA783C40EC82923353755E1@SHSMSX101.ccr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 30, 2012 at 03:18:59PM +0000, Liu, Jinsong wrote:
> Konrad Rzeszutek Wilk wrote:
> >>> +config XEN_ACPI_PAD_STUB
> >>> +	bool
> >>> +	depends on XEN_DOM0 && X86_64 && ACPI
> >>> +	default n
> >>> +
> >> 
> >> This Kconfig is pointless, if CONFIG_XEN_ACPI_PAD_STUB = n, native
> >> pad would successfully registerred, and then mwait #UD (we would
> >> revert df88b2d96e36d9a9e325bfcd12eb45671cbbc937, right?). So xen
> >> stub logic should unconditionally built-in kernel.   
> > 
> > 
> > Potentially. Keep in mind that there is no need to built this if the
> > kernel is not built with ACPI.
> 
> Sure, 'obj-$(CONFIG_XEN_DOM0) +=' is enough.
> (XEN_DOM0 depends on ACPI).
> 
> >>> +subsys_initcall(xen_acpi_pad_stub_init);
> >> 
> >> I'm still confused. In this way there are xen-acpi-pad-stub.c and
> >> xen-acpi-pad.c, and you want to let xen-acpi-pad loaded as module,
> >> right? how can xen-acpi-pad logic work when it was insmoded?  
> > 
> > Via the register/unregister calls that this provides? Or does ACPI bus
> > drivers get immediately called once the call acpi_bus_register_driver?
> 
> But when xen stub driver registerred, real xen pad ops has not been hooked to stub ops.
> 
> > 
> > Or can one 'poke' the 'add' and 'remove' calls so that once the "true"
> > PAD driver is loaded it will restart the ops->add call?
> 
> I think we'd better not to use xen pad stub approach. Technically it's complicated, say, how to match xen_acpi_pad driver w/ pad device? when and how to invoke .add method? how to avoid native pad loading risk? etc. I didn't find its obivous advantages, so how about keep simpler approach?

OK. Lets go with that one for right now. The one thing I don't like about it is
that it is built-in. It would be so much better if it was a module, but I am just
not sure how to make that work with the acpi_pad. Unless the mwait CPUID capability
is not exported (so drop your patch 1 that reverts a commit).

Perhaps there is a way to make it a module/built-in with some Kconfig
magic options? Say if ACPI_PROCESSOR_AGGREGATOR is not set, then we can
make it a module. But if ACPI_PROCESSOR_AGGREGATOR=m|y then we do it
as built-in?

