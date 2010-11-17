Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753407Ab0KQFOg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 00:14:36 -0500
Received: from sj-iport-1.cisco.com ([171.71.176.70]:12765 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912Ab0KQFOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 00:14:34 -0500
Authentication-Results: sj-iport-1.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlIEAGbz4kyrR7Ht/2dsb2JhbACDSJA5jkFxpSKKNZBggSKDNnMEhFqFfg
X-IronPort-AV: E=Sophos;i="4.59,209,1288569600"; 
   d="scan'208";a="381900981"
From: Tom Lyon <pugs@cisco.com>
Organization: Cisco Systems, Inc.
To: Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [PATCH] vfio: fix config virtualization, esp command byte
Date: Tue, 16 Nov 2010 21:14:50 -0800
User-Agent: KMail/1.13.5 (Linux/2.6.34.7-0.5-desktop; KDE/4.4.4; x86_64; ; )
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
References: <4cd9f0d6.jnHBr6PBphKwDwhM%pugs@cisco.com> <1289930061.3069.5.camel@x201> <1289933847.3069.8.camel@x201>
In-Reply-To: <1289933847.3069.8.camel@x201>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201011162114.50954.pugs@cisco.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Applied.

On Tuesday, November 16, 2010 10:57:27 am Alex Williamson wrote:
> On Tue, 2010-11-16 at 10:54 -0700, Alex Williamson wrote:
> > On Tue, 2010-11-09 at 17:09 -0800, Tom Lyon wrote:
> > > Cleans up config space virtualization, especialy handling of bytes
> > > which have some virtual and some real bits, like PCI_COMMAND.
> > > 
> > > Alex, I hope you can test this with your setups.
> > 
> > Sorry for the delay.  FWIW, I'm not having much luck with this, I'll try
> > to debug the problem.  Thanks,
> 
> This seems to be the bug.  Thanks,
> 
> Alex
> 
> vfio: Don't write random bits on read
> 
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> ---
> 
> diff --git a/drivers/vfio/vfio_pci_config.c
> b/drivers/vfio/vfio_pci_config.c index 7132ac4..422d7b1 100644
> --- a/drivers/vfio/vfio_pci_config.c
> +++ b/drivers/vfio/vfio_pci_config.c
> @@ -964,11 +964,6 @@ static int vfio_config_rwbyte(int write,
>  		return 0;
>  	}
> 
> -	if (write) {
> -		if (copy_from_user(&newval, buf, 1))
> -			return -EFAULT;
> -	}
> -
>  	if (~virt) {	/* mix of real and virt bits */
>  		/* update vconfig with latest hw bits */
>  		ret = vfio_read_config_byte(vdev, pos, &realbits);
> @@ -978,9 +973,14 @@ static int vfio_config_rwbyte(int write,
>  			(vdev->vconfig[pos] & virt) | (realbits & ~virt);
>  	}
> 
> -	/* update vconfig with writeable bits */
> -	vdev->vconfig[pos] =
> -		(vdev->vconfig[pos] & ~wr) | (newval & wr);
> +	if (write) {
> +		if (copy_from_user(&newval, buf, 1))
> +			return -EFAULT;
> +
> +		/* update vconfig with writeable bits */
> +		vdev->vconfig[pos] =
> +			(vdev->vconfig[pos] & ~wr) | (newval & wr);
> +        }
> 
>  	/*
>  	 * Now massage virtual fields
