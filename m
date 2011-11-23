Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756098Ab1KWOnu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 09:43:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14570 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752447Ab1KWOns (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 09:43:48 -0500
Date: Wed, 23 Nov 2011 09:43:44 -0500
From: Josh Boyer <jwboyer@redhat.com>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-team@fedoraproject.org
Subject: pata_jmicron triggers warning in PCIe code
Message-ID: <20111123144344.GA5116@zod.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

We have a report of the pata_jmicron driver hitting the following
warning in the 3.1.x kernel series:

WARNING: at drivers/pci/search.c:44 pci_find_upstream_pcie_bridge+0x56/0x6f()
Hardware name: System Product Name
Modules linked in: pata_jmicron(+)
Pid: 256, comm: modprobe Not tainted 3.1.1-1.fc16.x86_64 #1
Call Trace:
 [<ffffffff81057a1e>] warn_slowpath_common+0x83/0x9b
 [<ffffffff81057a50>] warn_slowpath_null+0x1a/0x1c
 [<ffffffff81241643>] pci_find_upstream_pcie_bridge+0x56/0x6f
 [<ffffffff814b45d4>] get_domain_for_dev.part.9.constprop.13+0x2e/0x47f
 [<ffffffff814b4bf9>] __get_valid_domain_for_dev+0x2c/0xa0
 [<ffffffff813c1ca3>] __intel_map_single+0x5a/0x172
 [<ffffffff811103e8>] ? alloc_pages_current+0xc7/0xd8
 [<ffffffff813c1eb7>] intel_alloc_coherent+0xc7/0xee
 [<ffffffff812e7612>] ? dmam_noncoherent_release+0x1b/0x1b
 [<ffffffff812e757c>] dma_alloc_coherent+0x80/0x82
 [<ffffffff812e7721>] dmam_alloc_coherent+0x58/0x9c
 [<ffffffff81317e88>] ata_bmdma_port_start+0x43/0x58
 [<ffffffff81309ef6>] ata_host_start+0xdd/0x168
 [<ffffffff813184fd>] ? __ata_sff_interrupt+0x179/0x179
 [<ffffffff81318709>] ata_pci_sff_activate_host+0x36/0x1e0
 [<ffffffff813c2b1f>] ? pcibios_set_master+0x88/0x8f
 [<ffffffff81318bc7>] ata_pci_bmdma_init_one+0xc2/0xf8
 [<ffffffffa0000032>] jmicron_init_one+0x32/0x34 [pata_jmicron]
 [<ffffffff8123fce7>] local_pci_probe+0x44/0x75
 [<ffffffff8124084a>] pci_device_probe+0xd0/0xff
 [<ffffffff812dea17>] driver_probe_device+0x131/0x213
 [<ffffffff812deb53>] __driver_attach+0x5a/0x7e
 [<ffffffff812deaf9>] ? driver_probe_device+0x213/0x213
 [<ffffffff812dda9f>] bus_for_each_dev+0x53/0x89
 [<ffffffff812de5f6>] driver_attach+0x1e/0x20
 [<ffffffff812de21a>] bus_add_driver+0xd1/0x224
 [<ffffffffa0002000>] ? 0xffffffffa0001fff
 [<ffffffff812deff7>] driver_register+0x98/0x105
 [<ffffffffa0002000>] ? 0xffffffffa0001fff
 [<ffffffff8124110d>] __pci_register_driver+0x56/0xc1
 [<ffffffffa0002000>] ? 0xffffffffa0001fff
 [<ffffffffa000201e>] jmicron_init+0x1e/0x20 [pata_jmicron]
 [<ffffffff81002099>] do_one_initcall+0x7f/0x136
 [<ffffffff8108a595>] sys_init_module+0x88/0x1d0
 [<ffffffff814bd8c2>] system_call_fastpath+0x16/0x1b

That boils down to the following check:

                /* PCI device should connect to a PCIe bridge */
                if (pdev->pcie_type != PCI_EXP_TYPE_PCI_BRIDGE) {
                        /* Busted hardware? */
                        WARN_ON_ONCE(1);
                        return NULL;
                }

I don't recall seeing reports of this on the 3.0 kernel.  Should we add
some debugging code to print out what pdev->pcie_type is set to here?
Without knowing that, I can't tell if it's actually finding something weird
about the hardware, or memory corruption that seems to hit here.

The user has hit it about 3 times thus far, so they can at least recreate
it fairly easily.

Any other ideas?

josh

Bugzilla report: https://bugzilla.redhat.com/show_bug.cgi?id=755943
