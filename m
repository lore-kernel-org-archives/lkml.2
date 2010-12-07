Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752189Ab0LGRlm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 12:41:42 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:50532 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751948Ab0LGRll (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 12:41:41 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.5.1
From: Takao Indoh <indou.takao@jp.fujitsu.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>,
        Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Chris Wright <chrisw@sous-sol.org>,
        Max Asbock <masbock@linux.vnet.ibm.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        David Woodhouse <dwmw2@infradead.org>,
        "stable@kernel.org" <stable@kernel.org>,
        "Luck, Tony" <tony.luck@intel.com>
Subject: Re: [patch 2/4] x86, vtd: fix the vt-d fault handling irq migration in the x2apic mode
Date: Tue, 07 Dec 2010 12:38:58 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
X-Mailer: HidemaruMail 5.38 (WinNT,501)
In-Reply-To: <1291225233.2648.39.camel@sbsiddha-MOBL3>
References: <20101201062225.292364637@intel.com> <20101201062244.447287381@intel.com> <20101201151404.GA2069@helgaas.com> <1291225233.2648.39.camel@sbsiddha-MOBL3>
Message-Id: <F8CB9635A08C18indou.takao@jp.fujitsu.com>
X-Antivirus: avast! (VPS 101207-0, 2010/12/07), Outbound message
X-Antivirus-Status: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 01 Dec 2010 09:40:32 -0800, Suresh Siddha wrote:

>On Wed, 2010-12-01 at 07:14 -0800, Bjorn Helgaas wrote:
>> On Tue, Nov 30, 2010 at 10:22:27PM -0800, Suresh Siddha wrote:
>> > +	if (x2apic_mode)
>> > +		msg.address_hi = MSI_ADDR_BASE_HI | MSI_ADDR_EXT_DEST_ID
>> > (dest);
>> 
>> Is it necessary to test x2apic_mode here?  It looks like
>> MSI_ADDR_EXT_DEST_ID() gives you everything above the low 8
>> bits of the APIC ID.  If those bits are always zero except in
>> x2apic_mode, we might not need the test.
>
>True. Appended the updated patch.

I applied this patch against 2.6.36 and confirmed irq migration of
vt-d fault worked.

Tested-by: Takao Indoh <indou.takao@jp.fujitsu.com>

Thanks,
Takao Indoh

>
>> Does the ia64 dmar_msi_set_affinity() need the same fix?
>
>No.
>
>> 
>> Why do we have both x2apic_enabled() and x2apic_mode?  They
>> seem sort of redundant.  (Not related to this patch, of course.)
>
>BIOS can handover to OS in x2apic mode in some cases. x2apic_enabled()
>is used to check for that and it reads the MSR to check the status. Some
>early portions of the kernel boot will use it.
>
>For all others, we should be using x2apic_mode.
>
>thanks,
>suresh
>---
>
>From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
>Subject: x86, vtd: fix the vt-d fault handling irq migration in the x2apic 
>mode
>
>In x2apic mode, we need to set the upper address register of the fault
>handling interrupt register of the vt-d hardware. Without this
>irq migration of the vt-d fault handling interrupt is broken.
>
>Signed-off-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
>Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
>Cc: stable@kernel.org [v2.6.32+]
>---
> arch/x86/kernel/apic/io_apic.c |    1 +
> 1 file changed, 1 insertion(+)
>
>Index: tip/arch/x86/kernel/apic/io_apic.c
>===================================================================
>--- tip.orig/arch/x86/kernel/apic/io_apic.c
>+++ tip/arch/x86/kernel/apic/io_apic.c
>@@ -3367,6 +3367,7 @@ dmar_msi_set_affinity(struct irq_data *d
> 	msg.data |= MSI_DATA_VECTOR(cfg->vector);
> 	msg.address_lo &= ~MSI_ADDR_DEST_ID_MASK;
> 	msg.address_lo |= MSI_ADDR_DEST_ID(dest);
>+	msg.address_hi = MSI_ADDR_BASE_HI | MSI_ADDR_EXT_DEST_ID(dest);
> 
> 	dmar_msi_write(irq, &msg);
> 


---
印藤隆夫(INDOH Takao)
 E-Mail : indou.takao@jp.fujitsu.com
