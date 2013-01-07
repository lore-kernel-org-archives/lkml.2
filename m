Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753245Ab3AGPIc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 10:08:32 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:42262 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751681Ab3AGPIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 10:08:31 -0500
Date: Mon, 7 Jan 2013 10:08:16 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Nickolai Zeldovich <nickolai@csail.mit.edu>, JBeulich@suse.com,
        xen-devel@lists.xensource.com
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH] drivers/xen: avoid out-of-range write in xen_add_device
Message-ID: <20130107150816.GC3219@phenom.dumpdata.com>
References: <1357413526-42430-1-git-send-email-nickolai@csail.mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1357413526-42430-1-git-send-email-nickolai@csail.mit.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 05, 2013 at 02:18:46PM -0500, Nickolai Zeldovich wrote:
> xen_add_device() in drivers/xen/pci.c allocates a struct
> physdev_pci_device_add on the stack and then writes to optarr[0].
> The previous declaration of struct physdev_pci_device_add contained
> a zero-length optarr[] array, presumably assuming it will be allocated
> with kmalloc with a suitable number of trailing elements, but the code in
> xen_add_device() as a result wrote past the end of the (stack-allocated)
> data structure.
> 
> Since xen_add_device() is the only use of struct physdev_pci_device_add
> in the kernel, turn optarr[] into a single-element array instead.
> 

Lets include Jan and Xen-devel on this email - as this is also changing
the official header that is used in Xen.

> Signed-off-by: Nickolai Zeldovich <nickolai@csail.mit.edu>
> ---
>  include/xen/interface/physdev.h |    6 +-----
>  1 file changed, 1 insertion(+), 5 deletions(-)
> 
> diff --git a/include/xen/interface/physdev.h b/include/xen/interface/physdev.h
> index 1844d31..24fd218 100644
> --- a/include/xen/interface/physdev.h
> +++ b/include/xen/interface/physdev.h
> @@ -242,11 +242,7 @@ struct physdev_pci_device_add {
>          uint8_t bus;
>          uint8_t devfn;
>      } physfn;
> -#if defined(__STDC_VERSION__) && __STDC_VERSION__ >= 199901L
> -    uint32_t optarr[];
> -#elif defined(__GNUC__)
> -    uint32_t optarr[0];
> -#endif
> +    uint32_t optarr[1];
>  };
>  
>  #define PHYSDEVOP_pci_device_remove     26
> -- 
> 1.7.10.4
> 
