Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756832Ab0DAPho (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 11:37:44 -0400
Received: from darkcity.gna.ch ([195.226.6.51]:49218 "EHLO mail.gna.ch"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754705Ab0DAPhi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 11:37:38 -0400
Subject: Re: AGP force use of scratch page
From: Michel =?ISO-8859-1?Q?D=E4nzer?= <michel@daenzer.net>
To: Jerome Glisse <glisse@freedesktop.org>
Cc: airlied@gmail.com, linux-kernel@vger.kernel.org, dri-devel@lists.sf.net
In-Reply-To: <20100401145442.GE2715@barney.localdomain>
References: <20100401145442.GE2715@barney.localdomain>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 01 Apr 2010 17:37:31 +0200
Message-ID: <1270136251.25578.9.camel@thor.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.29.92.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-04-01 at 16:54 +0200, Jerome Glisse wrote: 
> 
> From: Jerome Glisse <jglisse@redhat.com>
> Date: Thu, 1 Apr 2010 16:46:15 +0200
> Subject: [PATCH] agp: force use of scratch page
> 
> It seems that some AGP hardware can induce activity on bus
> after reporting being idle with the memory (preteching maybe).
> As new infrastructure for GPU is dynamicly binding/unbinding
> memory this result in hardware possibly trying to access invalid
> memory to avoid this situation the patch for the use of the
> scratch page mecanism for all the AGP driver. It remove the
> needs_scratch_page flags and fix the insert_memory/remove_memory
> to deal properly with scratch_page.
> 
> Been tested on intel & sis agp bridges.
> 
> Signed-off-by: Jerome Glisse <jglisse@redhat.com>

Please don't attach patches but use git send-email or so for easier review.


> diff --git a/drivers/char/agp/backend.c b/drivers/char/agp/backend.c
> index c3ab46d..fed5e46 100644
> --- a/drivers/char/agp/backend.c
> +++ b/drivers/char/agp/backend.c
> @@ -136,35 +136,32 @@ static int agp_find_max(void)
>  static int agp_backend_initialize(struct agp_bridge_data *bridge)
>  {
>  	int size_value, rc, got_gatt=0, got_keylist=0;
> +	struct page *page;
> +	void *va;
>  
>  	bridge->max_memory_agp = agp_find_max();
>  	bridge->version = &agp_current_version;
>  
> -	if (bridge->driver->needs_scratch_page) {
> -		struct page *page = bridge->driver->agp_alloc_page(bridge);
> -
> -		if (!page) {
> -			dev_err(&bridge->dev->dev,
> +	page = bridge->driver->agp_alloc_page(bridge);
> +	if (!page) {
> +		dev_err(&bridge->dev->dev,
>  				"can't get memory for scratch page\n");
> -			return -ENOMEM;
> -		}
> -
> -		bridge->scratch_page_page = page;
> -		if (bridge->driver->agp_map_page) {
> -			if (bridge->driver->agp_map_page(page,
> -							 &bridge->scratch_page_dma)) {
> -				dev_err(&bridge->dev->dev,
> +		return -ENOMEM;
> +	}
> +	bridge->scratch_page_page = page;
> +	if (bridge->driver->agp_map_page) {
> +		if (bridge->driver->agp_map_page(page,
> +					&bridge->scratch_page_dma)) {
> +			dev_err(&bridge->dev->dev,
>  					"unable to dma-map scratch page\n");
> -				rc = -ENOMEM;
> -				goto err_out_nounmap;
> -			}
> -		} else {
> -			bridge->scratch_page_dma = page_to_phys(page);
> +			rc = -ENOMEM;
> +			goto err_out_nounmap;
>  		}
> -
> -		bridge->scratch_page = bridge->driver->mask_memory(bridge,
> -						   bridge->scratch_page_dma, 0);
> +	} else {
> +		bridge->scratch_page_dma = page_to_phys(page);
>  	}
> +	bridge->scratch_page = bridge->driver->mask_memory(bridge,
> +			bridge->scratch_page_dma, 0);
>  
>  	size_value = bridge->driver->fetch_size();
>  	if (size_value == 0) {
> @@ -203,18 +200,15 @@ static int agp_backend_initialize(struct agp_bridge_data *bridge)
>  	return 0;
>  
>  err_out:
> -	if (bridge->driver->needs_scratch_page &&
> -	    bridge->driver->agp_unmap_page) {
> +	if (bridge->driver->agp_unmap_page) {
>  		bridge->driver->agp_unmap_page(bridge->scratch_page_page,
>  					       bridge->scratch_page_dma);
>  	}
>  err_out_nounmap:
> -	if (bridge->driver->needs_scratch_page) {
> -		void *va = page_address(bridge->scratch_page_page);
> +	va = page_address(bridge->scratch_page_page);
> +	bridge->driver->agp_destroy_page(va, AGP_PAGE_DESTROY_UNMAP);
> +	bridge->driver->agp_destroy_page(va, AGP_PAGE_DESTROY_FREE);
>  
> -		bridge->driver->agp_destroy_page(va, AGP_PAGE_DESTROY_UNMAP);
> -		bridge->driver->agp_destroy_page(va, AGP_PAGE_DESTROY_FREE);
> -	}
>  	if (got_gatt)
>  		bridge->driver->free_gatt_table(bridge);
>  	if (got_keylist) {
> @@ -227,6 +221,8 @@ err_out_nounmap:
>  /* cannot be __exit b/c as it could be called from __init code */
>  static void agp_backend_cleanup(struct agp_bridge_data *bridge)
>  {
> +	void *va;
> +
>  	if (bridge->driver->cleanup)
>  		bridge->driver->cleanup();
>  	if (bridge->driver->free_gatt_table)
> @@ -235,9 +231,8 @@ static void agp_backend_cleanup(struct agp_bridge_data *bridge)
>  	vfree(bridge->key_list);
>  	bridge->key_list = NULL;
>  
> -	if (bridge->driver->agp_destroy_page &&
> -	    bridge->driver->needs_scratch_page) {
> -		void *va = page_address(bridge->scratch_page_page);
> +	if (bridge->driver->agp_destroy_page) {
> +		va = page_address(bridge->scratch_page_page);
>  
>  		if (bridge->driver->agp_unmap_page)
>  			bridge->driver->agp_unmap_page(bridge->scratch_page_page,

AFAICT this just removes the needs_scratch_page flag but doesn't bind
all table entries to the scratch page. Am I missing something? 


> diff --git a/drivers/char/agp/uninorth-agp.c b/drivers/char/agp/uninorth-agp.c
> index d89da4a..d54d674 100644
> --- a/drivers/char/agp/uninorth-agp.c
> +++ b/drivers/char/agp/uninorth-agp.c
> @@ -171,7 +171,7 @@ static int uninorth_insert_memory(struct agp_memory *mem, off_t pg_start, int ty
>  
>  	gp = (u32 *) &agp_bridge->gatt_table[pg_start];
>  	for (i = 0; i < mem->page_count; ++i) {
> -		if (gp[i]) {
> +		if (!PGE_EMPTY(agp_bridge, gp[i])) {
>  			dev_info(&agp_bridge->dev->dev,
>  				 "uninorth_insert_memory: entry 0x%x occupied (%x)\n",
>  				 i, gp[i]);
> 

This won't work for pre-U3 bridges, as bound table entries are marked by
setting bit 0. (Maybe the driver just shouldn't use
agp_generic_mask_memory?) 


-- 
Earthling Michel Dänzer           |                http://www.vmware.com
Libre software enthusiast         |          Debian, X and DRI developer
