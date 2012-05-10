Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752723Ab2EJB7j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 21:59:39 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60456 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751621Ab2EJB7h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 21:59:37 -0400
Message-ID: <4FAB20FB.6070508@gmail.com>
Date: Thu, 10 May 2012 09:59:23 +0800
From: Jiang Liu <liuj97@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: "Sosnowski, Maciej" <maciej.sosnowski@intel.com>
CC: "Williams, Dan J" <dan.j.williams@intel.com>,
        Jiang Liu <jiang.liu@huawei.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Keping Chen <chenkeping@huawei.com>
Subject: Re: [RESEND,PATCH] DCA, x86: fix invalid memory access in DCA core
References: <1336406288-9479-1-git-send-email-jiang.liu@huawei.com> <436EC33EF05C3442BBF5497FC9483FF41626EACA@IRSMSX101.ger.corp.intel.com>
In-Reply-To: <436EC33EF05C3442BBF5497FC9483FF41626EACA@IRSMSX101.ger.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Maciej,
	I feel we may also need to tune the multiple IOH support in DCA.
Multiple IOH support is disabled for CB3.0 devices, how about CB3.1 devices
in Ivrbridge or SandyBridge? Does the hardware limitation still exist? Or
could we support multiple IOHs with IvyBridge and SandyBridge?
	If multiple IOH is supported, I think we should move the logic to
disable multiple IOH support for CB3.0 from DCA core into ioatdma. I have
also prepared two patches for that two.
	Thanks!

