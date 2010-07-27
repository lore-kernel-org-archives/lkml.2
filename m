Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753527Ab0G0Soa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 14:44:30 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36052 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751134Ab0G0So2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 14:44:28 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [RFC][PATCH] PCI / PCIe: Ask BIOS for control of all native services simultaneously
Date: Tue, 27 Jul 2010 20:42:39 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-rc6-rjw+; KDE/4.4.4; x86_64; ; )
Cc: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        linux-pci@vger.kernel.org, Len Brown <lenb@kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        linux-pm@lists.linux-foundation.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
References: <201007250105.23610.rjw@sisk.pl> <4C4E2BBD.7080003@jp.fujitsu.com> <20100727171842.GB7324@srcf.ucam.org>
In-Reply-To: <20100727171842.GB7324@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201007272042.39269.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, July 27, 2010, Matthew Garrett wrote:
> On Tue, Jul 27, 2010 at 09:43:41AM +0900, Kenji Kaneshige wrote:
> 
> > I think this will break PCIe services currently working. For example,
> > firmware doesn't grant PCIe AER control on my hardware. On the other
> > hand, firmware grants PCIe native hot-plug control on the same machine.
> > So I think PCIe hot-plug will not work with your patch. Another example,
> > what would happen on the platform that doesn't have any PCIe hot-plug
> > slot? I guess firmware doesn't grant PCIe native hot-plug control on
> > that environment. So I think all the other PCIe port services would
> > not work on such platform.
> 
> I've done some more testing of this and found that my intial belief 
> (supported by Microsoft's documentation...) that all PCIe support had to 
> be handed over for any to be used is incorrect. It turns out that the 
> firmware must support native hotplug, native power management and PCI 
> express capability structure control - ie, SHPC and AER aren't required.

But the ACPI spec says quite explicitly that PCIe capability control is
necessary for AER as well.

> However, if any of the other flags are missing then Windows doesn't use 
> any PCIe functionality on the system. That's the behaviour we wish to 
> duplicate.

Agreed.

> > (1) Query all controls for PCIe port services and see what controls
> >     will be granted to OS by firmware.
> > (2) Request all the controls acquired in step (1) at the same time.
> > (3) Create PCIe port services for those controls.
> >
> > What do you think about this?
> 
> I think we need to do:
> 
> (1) Query all controls and see what will be granted

This is done already by our current code running _OSC.

> (2) If any of bits 0, 2 and 4 are unsupported, disable all PCIe support 
> via _OSC

I guess you mean "don't request control of that services at all"?

> (3) Ask for the set of supported bits & 0x1d

Really, if we try to treat native PME, native hot-plug and AER separately
(which is our current approach), we fall into a Catch 22 situation where
each of them needs PCIe capability control and once we've received the
control of that, we have no choice but to use the other native sevices as well.

> > I think there is still a problem that needs to be addressed. The 
> > problem is that if ACPIPHP (ACPI based hot-plug driver) is required 
> > for PCIe hot- plug, all the PCIe port services needs to be disabled. I 
> > don't think it is acceptable for ACPIPHP users.
> 
> I believe that that's the only way Windows will work on their system, 
> which generally implies that that's how the machine was intended to run.

Agreed.

Thanks,
Rafael
