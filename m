Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756615Ab0EDHbF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 03:31:05 -0400
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:11141 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751217Ab0EDHbB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 03:31:01 -0400
Message-ID: <4BDFCD35.1070109@vmware.com>
Date: Tue, 04 May 2010 00:31:01 -0700
From: Petr Vandrovec <petr@vmware.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100411 Icedove/3.0.4
MIME-Version: 1.0
To: "Pan, Jacob jun" <jacob.jun.pan@intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH 2.6.34-rcX] Do not expect PCI devices to return zeroes
 in PCIe space
References: <20100501025423.GA10671@vana.vc.cvut.cz>  <43F901BD926A4E43B106BF17856F0755A3D633B4@orsmsx508.amr.corp.intel.com>
In-Reply-To: <43F901BD926A4E43B106BF17856F0755A3D633B4@orsmsx508.amr.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/03/10 23:21, Pan, Jacob jun wrote:
> Hi Petr,
>
> There are other code in the kernel makes similar assumption of accessing pci cfg above 0x100. (but they do not hang in a loop)
> e.g. in drivers/pci/probe.c
> * accesses, or the device is behind a reverse Express bridge.  So we try
>   * reading the dword at 0x100 which must either be 0 or a valid extended
>   * capability header.
>   */
> int pci_cfg_space_size_ext(struct pci_dev *dev)
> {
> 	u32 status;
> 	int pos = PCI_CFG_SPACE_SIZE;
>
> 	if (pci_read_config_dword(dev, pos,&status) != PCIBIOS_SUCCESSFUL)
> 		goto fail;
> 	if (status == 0xffffffff)
> 		goto fail;
>
>
> Back to the problem itself, hpa has suggested a better fix might be using cfg_size for checking in fixed_bar_cap. But we can not use it right now since we have cfg_size set to 0x100 on MRST (due to lack of PCI_CAP_ID_EXP in the PCI shim). I will negotiate with FW guys so that we have the correct return from pci_cfg_space_size() for Moorestown.
>
> Until then, your current fix should be good.

Thanks.  Other possibility would be to modify amd_bus.c to verify that
ENABLE_CF8_EXT_CFG bit in MSR_AMD64_NB_CFG is actually writeable, and
not set PCI_HAS_IO_ECS if bit is read-as-zero.  That would fix both
Moorestown code as well as pci_cfg_space_size_ext - patch below can be
applied instead of mrst.c changes.
							Petr


Do not report AMD processors in VMware as ECS capable

In a VM AMD processors do not have integrated northbridge, and so their
northbridge-related MSRs do not work, and do not enable PCIe configuration
space accesses via I/O ports 0xCF8/0xCFC.  Virtualized processor can be
detected by having NB_CFG register read-only.

Signed-off-by: Petr Vandrovec <petr@vandrovec.name>

diff --git a/arch/x86/pci/amd_bus.c b/arch/x86/pci/amd_bus.c
index fc1e8fe..cf03bff 100644
--- a/arch/x86/pci/amd_bus.c
+++ b/arch/x86/pci/amd_bus.c
@@ -349,6 +349,8 @@ static int __init early_fill_mp_bus_info(void)

  #define ENABLE_CF8_EXT_CFG      (1ULL << 46)

+static int ecs_ok = 1;
+
  static void enable_pci_io_ecs(void *unused)
  {
  	u64 reg;
@@ -356,6 +358,10 @@ static void enable_pci_io_ecs(void *unused)
  	if (!(reg & ENABLE_CF8_EXT_CFG)) {
  		reg |= ENABLE_CF8_EXT_CFG;
  		wrmsrl(MSR_AMD64_NB_CFG, reg);
+		/* VMware implements NB_CFG MSR as read-only.  Verify write worked... */
+		rdmsrl(MSR_AMD64_NB_CFG, reg);
+		if (!(reg & ENABLE_CF8_EXT_CFG))
+			ecs_ok = 0;
  	}
  }

@@ -390,7 +396,8 @@ static int __init pci_io_ecs_init(void)
  	for_each_online_cpu(cpu)
  		amd_cpu_notify(&amd_cpu_notifier, (unsigned long)CPU_ONLINE,
  			       (void *)(long)cpu);
-	pci_probe |= PCI_HAS_IO_ECS;
+	if (ecs_ok)
+		pci_probe |= PCI_HAS_IO_ECS;

  	return 0;
  }
