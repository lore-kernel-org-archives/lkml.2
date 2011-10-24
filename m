Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755850Ab1JXRoz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 13:44:55 -0400
Received: from ns2.gothnet.se ([82.193.160.251]:45859 "EHLO
	GOTHNET-SMTP2.gothnet.se" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751102Ab1JXRoy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 13:44:54 -0400
Message-ID: <4EA5A381.1050100@shipmail.org>
Date: Mon, 24 Oct 2011 19:42:25 +0200
From: Thomas Hellstrom <thomas@shipmail.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100624 Mandriva/3.0.5-0.1mdv2009.1 (2009.1) Thunderbird/3.0.5
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        thellstrom@vmware.com, airlied@redhat.com,
        xen-devel@lists.xensource.com, j.glisse@redhat.com, bskeggs@redhat.com
Subject: Re: [PATCH 06/11] ttm/driver: Expand ttm_backend_func to include
 two overrides for TTM page pool.
References: <1319062772-2793-1-git-send-email-konrad.wilk@oracle.com> <1319062772-2793-7-git-send-email-konrad.wilk@oracle.com> <4EA28FA6.7000006@shipmail.org> <20111024172728.GD2320@phenom.dumpdata.com>
In-Reply-To: <20111024172728.GD2320@phenom.dumpdata.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-BitDefender-Scanner: Mail not scanned due to license constraints
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/24/2011 07:27 PM, Konrad Rzeszutek Wilk wrote:
> On Sat, Oct 22, 2011 at 11:40:54AM +0200, Thomas Hellstrom wrote:
>    
>> Konrad,
>>
>> I was hoping that we could get rid of the dma_address shuffling into
>> core TTM,
>> like I mentioned in the review. From what I can tell it's now only
>> used in the backend and
>> core ttm doesn't care about it.
>>
>> Is there a particular reason we're still passing it around?
>>      
> Yes - and I should have addressed that in the writeup but forgot, sorry about that.
>
> So initially I thought you meant this:
>
> diff --git a/drivers/gpu/drm/ttm/ttm_page_alloc.c b/drivers/gpu/drm/ttm/ttm_page_alloc.c
> index 360afb3..06ef048 100644
> --- a/drivers/gpu/drm/ttm/ttm_page_alloc.c
> +++ b/drivers/gpu/drm/ttm/ttm_page_alloc.c
> @@ -662,8 +662,7 @@ out:
>
>   /* Put all pages in pages list to correct pool to wait for reuse */
>   static void __ttm_put_pages(struct list_head *pages, unsigned page_count,
> -			    int flags, enum ttm_caching_state cstate,
> -			    dma_addr_t *dma_address)
> +			    int flags, enum ttm_caching_state cstate)
>   {
>   	unsigned long irq_flags;
>   	struct ttm_page_pool *pool = ttm_get_pool(flags, cstate);
> @@ -707,8 +706,7 @@ static void __ttm_put_pages(struct list_head *pages, unsigned page_count,
>    * cached pages.
>    */
>   static int __ttm_get_pages(struct list_head *pages, int flags,
> -			   enum ttm_caching_state cstate, unsigned count,
> -			   dma_addr_t *dma_address)
> +			   enum ttm_caching_state cstate, unsigned count)
>   {
>   	struct ttm_page_pool *pool = ttm_get_pool(flags, cstate);
>   	struct page *p = NULL;
> @@ -864,7 +862,7 @@ int ttm_get_pages(struct ttm_tt *ttm, struct list_head *pages,
>   	if (ttm->be&&  ttm->be->func&&  ttm->be->func->get_pages)
>   		return ttm->be->func->get_pages(ttm, pages, count, dma_address);
>   	return __ttm_get_pages(pages, ttm->page_flags, ttm->caching_state,
> -				count, dma_address);
> +				count)
>   }
>   void ttm_put_pages(struct ttm_tt *ttm, struct list_head *pages,
>   		   unsigned page_count, dma_addr_t *dma_address)
> @@ -873,5 +871,5 @@ void ttm_put_pages(struct ttm_tt *ttm, struct list_head *pages,
>   		ttm->be->func->put_pages(ttm, pages, page_count, dma_address);
>   	else
>   		__ttm_put_pages(pages, page_count, ttm->page_flags,
> -				ttm->caching_state, dma_address);
> +				ttm->caching_state)
>   }
> which is trivial (thought I have not compile tested it), but it should do it.
>
> But I think you mean eliminate the dma_address handling completly in
> ttm_page_alloc.c and ttm_tt.c.
>
> For that there are couple of architectural issues I am not sure how to solve.
>
> There has to be some form of TTM<->[Radeon|Nouveau] lookup mechanism
> to say: "here is a 'struct page *', give me the bus address". Currently
> this is solved by keeping an array of DMA addresses along with the list
> of pages. And passing the list and DMA address up the stack (and down)
> from TTM up to the driver (when ttm->be->func->populate is called and they
> are handed off) does it. It does not break any API layering .. and the internal
> TTM pool (non-DMA) can just ignore the dma_address altogether (see patch above).
>
>    

I actually had something more simple in mind, but when tinking a bit 
deeper into it, it seems more complicated than I initially thought.

Namely that when we allocate pages from the ttm_backend, we actually 
populated it at the same time. be::populate would then not take a page 
array as an argument, and would actually be a no-op on many
drivers.

This makes us move towards struct ttm_tt consisting almost only of its 
backend, so that whole API should perhaps be looked at with new eyes.

So anyway, I'm fine with high level things as they are now, and the 
dma_addr issue can be looked at at a later time. If we could get a 
couple of extra eyes to review the code for style etc. would be great, 
because I have very little time the next couple of weeks.

/Thomas











