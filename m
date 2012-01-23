Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753953Ab2AWUsc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 15:48:32 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:45620 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753759Ab2AWUsb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 15:48:31 -0500
MIME-Version: 1.0
In-Reply-To: <CAE9FiQUPwvg0159-My4B+9FG0AeR=86Y5baQT5v8bSVcvGH=Hg@mail.gmail.com>
References: <1327139539-14301-1-git-send-email-yinghai@kernel.org>
	<1327139539-14301-2-git-send-email-yinghai@kernel.org>
	<CA+55aFz7B5ebEGKKJmvuWY+2O-6qarUj40CHASu_4EQ0KDgi_Q@mail.gmail.com>
	<CAE9FiQWbmO+FFsE06eQ=-PVNtdaTG3EsqXNXdUCxb9YxtPS8Cw@mail.gmail.com>
	<CA+55aFyok04YrmEYXLbAE2vB_944+aEJZhd5tzu6U2k0CLaN5A@mail.gmail.com>
	<CA+55aFwEbbq0yuN4mAtfDSbOE86mAWsBBz+pgBzn8_QHVk+B3g@mail.gmail.com>
	<CAE9FiQUPwvg0159-My4B+9FG0AeR=86Y5baQT5v8bSVcvGH=Hg@mail.gmail.com>
Date: Mon, 23 Jan 2012 12:48:29 -0800
X-Google-Sender-Auth: 7CPbE4tup77P4CNdlVKmIYwWhbs
Message-ID: <CAE9FiQVTtjTsTizCjg3KE=yxbyh9Y_J4XBUo77RMLdxiUWv1gA@mail.gmail.com>
Subject: Re: [PATCH 1/7] PCI: Make sriov work with hotplug remove
From: Yinghai Lu <yinghai@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Matthew Wilcox <matthew@wil.cx>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 23, 2012 at 11:59 AM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Mon, Jan 23, 2012 at 11:34 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>>  (b) if that isn't an option, and the virtual devices make a mess, at
>> least don't make the code uglier, just do something like:
>>
>>    while (!list_empty(&bus->devices)) {
>>        struct pci_dev *dev = list_first_entry(struct pci_dev, bus_list);
>>
>>        pci_stop_bus_device(dev);
>>    }
>>
>> which at least isn't butt ugly. Add a large comment about how
>> pci_stop_bus_device() can remove multiple devices due to the virtual
>> devices having been done badly.
>
> yes, this one should work and less confusing.

---
 drivers/pci/remove.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

