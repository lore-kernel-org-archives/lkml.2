Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752063Ab0G0S4k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 14:56:40 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:52800 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751080Ab0G0S4j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 14:56:39 -0400
Date: Tue, 27 Jul 2010 19:56:28 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        linux-pci@vger.kernel.org, Len Brown <lenb@kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        linux-pm@lists.linux-foundation.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [RFC][PATCH] PCI / PCIe: Ask BIOS for control of all native
	services simultaneously
Message-ID: <20100727185628.GA17903@srcf.ucam.org>
References: <201007250105.23610.rjw@sisk.pl> <4C4E2BBD.7080003@jp.fujitsu.com> <20100727171842.GB7324@srcf.ucam.org> <201007272042.39269.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201007272042.39269.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 27, 2010 at 08:42:39PM +0200, Rafael J. Wysocki wrote:
> On Tuesday, July 27, 2010, Matthew Garrett wrote:
> > I've done some more testing of this and found that my intial belief 
> > (supported by Microsoft's documentation...) that all PCIe support had to 
> > be handed over for any to be used is incorrect. It turns out that the 
> > firmware must support native hotplug, native power management and PCI 
> > express capability structure control - ie, SHPC and AER aren't required.
> 
> But the ACPI spec says quite explicitly that PCIe capability control is
> necessary for AER as well.

I may not have been clear. If the firmware doesn't report AER, Windows 
will use PME and hotplug. If the firmware doesn't support hotplug, 
Windows will *not* use PME or AER, and ditto if it doesn't support PME.

> > (2) If any of bits 0, 2 and 4 are unsupported, disable all PCIe support 
> > via _OSC
> 
> I guess you mean "don't request control of that services at all"?

I mean pass 0 as the third dword in our _OSC call.

> > (3) Ask for the set of supported bits & 0x1d
> 
> Really, if we try to treat native PME, native hot-plug and AER separately
> (which is our current approach), we fall into a Catch 22 situation where
> each of them needs PCIe capability control and once we've received the
> control of that, we have no choice but to use the other native sevices as well.

It seems that it's valid to have hotplug and PME without AER. The 
behaviour of Windows for each bit is:

0 Hotplug             Required
1 SHPHC               Will never request
2 PME                 Required
3 AER                 Optional
4 capability control  Required

So firmware can refuse to support SHPHC and AER and still get PCIe 
support, but if any of the required bits aren't available Windows won't 
use *any* of the _OSC-provided functions.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
