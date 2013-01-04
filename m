Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755205Ab3ADQ5K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 11:57:10 -0500
Received: from mail-pb0-f43.google.com ([209.85.160.43]:58798 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754984Ab3ADQ5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 11:57:07 -0500
Message-ID: <50E709DE.2020906@gmail.com>
Date: Sat, 05 Jan 2013 00:57:02 +0800
From: Jiang Liu <liuj97@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Daniel J Blueman <daniel@quora.org>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        Yijing Wang <wangyijing@huawei.com>
Subject: Re: 3.8-rc2: pciehp waitqueue hang...
References: <CAMVG2ssiRgcTD1bej2tkUUfsWmpL5eNtPcNif9va2-Gzb2u8nQ@mail.gmail.com> <50E5A6A1.5040508@gmail.com> <CAMVG2svLEwaY3OdJ_w-YX0OZRS+Je5NZage+niebVE2rNGCMfw@mail.gmail.com>
In-Reply-To: <CAMVG2svLEwaY3OdJ_w-YX0OZRS+Je5NZage+niebVE2rNGCMfw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/04/2013 09:08 AM, Daniel J Blueman wrote:
> On 3 January 2013 23:41, Jiang Liu <liuj97@gmail.com> wrote:
>> On 01/03/2013 11:11 PM, Daniel J Blueman wrote:
>>> When the Apple thunderbolt ethernet adapter comes loose on my Macbook
>>> Pro Retina (Intel DSL3510), we see pci_slot_name return
>>> non-deterministic data (ie varying each boot), and we see pciehp_wp
>>> remain armed with events causing the kthread to get stuck:
>>>
>>> tg3 0000:0a:00.0 eth0: Link is up at 1000 Mbps, full duplex
>>> tg3 0000:0a:00.0 eth0: Flow control is on for TX and on for RX
>>> <thunderbold adapter comes loose>
>>> pciehp 0000:06:03.0:pcie24: Card not present on Slot(3)
>>> tg3 0000:0a:00.0: tg3_abort_hw timed out, TX_MODE_ENABLE will not
>>> clear MAC_TX_MODE=ffffffff
>>> tg3 0000:0a:00.0 eth0: No firmware running
>>> tg3 0000:0a:00.0 eth0: Link is down
>>> pcieport 0000:00:01.1: System wakeup enabled by ACPI
>>> pciehp 0000:09:00.0:pcie24: unloading service driver pciehp
>>> pciehp 0000:09:00.0:pcie24: Latch open on
>>> Slot(\xfffffff89\xffffffbbe\x02\xffffff88\xffffffff\xffffffff\xffffffe09\xffffffbbe\x02\xffffff88\xffffffff\xfffffffffbcon)
>>> pciehp 0000:09:00.0:pcie24: Button pressed on
>>> Slot(\xfffffff89\xffffffbbe\x02\xffffff88\xffffffff\xffffffff\xffffffe09\xffffffbbe\x02\xffffff88\xffffffff\xfffffffffbcon)
>>> pciehp 0000:09:00.0:pcie24: Card present on
>>> Slot(\xfffffff89\xffffffbbe\x02\xffffff88\xffffffff\xffffffff\xffffffe09\xffffffbbe\x02\xffffff88\xffffffff\xfffffffffbcon)
>>> pciehp 0000:09:00.0:pcie24: Power fault on slot
>>> \xfffffff89\xffffffbbe\x02\xffffff88\xffffffff\xffffffff\xffffffe09\xffffffbbe\x02\xffffff88\xffffffff\xfffffffffbcon
>>> pciehp 0000:09:00.0:pcie24: Power fault bit 0 set
>>> pciehp 0000:09:00.0:pcie24: PCI slot
>>> #\xfffffff89\xffffffbbe\x02\xffffff88\xffffffff\xffffffff\xffffffe09\xffffffbbe\x02\xffffff88\xffffffff\xfffffffffbcon
>>> - powering on due to button press.
>>> pciehp 0000:09:00.0:pcie24: Link Training Error occurs
>>> pciehp 0000:09:00.0:pcie24: Failed to check link status
>>> INFO: task kworker/0:1:52 blocked for more than 120 seconds.
> [...]
> 
>> Hi Daniel,
>>         It seems like an issue caused by recursive PCIe HPC.
>> Could you please help to try the patch from:
>> http://www.spinics.net/lists/linux-pci/msg18625.html
>> Thanks!
>> Gerry
> 
> (adding Yijing)
> 
> Splendid; this fixes this failure nicely [1], finally releasing the bus.
> 
> If nothing else, I feel this should be queud for 3.8-rc3.
> 
> Many thanks,
>   Daniel
> 
> --- [1]
> 
> <thunderbolt ethernet adapter disengagement>
> pciehp 0000:06:03.0:pcie24: Card not present on Slot(3)
> tg3 0000:0a:00.0: tg3_abort_hw timed out, TX_MODE_ENABLE will not
> clear MAC_TX_MODE=ffffffff
> tg3 0000:0a:00.0 eth0: No firmware running
> tg3 0000:0a:00.0 eth0: Link is down
> [sched_delayed] sched: RT throttling activated
> pcieport 0000:00:01.1: System wakeup enabled by ACPI
> pciehp 0000:09:00.0:pcie24: unloading service driver pciehp
> pciehp 0000:09:00.0:pcie24: Latch open on
> Slot(\xffffffb0\x04Pd\x02\xffffff88\xffffffff\xffffffff\xffffff98\x04Pd\x02\xffffff88\xffffffff\xfffffffffbcon)
> pciehp 0000:09:00.0:pcie24: Button pressed on
> Slot(\xffffffb0\x04Pd\x02\xffffff88\xffffffff\xffffffff\xffffff98\x04Pd\x02\xffffff88\xffffffff\xfffffffffbcon)
> pciehp 0000:09:00.0:pcie24: Card present on
> Slot(\xffffffb0\x04Pd\x02\xffffff88\xffffffff\xffffffff\xffffff98\x04Pd\x02\xffffff88\xffffffff\xfffffffffbcon)
> pciehp 0000:09:00.0:pcie24: Power fault on slot
> \xffffffb0\x04Pd\x02\xffffff88\xffffffff\xffffffff\xffffff98\x04Pd\x02\xffffff88\xffffffff\xfffffffffbcon
Hi Daniel,
	I have worked on a patch which may solve the random output above,
but need to rebase it to the latest kernel. Will send the patch to you once
rebased.
	Thanks!
	Gerry
> pciehp 0000:09:00.0:pcie24: Power fault bit 0 set
> pciehp 0000:09:00.0:pcie24: PCI slot
> #\xffffffb0\x04Pd\x02\xffffff88\xffffffff\xffffffff\xffffff98\x04Pd\x02\xffffff88\xffffffff\xfffffffffbcon
> - powering on due to button press.
> pciehp 0000:09:00.0:pcie24: Link Training Error occurs
> pciehp 0000:09:00.0:pcie24: Failed to check link status
> pci_bus 0000:0a: busn_res: [bus 0a] is released
> pci_bus 0000:09: busn_res: [bus 09-0a] is released
> 

