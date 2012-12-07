Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030644Ab2LGOFo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 09:05:44 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:39642 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030437Ab2LGOFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 09:05:43 -0500
Date: Fri, 7 Dec 2012 09:05:28 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: "Liu, Jinsong" <jinsong.liu@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "lenb@kernel.org" <lenb@kernel.org>
Subject: Re: [PATCH V1 1/2] Xen acpi memory hotplug driver
Message-ID: <20121207140528.GA3140@phenom.dumpdata.com>
References: <DE8DF0795D48FD4CA783C40EC82923353942F9@SHSMSX101.ccr.corp.intel.com>
 <20121128192601.GA15871@phenom.dumpdata.com>
 <DE8DF0795D48FD4CA783C40EC829233539AC1D@SHSMSX101.ccr.corp.intel.com>
 <20121205174307.GC16072@phenom.dumpdata.com>
 <DE8DF0795D48FD4CA783C40EC82923353A2366@SHSMSX101.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DE8DF0795D48FD4CA783C40EC82923353A2366@SHSMSX101.ccr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 06, 2012 at 04:27:36AM +0000, Liu, Jinsong wrote:
> >>>> diff --git a/drivers/xen/Kconfig b/drivers/xen/Kconfig
> >>>> index 126d8ce..abd0396 100644
> >>>> --- a/drivers/xen/Kconfig
> >>>> +++ b/drivers/xen/Kconfig
> >>>> @@ -206,4 +206,15 @@ config XEN_MCE_LOG
> >>>>  	  Allow kernel fetching MCE error from Xen platform and
> >>>>  	  converting it into Linux mcelog format for mcelog tools
> >>>> 
> >>>> +config XEN_ACPI_MEMORY_HOTPLUG
> >>>> +	bool "Xen ACPI memory hotplug"
> >>> 
> >>> There should be a way to make this a module.
> >> 
> >> I have some concerns to make it a module:
> >> 1. xen and native memhotplug driver both work as module, while we
> >> need early load xen driver. 
> >> 2. if possible, a xen stub driver may solve load sequence issue, but
> >>   it may involve other issues * if xen driver load then unload,
> >> native driver may have chance to load successfully; 
> > 
> > The stub driver would still "occupy" the ACPI bus for the memory
> > hotplug PnP, so I think this would not be a problem.
> > 
> 
> I'm not quite clear your mean here, do you mean it has
> 1. xen_stub driver + xen_memhoplug driver, then xen_strub driver unload and entirely replaced by xen_memhotplug driver, or
> 2. xen_stub driver (w/ stub ops) + xen_memhotplug ops (not driver), then xen_stub driver keep occupying but its stub ops later replaced by xen_memhotplug ops?

#2
> 
> If in way #1, it has risk that native driver may load (if xen driver unload).
> If in way #2, xen_memhotplug ops lose the chance to probe/add/bind existed memory devices (since it's done when driver registerred).

Could the stub driver have a queue of events?

> 
> >>   * if xen driver load --> unload --> load again, then it will lose
> >> hotplug notification during unload period; 
> > 
> > Sure. But I think we can do it with this driver? After all the
> > function of 
> > it is to just tell the firmware to turn on/off sockets - and if we
> > miss 
> > one notification we won't take advantage of the power savings - but we
> > can do that later on.
> > 
> 
> Not only inform firmware.
> Hotplug notify callback will invoke acpi_bus_add -> ... -> implicitly invoke drv->ops.add method to add the hotadded memory device.

Gotcha.
> 
> > 
> >>   * if xen driver load --> unload --> load again, then it will
> >> re-add all memory devices, but the handle for 'booting memory
> >> device' and 'hotplug memory device' are different while we have no
> >> way to distinguish these 2 kind of devices.   
> > 
> > Wouldn't the stub driver hold onto that?
> > 
> 
> Same question as comment #1. Do you mean it has a xen_stub driver (w/ stub ops) and a xen_memhotplug ops?

Correct.
> 
> >> 
> >> IMHO I think to make xen hotplug logic as module may involves
> >> unexpected result. Is there any obvious advantages of doing so?
> >> after all we have provided config choice to user. Thoughts?  
> > 
> > Yes, it becomes a module - which is what we want.
> > 
> 
> What I meant here is, module will bring some unexpected issues for xen hotplug.
> We can provide user 'bool' config choice, let them decide to build-in or not, but not 'tristate' choice.

What would be involved in making it an tristate choice?
> 
> Thanks
> Jinsong
