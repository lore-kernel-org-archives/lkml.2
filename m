Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752590Ab2LAQBu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2012 11:01:50 -0500
Received: from mail.skyhub.de ([78.46.96.112]:48348 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752395Ab2LAQBt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2012 11:01:49 -0500
Date: Sat, 1 Dec 2012 17:01:44 +0100
From: Borislav Petkov <bp@alien8.de>
To: Lance Ortiz <lance.ortiz@hp.com>
Cc: bhelgaas@google.com, lance_ortiz@hotmail.com, jiang.liu@huawei.com,
        tony.luck@intel.com, rostedt@goodmis.org, mchehab@redhat.com,
        linux-acpi@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/3] aerdrv: Enhanced AER logging
Message-ID: <20121201160144.GC12274@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Lance Ortiz <lance.ortiz@hp.com>, bhelgaas@google.com,
	lance_ortiz@hotmail.com, jiang.liu@huawei.com, tony.luck@intel.com,
	rostedt@goodmis.org, mchehab@redhat.com, linux-acpi@vger.kernel.org,
	linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20121130213330.7649.51101.stgit@grignak.americas.hpqcorp.net>
 <20121130213337.7649.6709.stgit@grignak.americas.hpqcorp.net>
 <20121201155130.GA12274@liondog.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20121201155130.GA12274@liondog.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 01, 2012 at 04:51:30PM +0100, Borislav Petkov wrote:
> > @@ -281,9 +286,17 @@ static void cper_print_pcie(const char *pfx, const struct cper_sec_pcie *pcie,
> >  	"%s""bridge: secondary_status: 0x%04x, control: 0x%04x\n",
> >  	pfx, pcie->bridge.secondary_status, pcie->bridge.control);
> >  #ifdef CONFIG_ACPI_APEI_PCIEAER
> > -	if (pcie->validation_bits & CPER_PCIE_VALID_AER_INFO) {
> > +	dev = pci_get_domain_bus_and_slot(pcie->device_id.segment,
> > +			pcie->device_id.bus, pcie->device_id.function);
> > +	if (!dev)
> > +		pr_info("PCI AER Cannot get PCI device %04x:%02x:%02x.%d\n",
> > +			pcie->device_id.segment, pcie->device_id.bus,
> > +			pcie->device_id.slot, pcie->device_id.function);
> > +
> > +	if (pcie->validation_bits & CPER_PCIE_VALID_AER_INFO && dev) {
> 
> You don't need to test dev here because you've tested for !dev in the
> line above...
> 
> >  		struct aer_capability_regs *aer_regs = (void *)pcie->aer_info;
> > -		cper_print_aer(pfx, gdata->error_severity, aer_regs);
> > +		cper_print_aer(dev, gdata->error_severity, aer_regs);
> > +		pci_dev_put(dev);
> 
> ... and thus this pci_dev_put() has to be unconditional, i.e. after the
> if test.

Not entirely correct: you don't need to test dev if you return early in
the !dev case. And AFAICT you should return early because if you can't
get dev, you can't call cper_print_aer() afterwards.

IOW, this hunk should look like this:

@@ -281,10 +286,19 @@ static void cper_print_pcie(const char *pfx, const struct cper_sec_pcie *pcie,
        "%s""bridge: secondary_status: 0x%04x, control: 0x%04x\n",
        pfx, pcie->bridge.secondary_status, pcie->bridge.control);
 #ifdef CONFIG_ACPI_APEI_PCIEAER
-       if (pcie->validation_bits & CPER_PCIE_VALID_AER_INFO) {
-               struct aer_capability_regs *aer_regs = (void *)pcie->aer_info;
-               cper_print_aer(pfx, gdata->error_severity, aer_regs);
+       dev = pci_get_domain_bus_and_slot(pcie->device_id.segment,
+                       pcie->device_id.bus, pcie->device_id.function);
+       if (!dev) {
+               pr_info("PCI AER Cannot get PCI device %04x:%02x:%02x.%d\n",
+                       pcie->device_id.segment, pcie->device_id.bus,
+                       pcie->device_id.slot, pcie->device_id.function);
+               return;
        }
+
+       if (pcie->validation_bits & CPER_PCIE_VALID_AER_INFO)
+               cper_print_aer(dev, gdata->error_severity,
+                              (struct aer_capability_regs *)pcie->aer_info);
+       pci_dev_put(dev);
 #endif
 }

Thanks.

-- 
Regards/Gruss,
    Boris.
