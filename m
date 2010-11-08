Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751971Ab0KHPfd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 10:35:33 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:36865 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147Ab0KHPfc (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Mon, 8 Nov 2010 10:35:32 -0500
Date: Mon, 8 Nov 2010 10:34:04 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: jirislaby@gmail.com, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org
Subject: Re: [PATCH] x86: pci/xen, fix memory leak
Message-ID: <20101108153404.GA8637@dumpdata.com>
References: <1289034412-24278-1-git-send-email-jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289034412-24278-1-git-send-email-jslaby@suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 06, 2010 at 10:06:49AM +0100, Jiri Slaby wrote:
> Stanse found that xen_setup_msi_irqs leaks memory when
> xen_allocate_pirq fails. Free the memory in that fail path.

Duh! Yes, sticking it in the queue for bug-fixes. Thank you
for finding it.
> 
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Cc: xen-devel@lists.xensource.com
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: x86@kernel.org
> ---
>  arch/x86/pci/xen.c |    8 +++++---
>  1 files changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/pci/xen.c b/arch/x86/pci/xen.c
> index 117f5b8..d7b5109 100644
> --- a/arch/x86/pci/xen.c
> +++ b/arch/x86/pci/xen.c
> @@ -147,8 +147,10 @@ static int xen_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
>  		irq = xen_allocate_pirq(v[i], 0, /* not sharable */
>  			(type == PCI_CAP_ID_MSIX) ?
>  			"pcifront-msi-x" : "pcifront-msi");
> -		if (irq < 0)
> -			return -1;
> +		if (irq < 0) {
> +			ret = -1;
> +			goto free;
> +		}
>  
>  		ret = set_irq_msi(irq, msidesc);
>  		if (ret)
> @@ -164,7 +166,7 @@ error:
>  	if (ret == -ENODEV)
>  		dev_err(&dev->dev, "Xen PCI frontend has not registered" \
>  			" MSI/MSI-X support!\n");
> -
> +free:
>  	kfree(v);
>  	return ret;
>  }
> -- 
> 1.7.3.1
> 
