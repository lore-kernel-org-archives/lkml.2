Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751874Ab1HVEO5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 00:14:57 -0400
Received: from andromeda.dapyr.net ([206.212.254.10]:55218 "EHLO
	andromeda.dapyr.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750837Ab1HVEOz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 00:14:55 -0400
X-Greylist: delayed 764 seconds by postgrey-1.27 at vger.kernel.org; Mon, 22 Aug 2011 00:14:55 EDT
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Reply-To: konrad.wilk@oracle.com
Organization: Oracle
To: Daniel Kiper <dkiper@net-space.pl>
Subject: Re: [PATCH 1/4] xen: Take into account Xen control interface changes since Xen Ver. 4.1
Date: Sun, 21 Aug 2011 23:56:50 -0400
User-Agent: KMail/1.13.5 (Linux/3.0.0; KDE/4.5.5; i686; ; )
Cc: ian.campbell@citrix.com, vgoyal@redhat.com, horms@verge.net.au,
        olaf@aepfle.de, kexec@lists.infradead.org,
        xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
References: <20110821135139.GB17323@router-fw-old.local.net-space.pl>
In-Reply-To: <20110821135139.GB17323@router-fw-old.local.net-space.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201108212356.50589.konrad.wilk@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> xc_interface_open() receive three arguments instead of void and returns
> pointer to xc_interface type instead of int since Xen Ver. 4.1. Take into
> account that and allow kexec-tools compilation with all versions of Xen.
> 
> Signed-off-by: Daniel Kiper <dkiper@net-space.pl>
> ---
>  kexec/crashdump-xen.c |   15 ++++++++++++++-
>  1 files changed, 14 insertions(+), 1 deletions(-)
> 
> diff --git a/kexec/crashdump-xen.c b/kexec/crashdump-xen.c
> index b347764..9dfabf8 100644
> --- a/kexec/crashdump-xen.c
> +++ b/kexec/crashdump-xen.c
> @@ -126,19 +126,32 @@ unsigned long xen_architecture(struct crash_elf_info 
*elf_info)
>  {
>  	unsigned long machine = elf_info->machine;
>  #ifdef HAVE_LIBXENCTRL
> -	int xc, rc;
> +	int rc;
>  	xen_capabilities_info_t capabilities;
> +#ifdef XENCTRL_HAS_XC_INTERFACE
> +	xc_interface *xc;
> +#else
> +	int xc;
> +#endif

Where is the #endif for HAVE_LIBXENCTRL?

>  
>  	if (!xen_present())
>  		goto out;
>  
>  	memset(capabilities, '0', XEN_CAPABILITIES_INFO_LEN);
>  
> +#ifdef XENCTRL_HAS_XC_INTERFACE
> +	xc = xc_interface_open(NULL, NULL, 0);
> +	if ( !xc ) {
> +		fprintf(stderr, "failed to open xen control interface.\n");
> +		goto out;
> +	}
> +#else
>  	xc = xc_interface_open();
>  	if ( xc == -1 ) {
>  		fprintf(stderr, "failed to open xen control interface.\n");
>  		goto out;
>  	}
> +#endif
>  
>  	rc = xc_version(xc, XENVER_capabilities, &capabilities[0]);
>  	if ( rc == -1 ) {
> -- 
> 1.5.6.5
> 
