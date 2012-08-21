Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752155Ab2HUElQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 00:41:16 -0400
Received: from mga09.intel.com ([134.134.136.24]:22493 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750952Ab2HUElN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 00:41:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,799,1336374000"; 
   d="scan'208";a="136414756"
From: "Cui, Dexuan" <dexuan.cui@intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Jiang Liu <liuj97@gmail.com>
CC: Don Dutile <ddutile@redhat.com>, Yinghai Lu <yinghai@kernel.org>,
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
Thread-Index: AQHNfyEpc1sbAquqAkWs79W2HpqffZdjqchA
Date: Tue, 21 Aug 2012 04:40:50 +0000
Message-ID: <A25F549E4D43CD42B4C02DF47A1913230FE50780@SHSMSX102.ccr.corp.intel.com>
References: <1343836477-7287-1-git-send-email-jiang.liu@huawei.com>
 <CAErSpo7WoEeWayMQ__H4jiKKmMdNgyLMYdRmJ0Nf0LoEKjFRmA@mail.gmail.com>
 <50325732.3000700@gmail.com>
 <CAErSpo4-SGH__kE5tPNzz+VO=V-GKOMdcKCqqy6s3=5sNKgG0w@mail.gmail.com>
 <50325C18.9030207@gmail.com>
 <CAErSpo6t9m0xmWkXfmONtbicjqLR_z5dLsjKCLWQfcktzRKkUA@mail.gmail.com>
 <CAErSpo5=OUM9veX8890USWegTG_Fhh10soxPJbjemd80bAO0qg@mail.gmail.com>
In-Reply-To: <CAErSpo5=OUM9veX8890USWegTG_Fhh10soxPJbjemd80bAO0qg@mail.gmail.com>
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

Bjorn Helgaas wrote on 2012-08-21:
> On Mon, Aug 20, 2012 at 10:10 AM, Bjorn Helgaas <bhelgaas@google.com>
> wrote:
> 
>> So I'll try pulling your branch (I'll do something about the tsi721.c
>> stuff myself).
> 
> I pulled this into
> git://git.kernel.org/pub/scm/linux/kernel/git/helgaas/pci.git
> pci/jiang-pcie-cap with the following changes:
> 
>   - Dropped some "pci_" prefixes on internal functions in access.c -
>   Minor restructure of pcie_capability_read_*() - Removed export of
>   pcie_capability_reg_implemented() - Reworked
>   reset_intel_82599_sfp_virtfn() to check for FLR bit in DEVCAP rather
>   than using pcie_capability_reg_implemented() - Split driver patches
>   into one driver per patch - Fixed myri10ge_toggle_relaxed() --
>   previous code returned useful value, but your patch made it always
>   return zero - Use 16-bit, not 32-bit, accesses for DEVCTL, DEVCTL2
>   (tsi721)
> I am still concerned about reset_intel_82599_sfp_virtfn().  It looks
> wrong and possibly unnecessary.  It looks wrong because it sets
> PCI_EXP_DEVCTL_BCR_FLR and blindly clears all other bits in
> PCI_EXP_DEVCTL.  Most of the bits are probably cleared by the FLR
> anyway, but Aux Power PM Enable is RWS ("sticky"), so it is *not*
> modified by FLR.  Therefore, using reset_intel_82599_sfp_virtfn() has
> the probably unintended side effect of clearing Aux Power PM Enable.
> 
> It looks possibly unnecessary because the generic pcie_flr() does
> essentially the same thing, so it's not clear why we need a special
> case for 82599.
> 
> Yu or Dexuan, can you comment on these 82599 questions?
(Removed Yu Zhao from the To list since he has left Intel and the same
email is now used by another unrelated person...)

Hi Bjorn
I think reset_intel_82599_sfp_virtfn() is correct AND necessary.
(pcie_flr() doesn't work here)

Please note the 82599 VF is a special PCIe device that doesn't report
PCIe FLR capability though actually it does support that.
That is why we put it in quirks.c. :-)

The PCI_EXP_DEVCTL_AUX_PME bit of the 82599 VF is read-only and
always zero.

Please see 
http://www.intel.com/content/dam/doc/datasheet/82599-10-gbe-controller-datasheet.pdf
9.5 Virtual Functions Configuration Space
  Table 9.7 VF PCIe Configuration Space
  9.5.2.2.1 VF Device Control Register (0xA8; RW)

Surely I should say sorry for not putting these necessary information
in the git commit description.
Now I don't know why I forgot to do that at that time(almost 3 years ago...).

It would be great if you could help to add a comment in the code. :-)

> 
> The proposed new code is here:
> http://git.kernel.org/?p=linux/kernel/git/helgaas/pci.git;a=blob;f=driver
> s/pci/
> quirks.c;h=9abbf56e93fe5c98364a7dfe2b0b724047dfa4a9;hb=ef529bf0cb560
> 6ff5bd1422d2d2700a821d8218b#l3082
> 
> Bjorn

Thanks,
-- Dexuan

