Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964942Ab1LPWXC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 17:23:02 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:59102 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756644Ab1LPWWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 17:22:53 -0500
Date: Fri, 16 Dec 2011 17:21:41 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: liang tang <liang.tang@oracle.com>
Cc: Jan Beulich <JBeulich@suse.com>, stefan.bader@canonical.com,
        Ian.Campbell@citrix.com, mike.mcclurg@citrix.com, jeremy@goop.org,
        ke.yu@intel.com, kevin.tian@intel.com, konrad@kernel.org,
        lenb@kernel.org, xen-devel@lists.xensource.com, rjw@sisk.pl,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] [PATCH 5/8] ACPI: add processor driver for Xen
 virtual CPUs.
Message-ID: <20111216222140.GD9832@phenom.dumpdata.com>
References: <1322673664-14642-1-git-send-email-konrad.wilk@oracle.com>
 <1322673664-14642-6-git-send-email-konrad.wilk@oracle.com>
 <4ED755D70200007800064987@nat28.tlf.novell.com>
 <20111212172941.GA8619@phenom.dumpdata.com>
 <4EE710A00200007800067274@nat28.tlf.novell.com>
 <4EE71A62.9050700@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EE71A62.9050700@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090202.4EEBC4B1.002D,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 13, 2011 at 05:26:58PM +0800, liang tang wrote:
> On 2011-12-13 15:45, Jan Beulich wrote:
> >>>>On 12.12.11 at 18:29, Konrad Rzeszutek Wilk<konrad.wilk@oracle.com>  wrote:
> >>On Thu, Dec 01, 2011 at 09:24:23AM +0000, Jan Beulich wrote:
> >>>>>>On 30.11.11 at 18:21, Konrad Rzeszutek Wilk<konrad.wilk@oracle.com>  wrote:
> >>>>--- a/drivers/acpi/Makefile
> >>>>+++ b/drivers/acpi/Makefile
> >>>>@@ -66,6 +66,7 @@ obj-$(CONFIG_ACPI_CUSTOM_METHOD)+= custom_method.o
> >>>>  # processor has its own "processor." module_param namespace
> >>>>  processor-y			:= processor_driver.o processor_throttling.o
> >>>>  processor-y			+= processor_idle.o processor_thermal.o
> >>>>+processor-y			+= processor_xen.o
> >>>This should minimally be processor-$(CONFIG_XEN), with other things
> >>>adjusted as necessary.
> >>I was under the impression that this was required to get the
> >>processor_xen.ko
> >>to be a module. Otherwise it would only compile as built-in.
> >processor_xen.ko? Why not have all the code go into processor.ko?
> >(And the original construct didn't aim in that direction either.)
> >
> >Jan
> >
> the code about driver function which kernel
> require(drivers/acpi/processor_xen.c )  build into processor.ko.
> the code which have more relation with xen
> (drivers/xen/acpi_processor.c)  did not build into processor.ko.

I am not sure if I understand you. Are you saying that the bulk of
'acpi_processor' (in the drivers/xen directory) should not be built in
processor.o and that the config options will do that?

But the config option is for the drivers/acpi directory..

So if I enable CONFIG_ACPI_PROCESSOR and CONFIG_ACPI_PROCESSOR_XEN
then the build will stick processor_xen.o in to the processor.ko file.

And if I select CONFIG_ACPI_PROCESSOR and unselect CONFIG_ACPI_PROCESSOR_XEN
then I still get some of the processor_xen.o stuck in processor.ko file?
(Granted, there is not much that gets stuck in b/c the majority of the code
is guarded by a big #if defined(CONFIG_ACPI_PROCESSOR_XEN..) so the compiler
might not stick anything in there)


Is there a way to make it so there are _two_ modules:
 - processor.ko
 - processor-xen.ko [which uses some code from processor.ko]

And they both can work together? Well, .. such that processor.ko
does not really do anything since there are no cpuidle enabled, and
the processor-xen.ko just deals with the parsing of ACPI Pxx states.

And since cpuidle is disabled, there won't be any notify events sent anyhow
so that could be removed (ah wait. the processor_xen.c does call
processor_cntl_xen_notify(..PM_INIT) to pipe the data up.. so that is
needed).

In which case the processor-xen.ko only does one thing - parses the 
'struct acpi_processor' data and pipes it up the hypervisor.

Would this be feasible?

> liang
