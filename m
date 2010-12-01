Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755356Ab0LARk3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 12:40:29 -0500
Received: from mga01.intel.com ([192.55.52.88]:10237 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754102Ab0LARk2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 12:40:28 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,284,1288594800"; 
   d="scan'208";a="632064042"
Subject: Re: [patch 2/4] x86, vtd: fix the vt-d fault handling irq
 migration in the x2apic mode
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Chris Wright <chrisw@sous-sol.org>,
        Max Asbock <masbock@linux.vnet.ibm.com>,
        "indou.takao@jp.fujitsu.com" <indou.takao@jp.fujitsu.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        David Woodhouse <dwmw2@infradead.org>,
        "stable@kernel.org" <stable@kernel.org>,
        "Luck, Tony" <tony.luck@intel.com>
In-Reply-To: <20101201151404.GA2069@helgaas.com>
References: <20101201062225.292364637@intel.com>
	 <20101201062244.447287381@intel.com>  <20101201151404.GA2069@helgaas.com>
Content-Type: text/plain
Organization: Intel Corp
Date: Wed, 01 Dec 2010 09:40:32 -0800
Message-Id: <1291225233.2648.39.camel@sbsiddha-MOBL3>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-12-01 at 07:14 -0800, Bjorn Helgaas wrote:
> On Tue, Nov 30, 2010 at 10:22:27PM -0800, Suresh Siddha wrote:
> > +	if (x2apic_mode)
> > +		msg.address_hi = MSI_ADDR_BASE_HI | MSI_ADDR_EXT_DEST_ID(dest);
> 
> Is it necessary to test x2apic_mode here?  It looks like
> MSI_ADDR_EXT_DEST_ID() gives you everything above the low 8
> bits of the APIC ID.  If those bits are always zero except in
> x2apic_mode, we might not need the test.

True. Appended the updated patch.

> Does the ia64 dmar_msi_set_affinity() need the same fix?

No.

> 
> Why do we have both x2apic_enabled() and x2apic_mode?  They
> seem sort of redundant.  (Not related to this patch, of course.)

BIOS can handover to OS in x2apic mode in some cases. x2apic_enabled()
is used to check for that and it reads the MSR to check the status. Some
early portions of the kernel boot will use it.

For all others, we should be using x2apic_mode.

thanks,
suresh
---

From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Subject: x86, vtd: fix the vt-d fault handling irq migration in the x2apic mode

In x2apic mode, we need to set the upper address register of the fault
handling interrupt register of the vt-d hardware. Without this
irq migration of the vt-d fault handling interrupt is broken.

Signed-off-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: stable@kernel.org [v2.6.32+]
---
 arch/x86/kernel/apic/io_apic.c |    1 +
 1 file changed, 1 insertion(+)

Index: tip/arch/x86/kernel/apic/io_apic.c
===================================================================
--- tip.orig/arch/x86/kernel/apic/io_apic.c
+++ tip/arch/x86/kernel/apic/io_apic.c
@@ -3367,6 +3367,7 @@ dmar_msi_set_affinity(struct irq_data *d
 	msg.data |= MSI_DATA_VECTOR(cfg->vector);
 	msg.address_lo &= ~MSI_ADDR_DEST_ID_MASK;
 	msg.address_lo |= MSI_ADDR_DEST_ID(dest);
+	msg.address_hi = MSI_ADDR_BASE_HI | MSI_ADDR_EXT_DEST_ID(dest);
 
 	dmar_msi_write(irq, &msg);
 


