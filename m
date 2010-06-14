Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754666Ab0FNOSm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 10:18:42 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:20301 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754168Ab0FNOSk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 10:18:40 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Yinghai Lu <yinghai.lu@oracle.com>
Subject: Re: [Bug 16007] x86/pci Oops with CONFIG_SND_HDA_INTEL
Date: Mon, 14 Jun 2010 08:18:39 -0600
User-Agent: KMail/1.13.2 (Linux/2.6.32-22-generic; KDE/4.4.2; i686; ; )
Cc: Graham Ramsey <ramsey.graham@ntlworld.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, bugzilla-daemon@bugzilla.kernel.org,
       Myron Stowe <myron.stowe@hp.com>,
       Robert Richter <robert.richter@amd.com>,
       Harald Welte <HaraldWelte@viatech.com>,
       Joseph Chan <JosephChan@via.com.tw>
References: <4BF40014.30303@ntlworld.com> <201006111549.05164.bjorn.helgaas@hp.com> <4C12C189.50201@oracle.com>
In-Reply-To: <4C12C189.50201@oracle.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006140818.39599.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, June 11, 2010 05:06:49 pm Yinghai Lu wrote:
> 
> please check if this one workaround the problem
> 
> Thanks
> 
> Yinghai Lu
> 
> [PATCH] x86, pci: handle fallout pci devices with peer root bus
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>

This patch apparently does cover up the problem, but it fails on
so many levels:

  - incomprehensible summary
  - no changelog
  - no bugzilla pointer
  - unrelated junk in patch ("tmp")
  - completely unexplained change to generic resource.c
  - no indication that we understand the root cause

> ---
>  arch/x86/pci/bus_numa.c |    4 +++-
>  kernel/resource.c       |    2 +-
>  2 files changed, 4 insertions(+), 2 deletions(-)
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
> @@ -37,6 +38,7 @@ void x86_pci_root_bus_res_quirks(struct
>  	for (j = 0; j < info->res_num; j++) {
>  		struct resource *res;
>  		struct resource *root;
> +		struct resource *tmp;
>  
>  		res = &info->res[j];
>  		pci_bus_add_resource(b, res, 0);
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
