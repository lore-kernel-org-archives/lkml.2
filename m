Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932067Ab2KEKVP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 05:21:15 -0500
Received: from vsp-authed02.binero.net ([195.74.38.226]:60818 "HELO
	vsp-authed-02-02.binero.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752625Ab2KEKVL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 05:21:11 -0500
Message-ID: <50979310.9010902@gaisler.com>
Date: Mon, 05 Nov 2012 11:21:04 +0100
From: Andreas Larsson <andreas@gaisler.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Grant Likely <grant.likely@secretlab.ca>, davem@davemloft.net,
        Rob Herring <rob.herring@calxeda.com>, sparclinux@vger.kernel.org,
        software@gaisler.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] of/address: sparc: Declare of_address_to_resource() as
 an extern function for sparc again
References: <1351854236-14230-1-git-send-email-andreas@gaisler.com> <20121102175321.GA6720@merkur.ravnborg.org>
In-Reply-To: <20121102175321.GA6720@merkur.ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-11-02 18:53, Sam Ravnborg wrote:
> Hi Andreas.
> On Fri, Nov 02, 2012 at 12:03:56PM +0100, Andreas Larsson wrote:
>> This bug-fix makes sure that of_address_to_resource is defined extern for sparc
>> so that the sparc-specific implementation of of_address_to_resource() is once
>> again used when including include/linux/of_address.h in a sparc context. A
>> number of drivers in mainline relies on this function working for sparc.
>
> How about following (untested) approach.
> diff --git a/arch/sparc/include/asm/prom.h b/arch/sparc/include/asm/prom.h
> index c287651..8194801 100644
> --- a/arch/sparc/include/asm/prom.h
> +++ b/arch/sparc/include/asm/prom.h
> @@ -63,5 +63,8 @@ extern char *of_console_options;
>   extern void irq_trans_init(struct device_node *dp);
>   extern char *build_path_component(struct device_node *dp);
>
> +/* SPARC has a local implementation */
> +#define of_address_to_resource of_address_to_resource
> +
>   #endif /* __KERNEL__ */
>   #endif /* _SPARC_PROM_H */
> diff --git a/include/linux/of_address.h b/include/linux/of_address.h
> index a1984dd..e20e3af 100644
> --- a/include/linux/of_address.h
> +++ b/include/linux/of_address.h
> @@ -28,11 +28,13 @@ static inline unsigned long pci_address_to_pio(phys_addr_t addr) { return -1; }
>   #endif
>
>   #else /* CONFIG_OF_ADDRESS */
> +#ifndef of_address_to_resource
>   static inline int of_address_to_resource(struct device_node *dev, int index,
>   					 struct resource *r)
>   {
>   	return -EINVAL;
>   }
> +#endif
>   static inline struct device_node *of_find_matching_node_by_address(
>   					struct device_node *from,
>   					const struct of_device_id *matches,
>
> We use prom.h to teach the general of layer what SPARC provides.
> In prom.h we define the symbol of_address_to_resource which tell
> of_address.h that we have a local definition of this function, and
> the static version is skipped.
>
> This looks more elegant as we do not have to hardcode SPARC in of_address.h
> and this is easy to re-use the sme pattern in other places.

I agree that this is a much nicer approach! I'll send a v2 based on this.

Thanks for the feedback!

Cheers,
Andreas

