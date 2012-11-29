Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754640Ab2K2Ng4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 08:36:56 -0500
Received: from mail.skyhub.de ([78.46.96.112]:39083 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752277Ab2K2Ngy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 08:36:54 -0500
Date: Thu, 29 Nov 2012 14:36:50 +0100
From: Borislav Petkov <bp@alien8.de>
To: Daniel J Blueman <daniel@numascale-asia.com>
Cc: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        H Peter Anvin <hpa@zytor.com>, Steffen Persvold <sp@numascale.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4 v7] AMD64 EDAC: Fix PCI function lookup
Message-ID: <20121129133650.GA30789@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Daniel J Blueman <daniel@numascale-asia.com>,
	Ingo Molnar <mingo@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>, H Peter Anvin <hpa@zytor.com>,
	Steffen Persvold <sp@numascale.com>, x86@kernel.org,
	linux-kernel@vger.kernel.org
References: <1353997932-8475-1-git-send-email-daniel@numascale-asia.com>
 <1353997932-8475-3-git-send-email-daniel@numascale-asia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1353997932-8475-3-git-send-email-daniel@numascale-asia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 27, 2012 at 02:32:11PM +0800, Daniel J Blueman wrote:
> Fix locating sibling memory controller PCI functions by using the
> correct PCI domain.
> 
> v7: Refactor patches grouping changes
> 
> Signed-off-by: Daniel J Blueman <daniel@numascale-asia.com>
> ---
>  drivers/edac/amd64_edac.c |   40 +++++++++++++++++++++-------------------
>  1 file changed, 21 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
> index 60e93fa..62b7b17 100644
> --- a/drivers/edac/amd64_edac.c
> +++ b/drivers/edac/amd64_edac.c
> @@ -983,6 +983,24 @@ static u64 get_error_address(struct mce *m)
>  	return addr;
>  }
>  
> +static struct pci_dev *pci_get_related_function(unsigned int vendor,
> +						unsigned int device,
> +						struct pci_dev *related)
> +{
> +	struct pci_dev *dev = NULL;
> +
> +	dev = pci_get_device(vendor, device, dev);
> +	while (dev) {
> +		if (pci_domain_nr(dev->bus) == pci_domain_nr(related->bus) &&
> +		    (dev->bus->number == related->bus->number) &&
> +		    (PCI_SLOT(dev->devfn) == PCI_SLOT(related->devfn)))
> +			break;
> +		dev = pci_get_device(vendor, device, dev);
> +	}

This loop looks strange and I'm wondering, wouldn't it be more
straightforward to simply do:

	while (dev = pci_get_device(vendor, device, dev)) {
		if (...)
			break;
	}

	return dev;

I realize the original code does this pci_get_device twice but it is
crap IMO.

Thanks.

-- 
Regards/Gruss,
    Boris.
