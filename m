Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758902Ab1ELXcY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 19:32:24 -0400
Received: from oproxy5-pub.bluehost.com ([67.222.39.38]:48418 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757882Ab1ELXcW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 19:32:22 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=UxiKzxuGYX/lUhw5UfFOxy/HhFwh/iVo7LZA7fDjzGV6KouFCqhEO2svlnuGFuQwdOJpfbNsfI08WYBx5wCPmYaSMhlnJMquwd/eH7JEiGBkRq3GxFHt7LvqwBXDW3g+;
Date: Thu, 12 May 2011 16:32:10 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Bruce Allan <bruce.w.allan@intel.com>,
        Carolyn Wyborny <carolyn.wyborny@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        Greg Rose <gregory.v.rose@intel.com>,
        PJ Waskiewicz <peter.p.waskiewicz.jr@intel.com>,
        Alex Duyck <alexander.h.duyck@intel.com>,
        John Ronciak <john.ronciak@intel.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Matthew Garrett <mjg@redhat.com>,
        Naga Chumbalkar <nagananda.chumbalkar@hp.com>,
        e1000-devel@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] pci, e1000e: Add and use __pci_disable_link_state
Message-ID: <20110512163210.132a2954@jbarnes-desktop>
In-Reply-To: <4DCAF039.4030207@kernel.org>
References: <4DC6E6E8.9040306@kernel.org>
	<20110509143536.08bd0297@jbarnes-desktop>
	<4DCAF039.4030207@kernel.org>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 May 2011 13:23:21 -0700
Yinghai Lu <yinghai@kernel.org> wrote:

> On 05/09/2011 02:35 PM, Jesse Barnes wrote:
> > On Sun, 08 May 2011 11:54:32 -0700
> > Yinghai Lu <yinghai@kernel.org> wrote:
> > 
> >>
> >> Need to use it in _e1000e_disable_aspm.
> >> when aer happens,
> >> pci_walk_bus already have down_read(&pci_bus_sem)...
> >> then report_slot_reset
> >>         ==> e1000_io_slot_reset
> >>                 ==> e1000e_disable_aspm
> >>                         ==> pci_disable_link_state...
> >>
> >> We can not use pci_disable_link_state, and it will try to hold pci_bus_sem again.
> >>
> >> Try to have __pci_disable_link_state that will not need to hold pci_bus_sem.
> > 
> > What about the other callers of e1000e_disable_aspm?  Do they already
> > have the lock held or is it just reset that needs the already locked
> > version?
> 
> yes. 
> 
> there is another version when aspm is not defined. and it does not use any lock. 
> 
> #ifdef CONFIG_PCIEASPM
> static void __e1000e_disable_aspm(struct pci_dev *pdev, u16 state)
> {
>         pci_disable_link_state(pdev, state);
> }
> #else
> static void __e1000e_disable_aspm(struct pci_dev *pdev, u16 state)
> {
>         int pos;
>         u16 reg16;
> 
>         /*
>          * Both device and parent should have the same ASPM setting.
>          * Disable ASPM in downstream component first and then upstream.
>          */
>         pos = pci_pcie_cap(pdev);
>         pci_read_config_word(pdev, pos + PCI_EXP_LNKCTL, &reg16);
>         reg16 &= ~state;
>         pci_write_config_word(pdev, pos + PCI_EXP_LNKCTL, reg16);
> 
>         if (!pdev->bus->self)
>                 return;
> 
>         pos = pci_pcie_cap(pdev->bus->self);
>         pci_read_config_word(pdev->bus->self, pos + PCI_EXP_LNKCTL, &reg16);
>         reg16 &= ~state;
>         pci_write_config_word(pdev->bus->self, pos + PCI_EXP_LNKCTL, reg16);
> }
> #endif

No, I mean __e1000e_disable_aspm is called from several spots:

*** drivers/net/e1000e/82571.c:
e1000_get_variants_82571[435]  e1000e_disable_aspm(adapter->pdev, PCIE_LINK_STATE_L0S);

*** drivers/net/e1000e/netdev.c:
e1000_change_mtu[5027]         e1000e_disable_aspm(adapter->pdev, PCIE_LINK_STATE_L1);
__e1000_resume[5402]           e1000e_disable_aspm(pdev, PCIE_LINK_STATE_L1);
e1000_io_slot_reset[5650]      e1000e_disable_aspm(pdev, PCIE_LINK_STATE_L1);
e1000_probe[5797]              e1000e_disable_aspm(pdev, PCIE_LINK_STATE_L1);

Are all of them safe for the unlocked version of ASPM disable?

-- 
Jesse Barnes, Intel Open Source Technology Center
