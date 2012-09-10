Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753943Ab2IJOg4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 10:36:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46394 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752113Ab2IJOgw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 10:36:52 -0400
Date: Mon, 10 Sep 2012 10:36:04 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Takao Indoh <indou.takao@jp.fujitsu.com>
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, bhelgaas@google.com, hbabu@us.ibm.com,
        ishii.hironobu@jp.fujitsu.com, martin.wilck@ts.fujitsu.com
Subject: Re: [RFC][PATCH] Reset PCIe devices to address DMA problem on kdump
 with iommu
Message-ID: <20120910143604.GB639@redhat.com>
References: <501BB4EF.7080909@jp.fujitsu.com>
 <20120803114643.GA28330@redhat.com>
 <501F4877.5050605@jp.fujitsu.com>
 <20120806203902.GH25559@redhat.com>
 <50473306.1070803@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50473306.1070803@jp.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 05, 2012 at 08:09:58PM +0900, Takao Indoh wrote:
> (2012/08/07 5:39), Vivek Goyal wrote:
> >On Mon, Aug 06, 2012 at 01:30:47PM +0900, Takao Indoh wrote:
> >>Hi Vivek,
> >>
> >>(2012/08/03 20:46), Vivek Goyal wrote:
> >>>On Fri, Aug 03, 2012 at 08:24:31PM +0900, Takao Indoh wrote:
> >>>>Hi all,
> >>>>
> >>>>This patch adds kernel parameter "reset_pcie_devices" which resets PCIe
> >>>>devices at boot time to address DMA problem on kdump with iommu. When
> >>>>this parameter is specified, a hot reset is triggered on each PCIe root
> >>>>port and downstream port to reset its downstream endpoint.
> >>>
> >>>Hi Takao,
> >>>
> >>>Why not use existing "reset_devices" parameter instead of introducing
> >>>a new one?
> >>
> >>"reset_devices" is used for each driver to reset their own device, and
> >>this patch resets all devices forcibly, so I thought they were different
> >>things.
> >
> >Yes reset_devices currently is used for driver to reset its device. I
> >thought one could very well extend its reach to reset pci express devices
> >at bus level.
> >
> >Having them separate is not going to be much useful from kdump
> >perspective. We will end up passing both reset_devices and
> >reset_pcie_devices to second kernel whill lead to bus level reset as well
> >as device level reset.
> >
> >Ideal situation would be that somehow detect that bus level reset has been
> >done and skip device level reset (assuming bus level reset obviates the
> >need of device level reset, please correct me if that's not the case).
> >
> >After pcie reset, can we store the state in a variable and drivers can
> >use that variable to check if PCIe level reset was done or not. If yes,
> >skip device level reset (Assuming driver knows that device is on a
> >PCIe slot).
> >
> >In that case we will not have to introduce new kernel command line, and
> >also avoid double reset?
> I found a problem when testing my patch on some machines.
> 
> Originally there are two problems in kdump kernel when iommu is enabled;
> DMAR error and PCI SERR. I thought they are fixed by my patch, but I
> noticed that PCI SERR is still detected after applying the patch. It
> seems that something happens when Interrupt Remapping is initialized in
> kdump kernel.
> 
> Therefore resetting devices has to be done before enable_IR() is
> called. I have three ideas for it.
> 
>  (i) Resetting devices in 1st kernel(panic kernel)
>  We can reset devices before jumping into 2nd kernel. Of course it may
>  be dangerous to scan pci device tree and call PCI functions in panic'd
>  kernel. Beforehand we need to collect device information so that only
>  minimal code could run on panic.
> 
>  (ii) Resetting devices in purgatory
>  It seems to be be appropriate place to do this, but I'm not sure
>  where I can save/restore PCI config when resetting devices in
>  purgatory.
> 
>  (iii) Resetting devices in 2nd kernel(kdump kernel)
>  Important point is to do reset before enable_IR() is called as I wrote
>  above. I think I should add new function to do reset into
>  arch/x86/pci/early.c and call it in setup_arch like
>  early_dump_pci_devices() or early_quirks().

I would not claim that I understand hte PCI SERR issue. But whatever
resettings needs to happen, should happen early in second kernel.

Doing it in first kernel is not a good idea as it is crashed kernel and
we want to as little as possible.

Doing it in purgatory is not a good idea either as purgatory does not
konw anything about kernel as such. We don't want to bloat purgatory
with reset code and embedding the device knowledge there.

Keeping it in second kernel makes sense so that code remains with kernel
and can be maintained there.

Thanks
Vivek
