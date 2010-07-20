Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757550Ab0GTRTB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 13:19:01 -0400
Received: from mail.candelatech.com ([208.74.158.172]:59311 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754698Ab0GTRS7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 13:18:59 -0400
Message-ID: <4C45DA7F.1060801@candelatech.com>
Date: Tue, 20 Jul 2010 10:18:55 -0700
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc11 Thunderbird/3.0.4
MIME-Version: 1.0
To: Jacob Pan <jacob.jun.pan@linux.intel.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, Jesse Barnes <jbarnes@virtuousgeek.org>,
        LKML <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
Subject: Re: [PATCH] x86/pci/mrst: add extra check in fixed bar detection
References: <1279306706-27087-1-git-send-email-jacob.jun.pan@linux.intel.com>
In-Reply-To: <1279306706-27087-1-git-send-email-jacob.jun.pan@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/16/2010 11:58 AM, Jacob Pan wrote:
> Fixed bar capability structure is searched in PCI extended configuration
> space. We need to make sure there is a valid capability id to begin with
> otherwise, the search code may stuck in a infinite loop which results in
> boot hang.
> This patch adds additional check for cap ID 0, which is also invalid.

I think this should be added to the stable tree for 2.6.34
as well...

Thanks,
Ben

>
> Suggested-by: "H. Peter Anvin"<hpa@zytor.com>
>
> Signed-off-by: Jacob Pan<jacob.jun.pan@linux.intel.com>
> ---
>   arch/x86/pci/mrst.c |    7 ++++---
>   1 files changed, 4 insertions(+), 3 deletions(-)
>
> diff --git a/arch/x86/pci/mrst.c b/arch/x86/pci/mrst.c
> index c9649d0..8636567 100644
> --- a/arch/x86/pci/mrst.c
> +++ b/arch/x86/pci/mrst.c
> @@ -66,8 +66,9 @@ static int fixed_bar_cap(struct pci_bus *bus, unsigned int devfn)
>   					  devfn, pos, 4,&pcie_cap))
>   			return 0;
>
> -		if (pcie_cap == 0xffffffff)
> -			return 0;
> +		if (PCI_EXT_CAP_ID(pcie_cap) == 0x0000 ||
> +			PCI_EXT_CAP_ID(pcie_cap) == 0xffff)
> +			break;
>
>   		if (PCI_EXT_CAP_ID(pcie_cap) == PCI_EXT_CAP_ID_VNDR) {
>   			raw_pci_ext_ops->read(pci_domain_nr(bus), bus->number,
> @@ -76,7 +77,7 @@ static int fixed_bar_cap(struct pci_bus *bus, unsigned int devfn)
>   				return pos;
>   		}
>
> -		pos = pcie_cap>>  20;
> +		pos = PCI_EXT_CAP_NEXT(pcie_cap);
>   	}
>
>   	return 0;


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

