Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756350Ab0GNQJt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 12:09:49 -0400
Received: from mail.candelatech.com ([208.74.158.172]:45776 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751541Ab0GNQJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 12:09:48 -0400
Message-ID: <4C3DE148.9020509@candelatech.com>
Date: Wed, 14 Jul 2010 09:09:44 -0700
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: "Pan, Jacob jun" <jacob.jun.pan@intel.com>
CC: Robert Hancock <hancockrwd@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>
Subject: Re: Regression: 2.6.34 boot fails on E5405 system, bisected: 	de08e2c26
References: <4C3D067C.10507@candelatech.com>	<4C3D101E.5010605@candelatech.com>	<4C3D1942.1090207@gmail.com>	<4C3D1F82.1040907@candelatech.com> <AANLkTinDv7I4v51j-Lev9Ry_3DyVVv58lAyCQXZV1CwB@mail.gmail.com> <4C3DC64F.5040505@candelatech.com> <43F901BD926A4E43B106BF17856F0755EA8EE7E2@orsmsx508.amr.corp.intel.com>
In-Reply-To: <43F901BD926A4E43B106BF17856F0755EA8EE7E2@orsmsx508.amr.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/14/2010 08:36 AM, Pan, Jacob jun wrote:
> what is the config size of 10.1?
> ls -l /sys/bus/pci/devices/0000:00:10.1/config
>
> if that is 256, it might be related to this patch.
>
>> From e9b1d5d0ff4d3ae86050dc4c91b3147361c7af9e Mon Sep 17 00:00:00 2001
> From: H. Peter Anvin<hpa@linux.intel.com>
> Date: Fri, 14 May 2010 13:55:57 -0700
> Subject: [PATCH] x86, mrst: Don't blindly access extended config space
>
> Do not blindly access extended configuration space unless we actively
> know we're on a Moorestown platform.  The fixed-size BAR capability
> lives in the extended configuration space, and thus is not applicable
> if the configuration space isn't appropriately sized.
>
> This fixes booting certain VMware configurations with CONFIG_MRST=y.
>
> Moorestown will add a fake PCI-X 266 capability to advertise the
> presence of extended configuration space.

I'll try this in a bit, but shouldn't we also check for no-progress in
that while loop and bail out in that case?  No reason to hang on
boot just because the bios or whatever is busted?

Thanks,
Ben

>
> Reported-and-tested-by: Petr Vandrovec<petr@vandrovec.name>
> Signed-off-by: H. Peter Anvin<hpa@linux.intel.com>
> Acked-by: Jacob Pan<jacob.jun.pan@intel.com>
> Acked-by: Jesse Barnes<jbarnes@virtuousgeek.org>
> LKML-Reference:<AANLkTiltKUa3TrKR1M51eGw8FLNoQJSLT0k0_K5X3-OJ@mail.gmail.com>
> ---
>   arch/x86/pci/mrst.c |    4 ++++
>   1 files changed, 4 insertions(+), 0 deletions(-)
>
> diff --git a/arch/x86/pci/mrst.c b/arch/x86/pci/mrst.c
> index 8bf2fcb..1cdc02c 100644
> --- a/arch/x86/pci/mrst.c
> +++ b/arch/x86/pci/mrst.c
> @@ -247,6 +247,10 @@ static void __devinit pci_fixed_bar_fixup(struct pci_dev *dev)
>   	u32 size;
>   	int i;
>
> +	/* Must have extended configuration space */
> +	if (dev->cfg_size<  PCIE_CAP_OFFSET + 4)
> +		return;
> +
>   	/* Fixup the BAR sizes for fixed BAR devices and make them unmoveable */
>   	offset = fixed_bar_cap(dev->bus, dev->devfn);
>   	if (!offset || PCI_DEVFN(2, 0) == dev->devfn ||


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
