Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756771Ab1HVKJc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 06:09:32 -0400
Received: from mx01.sz.bfs.de ([194.94.69.103]:28839 "EHLO mx01.sz.bfs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753084Ab1HVKJY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 06:09:24 -0400
Message-ID: <4E522AD0.7030907@bfs.de>
Date: Mon, 22 Aug 2011 12:09:20 +0200
From: walter harms <wharms@bfs.de>
Reply-To: wharms@bfs.de
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; de; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Julia Lawall <julia@diku.dk>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        kernel-janitors@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH 2/2] arch/powerpc/platforms/powermac/setup.c: add missing
 of_node_put
References: <1313943001-12884-2-git-send-email-julia@diku.dk>
In-Reply-To: <1313943001-12884-2-git-send-email-julia@diku.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Am 21.08.2011 18:10, schrieb Julia Lawall:
> From: Julia Lawall <julia@diku.dk>
> 
> np is initialized to the result of calling a function that calls
> of_node_get, so of_node_put should be called before the pointer is dropped.
> 
> The semantic match that finds this problem is as follows:
> (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @@
> expression e,e1,e2;
> @@
> 
> * e = \(of_find_node_by_type\|of_find_node_by_name\)(...)
>   ... when != of_node_put(e)
>       when != true e == NULL
>       when != e2 = e
>   e = e1
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>
> 
> ---
>  arch/powerpc/platforms/powermac/setup.c |    8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/powerpc/platforms/powermac/setup.c b/arch/powerpc/platforms/powermac/setup.c
> index 96580b1..970ea1d 100644
> --- a/arch/powerpc/platforms/powermac/setup.c
> +++ b/arch/powerpc/platforms/powermac/setup.c
> @@ -494,11 +494,15 @@ static int __init pmac_declare_of_platform_devices(void)
>  		return -1;
>  
>  	np = of_find_node_by_name(NULL, "valkyrie");
> -	if (np)
> +	if (np) {
>  		of_platform_device_create(np, "valkyrie", NULL);
> +		of_node_put(np);
> +	}
>  	np = of_find_node_by_name(NULL, "platinum");
> -	if (np)
> +	if (np) {
>  		of_platform_device_create(np, "platinum", NULL);
> +		of_node_put(np);
> +	}
>          np = of_find_node_by_type(NULL, "smu");
>          if (np) {
>  		of_platform_device_create(np, "smu", NULL);
> 


hi,
it seems save to call of_node_put(np) with np==NULL, i assume the same is true
for of_platform_device_create().

so the code collapses to:

_test_node(char *name)
{
 struct device_node *np;
 np = of_find_node_by_name(NULL, name);
 of_platform_device_create(np, name, NULL);
 of_node_put(np);
 return NULL?:0:1;
}

maybe there is already something like find_node() ?

re,
 wh