On 05/09/2012 11:24 PM, Sosnowski, Maciej wrote:
> On Mon, May 07, 2012 5:58 PM, Jiang Liu <liuj97@gmail.com> wrote:
>>
>> From: Jiang Liu <jiang.liu@huawei.com>
>>
>> When unregister_dca_providers() is called, it will remove all registered
>> providers from the dca_providrers list by calling list_del(&dca->node).
>> list_del(node) poisons node->next and node->prev as 0xDEADBEEF and
>> 0xBEEFDEAD.
>> Later when unregister_dca_provider() is called to remove a DCA provier,
>> it calls list_del(&dca->node) to remove the dca from the list again,
>> but dca->node has already been poisoned, then causes invalid memory
>> access.
>>
>> The solution here is to use list_del_init(&dca->node) instead of
>> list_del(&dca->node) in function unregister_dca_providers(), so it won't
>> cause invalid memory access in unregister_dca_provider() later.
>>
>> ---
>>
>> This issue is triggered when hot-removing IOHs on Intel platforms, which
>> will remove all IOAT devices built in the IOHs.
>>
>> ioatdma 0000:80:16.7: Removing dma and dca services
>> ioatdma 0000:80:16.7: PCI INT D disabled
>> ioatdma 0000:80:16.6: Removing dma and dca services
>> ioatdma 0000:80:16.7: Removing dma and dca services
>> ioatdma 0000:80:16.7: PCI INT D disabled
>> ioatdma 0000:80:16.6: Removing dma and dca services
>> ioatdma 0000:80:16.6: PCI INT C disabled
>> ioatdma 0000:00:16.0: Removing dma and dca services
>> ------------[ cut here ]------------
>> WARNING: at lib/list_debug.c:47 __list_del_entry+0x63/0xd0()
>> Hardware name: System x3850 X5 -[7143O3G]-
>> list_del corruption, ffff880463540bc0->next is LIST_POISON1
>> (dead000000100100)
>> Modules linked in: ebtable_nat ebtables ipt_MASQUERADE iptable_nat
>> nf_nat xt_CHECKSUM iptable_mangle bridge stp llc autofs4 sunrpc
>> cpufreq_ondemand acpi_cpufreq freq_table mperf ipt_REJECT
>> nf_conntrack_ipv4 nf_defrag_ipv4 iptable_filter ip_tables ip6t_REJECT
>> nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter
>> ip6_tables ipv6 vfat fat vhost_net macvtap macvlan tun kvm_intel kvm uinput
>> microcode pcspkr serio_raw pmcraid sg be2net cdc_ether usbnet mii i2c_i801
>> i2c_core iTCO_wdt iTCO_vendor_support shpchp ioatdma i7core_edac
>> edac_core igb dca e1000e bnx2 ext4 mbcache jbd2 sr_mod cdrom sd_mod
>> crc_t10dif qla2xxx pata_acpi ata_generic ata_piix bfa scsi_transport_fc
>> scsi_tgt megaraid_sas dm_mirror dm_region_hash dm_log dm_mod [last
>> unloaded: scsi_wait_scan]
>> Pid: 10049, comm: bash.sh Not tainted 3.2.0IOAT+ #5
>> Call Trace:
>> [<ffffffff8106426f>] warn_slowpath_common+0x7f/0xc0
>> [<ffffffff81064366>] warn_slowpath_fmt+0x46/0x50
>> [<ffffffff8108c675>] ? __blocking_notifier_call_chain+0x65/0x80
>> [<ffffffff81256073>] __list_del_entry+0x63/0xd0
>> [<ffffffff812560f1>] list_del+0x11/0x40
>> [<ffffffffa001b2e2>] unregister_dca_provider+0x42/0xe0 [dca]
>> [<ffffffffa021f87d>] ioat_remove+0x43/0x67 [ioatdma]
>> [<ffffffff8126b1a2>] pci_device_remove+0x52/0x120
>> [<ffffffff8132b2dc>] __device_release_driver+0x7c/0xe0
>> [<ffffffff8132b42d>] device_release_driver+0x2d/0x40
>> [<ffffffff8132a871>] driver_unbind+0xa1/0xc0
>> [<ffffffff81329cbc>] drv_attr_store+0x2c/0x30
>> [<ffffffff811d72ef>] sysfs_write_file+0xef/0x170
>> [<ffffffff81167338>] vfs_write+0xc8/0x190
>> [<ffffffff81167501>] sys_write+0x51/0x90
>> [<ffffffff814fa382>] system_call_fastpath+0x16/0x1b
>> ---[ end trace b81b51e7c494ec0d ]---
>> BUG: unable to handle kernel NULL pointer dereference at 0000000000000010
>> IP: [<ffffffffa001b360>] unregister_dca_provider+0xc0/0xe0 [dca]
>> PGD 1465b48067 PUD 1465035067 PMD 0
>> Oops: 0000 [#1] SMP
>> CPU 57
>> Modules linked in: ebtable_nat ebtables ipt_MASQUERADE iptable_nat
>> nf_nat xt_CHECKSUM iptable_mangle bridge stp llc autofs4 sunrpc
>> cpufreq_ondemand acpi_cpufreq freq_table mperf ipt_REJECT
>> nf_conntrack_ipv4 nf_defrag_ipv4 iptable_filter ip_tables ip6t_REJECT
>> nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter
>> ip6_tables ipv6 vfat fat vhost_net macvtap macvlan tun kvm_intel kvm uinput
>> microcode pcspkr serio_raw pmcraid sg be2net cdc_ether usbnet mii i2c_i801
>> i2c_core iTCO_wdt iTCO_vendor_support shpchp ioatdma i7core_edac
>> edac_core igb dca e1000e bnx2 ext4 mbcache jbd2 sr_mod cdrom sd_mod
>> crc_t10dif qla2xxx pata_acpi ata_generic ata_piix bfa scsi_transport_fc
>> scsi_tgt megaraid_sas dm_mirror dm_region_hash dm_log dm_mod [last
>> unloaded: scsi_wait_scan]
>>
>> Pid: 10049, comm: bash.sh Tainted: G        W    3.2.0IOAT+ #5 IBM System x3850
>> X5 -[7143O3G]-/Node 1, Processor Card
>> RIP: 0010:[<ffffffffa001b360>]  [<ffffffffa001b360>]
>> unregister_dca_provider+0xc0/0xe0 [dca]
>> RSP: 0018:ffff880c4eafbdb8  EFLAGS: 00010046
>> RAX: 0000000000000010 RBX: ffff880463540bc0 RCX: 0000000000002288
>> RDX: ffff881465a51800 RSI: 0000000000000046 RDI: 0000000000000009
>> RBP: ffff880c4eafbdd8 R08: 0000000000000000 R09: 0000000000000000
>> R10: 0000000000000010 R11: 000000000000000b R12: 0000000000000000
>> R13: 0000000000000257 R14: ffff881465abe000 R15: ffff881464199840
>> FS:  00007f91d8314700(0000) GS:ffff88147fd20000(0000)
>> knlGS:0000000000000000
>> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> CR2: 0000000000000010 CR3: 0000001457b07000 CR4: 00000000000006e0
>> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
>> Process bash.sh (pid: 10049, threadinfo ffff880c4eafa000, task
>> ffff880c4e3b8af0)
>> Stack:
>> 0000000000000206 ffff88046133a218 ffff881465abe090 ffffffffa0222560
>> ffff880c4eafbdf8 ffffffffa021f87d ffff881465abe090 ffff881465abe208
>> ffff880c4eafbe28 ffffffff8126b1a2 ffff881465abe090 ffffffffa02225c0
>> Call Trace:
>> [<ffffffffa021f87d>] ioat_remove+0x43/0x67 [ioatdma]
>> [<ffffffff8126b1a2>] pci_device_remove+0x52/0x120
>> [<ffffffff8132b2dc>] __device_release_driver+0x7c/0xe0
>> [<ffffffff8132b42d>] device_release_driver+0x2d/0x40
>> [<ffffffff8132a871>] driver_unbind+0xa1/0xc0
>> [<ffffffff81329cbc>] drv_attr_store+0x2c/0x30
>> [<ffffffff811d72ef>] sysfs_write_file+0xef/0x170
>> [<ffffffff81167338>] vfs_write+0xc8/0x190
>> [<ffffffff81167501>] sys_write+0x51/0x90
>> [<ffffffff814fa382>] system_call_fastpath+0x16/0x1b
>> Code: c7 20 c0 01 a0 e8 51 6c 4d e1 48 89 df e8 c9 05 00 00 48 83 c4 08 5b 41 5c 41
>> 5d c9 c3 66 0f 1f 44 00 00 45 31 e4 49 8d 44 24 10 <49> 39 44 24 10 75 c9 4c 89 e7
>> e8 71 ad 23 e1 4c 89 e7 e8 19 7b
>> RIP  [<ffffffffa001b360>] unregister_dca_provider+0xc0/0xe0 [dca]
>> RSP <ffff880c4eafbdb8>
>> CR2: 0000000000000010
>> ---[ end trace b81b51e7c494ec0e ]---
>>
>> Signed-off-by: Jiang Liu <liuj97@gmail.com>
>> ---
>> drivers/dca/dca-core.c |    2 +-
>> 1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/dca/dca-core.c b/drivers/dca/dca-core.c
>> index bc6f5fa..075c4bd 100644
>> --- a/drivers/dca/dca-core.c
>> +++ b/drivers/dca/dca-core.c
>> @@ -121,7 +121,7 @@ static void unregister_dca_providers(void)
>>
>> 	list_for_each_entry_safe(dca, _dca, &unregistered_providers, node)
>> {
>> 		dca_sysfs_remove_provider(dca);
>> -		list_del(&dca->node);
>> +		list_del_init(&dca->node);
>> 	}
>> }
>>
>> --
>> 1.7.9.5
> 
> Thanks for reporting and debugging. However I think this patch is not
> the right solution. Dca should be prevented from trying to unregister
> any provider after providers have been blocked and
> unregister_dca_providers() has been called.
> I will prepare a patch.
> 
> Thanks,
> Maciej

