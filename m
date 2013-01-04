Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754321Ab3ADBIE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 20:08:04 -0500
Received: from mail-ob0-f170.google.com ([209.85.214.170]:57314 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754041Ab3ADBIB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 20:08:01 -0500
X-Greylist: delayed 35401 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 Jan 2013 20:08:00 EST
MIME-Version: 1.0
X-Originating-IP: [121.6.69.232]
In-Reply-To: <50E5A6A1.5040508@gmail.com>
References: <CAMVG2ssiRgcTD1bej2tkUUfsWmpL5eNtPcNif9va2-Gzb2u8nQ@mail.gmail.com>
	<50E5A6A1.5040508@gmail.com>
Date: Fri, 4 Jan 2013 09:08:00 +0800
Message-ID: <CAMVG2svLEwaY3OdJ_w-YX0OZRS+Je5NZage+niebVE2rNGCMfw@mail.gmail.com>
Subject: Re: 3.8-rc2: pciehp waitqueue hang...
From: Daniel J Blueman <daniel@quora.org>
To: Jiang Liu <liuj97@gmail.com>, Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        Yijing Wang <wangyijing@huawei.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3 January 2013 23:41, Jiang Liu <liuj97@gmail.com> wrote:
> On 01/03/2013 11:11 PM, Daniel J Blueman wrote:
>> When the Apple thunderbolt ethernet adapter comes loose on my Macbook
>> Pro Retina (Intel DSL3510), we see pci_slot_name return
>> non-deterministic data (ie varying each boot), and we see pciehp_wp
>> remain armed with events causing the kthread to get stuck:
>>
>> tg3 0000:0a:00.0 eth0: Link is up at 1000 Mbps, full duplex
>> tg3 0000:0a:00.0 eth0: Flow control is on for TX and on for RX
>> <thunderbold adapter comes loose>
>> pciehp 0000:06:03.0:pcie24: Card not present on Slot(3)
>> tg3 0000:0a:00.0: tg3_abort_hw timed out, TX_MODE_ENABLE will not
>> clear MAC_TX_MODE=ffffffff
>> tg3 0000:0a:00.0 eth0: No firmware running
>> tg3 0000:0a:00.0 eth0: Link is down
>> pcieport 0000:00:01.1: System wakeup enabled by ACPI
>> pciehp 0000:09:00.0:pcie24: unloading service driver pciehp
>> pciehp 0000:09:00.0:pcie24: Latch open on
>> Slot(\xfffffff89\xffffffbbe\x02\xffffff88\xffffffff\xffffffff\xffffffe09\xffffffbbe\x02\xffffff88\xffffffff\xfffffffffbcon)
>> pciehp 0000:09:00.0:pcie24: Button pressed on
>> Slot(\xfffffff89\xffffffbbe\x02\xffffff88\xffffffff\xffffffff\xffffffe09\xffffffbbe\x02\xffffff88\xffffffff\xfffffffffbcon)
>> pciehp 0000:09:00.0:pcie24: Card present on
>> Slot(\xfffffff89\xffffffbbe\x02\xffffff88\xffffffff\xffffffff\xffffffe09\xffffffbbe\x02\xffffff88\xffffffff\xfffffffffbcon)
>> pciehp 0000:09:00.0:pcie24: Power fault on slot
>> \xfffffff89\xffffffbbe\x02\xffffff88\xffffffff\xffffffff\xffffffe09\xffffffbbe\x02\xffffff88\xffffffff\xfffffffffbcon
>> pciehp 0000:09:00.0:pcie24: Power fault bit 0 set
>> pciehp 0000:09:00.0:pcie24: PCI slot
>> #\xfffffff89\xffffffbbe\x02\xffffff88\xffffffff\xffffffff\xffffffe09\xffffffbbe\x02\xffffff88\xffffffff\xfffffffffbcon
>> - powering on due to button press.
>> pciehp 0000:09:00.0:pcie24: Link Training Error occurs
>> pciehp 0000:09:00.0:pcie24: Failed to check link status
>> INFO: task kworker/0:1:52 blocked for more than 120 seconds.
[...]

> Hi Daniel,
>         It seems like an issue caused by recursive PCIe HPC.
> Could you please help to try the patch from:
> http://www.spinics.net/lists/linux-pci/msg18625.html
> Thanks!
> Gerry

(adding Yijing)

Splendid; this fixes this failure nicely [1], finally releasing the bus.

If nothing else, I feel this should be queud for 3.8-rc3.

Many thanks,
  Daniel

--- [1]

<thunderbolt ethernet adapter disengagement>
pciehp 0000:06:03.0:pcie24: Card not present on Slot(3)
tg3 0000:0a:00.0: tg3_abort_hw timed out, TX_MODE_ENABLE will not
clear MAC_TX_MODE=ffffffff
tg3 0000:0a:00.0 eth0: No firmware running
tg3 0000:0a:00.0 eth0: Link is down
[sched_delayed] sched: RT throttling activated
pcieport 0000:00:01.1: System wakeup enabled by ACPI
pciehp 0000:09:00.0:pcie24: unloading service driver pciehp
pciehp 0000:09:00.0:pcie24: Latch open on
Slot(\xffffffb0\x04Pd\x02\xffffff88\xffffffff\xffffffff\xffffff98\x04Pd\x02\xffffff88\xffffffff\xfffffffffbcon)
pciehp 0000:09:00.0:pcie24: Button pressed on
Slot(\xffffffb0\x04Pd\x02\xffffff88\xffffffff\xffffffff\xffffff98\x04Pd\x02\xffffff88\xffffffff\xfffffffffbcon)
pciehp 0000:09:00.0:pcie24: Card present on
Slot(\xffffffb0\x04Pd\x02\xffffff88\xffffffff\xffffffff\xffffff98\x04Pd\x02\xffffff88\xffffffff\xfffffffffbcon)
pciehp 0000:09:00.0:pcie24: Power fault on slot
\xffffffb0\x04Pd\x02\xffffff88\xffffffff\xffffffff\xffffff98\x04Pd\x02\xffffff88\xffffffff\xfffffffffbcon
pciehp 0000:09:00.0:pcie24: Power fault bit 0 set
pciehp 0000:09:00.0:pcie24: PCI slot
#\xffffffb0\x04Pd\x02\xffffff88\xffffffff\xffffffff\xffffff98\x04Pd\x02\xffffff88\xffffffff\xfffffffffbcon
- powering on due to button press.
pciehp 0000:09:00.0:pcie24: Link Training Error occurs
pciehp 0000:09:00.0:pcie24: Failed to check link status
pci_bus 0000:0a: busn_res: [bus 0a] is released
pci_bus 0000:09: busn_res: [bus 09-0a] is released
-- 
Daniel J Blueman
