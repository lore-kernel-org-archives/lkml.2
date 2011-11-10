Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932217Ab1KJRat (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 12:30:49 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:59772 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755329Ab1KJRar (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 12:30:47 -0500
Message-ID: <4EBC038C.1050700@lwfinger.net>
Date: Thu, 10 Nov 2011 11:02:04 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: =?UTF-8?B?VG9tw6HFoSBKYW5vdcWhZWs=?= <tomi@nomi.cz>
CC: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: iwlagn: memory corruption with WPA enterprise
References: <20111029171554.GA16596@nomi.cz> <20111031160342.GB2225@redhat.com> <20111109155411.GA1669@nomi.cz> <20111109165158.GA2254@redhat.com> <20111110091816.GA2247@nomi.cz> <20111110114732.GA2217@redhat.com> <20111110125347.GA29415@nomi.cz> <20111110160703.GA2775@redhat.com> <1320938685.31823.200.camel@wwguy-huron> <20111110164230.GB24533@nomi.cz>
In-Reply-To: <20111110164230.GB24533@nomi.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/10/2011 10:42 AM, Tomáš Janoušek wrote:
> (Don't be scared by the vboxdrv messages. Those modules don't compile with
> 3.2-rc1, and the bug happens there as well.)

The following patch will fix the 3.2-rc1 build problem.

Index: vboxhost/vboxpci/linux/VBoxPci-linux.c
===================================================================
--- vboxhost.orig/vboxpci/linux/VBoxPci-linux.c
+++ vboxhost/vboxpci/linux/VBoxPci-linux.c
@@ -146,7 +146,11 @@ static int __init VBoxPciLinuxInit(void)
  #endif

  #ifdef VBOX_WITH_IOMMU
+# if LINUX_VERSION_CODE >= KERNEL_VERSION(3, 2, 0)
+    if (iommu_present(&pci_bus_type))
+#else
      if (iommu_found())
+#endif
          printk(KERN_INFO "vboxpci: IOMMU found\n");
      else
          printk(KERN_INFO "vboxpci: IOMMU not found (not registered)\n");
@@ -984,9 +988,15 @@ int  vboxPciOsInitVm(PVBOXRAWPCIDRVVM pT
      printk(KERN_DEBUG "vboxPciOsInitVm: %p\n", pThis);
  #endif
  #ifdef VBOX_WITH_IOMMU
+# if LINUX_VERSION_CODE >= KERNEL_VERSION(3, 2, 0)
+    if (iommu_present(&pci_bus_type))
+    {
+        pThis->pIommuDomain = iommu_domain_alloc(&pci_bus_type);
+#else
      if (iommu_found())
      {
          pThis->pIommuDomain = iommu_domain_alloc();
+#endif
          if (!pThis->pIommuDomain)
          {
              printk(KERN_DEBUG "cannot allocate IOMMU domain\n");


