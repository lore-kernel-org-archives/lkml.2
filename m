Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756722Ab2LGTLL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 14:11:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:21186 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756699Ab2LGTLI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 14:11:08 -0500
Subject: Re: [PATCH 06/15] PCI/acpiphp: Convert "acpiphp" sub-driver's
 functionality to built-in only
From: Myron Stowe <mstowe@redhat.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Myron Stowe <myron.stowe@redhat.com>, bhelgaas@google.com,
        linux-pci@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <CAE9FiQUh_jcoemFpeiAKHr4FyxSA4itHycNwJk+Dhf45Ap5prA@mail.gmail.com>
References: <20121207062454.11051.12739.stgit@amt.stowe>
	 <20121207062530.11051.47869.stgit@amt.stowe>
	 <CAE9FiQUh_jcoemFpeiAKHr4FyxSA4itHycNwJk+Dhf45Ap5prA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 07 Dec 2012 12:11:04 -0700
Message-ID: <1354907464.2419.34.camel@zim.stowe>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-12-06 at 22:48 -0800, Yinghai Lu wrote:
> On Thu, Dec 6, 2012 at 10:25 PM, Myron Stowe <myron.stowe@redhat.com> wrote:
> > The "ACPI Hot Plug PCI Controller ("acpiphp")" sub-driver may be compiled
> > as a module.  Kernel modules are instantiated somewhat randomly - the
> > order in which they are linked as the kernel as built - thus if there are
> > any dependencies on the ordering of attaching sub-drivers, they can not be
> > effectively dealt with.
> >
> > This patch series resolves any potential sequencing inter-dependencies by
> > converting "acpiphp" sub-driver's functionality to being only supported as
> > statically built-in to the kernel.  Inter-dependencies can then be
> > effectively handled by explicitly sequencing the addition of such
> > functionality.
> 
> some slots may support both acpiphp and pciehp.
> 
> if make acpiphp to be built-in, user do not have choice anymore.

What area are you worried about and how do we exercise that choice
today?

Here is my current understanding to set a little context -

I see the following call chains with respect to pciehp and acpiphp:

  pcied_init			# pciehp module_init
    pciehp_firmware_init
      pciehp_acpi_slot_detection_init
        parse_detect_mode	#pcie, acpi, auto (default)
    pcie_port_service_register


  acpiphp_init					# module_init
    init_acpi
      acpiphp_glue_init
        acpi_pci_register_driver(&acpi_pci_hp_driver)
          list_for_each_entry(root, &acpi_pci_roots, node)
            driver->add				# for \_SB_.PCI0
              add_bridge
                add_host_bridge
                  bridge = kzalloc(struct acpiphp_bridge)
                  bridge->handle = handle	# \_SB_.PCI0
                  bridge->pci_bus = root_bus	#pci_bus 0000:00
                  init_bridge_misc
                    acpi_walk_namespace(..., register_slot, ...)
                      register_slot
                        if (device_is_managed_by_native_pciehp(pdev))
                          return AE_OK

Does pciehp influence device_is_managed_by_native_pciehp()?  If not, it
seems that the acpiphp driver will never attach.

Looking at ./drivers/pci/hotplug/Makefile, CONFIG_HOTPLUG_PCI_PCIE comes
before CONFIG_HOTPLUG_PCI_ACPI so if pciehp and acpiphp are both
configured as modules then the load order would seem to be:
  acpiphp, pciehp: acpiphp ignores, pciehp claims
  pciehp, acpiphp: pciehp claims, acpiphp ignores

To complete the matrix taking built-in vs. module into account -
  pciehp=y, acpiphp=y
    pciehp, acpiphp: pciehp claims, acpiphp ignores

  pciehp=y, acpiphp=m
    pciehp, acpiphp: pciehp claims, acpiphp ignores

  pciehp=m, acpiphp=y
    acpiphp, pciehp: acpiphp ignores, pciehp claims

The above combinations all seem to end up with pciehp claiming the slot
which raises the question: How do we get acpiphp to claim a slot today?

Thanks,
 Myron 
> 
> Thanks
> 
> Yinghai


