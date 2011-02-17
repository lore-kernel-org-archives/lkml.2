Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752924Ab1BQIlg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 03:41:36 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:32967 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751351Ab1BQIle (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 03:41:34 -0500
X-IronPort-AV: E=Sophos;i="4.60,485,1291611600"; 
   d="scan'208";a="136294795"
Subject: Re: [Xen-devel] [PATCH 1/3] pci/xen: Use xen_allocate_pirq_msi
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Konrad Rzeszutek Wilk" <konrad@kernel.org>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "Stefano Stabellini" <Stefano.Stabellini@eu.citrix.com>
In-Reply-To: <1297894638-28007-2-git-send-email-konrad.wilk@oracle.com>
References: <1297894638-28007-1-git-send-email-konrad.wilk@oracle.com>
	 <1297894638-28007-2-git-send-email-konrad.wilk@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Citrix Systems, Inc.
Date: Thu, 17 Feb 2011 08:41:31 +0000
Message-ID: <1297932091.16356.1292.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-02-16 at 22:17 +0000, Konrad Rzeszutek Wilk wrote:
> There is no need to use the old interface.

xen_allocate_pirq -> xen_map_pirq_gsi -> PHYSDEVOP_alloc_irq_vector IFF
xen_initial_domain() in addition to the kernel side book-keeping side of
things (set chip and handler, update irq_info etc) whereas
xen_allocate_pirq_msi just does the kernel book keeping.

Also xen_allocate_pirq allocates an IRQ in the 1-1 GSI space whereas
xen_allocate_pirq_msi allocates a dynamic one in the >GSI IRQ space.

So this change is actually a semantic change and not just a switch to a
new interface. I think the change is OK (because the caller is domU
only?) but a comment explaining this would be appreciated.

> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> ---
>  arch/x86/pci/xen.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/pci/xen.c b/arch/x86/pci/xen.c
> index 25cd4a0..6432f75 100644
> --- a/arch/x86/pci/xen.c
> +++ b/arch/x86/pci/xen.c
> @@ -157,14 +157,14 @@ static int xen_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
>  		goto error;
>  	i = 0;
>  	list_for_each_entry(msidesc, &dev->msi_list, list) {
> -		irq = xen_allocate_pirq(v[i], 0, /* not sharable */
> +		xen_allocate_pirq_msi(
>  			(type == PCI_CAP_ID_MSIX) ?
> -			"pcifront-msi-x" : "pcifront-msi");
> +			"pcifront-msi-x" : "pcifront-msi",
> +			&irq, &v[i], XEN_ALLOC_IRQ);

All callers have this (type == MSIX) ? "msi-x" : "msi" construct,
differing only in their use of a "pcifront-" prefix. Something which
could be hoisted into the function perhaps?

Another aside: I think there are other cleanups which could be made to
the various pirq allocation/mapping interfaces (of which there seem to
be too many, or at least their individual unique qualities are
indistinguishable by their names), I made a start on this at one point
since I wanted to get rid of the pirq_to_irq[nr_irqs] array, for obvious
reasons, but didn't finish it off. I'll hopefully revisit this soon.

Ian.

>  		if (irq < 0) {
>  			ret = -1;
>  			goto free;
>  		}
> -
>  		ret = set_irq_msi(irq, msidesc);
>  		if (ret)
>  			goto error_while;


