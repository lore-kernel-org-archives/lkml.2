Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965164Ab2JDOae (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 10:30:34 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:50559 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964963Ab2JDOad (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 10:30:33 -0400
X-Sasl-enc: 32ZWMVCal2pgXYR1g4iT1jwLlbsTgq8P+CQt5OF8M+s/ 1349361032
Date: Thu, 4 Oct 2012 07:30:30 -0700
From: Greg KH <greg@kroah.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Bjorn Helgaas <bhelgaas@google.com>, linux-arm-kernel@lists.infradead.org,
        arm@kernel.org, linux-kernel@vger.kernel.org,
        Lennert Buytenhek <kernel@wantstofly.org>, Dan Williams <djbw@fb.com>
Subject: Re: [PATCH 12/17] ARM: iop13xx: mark iop13xx_scan_bus as __devinit
Message-ID: <20121004143030.GB26625@kroah.com>
References: <1349195816-2225-1-git-send-email-arnd@arndb.de>
 <1349195816-2225-13-git-send-email-arnd@arndb.de>
 <CAErSpo7rkN_F=AxweoEG3oXj392FvzVGPSKnkXCd=JX6cg0aTA@mail.gmail.com>
 <201210041032.20300.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201210041032.20300.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 04, 2012 at 10:32:20AM +0000, Arnd Bergmann wrote:
> (+Greg)
> 
> On Tuesday 02 October 2012, Bjorn Helgaas wrote:
> > 
> > On Tue, Oct 2, 2012 at 10:36 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> > > pci_scan_root_bus is __devinit, so iop13xx_scan_bus has to be the
> > > same in order to safely call it. This is ok because the function
> > > itself is only called from the hwpci->scan callback.
> > >
> > > WARNING: vmlinux.o(.text+0x10138): Section mismatch in reference from the function iop13xx_scan_bus() to the function .devinit.text:pci_scan_root_bus()
> > > The function iop13xx_scan_bus() references
> > > the function __devinit pci_scan_root_bus().
> > > This is often because iop13xx_scan_bus lacks a __devinit
> > > annotation or the annotation of pci_scan_root_bus is wrong.
> > 
> > With CONFIG_HOTPLUG going away (I think the current state is that it
> > is always set to "y"), __devinit will effectively become a no-op, so I
> > expect we'll remove it from pci_scan_root_bus().
> > 
> > Therefore, I would skip this patch and live with the warning a little longer.
> 
> Hmm, I'm just trying to get rid of all build time warnings in the defconfigs
> right now, and modpost still complains about the section mismatches. I have
> a bunch more of these patches, but it would also be fine with me if we can
> patch mostpost to ignore these cases.
> 
> I've also redone the analysis that Greg cited in the commit message for
> 45f035ab9b8 "CONFIG_HOTPLUG should be always on"
> 
>    It is quite hard to disable it these days, and even if you do, it
>     only saves you about 200 bytes.  However, if it is disabled, lots of
>     bugs show up because it is almost never tested if the option is disabled.
> 
> My test case (ARM omap2plus_defconfig, one of the most common configurations)
> shows these size -A differences:
> 
> 
> 
> section		nohotplug	hotplug		difference
> .head.text	392		392		0
> .text		4829940		4881140		51200
> .rodata		1630360		1633056		2696
> __ksymtab	25720		25720		0
> __ksymtab_gpl	17096		17136		40
> __kcrctab	12860		12860		0
> __kcrctab_gpl	8548		8568		20
> __ksymtab_stri	96427		96509		82
> __init_rodata	0		9800		9800
> __param		2320		2320		0
> __modver	716		364		-352
> .ARM.unwind_idx	160360		160792		432
> .ARM.unwind_tab	24312		24312		0
> .init.text	234632		195688		-38944
> .exit.text	8680		5116		-3564
> .init.proc.info	312		312		0
> .init.arch.info	2964		2964		0
> .init.tagtable	72		72		0
> .init.smpalt	776		776		0
> .init.pv_table	880		880		0
> .init.data	123356		111348		-12008
> .exit.data	0		0		0
> .data..percpu	12928		12928		0
> .data		560160		562688		2528
> .notes		36		36		0
> .bss		5605324		5605580		256
> 
> total		13359171	13371357	12186
> after boot	13001183	13054521	53338
> 
> That is over 50kb difference after discarding the init sections,
> significantly more than the 200 bytes that Greg found.
> The point about lack of testing is still valid of course, and I'm
> not saying we need to keep the option around, but it's really
> not as obvious as before. An argument in favor of removing the
> __devinit logic is that these 50kb is still just 0.4% of the
> kernel size.
> 
> For the five ARM defconfig files that actually turn off hotplug,
> the absolute numbers are a bit lower, but the percentage is similar.
> 
> This is the amount of space wasted by enabling on CONFIG_HOTPLUG
> on them, in bytes after discarding the init sections, and as a
> percentage of the vmlinux size:
> 
> at91x40_defconfig	3448	0.27%
> edb7211_defconfig	8912	0.41%
> footbridge_defconfig	33347	0.97%
> fortunet_defconfig	4592	0.25%
> pleb_defconfig		7405	0.28%
> 
> Footbridge is the only config among these that enables PCI and USB, so
> it has a bunch more drivers that actually have notable functions that 
> can be discarded.

USB drivers should not be having anything discarded if CONFIG_HOTPLUG is
disabled (it shouldn't be disabled for USB systems, unless someone isn't
going to plug a USB device into the system after it comes up, which is
one of the main confusions here.)

As for PCI, that seems like a lot of code getting thrown away, it would
be interesting to figure out why that is.

My plans are to now start unwinding the CONFIG_HOTPLUG dependancies.  If
a driver subsystem really does want to throw away sections (like PCI
will if CONFIG_PCI_HOTPLUG is not enabled), then it should be able to.
But I imagine all of the real savings will be in the bus cores, not the
individual drivers, unless they have huge module_init() functions.

Thanks for the numbers, I'll look into this more in the coming weeks.

greg k-h