Index: linux-2.6/drivers/pci/remove.c
===================================================================
--- linux-2.6.orig/drivers/pci/remove.c
+++ linux-2.6/drivers/pci/remove.c
@@ -126,10 +126,15 @@ void pci_remove_behind_bridge(struct pci

 static void pci_stop_bus_devices(struct pci_bus *bus)
 {
-       struct list_head *l, *n;
+       /*
+        * VFs are removed by pci_remove_bus_device() in the
+        *  pci_stop_bus_devices() code path for PF.
+        *  aka, bus->devices get updated in the process.
+        */
+       while (!list_empty(&bus->devices)) {
+               struct pci_dev *dev;

-       list_for_each_safe(l, n, &bus->devices) {
-               struct pci_dev *dev = pci_dev_b(l);
+               dev = list_first_entry(&bus->devices, struct pci_dev, bus_list);
                pci_stop_bus_device(dev);
        }
 }


it does not work... get lock up

sca21d-0a86d3bf:~ # echo 0 > /sys/bus/pci/slots/3/power
[  145.027439] pciehp 0000:80:02.2:pcie04: disable_slot: physical_slot = 3
[  145.034329] pciehp 0000:80:02.2:pcie04: pciehp_get_power_status:
SLOTCTRL a8 value read 1f9
[  145.042709] pciehp 0000:80:02.2:pcie04: pciehp_unconfigure_device:
domain:bus:dev = 0000:b0:00
[  145.053636] libfcoe_device_notification: NETDEV_UNREGISTER eth6
[  145.132359] libfcoe_device_notification: NETDEV_UNREGISTER eth14
[  145.203456]   free irq_desc for 273
[  145.207012]   free irq_desc for 274
[  145.210538]   free irq_desc for 275
[  145.214094]   free irq_desc for 276
[  145.217642]   free irq_desc for 277
[  145.221188]   free irq_desc for 278
[  145.224727]   free irq_desc for 279
[  145.233569] libfcoe_device_notification: NETDEV_UNREGISTER eth15
[  145.311168]   free irq_desc for 280
[  145.314768]   free irq_desc for 281
[  145.318296]   free irq_desc for 282
[  145.321857]   free irq_desc for 283
[  145.325412]   free irq_desc for 284
[  145.328965]   free irq_desc for 285
[  145.332505]   free irq_desc for 286
[  145.337528] libfcoe_device_notification: NETDEV_UNREGISTER eth16
[  145.423045]   free irq_desc for 287
[  145.426643]   free irq_desc for 288
[  145.430164]   free irq_desc for 289
[  145.433716]   free irq_desc for 290
[  145.437257]   free irq_desc for 291
[  145.440808]   free irq_desc for 292
[  145.444355]   free irq_desc for 293
[  146.449844]   free irq_desc for 217
[  146.453458]   free irq_desc for 218
[  146.456994]   free irq_desc for 219
[  146.460566]   free irq_desc for 220
[  146.464123]   free irq_desc for 221
[  146.467675]   free irq_desc for 222
[  146.471245]   free irq_desc for 223

[  171.286565] BUG: soft lockup - CPU#2 stuck for 22s! [bash:10294]
[  171.292570] Modules linked in:
[  171.295644] irq event stamp: 107478
[  171.299132] hardirqs last  enabled at (107477):
[<ffffffff81ceaadd>] restore_args+0x0/0x30
[  171.307424] hardirqs last disabled at (107478):
[<ffffffff81cf20eb>] apic_timer_interrupt+0x6b/0x80
[  171.316495] softirqs last  enabled at (107476):
[<ffffffff8106e59c>] __do_softirq+0x195/0x1ab
[  171.325046] softirqs last disabled at (107461):
[<ffffffff81cf2adc>] call_softirq+0x1c/0x30
[  171.333417] CPU 2
[  171.335260] Modules linked in:
[  171.338518]
[  171.340023] Pid: 10294, comm: bash Not tainted
3.3.0-rc1-tip-yh-01748-g1b96060-dirty #143 Oracle Corporation Sun
Blade X6270 M3/BD,ASSY,
[  171.352330] RIP: 0010:[<ffffffff813c9a6a>]  [<ffffffff813c9a6a>]
pci_stop_bus_device+0x66/0x78
[  171.360971] RSP: 0018:ffff8820330dfce8  EFLAGS: 00000286
[  171.366285] RAX: ffff881036485000 RBX: 0000000000000002 RCX: 00000000000003bd
[  171.373408] RDX: 0000000000000000 RSI: 0000000000000002 RDI: ffff881036471000
[  171.380532] RBP: ffff8820330dfd08 R08: 0000000000000002 R09: ffff88202c330740
[  171.387657] R10: 0000000bfc77a084 R11: ffff88202c3306d0 R12: 0000000bfc77a084
[  171.394788] R13: ffff88202c3306d0 R14: ffffffff81ceaadd R15: ffffffff810af1b9
[  171.401914] FS:  00007f07c4d7a700(0000) GS:ffff88103e200000(0000)
knlGS:0000000000000000
[  171.410005] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  171.415745] CR2: 00007fd6b37000a0 CR3: 00000010310f1000 CR4: 00000000000407e0
[  171.422869] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  171.429994] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  171.437125] Process bash (pid: 10294, threadinfo ffff8820330de000,
task ffff88202c330000)
[  171.445294] Stack:
[  171.447304]  0000000000000000 ffff88103645f000 ffff881036485000
ffff881036485028
[  171.454748]  ffff8820330dfd38 ffffffff813c9a2b 0000000000000007
ffff88103645e000
[  171.462191]  ffff881036484800 ffff881036484828 ffff8820330dfd68
ffffffff813c9a2b
[  171.469647] Call Trace:
[  171.472100]  [<ffffffff813c9a2b>] pci_stop_bus_device+0x27/0x78
[  171.478011]  [<ffffffff813c9a2b>] pci_stop_bus_device+0x27/0x78
[  171.483940]  [<ffffffff813c9bc0>] pci_remove_bus_device+0x14/0x24
[  171.490036]  [<ffffffff813dbb66>] pciehp_unconfigure_device+0x107/0x16d
[  171.496648]  [<ffffffff813db5d9>] pciehp_disable_slot+0x11e/0x186
[  171.502733]  [<ffffffff813db88c>] pciehp_sysfs_disable_slot+0x68/0x108
[  171.509251]  [<ffffffff813da9c9>] disable_slot+0x58/0x5c
[  171.514556]  [<ffffffff813d77dc>] power_write_file+0xd2/0x11c
[  171.520295]  [<ffffffff813d770a>] ? get_attention_status+0xae/0xae
[  171.526471]  [<ffffffff813d1a49>] pci_slot_attr_store+0x29/0x2b
[  171.532389]  [<ffffffff81194eec>] sysfs_write_file+0x10e/0x14a
[  171.538218]  [<ffffffff8113de25>] vfs_write+0xb5/0x128
[  171.543356]  [<ffffffff8113e081>] sys_write+0x4d/0x77
[  171.548417]  [<ffffffff81cf1652>] system_call_fastpath+0x16/0x1b
[  171.554416] Code: 89 df e8 4d 7f 00 00 48 89 df e8 1b 6a 00 00 48
8d bb 90 00 00 00 e8 78 11 0c 00 80 a3 50 09 00 00 fb 48 8b 43 10 48
83 78 38 00 <74> 08 48 89 df e8 87 a3 00 00 58 5b 41 5c 41 5d 5d c3 55
48 89
[  171.574366] Call Trace:
[  171.576809]  [<ffffffff813c9a2b>] pci_stop_bus_device+0x27/0x78
[  171.582724]  [<ffffffff813c9a2b>] pci_stop_bus_device+0x27/0x78
[  171.588634]  [<ffffffff813c9bc0>] pci_remove_bus_device+0x14/0x24
[  171.594719]  [<ffffffff813dbb66>] pciehp_unconfigure_device+0x107/0x16d
[  171.601324]  [<ffffffff813db5d9>] pciehp_disable_slot+0x11e/0x186
[  171.607409]  [<ffffffff813db88c>] pciehp_sysfs_disable_slot+0x68/0x108
[  171.613926]  [<ffffffff813da9c9>] disable_slot+0x58/0x5c
[  171.619233]  [<ffffffff813d77dc>] power_write_file+0xd2/0x11c
[  171.624971]  [<ffffffff813d770a>] ? get_attention_status+0xae/0xae
[  171.631144]  [<ffffffff813d1a49>] pci_slot_attr_store+0x29/0x2b
[  171.637064]  [<ffffffff81194eec>] sysfs_write_file+0x10e/0x14a
[  171.642890]  [<ffffffff8113de25>] vfs_write+0xb5/0x128
[  171.648024]  [<ffffffff8113e081>] sys_write+0x4d/0x77
[  171.653070]  [<ffffffff81cf1652>] system_call_fastpath+0x16/0x1b
