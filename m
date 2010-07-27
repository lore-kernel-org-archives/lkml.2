Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753393Ab0G0Sdc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 14:33:32 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:35983 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753360Ab0G0Sda (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 14:33:30 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Subject: Re: [RFC][PATCH] PCI / PCIe: Ask BIOS for control of all native services simultaneously
Date: Tue, 27 Jul 2010 20:31:15 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-rc6-rjw+; KDE/4.4.4; x86_64; ; )
Cc: linux-pci@vger.kernel.org, Len Brown <lenb@kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        linux-pm@lists.linux-foundation.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Matthew Garrett <mjg@redhat.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
References: <201007250105.23610.rjw@sisk.pl> <4C4E2BBD.7080003@jp.fujitsu.com>
In-Reply-To: <4C4E2BBD.7080003@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201007272031.15517.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, July 27, 2010, Kenji Kaneshige wrote:
> Hi,
> 
> If I understand your patch correctly, the PCIe port services work
> only when firmware grants all the controls for port services with
> your patch. Correct?

Yes, that's correct.

> I think this will break PCIe services currently working. For example,
> firmware doesn't grant PCIe AER control on my hardware. On the other
> hand, firmware grants PCIe native hot-plug control on the same machine.
> So I think PCIe hot-plug will not work with your patch.

It won't, but the question is if it should.  Namely, PCIe native hot-plug
requires control of the PCIe capability structure, which is also used for
AER, so the BIOS granting control of the PCIe capability structure and
not granting control of AER is arguably broken.

> Another example, what would happen on the platform that doesn't have any PCIe
> hot-plug slot? I guess firmware doesn't grant PCIe native hot-plug control on
> that environment. So I think all the other PCIe port services would
> not work on such platform.

You would be surprised. :-)

> My suggestion is that
> 
> (1) Query all controls for PCIe port services and see what controls
>      will be granted to OS by firmware.

We do that already.

> (2) Request all the controls acquired in step (1) at the same time.

Yes, we can do that, although it would complicate things quite a bit and I'm
not sure that's _really_ necessary, given that all of the native services
require access to the PCIe capability structure and once _that_ is granted,
the BIOS has no reason not to grant any other bits.

> (3) Create PCIe port services for those controls.

I don't really think (3) is necessary in that case.  It should be OK not to
load a service driver, in which case the service will simply be disabled.

> What do you think about this?
> 
> I think there is still a problem that needs to be addressed. The problem
> is that if ACPIPHP (ACPI based hot-plug driver) is required for PCIe hot-
> plug, all the PCIe port services needs to be disabled. I don't think it
> is acceptable for ACPIPHP users.

I'm not sure what you mean.  The $subject patch (rather the last version of it
at https://patchwork.kernel.org/patch/114127/) doesn't change the existing
behavior in that respect other than PCIeHP will not be enabled without PME and
possibly AER.

Certainly, though, our current behavior is wrong, since all of the port service
drivers request OSC_PCI_EXPRESS_CAP_STRUCTURE_CONTROL on their own, which leads
to problems in real systems.

Thanks,
Rafael
