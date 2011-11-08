Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755482Ab1KHQoh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 11:44:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:21236 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753193Ab1KHQoe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 11:44:34 -0500
Message-ID: <1320770670.19116.23.camel@bling.home>
Subject: Re: [PATCH] pci: More PRI/PASID cleanup
From: Alex Williamson <alex.williamson@redhat.com>
To: "Roedel, Joerg" <Joerg.Roedel@amd.com>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>
Date: Tue, 08 Nov 2011 09:44:30 -0700
In-Reply-To: <20111108162826.GD5182@amd.com>
References: <20111103034359.10286.19062.stgit@bling.home>
	 <20111108162826.GD5182@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-11-08 at 17:28 +0100, Roedel, Joerg wrote:
> On Wed, Nov 02, 2011 at 11:53:56PM -0400, Alex Williamson wrote:
> > More consistency cleanups.  Drop the _OFF, separate and indent
> > CTRL/CAP/STATUS bit definitions, fix that PASID_CAP doesn't
> > actually report the ENABLE bit.
> > 
> > Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> > ---
> > 
> > Joerg, I can't test this, so you may want to make sure I'm not
> > breaking your API.  The March 31, 2011 version of the PASID ECN
> > shows bit 0 of the PASID capability register as reserved, not
> > an indicator of support for or status of the enable bit.
> > Presumably the entire capability wouldn't be included if it
> > can't be enabled.  With the below, pci_enable_pasid() now checks
> > the right bit, but also pci_pasid_features() no longer masks in
> > bit 0, but being reserved, it should have been clear anyway.
> 
> Looks like you are only renaming stuff. I don't see the real point but I
> also don't object unless this will be merged upstream soon. I plan to
> push the code using these capabilities for the next merge-window and if
> this one will me merged then too it will cause a lot of pain.

I'll paste the functional change below, but the renaming pulls PRI/PASID
in line with the rest of the defines in the file.  Consistent naming
promotes proper usage, imho.

 /* PASID capability */
> -#define PCI_PASID_CAP_OFF	0x04    /* PASID feature register */
> -#define PCI_PASID_CONTROL_OFF   0x06    /* PASID control register */
> -#define PCI_PASID_ENABLE	0x01	/* Enable/Supported bit */
> -#define PCI_PASID_EXEC		0x02	/* Exec permissions Enable/Supported */
> -#define PCI_PASID_PRIV		0x04	/* Priviledge Mode Enable/Support */
> +#define PCI_PASID_CAP		0x04    /* PASID feature register */
> +#define  PCI_PASID_CAP_EXEC	0x02	/* Exec permissions Supported */
> +#define  PCI_PASID_CAP_PRIV	0x04	/* Priviledge Mode Supported */
> +#define PCI_PASID_CTRL		0x06    /* PASID control register */
> +#define  PCI_PASID_CTRL_ENABLE	0x01	/* Enable bit */
> +#define  PCI_PASID_CTRL_EXEC	0x02	/* Exec permissions Enable */
> +#define  PCI_PASID_CTRL_PRIV	0x04	/* Priviledge Mode Enable */

bit 0 (PCI_PASID_ENABLE) is reserved in the CAP register...

@@ -345,21 +346,21 @@ int pci_enable_pasid(struct pci_dev *pdev, int features)
>  	if (!pos)
>  		return -EINVAL;
>  
> -	pci_read_config_word(pdev, pos + PCI_PASID_CONTROL_OFF, &control);
> -	pci_read_config_word(pdev, pos + PCI_PASID_CAP_OFF,     &supported);
> +	pci_read_config_word(pdev, pos + PCI_PASID_CTRL, &control);
> +	pci_read_config_word(pdev, pos + PCI_PASID_CAP, &supported);
>  
> -	if (!(supported & PCI_PASID_ENABLE))
> +	if (!(control & PCI_PASID_CTRL_ENABLE))
>  		return -EINVAL;

Which means we need to check CTRL, not CAP to see if it was previously
enabled... or maybe this check is entirely wrong and we're was trying to
see if enable is supported.

@@ -390,9 +391,8 @@ EXPORT_SYMBOL_GPL(pci_disable_pasid);
>   * Returns a negative value when no PASI capability is present.
>   * Otherwise is returns a bitmask with supported features. Current
>   * features reported are:
> - * PCI_PASID_ENABLE - PASID capability can be enabled
> - * PCI_PASID_EXEC - Execute permission supported
> - * PCI_PASID_PRIV - Priviledged mode supported
> + * PCI_PASID_CAP_EXEC - Execute permission supported
> + * PCI_PASID_CAP_PRIV - Priviledged mode supported
>   */
>  int pci_pasid_features(struct pci_dev *pdev)
>  {
> @@ -403,9 +403,9 @@ int pci_pasid_features(struct pci_dev *pdev)
>  	if (!pos)
>  		return -EINVAL;
>  
> -	pci_read_config_word(pdev, pos + PCI_PASID_CAP_OFF, &supported);
> +	pci_read_config_word(pdev, pos + PCI_PASID_CAP, &supported);
>  
> -	supported &= PCI_PASID_ENABLE | PCI_PASID_EXEC | PCI_PASID_PRIV;
> +	supported &= PCI_PASID_CAP_EXEC | PCI_PASID_CAP_PRIV;

And nobody exposes PCI_PASID_ENABLE because it doesn't exist as a
capability.

It's easy to see this if the bit definitions are named appropriately and
specified per register instead of being lumped together as "close
enough".  Thanks,

Alex

