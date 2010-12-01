Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754026Ab0LAPOL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 10:14:11 -0500
Received: from qmta04.emeryville.ca.mail.comcast.net ([76.96.30.40]:57254 "EHLO
	qmta04.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751173Ab0LAPOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 10:14:09 -0500
Date: Wed, 1 Dec 2010 08:14:04 -0700
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Chris Wright <chrisw@sous-sol.org>,
        Max Asbock <masbock@linux.vnet.ibm.com>, indou.takao@jp.fujitsu.com,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        David Woodhouse <dwmw2@infradead.org>, stable@kernel.org,
        Tony Luck <tony.luck@intel.com>
Subject: Re: [patch 2/4] x86, vtd: fix the vt-d fault handling irq
 migration in the x2apic mode
Message-ID: <20101201151404.GA2069@helgaas.com>
References: <20101201062225.292364637@intel.com>
 <20101201062244.447287381@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101201062244.447287381@intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 30, 2010 at 10:22:27PM -0800, Suresh Siddha wrote:
> From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
> Subject: x86, vtd: fix the vt-d fault handling irq migration in the x2apic mode
> 
> In x2apic mode, we need to set the upper address register of the fault
> handling interrupt register of the vt-d hardware. Without this
> irq migration of the vt-d fault handling interrupt is broken.
> 
> Signed-off-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
> Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
> Cc: stable@kernel.org [v2.6.32+]
> ---
>  arch/x86/kernel/apic/io_apic.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> Index: tip/arch/x86/kernel/apic/io_apic.c
> ===================================================================
> --- tip.orig/arch/x86/kernel/apic/io_apic.c
> +++ tip/arch/x86/kernel/apic/io_apic.c
> @@ -3367,6 +3367,8 @@ dmar_msi_set_affinity(struct irq_data *d
>  	msg.data |= MSI_DATA_VECTOR(cfg->vector);
>  	msg.address_lo &= ~MSI_ADDR_DEST_ID_MASK;
>  	msg.address_lo |= MSI_ADDR_DEST_ID(dest);
> +	if (x2apic_mode)
> +		msg.address_hi = MSI_ADDR_BASE_HI | MSI_ADDR_EXT_DEST_ID(dest);

Is it necessary to test x2apic_mode here?  It looks like
MSI_ADDR_EXT_DEST_ID() gives you everything above the low 8
bits of the APIC ID.  If those bits are always zero except in
x2apic_mode, we might not need the test.

Does the ia64 dmar_msi_set_affinity() need the same fix?

Why do we have both x2apic_enabled() and x2apic_mode?  They
seem sort of redundant.  (Not related to this patch, of course.)

Bjorn
