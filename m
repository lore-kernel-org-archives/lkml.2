Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754866Ab0FECCB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 22:02:01 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:19765 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753824Ab0FECCA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 22:02:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=KwotACYW5LfDnHYq2dCoZML0rrqtRulTeCAm12v7mK9ebDG0wAXwhgTKYMMIZTUtP3
         GUaL7wCTAPTcWomGDBR+QS7pf5ZvHl7uSRGOU5LJLUqMF8k2STwMej6q/o/u9iLuQ7Gx
         h83CfPq+f1XCdMnq5PQlarccKFsBgygAPK4g0=
MIME-Version: 1.0
In-Reply-To: <AANLkTimXcF1pafrSt8dMbUs59AjnqaRwpzDnPIPjdjsn@mail.gmail.com>
References: <AANLkTiktNufXK_pn6mP2-zyowAIbHlUy5TGu3AtpALv-@mail.gmail.com>
	<20100603020006.GB19123@srcf.ucam.org>
	<AANLkTikpv86r5BBPCEOHujpm8uCgY0DxghSKjBufBWiM@mail.gmail.com>
	<4C08760B.8050002@gmail.com>
	<AANLkTimFY5YQv8DC-zTQ1RF84rno6svvcyLzHGWL6HOk@mail.gmail.com>
	<AANLkTimXcF1pafrSt8dMbUs59AjnqaRwpzDnPIPjdjsn@mail.gmail.com>
Date: Fri, 4 Jun 2010 22:01:58 -0400
Message-ID: <AANLkTinZ7d3WWyO3m9A7GVnaTuSbn1G33ADFW6ixywcT@mail.gmail.com>
Subject: Re: Hang during boot, bisected to commit 96d60303fd
From: Marc Dionne <marc.c.dionne@gmail.com>
To: Robert Hancock <hancockrwd@gmail.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org, garzik@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 4, 2010 at 9:37 PM, Robert Hancock <hancockrwd@gmail.com> wrote:
> Is that the right dmesg? I didn't see where the extra output was. It
> might be useful to put a WARN_ON(1); inside ahci_start_engine to see
> the two code paths where it's being called..

The first series of calls to ahci_start_engine have a stack trace that
looks like this:

Call Trace:
 [<ffffffff81077002>] warn_slowpath_common+0x85/0x9d
 [<ffffffff81077034>] warn_slowpath_null+0x1a/0x1c
 [<ffffffff813572dd>] ahci_start_engine+0x92/0xa4
 [<ffffffff8135736a>] ahci_start_port+0x7b/0x16c
 [<ffffffff81357792>] ahci_port_resume+0x52/0x73
 [<ffffffff81357901>] ahci_port_start+0x14e/0x164
 [<ffffffff81341dc5>] ata_host_start+0xdf/0x184
 [<ffffffff81357b35>] ? ahci_interrupt+0x0/0x5f3
 [<ffffffff8134266f>] ata_host_activate+0x2a/0xdc
 [<ffffffff81355aab>] ahci_init_one+0x9dd/0x9fe
 [<ffffffff81170a9c>] ? __sysfs_add_one+0x38/0x9a
 [<ffffffff812519bd>] ? kobject_get+0x1a/0x22
 [<ffffffff81269891>] local_pci_probe+0x17/0x1b
 [<ffffffff8126a63f>] pci_device_probe+0xca/0xfa
 [<ffffffff81308fbe>] ? driver_sysfs_add+0x4c/0x71
 [<ffffffff81309110>] driver_probe_device+0xac/0x13b
 [<ffffffff813091fc>] __driver_attach+0x5d/0x81
 [<ffffffff8130919f>] ? __driver_attach+0x0/0x81
 [<ffffffff81308714>] bus_for_each_dev+0x53/0x88
 [<ffffffff81308f70>] driver_attach+0x1e/0x20
 [<ffffffff81308bc3>] bus_add_driver+0xb6/0x203
 [<ffffffff813094ed>] driver_register+0x9e/0x10f
 [<ffffffff8126a869>] __pci_register_driver+0x58/0xc8
 [<ffffffff81b6582c>] ? ahci_init+0x0/0x1b
 [<ffffffff81b65845>] ahci_init+0x19/0x1b
 [<ffffffff81002069>] do_one_initcall+0x5e/0x159
 [<ffffffff81b33713>] kernel_init+0x183/0x211
 [<ffffffff810319a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81b33590>] ? kernel_init+0x0/0x211
 [<ffffffff810319a0>] ? kernel_thread_helper+0x0/0x10

The later calls:

Call Trace:
 [<ffffffff81077002>] warn_slowpath_common+0x85/0x9d
 [<ffffffff81077034>] warn_slowpath_null+0x1a/0x1c
 [<ffffffff813572dd>] ahci_start_engine+0x92/0xa4
 [<ffffffff81357a0d>] ahci_hardreset+0xc6/0x124
 [<ffffffff81357947>] ? ahci_hardreset+0x0/0x124
 [<ffffffff81342e08>] ? ata_std_prereset+0x0/0xb7
 [<ffffffff8134aeca>] ata_do_reset+0x59/0x62
 [<ffffffff8134c3fa>] ata_eh_reset+0x512/0xc99
 [<ffffffff81356baa>] ? ahci_postreset+0x0/0x5d
 [<ffffffff81357947>] ? ahci_hardreset+0x0/0x124
 [<ffffffff81358498>] ? ahci_softreset+0x0/0x44
 [<ffffffff81357947>] ? ahci_hardreset+0x0/0x124
 [<ffffffff8134d9a1>] ? ata_eh_schedule_probe+0xc5/0xf3
 [<ffffffff8134dca7>] ata_eh_recover+0x2d8/0xd6d
 [<ffffffff81356baa>] ? ahci_postreset+0x0/0x5d
 [<ffffffff81357947>] ? ahci_hardreset+0x0/0x124
 [<ffffffff81358498>] ? ahci_softreset+0x0/0x44
 [<ffffffff81342e08>] ? ata_std_prereset+0x0/0xb7
 [<ffffffff81352ec9>] sata_pmp_error_handler+0xd3/0xa0a
 [<ffffffff81067f73>] ? dequeue_entity+0x4a/0x183
 [<ffffffff8108c1ae>] ? __cancel_work_timer+0xad/0x193
 [<ffffffff8108395e>] ? lock_timer_base+0x2c/0x52
 [<ffffffff810839ff>] ? try_to_del_timer_sync+0x7b/0x89
 [<ffffffff81357943>] ahci_error_handler+0x2c/0x30
 [<ffffffff8134f2c7>] ata_scsi_error+0x33d/0x697
 [<ffffffff8131bc10>] scsi_error_handler+0xc2/0x3c5
 [<ffffffff8131bb4e>] ? scsi_error_handler+0x0/0x3c5
 [<ffffffff8108f451>] kthread+0x7f/0x87
 [<ffffffff810319a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff8108f3d2>] ? kthread+0x0/0x87
 [<ffffffff810319a0>] ? kernel_thread_helper+0x0/0x10

Marc
