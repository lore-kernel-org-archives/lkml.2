Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752986Ab1BVXZq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 18:25:46 -0500
Received: from oproxy2-pub.bluehost.com ([67.222.39.60]:50338 "HELO
	oproxy2-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751547Ab1BVXZp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 18:25:45 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=Zt0KDtdLCC9+A3HQ4vM+pl8qMkllYNRdk8rRyXNH5jarFms7X8Is/JrV3ZmSC+/UhXp7zKSdvyolA8dFvAiCb/9xocBdyPQpwaLEdcN3lC+XffJ+kmH79sDAzMNd27KU;
Date: Tue, 22 Feb 2011 15:25:40 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Jan Beulich" <JBeulich@novell.com>
Cc: "Mauro Carvalho Chehab" <mchehab@redhat.com>, <mingo@elte.hu>,
        <tglx@linutronix.de>, <arozansk@redhat.com>,
        "Michal Marek" <mmarek@suse.cz>, <linux-kernel@vger.kernel.org>,
        <hpa@zytor.com>
Subject: Re: [PATCH, resend] x86/PCI: don't export a __devinit function
Message-ID: <20110222152540.5023e9f1@jbarnes-desktop>
In-Reply-To: <4D5E45FB0200007800032A45@vpn.id2.novell.com>
References: <4D5D562A0200007800032744@vpn.id2.novell.com>
	<4D5D6517.5060600@redhat.com>
	<4D5E45FB0200007800032A45@vpn.id2.novell.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.174.193.198 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Feb 2011 09:12:11 +0000
"Jan Beulich" <JBeulich@novell.com> wrote:

> Like this:
> 
> --- a/arch/x86/pci/mmconfig-shared.c
> +++ b/arch/x86/pci/mmconfig-shared.c
> @@ -606,6 +606,16 @@ static void __init __pci_mmcfg_init(int 
>  	if (list_empty(&pci_mmcfg_list))
>  		return;
>  
> +	if (pcibios_last_bus < 0) {
> +		const struct pci_mmcfg_region *cfg;
> +
> +		list_for_each_entry(cfg, &pci_mmcfg_list, list) {
> +			if (cfg->segment)
> +				break;
> +			pcibios_last_bus = cfg->end_bus;
> +		}
> +	}
> +
>  	if (pci_mmcfg_arch_init())
>  		pci_probe = (pci_probe & ~PCI_PROBE_MASK) | PCI_PROBE_MMCONF;
>  	else {
> 
> I (unsuccessfully so far) tried to find someone at Intel who could
> confirm that this approach is usable namely on those Xeon 55xx
> systems that the edac driver tries to deal with, which is why I
> didn't submit this so far.

What's the actual user of pcibios_last_bus we're concerned about here?
Presumably pcibios_fixup_peer_bridges(), since that's the only place
that might be affected by a positive value...

So in that sense, the above seems like a good fix; we should initialize
pcibios_last_bus to a reasonable value based on the configuration we
discover in the MCFG table.

-- 
Jesse Barnes, Intel Open Source Technology Center
