Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756775Ab0GPRnL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 13:43:11 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:34806 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756269Ab0GPRnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 13:43:09 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Ben Greear <greearb@candelatech.com>
Subject: Re: [pci] pci/mrst:  Detect loops when reading fixed BAR cap.
Date: Fri, 16 Jul 2010 11:43:04 -0600
User-Agent: KMail/1.13.2 (Linux/2.6.32-23-generic; KDE/4.4.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <1279126923-27926-1-git-send-email-greearb@candelatech.com>
In-Reply-To: <1279126923-27926-1-git-send-email-greearb@candelatech.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201007161143.05187.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, July 14, 2010 11:02:03 am Ben Greear wrote:
> The mrst logic introduced in 2.6.33-rc8 in commit
> a712ffbc199849364c46e9112b93b66de08e2c26 causes boot
> to hang on at least this platform:
> 
> Intel E5405 CPU
> System Information
> 	Manufacturer: Supermicro
> 	Product Name: X7DBU
> 
> The cause of the hang is that pci_cap points to itself
> as the next capability, putting the fixed_bar_cap into
> an endless loop.
> 
> This patch detects the loop, prints a warning, and
> continues on with useful work.  This strategy was
> suggested by Robert Hancock <hancockrwd@gmail.com>
> 
> This should be a candidate for 2.6.34.y as well.
> 
> Signed-off-by: Ben Greear <greearb@candelatech.com>
> ---
> :100644 100644 1cdc02c... 9535ba9... M	arch/x86/pci/mrst.c
>  arch/x86/pci/mrst.c |   11 +++++++++++
>  1 files changed, 11 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/pci/mrst.c b/arch/x86/pci/mrst.c
> index 1cdc02c..9535ba9 100644
> --- a/arch/x86/pci/mrst.c
> +++ b/arch/x86/pci/mrst.c
> @@ -76,6 +76,17 @@ static int fixed_bar_cap(struct pci_bus *bus, unsigned int devfn)
>  				return pos;
>  		}
>  
> +		if ((pcie_cap >> 20) == 0)
> +			break;
> +		
> +		if ((pcie_cap >> 20) <= pos) {
> +			printk(KERN_WARNING "WARNING: mrst:  detected loop"
> +			       " when searching for fixed BAR cap, previous"
> +			       " position: 0x%x new position: 0x%x"
> +			       " bus-number: %i  devfn: %i\n",
> +			       pos, pcie_cap >> 20, bus->number, devfn);

Can you use dev_warn() here to print the device info in the
standard way?

Bjorn
