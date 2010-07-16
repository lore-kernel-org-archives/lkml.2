Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758980Ab0GPTM4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 15:12:56 -0400
Received: from cpoproxy3-pub.bluehost.com ([67.222.54.6]:42558 "HELO
	cpoproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754752Ab0GPTMz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 15:12:55 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=Hdrj1s32sX0BZ0eO7ciVgwBamOl5ifJ0O6qVNs1UrS9bNym51gARDFwOHWxWR7L8Z/FQFr8fR5cFOfAySCQFl/f1Qt53B/Nr1j70wRJniexUCsZd9FAL6Md8A+0VSbsn;
Date: Fri, 16 Jul 2010 12:12:48 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ben Greear <greearb@candelatech.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86/pci/mrst: add extra check in fixed bar detection
Message-ID: <20100716121248.0f3daa3b@virtuousgeek.org>
In-Reply-To: <1279306706-27087-1-git-send-email-jacob.jun.pan@linux.intel.com>
References: <1279306706-27087-1-git-send-email-jacob.jun.pan@linux.intel.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.110.194.140 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Jul 2010 11:58:26 -0700
Jacob Pan <jacob.jun.pan@linux.intel.com> wrote:

> Fixed bar capability structure is searched in PCI extended configuration
> space. We need to make sure there is a valid capability id to begin with
> otherwise, the search code may stuck in a infinite loop which results in
> boot hang.
> This patch adds additional check for cap ID 0, which is also invalid.
> 
> Suggested-by: "H. Peter Anvin" <hpa@zytor.com>
> 
> Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
> ---
>  arch/x86/pci/mrst.c |    7 ++++---
>  1 files changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/pci/mrst.c b/arch/x86/pci/mrst.c
> index c9649d0..8636567 100644
> --- a/arch/x86/pci/mrst.c
> +++ b/arch/x86/pci/mrst.c
> @@ -66,8 +66,9 @@ static int fixed_bar_cap(struct pci_bus *bus, unsigned int devfn)
>  					  devfn, pos, 4, &pcie_cap))
>  			return 0;
>  
> -		if (pcie_cap == 0xffffffff)
> -			return 0;
> +		if (PCI_EXT_CAP_ID(pcie_cap) == 0x0000 ||
> +			PCI_EXT_CAP_ID(pcie_cap) == 0xffff)
> +			break;
>  
>  		if (PCI_EXT_CAP_ID(pcie_cap) == PCI_EXT_CAP_ID_VNDR) {
>  			raw_pci_ext_ops->read(pci_domain_nr(bus), bus->number,
> @@ -76,7 +77,7 @@ static int fixed_bar_cap(struct pci_bus *bus, unsigned int devfn)
>  				return pos;
>  		}
>  
> -		pos = pcie_cap >> 20;
> +		pos = PCI_EXT_CAP_NEXT(pcie_cap);
>  	}
>  
>  	return 0;

Looks good.

Reviewed-by: Jesse Barnes <jbarnes@virtuousgeek.org>

-- 
Jesse Barnes, Intel Open Source Technology Center
