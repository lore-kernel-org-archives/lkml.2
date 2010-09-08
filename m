Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752782Ab0IHRp5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 13:45:57 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:53393 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752080Ab0IHRpu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 13:45:50 -0400
Date: Wed, 8 Sep 2010 11:45:47 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Julia Lawall <julia@diku.dk>
Cc: kernel-janitors@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH] arch/powerpc/platforms/52xx/efika.c: Add of_node_put
 to avoid memory leak
Message-ID: <20100908174547.GN3686@angua.secretlab.ca>
References: <1283584397-7697-1-git-send-email-julia@diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1283584397-7697-1-git-send-email-julia@diku.dk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 04, 2010 at 09:13:17AM +0200, Julia Lawall wrote:
> This function is implemented as though the function of_get_next_child does
> not increment the reference count of its result, but actually it does.
> Thus the patch adds of_node_put in error handling code and drops a call to
> of_node_get.

applied, thanks.

g.

> 
> The semantic match that finds this problem is as follows:
> (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @r exists@
> local idexpression x;
> expression E1;
> position p1,p2;
> @@
> 
> x@p1 = of_get_next_child(...);
> ... when != x = E1
> of_node_get@p2(x)
> 
> @script:python@
> p1 << r.p1;
> p2 << r.p2;
> @@
> 
> cocci.print_main("call",p1)
> cocci.print_secs("get",p2)
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>
> 
> ---
>  arch/powerpc/platforms/52xx/efika.c |    9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/powerpc/platforms/52xx/efika.c b/arch/powerpc/platforms/52xx/efika.c
> index 45c0cb9..18c1048 100644
> --- a/arch/powerpc/platforms/52xx/efika.c
> +++ b/arch/powerpc/platforms/52xx/efika.c
> @@ -99,7 +99,7 @@ static void __init efika_pcisetup(void)
>  	if (bus_range == NULL || len < 2 * sizeof(int)) {
>  		printk(KERN_WARNING EFIKA_PLATFORM_NAME
>  		       ": Can't get bus-range for %s\n", pcictrl->full_name);
> -		return;
> +		goto out_put;
>  	}
>  
>  	if (bus_range[1] == bus_range[0])
> @@ -111,12 +111,12 @@ static void __init efika_pcisetup(void)
>  	printk(" controlled by %s\n", pcictrl->full_name);
>  	printk("\n");
>  
> -	hose = pcibios_alloc_controller(of_node_get(pcictrl));
> +	hose = pcibios_alloc_controller(pcictrl);
>  	if (!hose) {
>  		printk(KERN_WARNING EFIKA_PLATFORM_NAME
>  		       ": Can't allocate PCI controller structure for %s\n",
>  		       pcictrl->full_name);
> -		return;
> +		goto out_put;
>  	}
>  
>  	hose->first_busno = bus_range[0];
> @@ -124,6 +124,9 @@ static void __init efika_pcisetup(void)
>  	hose->ops = &rtas_pci_ops;
>  
>  	pci_process_bridge_OF_ranges(hose, pcictrl, 0);
> +	return;
> +out_put:
> +	of_node_put(pcictrl);
>  }
>  
>  #else
> 
