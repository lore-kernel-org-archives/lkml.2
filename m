Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755343Ab0EDGVt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 02:21:49 -0400
Received: from mga02.intel.com ([134.134.136.20]:32992 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754882Ab0EDGVr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 02:21:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,324,1270450800"; 
   d="scan'208";a="618652775"
From: "Pan, Jacob jun" <jacob.jun.pan@intel.com>
To: Petr Vandrovec <petr@vandrovec.name>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       "Pan, Jacob jun" <jacob.jun.pan@intel.com>
Date: Mon, 3 May 2010 23:21:44 -0700
Subject: RE: [PATCH 2.6.34-rcX] Do not expect PCI devices to return zeroes
 in PCIe space
Thread-Topic: [PATCH 2.6.34-rcX] Do not expect PCI devices to return zeroes
 in PCIe space
Thread-Index: Acro2Z1v6KFRsr04TkS/xmK5MN+FQgCdiaBQ
Message-ID: <43F901BD926A4E43B106BF17856F0755A3D633B4@orsmsx508.amr.corp.intel.com>
References: <20100501025423.GA10671@vana.vc.cvut.cz>
In-Reply-To: <20100501025423.GA10671@vana.vc.cvut.cz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Petr,

There are other code in the kernel makes similar assumption of accessing pci cfg above 0x100. (but they do not hang in a loop)
e.g. in drivers/pci/probe.c
* accesses, or the device is behind a reverse Express bridge.  So we try
 * reading the dword at 0x100 which must either be 0 or a valid extended
 * capability header.
 */
int pci_cfg_space_size_ext(struct pci_dev *dev)
{
	u32 status;
	int pos = PCI_CFG_SPACE_SIZE;

	if (pci_read_config_dword(dev, pos, &status) != PCIBIOS_SUCCESSFUL)
		goto fail;
	if (status == 0xffffffff)
		goto fail;


Back to the problem itself, hpa has suggested a better fix might be using cfg_size for checking in fixed_bar_cap. But we can not use it right now since we have cfg_size set to 0x100 on MRST (due to lack of PCI_CAP_ID_EXP in the PCI shim). I will negotiate with FW guys so that we have the correct return from pci_cfg_space_size() for Moorestown.

Until then, your current fix should be good.

Thanks,

Jacob
> -----Original Message-----
> From: Petr Vandrovec [mailto:petr@vandrovec.name]
> Sent: Friday, April 30, 2010 7:54 PM
> To: linux-kernel@vger.kernel.org
> Cc: akpm@linux-foundation.org; Thomas Gleixner; Ingo Molnar; H. Peter
> Anvin; x86@kernel.org; Pan, Jacob jun; Jesse Barnes
> Subject: [PATCH 2.6.34-rcX] Do not expect PCI devices to return zeroes
> in PCIe space
> 
> Hello,
>   openSUSE11.3 32bit kernels hang when installed to the VMware's VMs
> because Moorestown
> fixed capabilities detection code enters endless loop on Intel's AGP
> bridges (with
> device ID=7191).  See https://bugzilla.kernel.org/show_bug.cgi?id=15888
> for additional
> details.  arch/x86/pci/mrst.c was introduced after 2.6.33, so only
> 2.6.34-rcX are
> affected.
> 				Thanks,
> 					Petr Vandrovec
> 
> 
> commit 11a35e56ad8275cbf62882d9c0dc2f17c2b5628b
> Author: Petr Vandrovec <petr@vandrovec.name>
> Date:   Fri Apr 30 19:17:43 2010 -0700
> 
>     Do not expect PCI devices to return zeroes in PCIe space
> 
>     There is no reason why old pre-PCIe/PCI-X devices should return
> zeroes when
>     configuration space above 0x100 is accessed.  If these devices
> decode just
>     low 8 bits of register number, conventional space repeats 15 times
> in
>     PCIe config space.  And Moorestown parser for fixed bars then can
> enter
>     endless loop when finding Intel AGP bridge device 0x7191 with
> secondary
>     latency timer programmed to 0x40 - when such device is encountered,
> code
>     will enter endless loop of reading registers 0x718 (reading
> 0x40010100)
>     and 0x400 (reading 0x71918086).
> 
>     This change adds additional condition to the test: if device
> id/vendor
>     match first PCIe capability, then device is not really PCIe.  It
> should
>     not cause any problems: fixed_bar_cap is invoked only on Intel's
> devices,
>     so only time there is possibilty to have false match would be if
> first
>     PCIe capability would have ID 0x8086, and even then that address of
>     next capability pointer and capability version will match device ID
> seems
>     highly unlikely.
> 
>     This fix unbreaks 32bit 2.6.33+ kernels configured with Moorestown
>     support to boot on AMD rev 10h+ processors under VMware in VMs
> which
>     lack PCIe support.
> 
>     Signed-off-by: Petr Vandrovec <petr@vandrovec.name>
> 
> diff --git a/arch/x86/pci/mrst.c b/arch/x86/pci/mrst.c
> index 8bf2fcb..cd6c277 100644
> --- a/arch/x86/pci/mrst.c
> +++ b/arch/x86/pci/mrst.c
> @@ -55,12 +55,16 @@ static int fixed_bar_cap(struct pci_bus *bus,
> unsigned int devfn)
>  {
>  	int pos;
>  	u32 pcie_cap = 0, cap_data;
> +	u32 devid;
> 
>  	pos = PCIE_CAP_OFFSET;
> 
>  	if (!raw_pci_ext_ops)
>  		return 0;
> 
> +	if (raw_pci_ops->read(pci_domain_nr(bus), bus->number, devfn, 0,
> 4, &devid))
> +		return 0;
> +
>  	while (pos) {
>  		if (raw_pci_ext_ops->read(pci_domain_nr(bus), bus->number,
>  					  devfn, pos, 4, &pcie_cap))
> @@ -69,6 +73,9 @@ static int fixed_bar_cap(struct pci_bus *bus,
> unsigned int devfn)
>  		if (pcie_cap == 0xffffffff)
>  			return 0;
> 
> +		if (pcie_cap == devid && pos == PCIE_CAP_OFFSET)
> +			return 0;
> +
>  		if (PCI_EXT_CAP_ID(pcie_cap) == PCI_EXT_CAP_ID_VNDR) {
>  			raw_pci_ext_ops->read(pci_domain_nr(bus), bus-
> >number,
>  					      devfn, pos + 4, 4, &cap_data);

