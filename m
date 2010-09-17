Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754360Ab0IQVPN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 17:15:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14873 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753671Ab0IQVPM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 17:15:12 -0400
Date: Fri, 17 Sep 2010 14:15:08 -0700
From: Chris Wright <chrisw@redhat.com>
To: Cam Macdonell <cam@cs.ualberta.ca>
Cc: Chris Wright <chrisw@redhat.com>,
        "qemu-devel@nongnu.org Developers" <qemu-devel@nongnu.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [Qemu-devel] Re: ACPI error when mapping a 2GB BAR w/ 4GB of RAM
Message-ID: <20100917211508.GF19949@x200.localdomain>
References: <AANLkTinORYZOYk9xsST+J=zxgeZPr2BNw3S=dvPPTcdn@mail.gmail.com>
 <20100917200428.GD19949@x200.localdomain>
 <AANLkTiny67-sKAwn3ipHBDEMx9NJujznNOjAeyZZXj_j@mail.gmail.com>
 <AANLkTim0dCDGeC+sLFLSH1Ezb=2UHP6dn=EPBhxBQ4-P@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTim0dCDGeC+sLFLSH1Ezb=2UHP6dn=EPBhxBQ4-P@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Cam Macdonell (cam@cs.ualberta.ca) wrote:
> On Fri, Sep 17, 2010 at 2:52 PM, Cam Macdonell <cam@cs.ualberta.ca> wrote:
> > On Fri, Sep 17, 2010 at 2:04 PM, Chris Wright <chrisw@redhat.com> wrote:
> >> * Cam Macdonell (cam@cs.ualberta.ca) wrote:
> >>> After fixing the resource_size_t return value with
> >>> pci_resource_alignment, I see one other strange behaviour only when
> >>> using 4GB of RAM and a 2GB BAR.  I haven't found any other combination
> >>> of RAM/BAR size that triggers this bug.  I am using 2.6.36-rc3.
> >>>
> >>> ACPI Error: The DSDT has been corrupted or replaced - old, new headers
> >>> below (20100702/tbutils-372)
> >>> ACPI: DSDT (null) 01F15 (v01   BXPC   BXDSDT 00000001 INTL 20090123)
> >>> ACPI:      (null) 00000 (v00                 00000000      00000000)
> >>> ACPI Error: Please send DMI info to linux-acpi@vger.kernel.org
> >>> If system does not work as expected, please boot with acpi=copy_dsdt
> >>> (20100702/tbutils-378)
> >>> ACPI: PCI Interrupt Link [LNKC] disabled and referenced, BIOS bug
> >>> ACPI Exception: AE_AML_INVALID_RESOURCE_TYPE, Evaluating _CRS
> >>> (20100702/pci_link-283)
> >>> ACPI: Unable to set IRQ for PCI Interrupt Link [LNKC]. Try pci=noacpi
> >>> or acpi=off
> >>> virtio-pci 0000:00:03.0: PCI INT A: no GSI - using ISA IRQ 11
> >>> Non-volatile memory driver v1.3
> >>> Linux agpgart interface v0.103
> >>> Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
> >>
> >> IIRC,  the pci hole is only 1.5G in the BIOS, can you verify that
> >> seabios is doing the right thing?
> >
> > I'm not sure what the right thing for seabios to do is.  Here is the
> > seabios output related to the device.
> >
> > PCI: bus=0 devfn=0x20: vendor_id=0x1af4 device_id=0x1110
> > region 0: 0xf2040000
> > init smm
> > init boot device ordering
> >
> > <snip>
> >
> > Attempting to init PCI bdf 00:04.0 (vd 1af4:1110)
> > Attempting to map option rom on dev 00:04.0
> > Option rom sizing returned 0 0
> > Checking rom 0x000c9800 (sig aa55 size 17)
> > Checking rom 0x000cc000 (sig aa55 size 2)
> > Checking rom 0x000c9000 (sig aa55 size 4)
> > Checking rom 0x000c9800 (sig aa55 size 17)
> > Checking rom 0x000cc000 (sig aa55 size 2)
> > Mapping hd drive 0x000fdb50 to 0
> > Running option rom at c980:0003
> > Running option rom at cc00:0003
> > pmm_malloc zone=0x000f515c handle=ffffffff size=36 align=10
> > ret=0x000fdaf0 (detail=0x7ffefca0)
> > ebda moved from 9fc00 to 9f400
> > pmm_malloc zone=0x000f5154 handle=ffffffff size=2048 align=10
> > ret=0x0009f800 (detail=0x7ffefb40)
> > finalize PMM
> > malloc finalize
> >
> > when using a BAR of 2GB or less, there is an additional write to the
> > PCI space of the device, which may be from the bios
> >
> > pci_write_config: (val) 0xffffffff -> 0x18 (addr)
> > pci_read_config: (val) 0x80000004 <- 0x18 (addr)
> > pci_write_config: (val) 0x4 -> 0x18 (addr)
> > pci_write_config: (val) 0x3 -> 0x4 (addr)
> > pci_read_config: (val) 0x0 <- 0x1c (addr)
> > pci_write_config: (val) 0xffffffff -> 0x1c (addr)
> > IVSHMEM: guest pci addr = ffffffff00000000, guest h/w addr =
> > 4312137728, size = 80000000
> >
> > so is it succeeding with smaller sizes (> 2GB) because it fits in the
> > bios' pci hole?
> 
> sorry that should be "< 2GB".

It seems most likely...< 2GB also means <= 1GB (which would fit in
the hole).  Although, I have to admit, I'm not sure how seabios handles
the hole nowadays.

What about 2GB with 32bit BAR?

thanks,
-chris
