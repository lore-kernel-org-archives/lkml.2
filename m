Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965097Ab2EXTvn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 15:51:43 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:30036 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932869Ab2EXTvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 15:51:41 -0400
Message-ID: <1337888931.16730.393.camel@misato.fc.hp.com>
Subject: Re: [PATCH v4 0/6] ACPI: Add _OST support for ACPI hotplug
From: Toshi Kani <toshi.kani@hp.com>
To: shuahkhan@gmail.com
Cc: lenb@kernel.org, linux-acpi@vger.kernel.org, bhelgaas@google.com,
        liuj97@gmail.com, andi@firstfloor.org, linux-kernel@vger.kernel.org
Date: Thu, 24 May 2012 13:48:51 -0600
In-Reply-To: <1337880880.2718.68.camel@lorien2>
References: <1337826324-16802-1-git-send-email-toshi.kani@hp.com>
	 <1337880880.2718.68.camel@lorien2>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-24 at 11:34 -0600, Shuah Khan wrote:
> On Wed, 2012-05-23 at 20:25 -0600, Toshi Kani wrote:
> > This patchset supports ACPI OSPM Status Indication (_OST) method for
> > ACPI CPU/memory/container hotplug operations and sysfs eject. After
> > an ACPI hotplug operation has completed, OSPM calls _OST to indicate
> > the result of the operation to the platform. If a platform does not
> > support _OST, this patchset has no effect on the platform.
> > 
> > This _OST support is enabled when all relevant ACPI hotplug operations,
> > such as CPU, memory and container hotplug, are enabled. This assures
> > consistent behavior among the hotplug operations with regarding the
> > _OST support.
> > 
> > Some platforms may require the OS to support _OST in order to support
> > ACPI hotplug operations. For example, if a platform has the management
> > console where user can request a hotplug operation from, this _OST
> > support would be required for the management console to show the result
> > of the hotplug request to user.
> > 
> > The _OST definition can be found in section 6.3.5 of ACPI 5.0 spec.
> > The HPPF spec below also describes hotplug flows with _OST.
> > 
> >   DIG64 Hot-Plug & Partitioning Flow (HPPF) Specification R1.0
> >   http://www.dig64.org/home/DIG64_HPPF_R1_0.pdf
> > 
> > The changes have been tested with simulated _OST methods.
> 
> Toshi,
> 
> First of all thanks for asking for my feedback. :) Having benefited from
> reviewing the previous versions of this patch set, my thoughts on the
> implementation have evolved.

Thanks for reviewing! :)

> I have some general comments first in the response, and please find code
> specific comments on individual patches.
> 
> This patch set enables Insertion/Ejection _OST processing support which
> will be a good addition since OS already supports it for Processor
> Aggregator Device Support and _PPC.

Right.

> However, in this case it is enabled as a compile time option and would
> require a kernel build when firmware starts supporting _OST method in
> some cases. Reference: PATCH v4 1/6. 

Yes, it requires ACPI CPU, Memory and Container hotplug be enabled in the kernel.

> It also restricts the support to be all or nothing. i.e _OST is
> supported only when all relevant hotplug operations are supported and
> these need to be specifically enabled using the config options that
> control it. For example, if a platform supports CPU_HOTPLUG and not
> MEMORY_HOTPLUG, _OST support will be disabled even when firmware
> supports it for cpus. Also the set of hotplug operations is limited as
> _OST could be present in other hotplug cases such as PCI and PCIe.
>
> I understand the spirit of this restriction that you are trying to limit
> the exposure and it is a good goal. However, it probably could be
> achieved in a way that doesn't shoehorn the implementation.

This restriction is to assure that the OS is compliant with the ACPI
spec. When the OS calls _OSC with the hotplug _OST bit set, the OS needs
to support _OST for all relevant ACPI hotplug operations. Unfortunately,
this requires all relevant hotplug modules be enabled in the OS under
the current implementation.

For example, when the platform supports ACPI memory hotplug, but
ACPI_HOTPLUG_MEMORY is undefined in the OS, the OS needs to call _OSC
with the hotplug _OST bit unset. This is because the OS cannot receive
an ACPI notification to a memory object when ACPI_HOTPLUG_MEMORY is
undefined. Without the notify handler, we cannot call _OST.

