Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751502Ab2CHA6p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 19:58:45 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:54475 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751262Ab2CHA6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 19:58:40 -0500
MIME-Version: 1.0
In-Reply-To: <CAErSpo5T8-hrtMufDeo_EfupQX3neyoA9ufjN2UYro7-2SXc+Q@mail.gmail.com>
References: <1331018040-30725-1-git-send-email-yinghai@kernel.org>
	<1331018040-30725-24-git-send-email-yinghai@kernel.org>
	<CAErSpo5TjhNv1W=PxSPO6qXfhW1Mi4dMp83vj82=O_hFOq1vow@mail.gmail.com>
	<CAE9FiQXsY7Dn5TGtD1ARM_KFdz1V1hJOvYAy6e4msM=i3VfhDg@mail.gmail.com>
	<CABhMZUWDngY6jL8jkxQ+SHzEHqTS4i3DqtCD7DUBtL4QS58ovA@mail.gmail.com>
	<CAE9FiQV23maKVMrk7h1cJxYfxrqJcKu7GfwFYUJfSDfh8g-KFQ@mail.gmail.com>
	<CAErSpo5T8-hrtMufDeo_EfupQX3neyoA9ufjN2UYro7-2SXc+Q@mail.gmail.com>
Date: Wed, 7 Mar 2012 16:58:39 -0800
X-Google-Sender-Auth: 91AElwRKyljFohrzAPoMatJqF1c
Message-ID: <CAE9FiQUHm2YOJvoxWZ57AXPcAV7T1QJnFzsWXGNAT160X3Rd6g@mail.gmail.com>
Subject: Re: [PATCH 23/23] x86, PCI: add pcibios_root_rescan
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Bjorn Helgaas <bjorn.helgaas@gmail.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>, x86 <x86@kernel.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 7, 2012 at 3:32 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>
> What's the reason we need to discover those CPU devices in the first place?
>
> I don't think the current policy of blindly probing for things should
> be continued forever.

Do you want to revert follow commit?

BTW, edac never work on nehalem-ex and westmere-ex.

commit a3170c1f924ce2565c4e160b9b095e65c03b2dc6
Author: Jan Beulich <JBeulich@novell.com>
Date:   Wed Feb 23 10:08:10 2011 +0000

    x86/PCI: derive pcibios_last_bus from ACPI MCFG

    On various newer Intel systems the PCI bus(ses) the non-core devices
    live on aren't getting announced by ACPI except through the bus range
    covered by mmconfig. At least the i7core-edac driver depends on these
    devices getting detected.

    Mauro, could you check whether with this change the Xeon 55xx hack in
    that driver can go away altogether, and with it the bogus exporting of
    pcibios_scan_specific_bus()?

    Signed-off-by: Jan Beulich <jbeulich@novell.com>
    Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
    Cc: Aristeu Sergio <arozansk@redhat.com>
    Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>

diff --git a/arch/x86/pci/mmconfig-shared.c b/arch/x86/pci/mmconfig-shared.c
index e282886..750c346 100644
--- a/arch/x86/pci/mmconfig-shared.c
+++ b/arch/x86/pci/mmconfig-shared.c
@@ -606,6 +606,16 @@ static void __init __pci_mmcfg_init(int early)
        if (list_empty(&pci_mmcfg_list))
                return;

+       if (pcibios_last_bus < 0) {
+               const struct pci_mmcfg_region *cfg;
+
+               list_for_each_entry(cfg, &pci_mmcfg_list, list) {
+                       if (cfg->segment)
+                               break;
+                       pcibios_last_bus = cfg->end_bus;
+               }
+       }
+
        if (pci_mmcfg_arch_init())
                pci_probe = (pci_probe & ~PCI_PROBE_MASK) | PCI_PROBE_MMCONF;
        else {
