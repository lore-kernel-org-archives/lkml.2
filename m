Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756569Ab2HTWOS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 18:14:18 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:56887 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754289Ab2HTWOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 18:14:16 -0400
MIME-Version: 1.0
In-Reply-To: <CAErSpo6t9m0xmWkXfmONtbicjqLR_z5dLsjKCLWQfcktzRKkUA@mail.gmail.com>
References: <1343836477-7287-1-git-send-email-jiang.liu@huawei.com>
 <CAErSpo7WoEeWayMQ__H4jiKKmMdNgyLMYdRmJ0Nf0LoEKjFRmA@mail.gmail.com>
 <50325732.3000700@gmail.com> <CAErSpo4-SGH__kE5tPNzz+VO=V-GKOMdcKCqqy6s3=5sNKgG0w@mail.gmail.com>
 <50325C18.9030207@gmail.com> <CAErSpo6t9m0xmWkXfmONtbicjqLR_z5dLsjKCLWQfcktzRKkUA@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 20 Aug 2012 16:13:54 -0600
Message-ID: <CAErSpo5=OUM9veX8890USWegTG_Fhh10soxPJbjemd80bAO0qg@mail.gmail.com>
Subject: Re: [PATCH v3 00/32] provide interfaces to access PCIe capabilities registers
To: Jiang Liu <liuj97@gmail.com>, Yu Zhao <yu.zhao@intel.com>,
        Dexuan Cui <dexuan.cui@intel.com>
Cc: Don Dutile <ddutile@redhat.com>, Yinghai Lu <yinghai@kernel.org>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        "Rafael J . Wysocki" <rjw@sisk.pl>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Yijing Wang <wangyijing@huawei.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 20, 2012 at 10:10 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:

> So I'll try pulling your branch (I'll do something about the tsi721.c
> stuff myself).

I pulled this into
git://git.kernel.org/pub/scm/linux/kernel/git/helgaas/pci.git
pci/jiang-pcie-cap with the following changes:

  - Dropped some "pci_" prefixes on internal functions in access.c
  - Minor restructure of pcie_capability_read_*()
  - Removed export of pcie_capability_reg_implemented()
  - Reworked reset_intel_82599_sfp_virtfn() to check for FLR bit in
DEVCAP rather than using pcie_capability_reg_implemented()
  - Split driver patches into one driver per patch
  - Fixed myri10ge_toggle_relaxed() -- previous code returned useful
value, but your patch made it always return zero
  - Use 16-bit, not 32-bit, accesses for DEVCTL, DEVCTL2 (tsi721)

I am still concerned about reset_intel_82599_sfp_virtfn().  It looks
wrong and possibly unnecessary.  It looks wrong because it sets
PCI_EXP_DEVCTL_BCR_FLR and blindly clears all other bits in
PCI_EXP_DEVCTL.  Most of the bits are probably cleared by the FLR
anyway, but Aux Power PM Enable is RWS ("sticky"), so it is *not*
modified by FLR.  Therefore, using reset_intel_82599_sfp_virtfn() has
the probably unintended side effect of clearing Aux Power PM Enable.

It looks possibly unnecessary because the generic pcie_flr() does
essentially the same thing, so it's not clear why we need a special
case for 82599.

Yu or Dexuan, can you comment on these 82599 questions?

The proposed new code is here:
http://git.kernel.org/?p=linux/kernel/git/helgaas/pci.git;a=blob;f=drivers/pci/quirks.c;h=9abbf56e93fe5c98364a7dfe2b0b724047dfa4a9;hb=ef529bf0cb5606ff5bd1422d2d2700a821d8218b#l3082

Bjorn