A long term solution to address this issue is to have the system global
notify handler to receive all hotplug notifications, and call _OST
accordingly. However, it will require restructuring efforts which well
beyond the scope of this patchset. The email below describes this issue
and my thoughts on this.
http://marc.info/?l=linux-acpi&m=133546048929384&w=2

> I think here are the goals, 
> 
> 1. limit exposure so platforms that don't implement _OST are not
> penalized evaluation _OST unnecessarily.

This goal is met since the OS cannot evaluate _OST unless it is
implemented.

> 2. enable it when needed without requiring special compile time steps
> and not worrying about sorting through various config options.

I agree, but as I explained above, this is required to be compliant with
ACPI spec at this point. We can remove this restriction by improving the
notify handler design, but it will take more steps to do so.

> 3. don't require all hotplug variants to be enabled in config, before OS
> enables _OST support.

I agree, but the same reason above.

> I see that you are enabling _OST evaluation and set the cap bit
> OSC_SB_PPC_OST_SUPPORT only when ACPI_HOTPLUG_OST is defined. What
> happens on when a kernel is configured with the config options that
> enable ACPI_HOTPLUG_OST at compile time, and other hotplug options for
> example CONFIG_HOTPLUG_PCI_PCIE, and CONFIG_HOTPLUG_PCI.

Non-ACPI hotplug operations like PCIe native hotplug are irrelevant to _OST.

If user defines ACPI_HOTPLUG_OST at compile time, it forces the _OST to
be supported. It works fine as long as the kernel hotplug capabilities
match with the platform. 

> _OST is a platform capability and once OS tells firmware it can support
> it, isn't it expected to call all _OST method if present under any
> device object that is hotplug capable? What are the implications and
> issues if OS doesn't evaluate _OST on PCI for example, once it tells the
> firmware it supports _OST as a platform capability when it evaluates
> _OSC? The question is, is it safe? This goes back to the first goal on
> exposure.

Yes, and therefore, this _OST support is enabled when all relevant
hotplug operations are enabled.

> Also, when _OSC is evaluated, the _OST code in this patch set, tells
> firmware it supports _OST, however it doesn't check whether or not the
> firmware actually acked the capability or not. Hence, it doesn't make
> sure firmware has support for it, before it enables the _OST.

This step is not necessary because FW does not implement _OST method
when it does not support it.

> I think you will get closer to implementing a solution that achieves the
> stated objectives by changing the design some as outlined below: ( I am
> sure there are other ideas )
> 
> 1. implement this similar to the way APEI support (OSC_SB_APEI_SUPPORT)
> is implemented by checking the firmware ack and enabling the apei
> support using a bool osc_sb_apei_support_acked which is only set when
> firmware acknowledges back saying it can also support _OST. This ensures
> that the feature is enabled only when both OS and firmware support it.
> It will also get rid of the compile time restrictions.

APEI needs the OS to configure FW mode, so this acknowledge is
necessary. This step is not necessary for _OST.

> 2. Calling acpi_get_handle() on _OST prior to executing the method. This
> will ensure that this method only gets run if it is present under the
> device in question. Coupled with what is already outlined in #1 above,
> now _OST gets executed only when it is defined under the device object.
> Example case in the existing code, please see acpi_processor_ppc_ost()
> implementation.

Yes, I did look at acpi_processor_ppc_ost() when I implemented the
function.  I believe calling acpi_get_handle() is redundant since
acpi_ns_get_node() is called within acpi_evaluate_object() as well.
acpi_evaluate_object() simply returns with AE_NOT_FOUND when _OST method
does not exist.

> Please see other examples of _OST implementation in the kernel that
> implement _OST for PAD and _PPC. These two examples will help you
> understand my premise for these review comments.

I think acpi_processor_ppc_ost() has a bug since it calls _OST with 2
parameters. _OST is defined to have 3 parameters. When I called my _OST
method with 2 parameters for testing, it generated a warning message.  


Thanks,
-Toshi


> Thanks,
> -- Shuah
> 


