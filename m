Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753427Ab2GJDWb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 23:22:31 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:64752 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753075Ab2GJDW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 23:22:29 -0400
MIME-Version: 1.0
In-Reply-To: <20120709213554.8975.60552.stgit@amt.stowe>
References: <20120709213554.8975.60552.stgit@amt.stowe>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 9 Jul 2012 21:22:06 -0600
Message-ID: <CAErSpo5jdd2CAKOx-Ri=jqUkQC49xbvPnHsjBepNcWUUaLYD5g@mail.gmail.com>
Subject: Re: [PATCH -v2 0/8] PCI: Add 'pci_fixup_final' quirks into hot-plug paths
To: Myron Stowe <myron.stowe@redhat.com>
Cc: linux-pci@vger.kernel.org, rth@twiddle.net, ink@jurassic.park.msu.ru,
        mattst88@gmail.com, ralf@linux-mips.org, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, yinghai@kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 9, 2012 at 3:35 PM, Myron Stowe <myron.stowe@redhat.com> wrote:
> PCI's final quirks (pci_fixup_final) are currently invoked by
> pci_apply_final_quirk() which traverses the platform's list of PCI
> devices.  The calling mechanism, and to some point the use of the device
> list, limits the quirk invocations to a single instance during boot.  As
> such, hot-plugable devices do not have their associated final quirks
> called upon hot-plug events.
>
> This series implements a interim solution to integrate pci_fixup_final
> quirks into the various hot-plug event paths[1].
>
> The series basis is
> git://git.kernel.org/pub/scm/linux/kernel/git/helgaas/pci.git next
>
>   -v2: Re-worked PATCH 1/9 based on Bjorn's suggestion:
>        http://marc.info/?l=linux-pci&m=134074984925361&w=2
>        There is some more opportunity to clean this up even further
>        if we re-work the script that gathers initcall data to accept
>        'dev_dbg()' structured output.
>
>        Replaced PATCHes 3/9-8/9 with 3/8-7/8 (I don't know what I
>        was thinking with the original set).
>
>
> [1] I intended to come up with a single, uniform, solution that would
> satisfy both the boot path and the various hot-plug event paths with
> respect to final quirks.  From an architectural perspective, the proper
> placement for the final quirks is somewhere just prior to when drivers can
> probe and attach which would be the device_add path: pci_bus_add_devices
> or pci_bus_add device.
>
> I originally started with that approach but eventually realized that there
> are issues with moving the quirks into the device_add path with respect to
> booting.  Using the 'initcall_debug' boot command instrumentation, one
> can see that moving the final quirks into the device_add path would cause
> the quirks to be called substantially earlier during boot.  While there
> may be additional issues, two that were especially concerning were that
> the final quirks would be called *before* both 'pci_subsys_init' and
> 'pcibios_assign_resources'.
>
> Calling the quirks prior to resource assignment seems fraught with
> potential issues so I started looking into the various hot-plug paths and
> quickly noticed asymmetry with respect to PCI device setup between the
> boot path and the hot-plug paths.
>
> Currently, the boot path scans the PCI devices, adds the devices, assigns
> resources, and then call the final quirks whereas the hot-plug paths scan,
> assign resources, and then add the devices which is better sequencing with
> respect to the assignment of resources and the addition of devices (i.e.
> resource assignment occurs *before* a driver can probe and attach).
>
> All of this suggests that we should change PCI device setup in the boot
> path to be more like hot-plug: scan, assign resources, (final fixups,)
> then add.  While I think that is the correct approach, and something that
> we should be addressing, it will require a lot of work.  So until that
> occurs, this series should serve as a stop-gap solution for the interim.
>
> When the boot path's PCI device setup is addressed we should end up with a
> single, uniform, device_add based solution for applying final quirks
> after:
>   o  removing 'fs_initcall_sync(pci_apply_final_quirks);',
>   o  removing the global variable 'pci_fixup_final_inited' and all
>      of its usages,
>   o  renaming, and moving, the 'pci_cache_line_size' related code
>      currently embedded in 'pci_apply_final_quirks()'.
>
> Note: I do not have a cross-compile environment so I have only tested x86.
> ---
>
> Myron Stowe (8):
>       PCI: Integrate 'pci_fixup_final' quirks into hot-plug paths
>       PCI: Move final fixup quirks from __init to __devinit
>       x86/PCI: Move final fixup quirks from __init to __devinit
>       MIPS/PCI: Move final fixup quirks from __init to __devinit
>       alpha/PCI: Move final fixup quirks from __init to __devinit
>       PCI: Adjust section annotations of various quirks
>       PCI: release temporary reference in __nv_msi_ht_cap_quirk()
>       PCI: Restructure 'pci_do_fixups()'
>
>
>  arch/alpha/kernel/pci.c         |    2 -
>  arch/mips/mti-malta/malta-pci.c |    2 -
>  arch/mips/pci/ops-tx4927.c      |    2 -
>  arch/mips/txx9/generic/pci.c    |    4 +
>  arch/x86/kernel/quirks.c        |    2 -
>  drivers/pci/bus.c               |    4 +
>  drivers/pci/quirks.c            |  107 ++++++++++++++++++++++++++-------------
>  7 files changed, 81 insertions(+), 42 deletions(-)
>
> --

Thanks, I added this to my "next" branch and pushed it.

The alpha quirks fix was already in my "next" branch, so I dropped that patch:
http://git.kernel.org/?p=linux/kernel/git/helgaas/pci.git;a=commitdiff;h=8ff255afb022b8e183c7aa1ecc4ba8d0563e1e17

Bjorn
