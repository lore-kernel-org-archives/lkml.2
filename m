Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752496Ab1DKPtc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 11:49:32 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:56529 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751673Ab1DKPtb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 11:49:31 -0400
Date: Mon, 11 Apr 2011 11:49:30 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Roedel, Joerg" <Joerg.Roedel@amd.com>
cc: Borislav Petkov <bp@alien8.de>, Greg Kroah-Hartman <gregkh@suse.de>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Andiry Xu <andiry.xu@amd.com>, USB list <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5] USB host: Fix lockdep warning in AMD PLL quirk
In-Reply-To: <20110411065957.GI23633@amd.com>
Message-ID: <Pine.LNX.4.44L0.1104111144540.1975-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Apr 2011, Roedel, Joerg wrote:

> On Mon, Apr 11, 2011 at 02:26:00AM -0400, Borislav Petkov wrote:
> > You mean 2.6.39-rc2 right? I'm asking because I hit the same warning
> > with 39-rc2 now too but it didn't appear with .38 - so it has to have
> > snuck in after the merge window. If so, you don't need the stable tag.
> 
> You were right, just tested plain 2.6.38 and it doesn't happen. So I
> removed the stable tag. Here is the updated patch.

...

> --- a/drivers/usb/host/pci-quirks.c
> +++ b/drivers/usb/host/pci-quirks.c
> @@ -84,65 +84,92 @@ int usb_amd_find_chipset_info(void)
>  {

...

> +commit:
> +
> +	spin_lock_irqsave(&amd_lock, flags);
> +	if (amd_chipset.probe_count > 0) {
> +		/* race - someone else was faster - drop devices */
> +
> +		/* Mark that we where here */
> +		amd_chipset.probe_count++;

This line should be moved above the "if" statement, since you always 
want to increment the count.

> +		ret = amd_chipset.probe_result;
> +
> +		spin_unlock_irqrestore(&amd_lock, flags);
> +
> +		if (info.nb_dev)
> +			pci_dev_put(info.nb_dev);
> +		if (info.smbus_dev)
> +			pci_dev_put(info.smbus_dev);
> +
> +	} else {
> +		/* no race - commit the result */
> +		info.probe_count++;

This isn't right, because info.probe_count was initialized to 0.  Maybe 
amd_chipset.probe_count should be made into a separate variable, not a 
part of the structure, like amd_lock.

> +		amd_chipset = info;
> +		spin_unlock_irqrestore(&amd_lock, flags);
> +	}
> +
> +	return ret;
>  }
>  EXPORT_SYMBOL_GPL(usb_amd_find_chipset_info);

Alan Stern

