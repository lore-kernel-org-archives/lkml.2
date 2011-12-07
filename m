Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756998Ab1LGR6G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 12:58:06 -0500
Received: from oproxy9.bluehost.com ([69.89.24.6]:37961 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756863Ab1LGR6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 12:58:04 -0500
Message-ID: <4EDFB712.1000508@xenotime.net>
Date: Wed, 07 Dec 2011 10:57:22 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Mark Einon <mark.einon@gmail.com>
CC: linux-next@vger.kernel.org, romieu@fr.zoreil.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] linux-next:et131x: Revert changes from previous commit
References: <1323213790-22039-1-git-send-email-mark.einon@gmail.com>
In-Reply-To: <1323213790-22039-1-git-send-email-mark.einon@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/06/2011 03:23 PM, Mark Einon wrote:
> In commit 834d0ee317b (uintxy_t removal) not all changes were trival text replacements, some converted u64 -> dma_addr_t.
> In some configurations dma_addr_t is a u32, meaning that some bit operations cause build warnings. From Randy Dunlap:
> 
> ----------------
> on i386 (X86_32) builds:
> 
> drivers/staging/et131x/et131x.c:2483:8: warning: right shift count >= width of type
> drivers/staging/et131x/et131x.c:2531:8: warning: right shift count >= width of type
> ----------------
> 
> Removed these by reverting dma_addr_t back to u64 types, as well as reverting some other non-trivial changes from the aforementioned commit.
> 
> Reported-by: Randy Dunlap <rdunlap@xenotime.net>
> Signed-off-by: Mark Einon <mark.einon@gmail.com>

Acked-by: Randy Dunlap <rdunlap@xenotime.net>

Thanks.

> ---
>  drivers/staging/et131x/et131x.c |   28 +++++++++++++---------------
>  1 files changed, 13 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/staging/et131x/et131x.c b/drivers/staging/et131x/et131x.c
> index 7ae3e53..2c4069f 100644
> --- a/drivers/staging/et131x/et131x.c
> +++ b/drivers/staging/et131x/et131x.c
> @@ -299,8 +299,8 @@ struct fbr_lookup {
>  	dma_addr_t	 ring_physaddr;
>  	void		*mem_virtaddrs[MAX_DESC_PER_RING_RX / FBR_CHUNKS];
>  	dma_addr_t	 mem_physaddrs[MAX_DESC_PER_RING_RX / FBR_CHUNKS];
> -	dma_addr_t	 real_physaddr;
> -	u32		 offset;
> +	u64		 real_physaddr;
> +	u64		 offset;
>  	u32		 local_full;
>  	u32		 num_entries;
>  	u32		 buffsize;
> @@ -1902,10 +1902,9 @@ static void et131x_config_rx_dma_regs(struct et131x_adapter *adapter)
>  	/* Set the address and parameters of Free buffer ring 1 (and 0 if
>  	 * required) into the 1310's registers
>  	 */
> -	writel(((u64) rx_local->fbr[0]->real_physaddr) >> 32,
> +	writel((u32) (rx_local->fbr[0]->real_physaddr >> 32),
>  	       &rx_dma->fbr1_base_hi);
> -	writel(((u64) rx_local->fbr[0]->real_physaddr) & DMA_BIT_MASK(32),
> -	       &rx_dma->fbr1_base_lo);
> +	writel((u32) rx_local->fbr[0]->real_physaddr, &rx_dma->fbr1_base_lo);
>  	writel(rx_local->fbr[0]->num_entries - 1, &rx_dma->fbr1_num_des);
>  	writel(ET_DMA10_WRAP, &rx_dma->fbr1_full_offset);
>  
> @@ -1927,10 +1926,9 @@ static void et131x_config_rx_dma_regs(struct et131x_adapter *adapter)
>  		fbr_entry++;
>  	}
>  
> -	writel(((u64) rx_local->fbr[1]->real_physaddr) >> 32,
> +	writel((u32) (rx_local->fbr[1]->real_physaddr >> 32),
>  	       &rx_dma->fbr0_base_hi);
> -	writel(((u64) rx_local->fbr[1]->real_physaddr) & DMA_BIT_MASK(32),
> -	       &rx_dma->fbr0_base_lo);
> +	writel((u32) rx_local->fbr[1]->real_physaddr, &rx_dma->fbr0_base_lo);
>  	writel(rx_local->fbr[1]->num_entries - 1, &rx_dma->fbr0_num_des);
>  	writel(ET_DMA10_WRAP, &rx_dma->fbr0_full_offset);
>  
> @@ -2275,10 +2273,10 @@ static inline u32 bump_free_buff_ring(u32 *free_buff_ring, u32 limit)
>   * @mask: correct mask
>   */
>  static void et131x_align_allocated_memory(struct et131x_adapter *adapter,
> -					  dma_addr_t *phys_addr, u32 *offset,
> -					  u32 mask)
> +					  u64 *phys_addr, u64 *offset,
> +					  u64 mask)
>  {
> -	dma_addr_t new_addr = *phys_addr & ~mask;
> +	u64 new_addr = *phys_addr & ~mask;
>  
>  	*offset = 0;
>  
> @@ -2430,8 +2428,8 @@ static int et131x_rx_dma_memory_alloc(struct et131x_adapter *adapter)
>  			rx_ring->fbr[1]->offset);
>  #endif
>  	for (i = 0; i < (rx_ring->fbr[0]->num_entries / FBR_CHUNKS); i++) {
> -		dma_addr_t fbr1_tmp_physaddr;
> -		u32 fbr1_offset;
> +		u64 fbr1_tmp_physaddr;
> +		u64 fbr1_offset;
>  		u32 fbr1_align;
>  
>  		/* This code allocates an area of memory big enough for N
> @@ -2496,8 +2494,8 @@ static int et131x_rx_dma_memory_alloc(struct et131x_adapter *adapter)
>  #ifdef USE_FBR0
>  	/* Same for FBR0 (if in use) */
>  	for (i = 0; i < (rx_ring->fbr[1]->num_entries / FBR_CHUNKS); i++) {
> -		dma_addr_t fbr0_tmp_physaddr;
> -		u32 fbr0_offset;
> +		u64 fbr0_tmp_physaddr;
> +		u64 fbr0_offset;
>  
>  		fbr_chunksize =
>  		    ((FBR_CHUNKS + 1) * rx_ring->fbr[1]->buffsize) - 1;


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
