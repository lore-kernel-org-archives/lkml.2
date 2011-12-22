Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755623Ab1LVTPo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 14:15:44 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:37209 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752448Ab1LVTPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 14:15:42 -0500
Date: Thu, 22 Dec 2011 14:15:37 -0500 (EST)
Message-Id: <20111222.141537.1513319029738355747.davem@davemloft.net>
To: bhelgaas@google.com
Cc: James.Bottomley@hansenpartnership.com, linux-pci@vger.kernel.org,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 00/29] Create PCI root buses with correct resources
From: David Miller <davem@davemloft.net>
In-Reply-To: <20111222.135911.584309149966835644.davem@davemloft.net>
References: <1318607132.3018.30.camel@dabdike.int.hansenpartnership.com>
	<CAErSpo7yoWOg8P1NAi70HJX=OMyO6XUwnUBxVq3P0YK87eP5tw@mail.gmail.com>
	<20111222.135911.584309149966835644.davem@davemloft.net>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 22 Dec 2011 11:15:39 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Thu, 22 Dec 2011 13:59:11 -0500 (EST)

> From: Bjorn Helgaas <bhelgaas@google.com>
> Date: Tue, 20 Dec 2011 08:55:53 -0700
> 
>> This series has been in linux-next for a while now (via Jesse's PCI
>> tree), so this would be a good time to try it out if you haven't
>> already.
>> 
>> I know ia64 has been exercised a bit (thanks, Tony), but I haven't
>> heard anything about arm, mips, parisc, powerpc, sparc, etc.
>> 
>> There is one outstanding bug fix for alpha that Jesse hasn't
>> integrated yet, but as far as I know, everything else is in good
>> shape.
> 
> I'll give it a quick test on sparc64 today.

Jesse's linux-next GIT branch boots up fine, but I get tons of
warnings that kobject_put() is being performed on an uninitialized
kobject.

It looks like populate_msi_sysfs() is where these kobjects are
supposed to be initialized.

Anyways, two examples:

[2766595.475642] mpt2sas1: 32 BIT PCI BUS DMA ADDRESSING SUPPORTED, total mem (7767632 kB)
[2766595.491604] ------------[ cut here ]------------
[2766595.500986] WARNING: at lib/kobject.c:595 kobject_put+0x48/0x80()
[2766595.513482] kobject: '(null)' (fffff801f9b7a620): is not initialized, yet kobject_put() is being called.
[2766595.532762] Modules linked in:
[2766595.539152] Call Trace:
[2766595.544391]  [000000000046944c] warn_slowpath_fmt+0x2c/0x40
[2766595.555837]  [00000000005ed188] kobject_put+0x48/0x80
[2766595.566261]  [0000000000622b68] free_msi_irqs+0xc8/0x120
[2766595.577196]  [0000000000623870] pci_enable_msix+0x270/0x420
[2766595.588665]  [00000000006a9fe8] mpt2sas_base_map_resources+0x2c8/0x480
[2766595.602023]  [00000000006acb8c] mpt2sas_base_attach+0xac/0x1280
[2766595.614166]  [00000000006b5c20] _scsih_probe+0x2a0/0x480
[2766595.625113]  [000000000061d048] pci_device_probe+0x108/0x120
[2766595.636746]  [0000000000671464] driver_probe_device+0x64/0x180
[2766595.648716]  [0000000000671600] __driver_attach+0x80/0xa0
[2766595.659838]  [0000000000670570] bus_for_each_dev+0x50/0x80
[2766595.671115]  [0000000000670cdc] bus_add_driver+0x9c/0x260
[2766595.682217]  [000000000067190c] driver_register+0x6c/0x160
[2766595.693508]  [000000000061d4d4] __pci_register_driver+0x34/0xc0
[2766595.705652]  [000000000096912c] _scsih_init+0x150/0x17c
[2766595.716413]  [0000000000426ad8] do_one_initcall+0x18/0x160
[2766595.727697] ---[ end trace 1cc904a40b8d2c88 ]---

--------------------

[2766607.786504] ------------[ cut here ]------------
[2766607.786519] WARNING: at lib/kobject.c:595 kobject_put+0x48/0x80()
[2766607.786529] kobject: '(null)' (fffff801fbec1280): is not initialized, yet kobject_put() is being called.
[2766607.786540] Modules linked in: igb(+) ehci_hcd(+) n2_rng rng_core
[2766607.786554] Call Trace:
[2766607.786568]  [000000000046944c] warn_slowpath_fmt+0x2c/0x40
[2766607.786581]  [00000000005ed188] kobject_put+0x48/0x80
[2766607.786596]  [0000000000622b68] free_msi_irqs+0xc8/0x120
[2766607.786610]  [0000000000622e1c] pci_enable_msi_block+0x25c/0x2c0
[2766607.786644]  [0000000010054b78] igb_probe+0x514/0xfc0 [igb]
[2766607.786658]  [000000000061d048] pci_device_probe+0x108/0x120
[2766607.786672]  [0000000000671464] driver_probe_device+0x64/0x180
[2766607.786683]  [0000000000671600] __driver_attach+0x80/0xa0
[2766607.786694]  [0000000000670570] bus_for_each_dev+0x50/0x80
[2766607.786707]  [0000000000670cdc] bus_add_driver+0x9c/0x260
[2766607.786718]  [000000000067190c] driver_register+0x6c/0x160
[2766607.786730]  [000000000061d4d4] __pci_register_driver+0x34/0xc0
[2766607.786743]  [0000000000426ad8] do_one_initcall+0x18/0x160
[2766607.786756]  [00000000004a33ec] SyS_init_module+0x6c/0x1c0
[2766607.786771]  [0000000000406194] linux_sparc_syscall32+0x34/0x40
[2766607.786779] ---[ end trace 1cc904a40b8d2c9d ]---

--------------------
