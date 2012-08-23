Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758161Ab2HWBAr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 21:00:47 -0400
Received: from mga11.intel.com ([192.55.52.93]:63221 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751475Ab2HWBAo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 21:00:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,297,1344236400"; 
   d="scan'208";a="212662681"
From: "Cui, Dexuan" <dexuan.cui@intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>
CC: Jiang Liu <liuj97@gmail.com>, Don Dutile <ddutile@redhat.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        "Rafael J . Wysocki" <rjw@sisk.pl>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Yijing Wang <wangyijing@huawei.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: RE: [PATCH v3 00/32] provide interfaces to access PCIe capabilities
 registers
Thread-Topic: [PATCH v3 00/32] provide interfaces to access PCIe
 capabilities registers
Thread-Index: AQHNfyEpc1sbAquqAkWs79W2HpqffZdjqchAgAHYTwCAARPj4A==
Date: Thu, 23 Aug 2012 01:00:40 +0000
Message-ID: <A25F549E4D43CD42B4C02DF47A1913230FE53087@SHSMSX102.ccr.corp.intel.com>
References: <1343836477-7287-1-git-send-email-jiang.liu@huawei.com>
 <CAErSpo7WoEeWayMQ__H4jiKKmMdNgyLMYdRmJ0Nf0LoEKjFRmA@mail.gmail.com>
 <50325732.3000700@gmail.com>
 <CAErSpo4-SGH__kE5tPNzz+VO=V-GKOMdcKCqqy6s3=5sNKgG0w@mail.gmail.com>
 <50325C18.9030207@gmail.com>
 <CAErSpo6t9m0xmWkXfmONtbicjqLR_z5dLsjKCLWQfcktzRKkUA@mail.gmail.com>
 <CAErSpo5=OUM9veX8890USWegTG_Fhh10soxPJbjemd80bAO0qg@mail.gmail.com>
 <A25F549E4D43CD42B4C02DF47A1913230FE50780@SHSMSX102.ccr.corp.intel.com>
 <CAErSpo5ftvKLF2=1ixzp1KroNLKh_s-b5hi9aFv3X7PpqisGwg@mail.gmail.com>
In-Reply-To: <CAErSpo5ftvKLF2=1ixzp1KroNLKh_s-b5hi9aFv3X7PpqisGwg@mail.gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bjorn Helgaas wrote on 2012-08-23:
> On Mon, Aug 20, 2012 at 9:40 PM, Cui, Dexuan <dexuan.cui@intel.com>
> wrote:
>> Bjorn Helgaas wrote on 2012-08-21:
> 
>>> I am still concerned about reset_intel_82599_sfp_virtfn().  It looks
>>> wrong and possibly unnecessary.  It looks wrong because it sets
>>> PCI_EXP_DEVCTL_BCR_FLR and blindly clears all other bits in
>>> PCI_EXP_DEVCTL.  Most of the bits are probably cleared by the FLR
>>> anyway, but Aux Power PM Enable is RWS ("sticky"), so it is *not*
>>> modified by FLR.  Therefore, using reset_intel_82599_sfp_virtfn() has
>>> the probably unintended side effect of clearing Aux Power PM Enable.
>>> 
>>> It looks possibly unnecessary because the generic pcie_flr() does
>>> essentially the same thing, so it's not clear why we need a special
>>> case for 82599.
> 
>> I think reset_intel_82599_sfp_virtfn() is correct AND necessary.
>> (pcie_flr() doesn't work here)
>> 
>> Please note the 82599 VF is a special PCIe device that doesn't report
>> PCIe FLR capability though actually it does support that.
>> That is why we put it in quirks.c. :-)
>> 
>> The PCI_EXP_DEVCTL_AUX_PME bit of the 82599 VF is read-only and
>> always zero.
>> 
>> Please see
>> 
> http://www.intel.com/content/dam/doc/datasheet/82599-10-gbe-controller-
> datasheet.pdf
>> 9.5 Virtual Functions Configuration Space
>>   Table 9.7 VF PCIe Configuration Space
>>   9.5.2.2.1 VF Device Control Register (0xA8; RW)
> 
> Thanks, Dexuan!
> 
> The 82599 does report FLR in the DEVCAP for the PF (sec 9.3.10.4), but
> not in the DEVCAP for the VF (sec 9.5), which indeed means we can't
> use pcie_flr() on the VFs.  I wonder whether this error appears in any
> other devices.
> 
> The VF DEVCTL register (sec 9.5.2.2.1) is RO and zero except for
> "Initiate FLR" unlike the PF DEVCTL (sec 9.3.10.5).  The
> read/modify/write done by pcie_flr() would work on the VF but is not
> necessary.
> 
> The VF DEVSTA register (sec 9.5.2.2.2) does have an active
> "Transaction Pending" bit.  That suggests to me that we should wait
> for it to be clear, as pcie_flr() does.
I agree.

> 
> What would you think of a patch like the following?  My idea is to
> make it the same as pcie_flr() except for the absolutely necessary
> differences.  With this patch, the only difference is that we don't
> look at the 82599 DEVCAP FLR bit.
Hi Bjorn,
Thanks for the patch!
It seems good to me (BTW, I don't have such a device at
hand to test)

Thanks,
-- Dexuan

