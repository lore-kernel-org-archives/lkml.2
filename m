Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753877Ab2JDKck (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 06:32:40 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:51820 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753001Ab2JDKci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 06:32:38 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH 12/17] ARM: iop13xx: mark iop13xx_scan_bus as __devinit
Date: Thu, 4 Oct 2012 10:32:20 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, arm@kernel.org,
        linux-kernel@vger.kernel.org,
        Lennert Buytenhek <kernel@wantstofly.org>, Dan Williams <djbw@fb.com>,
        Greg KH <greg@kroah.com>
References: <1349195816-2225-1-git-send-email-arnd@arndb.de> <1349195816-2225-13-git-send-email-arnd@arndb.de> <CAErSpo7rkN_F=AxweoEG3oXj392FvzVGPSKnkXCd=JX6cg0aTA@mail.gmail.com>
In-Reply-To: <CAErSpo7rkN_F=AxweoEG3oXj392FvzVGPSKnkXCd=JX6cg0aTA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201210041032.20300.arnd@arndb.de>
X-Provags-ID: V02:K0:SH1WjKZJKfqlzL2s6K88M9exHl85WWr8monxses47Kh
 czinxsGnxxaTJ29iK3UBRs0/L93lzbRJcJ/uodes5yHflTMucZ
 +bx3QxVGpXqCdz8HFdsyzOHS/X2Fy5agWLjhQ/xTba2Kcgo2qK
 +Rxp4ZiSm9S0bFV1NCz0FqVkoZX132DINZPdFp3sWrdJxAJM1c
 JcX2y3JV5RodX4W1LAEybLt/RkGtg8bSvLUUBrnSHEm0M0SjyS
 nMX487b2PAMKP4FLZsLxawI3oP37eiMLV2xdgCgV2ZySjr8h+r
 3FuyoSK6/Bnxt9Y5EGq64aZUYUKI5dBRPs5mkEgTZpqxo+F4l8
 oEBKEdZp/IyCinN9JNN8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(+Greg)

On Tuesday 02 October 2012, Bjorn Helgaas wrote:
> 
> On Tue, Oct 2, 2012 at 10:36 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> > pci_scan_root_bus is __devinit, so iop13xx_scan_bus has to be the
> > same in order to safely call it. This is ok because the function
> > itself is only called from the hwpci->scan callback.
> >
> > WARNING: vmlinux.o(.text+0x10138): Section mismatch in reference from the function iop13xx_scan_bus() to the function .devinit.text:pci_scan_root_bus()
> > The function iop13xx_scan_bus() references
> > the function __devinit pci_scan_root_bus().
> > This is often because iop13xx_scan_bus lacks a __devinit
> > annotation or the annotation of pci_scan_root_bus is wrong.
> 
> With CONFIG_HOTPLUG going away (I think the current state is that it
> is always set to "y"), __devinit will effectively become a no-op, so I
> expect we'll remove it from pci_scan_root_bus().
> 
> Therefore, I would skip this patch and live with the warning a little longer.

Hmm, I'm just trying to get rid of all build time warnings in the defconfigs
right now, and modpost still complains about the section mismatches. I have
a bunch more of these patches, but it would also be fine with me if we can
patch mostpost to ignore these cases.

I've also redone the analysis that Greg cited in the commit message for
45f035ab9b8 "CONFIG_HOTPLUG should be always on"

   It is quite hard to disable it these days, and even if you do, it
    only saves you about 200 bytes.  However, if it is disabled, lots of
    bugs show up because it is almost never tested if the option is disabled.

My test case (ARM omap2plus_defconfig, one of the most common configurations)
shows these size -A differences:



section		nohotplug	hotplug		difference
.head.text	392		392		0
.text		4829940		4881140		51200
.rodata		1630360		1633056		2696
__ksymtab	25720		25720		0
__ksymtab_gpl	17096		17136		40
__kcrctab	12860		12860		0
__kcrctab_gpl	8548		8568		20
__ksymtab_stri	96427		96509		82
__init_rodata	0		9800		9800
__param		2320		2320		0
__modver	716		364		-352
.ARM.unwind_idx	160360		160792		432
.ARM.unwind_tab	24312		24312		0
.init.text	234632		195688		-38944
.exit.text	8680		5116		-3564
.init.proc.info	312		312		0
.init.arch.info	2964		2964		0
.init.tagtable	72		72		0
.init.smpalt	776		776		0
.init.pv_table	880		880		0
.init.data	123356		111348		-12008
.exit.data	0		0		0
.data..percpu	12928		12928		0
.data		560160		562688		2528
.notes		36		36		0
.bss		5605324		5605580		256

total		13359171	13371357	12186
after boot	13001183	13054521	53338

That is over 50kb difference after discarding the init sections,
significantly more than the 200 bytes that Greg found.
The point about lack of testing is still valid of course, and I'm
not saying we need to keep the option around, but it's really
not as obvious as before. An argument in favor of removing the
__devinit logic is that these 50kb is still just 0.4% of the
kernel size.

For the five ARM defconfig files that actually turn off hotplug,
the absolute numbers are a bit lower, but the percentage is similar.

This is the amount of space wasted by enabling on CONFIG_HOTPLUG
on them, in bytes after discarding the init sections, and as a
percentage of the vmlinux size:

at91x40_defconfig	3448	0.27%
edb7211_defconfig	8912	0.41%
footbridge_defconfig	33347	0.97%
fortunet_defconfig	4592	0.25%
pleb_defconfig		7405	0.28%

Footbridge is the only config among these that enables PCI and USB, so
it has a bunch more drivers that actually have notable functions that 
can be discarded.

	Arnd
