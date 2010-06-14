Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753377Ab0FNSeV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 14:34:21 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:11388 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752342Ab0FNSeT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 14:34:19 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Yinghai Lu <yinghai.lu@oracle.com>
Subject: Re: [PATCH -v2] x86, pci: Handle fallout pci devices with peer root bus
Date: Mon, 14 Jun 2010 12:34:17 -0600
User-Agent: KMail/1.13.2 (Linux/2.6.32-22-generic; KDE/4.4.2; i686; ; )
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Graham Ramsey <ramsey.graham@ntlworld.com>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       Robert Richter <robert.richter@amd.com>,
       Harald Welte <HaraldWelte@viatech.com>,
       Joseph Chan <JosephChan@via.com.tw>, Jiri Slaby <jslaby@suse.cz>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Dominik Brodowski <linux@dominikbrodowski.net>
References: <4BF40014.30303@ntlworld.com> <4C12C189.50201@oracle.com> <4C166B4F.90308@oracle.com>
In-Reply-To: <4C166B4F.90308@oracle.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006141234.17912.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, June 14, 2010 11:47:59 am Yinghai Lu wrote:
> 
> Graham bisected
> |    commit 3e3da00c01d050307e753fb7b3e84aefc16da0d0
> |    x86/pci: AMD one chain system to use pci read out res
> 
> cause the SND_HDA_INTEL doesn't work anymore.
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=16007
> 
> It turns out that his system with via chipset only have one hypertransport
> chain, but does have one extra orphan device 80:01.0
> 
>  PCI: Probing PCI hardware (bus 00)
>  PCI: Discovered primary peer bus 80 [IRQ]
> 
>  node 0 link 0: io port [1000, ffffff]
>  TOM: 0000000080000000 aka 2048M
>  node 0 link 0: mmio [e0000000, efffffff]
>  node 0 link 0: mmio [a0000, bffff]
>  node 0 link 0: mmio [80000000, ffffffff]
>  bus: [00, ff] on node 0 link 0
> 
> Try to make peer root buses to share same mmio/io resources if those peer root
> buses fall into the same bus range.

Yinghai, did you read https://bugzilla.kernel.org/show_bug.cgi?id=16007#c15 ?

I made the point there that an HT chain may contain multiple HT/PCI
host bridges, but you are stuck on the idea that "one HT chain == one
PCI root bus."

I have not found the "one PCI host bridge per HT chain" requirement
in the HT spec (if you find it, please point me to it).

If an HT chain may contain multiple HT/PCI host bridges, then it's
obvious that the HT host bridge registers read by amd_bus.c don't
contain enough information to correctly assign address space to the
PCI root buses.

> Also need to update insert_resource to avoid insert same resource two times.
> 
> We need this patch for 2.6.34 stable.

No, we don't!  Not yet, anyway.  We need to find the root cause of this
problem, not just paper over it and wait for it to pop up again somewhere
else.

> Reported-by: Graham Ramsey <ramsey.graham@ntlworld.com>
> Bisected-by: Graham Ramsey <ramsey.graham@ntlworld.com>
> Tested-by: Graham Ramsey <ramsey.graham@ntlworld.com>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> Cc: stable@kernel.org
> 
> ---
>  arch/x86/pci/bus_numa.c |    3 ++-
>  kernel/resource.c       |    2 +-
>  2 files changed, 3 insertions(+), 2 deletions(-)
> 
> Index: linux-2.6/arch/x86/pci/bus_numa.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/pci/bus_numa.c
> +++ linux-2.6/arch/x86/pci/bus_numa.c
> @@ -22,7 +22,8 @@ void x86_pci_root_bus_res_quirks(struct
>  		return;
>  
>  	for (i = 0; i < pci_root_num; i++) {
> -		if (pci_root_info[i].bus_min == b->number)
> +		if (pci_root_info[i].bus_min <= b->number &&
> +		    pci_root_info[i].bus_max >= b->number)
>  			break;
>  	}
>  
> Index: linux-2.6/kernel/resource.c
> ===================================================================
> --- linux-2.6.orig/kernel/resource.c
> +++ linux-2.6/kernel/resource.c
> @@ -451,7 +451,7 @@ static struct resource * __insert_resour
>  		if (!first)
>  			return first;
>  
> -		if (first == parent)
> +		if (first == parent || first == new)
>  			return first;
>  
>  		if ((first->start > new->start) || (first->end < new->end))
> 
