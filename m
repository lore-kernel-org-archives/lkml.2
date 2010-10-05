Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932434Ab0JEJH7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 05:07:59 -0400
Received: from www.tglx.de ([62.245.132.106]:32997 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755038Ab0JEJH5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 05:07:57 -0400
Date: Tue, 5 Oct 2010 11:07:36 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH 15/22] x86: Copy-n-paste arch_teardown_msi_irqs from
 msi.c to io_apic.c.
In-Reply-To: <1286216015-9710-16-git-send-email-konrad.wilk@oracle.com>
Message-ID: <alpine.LFD.2.00.1010051055470.2556@localhost6.localdomain6>
References: <1286216015-9710-1-git-send-email-konrad.wilk@oracle.com> <1286216015-9710-16-git-send-email-konrad.wilk@oracle.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Oct 2010, Konrad Rzeszutek Wilk wrote:

> In preparation for non-privileged domains to disable PCI devices'
> MSI/MSIx, we need to augment arch_teardown_msi_irqs to make
> a call to the privileged domain (patch to follow).

Can't we find a more clever solution than just copying stuff around ?

Something like this:

diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index 69b7be3..36d607c 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -60,7 +60,12 @@ int arch_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
 #endif
 
 #ifndef arch_teardown_msi_irqs
-void arch_teardown_msi_irqs(struct pci_dev *dev)
+# define arch_teardown_msi_irqs default_teardown_msi_irqs
+# define HAVE_DEFAULT_MSI_TEARDOWN_IRQS
+#endif
+
+#ifdef HAVE_DEFAULT_MSI_TEARDOWN_IRQS
+void default_teardown_msi_irqs(struct pci_dev *dev)
 {
 	struct msi_desc *entry;
 
That way you can override arch_teardown_msi_irqs with x86_msi_ops, define
HAVE_DEFAULT_MSI_TEARDOWN_IRQS in asm/msi.h and set the default
pointer to default_teardown_msi_irqs().

Thanks,

	tglx
