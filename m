Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756511Ab1G2NDA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 09:03:00 -0400
Received: from mga02.intel.com ([134.134.136.20]:47689 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755804Ab1G2NC7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 09:02:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,287,1309762800"; 
   d="scan'208";a="33524418"
Subject: Re: [PATCH 10/18] dmaengine/amba-pl08x: Get rid of
 pl08x_pre_boundary()
From: "Koul, Vinod" <vinod.koul@intel.com>
To: Viresh Kumar <viresh.kumar@st.com>
Cc: linus.walleij@linaro.org, pratyush.anand@st.com, rajeev-dlh.kumar@st.com,
        linux@arm.linux.org.uk, bhupesh.sharma@st.com, shiraz.hashim@st.com,
        linux-kernel@vger.kernel.org, vipin.kumar@st.com,
        armando.visconti@st.com, amit.virdi@st.com, vipulkumar.samar@st.com,
        viresh.linux@gmail.com, deepak.sikri@st.com, dan.j.williams@intel.com,
        linux-arm-kernel@lists.infradead.org
In-Reply-To: <c147ba3a755935e93fdb40b5531a6e18d34e0fd7.1311936524.git.viresh.kumar@st.com>
References: <cover.1311936523.git.viresh.kumar@st.com>
	 <c147ba3a755935e93fdb40b5531a6e18d34e0fd7.1311936524.git.viresh.kumar@st.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 29 Jul 2011 17:49:40 +0530
Message-ID: <1311941980.1536.534.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-07-29 at 16:19 +0530, Viresh Kumar wrote:
> Pl080 Manual says: "Bursts do not cross the 1KB address boundary"
> 
> We can program the controller to cross 1 KB boundary on a burst and controller
> can take care of this boundary condition by itself.
> 
> Following is the discussion with ARM Technical Support Guys (David):
> [Viresh] Manual says: "Bursts do not cross the 1KB address boundary"
> 
> What does that actually mean? As, Maximum size transferable with a single LLI is
> 4095 * 4 =16380 ~ 16KB. So, if we don't have src/dest address aligned to burst
> size, we can't use this big of an LLI.
> 
> [David] There is a difference between bursts describing the total data
> transferred by the DMA controller and AHB bursts. Bursts described by the
> programmable parameters in the PL080 have no direct connection with the bursts
> that are seen on the AHB bus.
> 
> The statement that "Bursts do not cross the 1KB address boundary" in the TRM is
> referring to AHB bursts, where this limitation is a requirement of the AHB spec.
> You can still issue bursts within the PL080 that are in excess o f 1KB. The
								^^^^^^
of

> PL080 will make sure that its bursts are broken down into legal AHB bursts which
> will be formatted to ensure that no AHB burst crosses a 1KB boundary.
> 
> Based on above discussion, this patch removes all code related to 1 KB boundary
> as we are not required to handle this in driver.
> 
> Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
> ---
>  drivers/dma/amba-pl08x.c   |  136 ++++---------------------------------------
>  include/linux/amba/pl08x.h |    2 -
>  2 files changed, 13 insertions(+), 125 deletions(-)
> 
> diff --git a/drivers/dma/amba-pl08x.c b/drivers/dma/amba-pl08x.c
> index b9137bc..04f7889 100644
> --- a/drivers/dma/amba-pl08x.c
> +++ b/drivers/dma/amba-pl08x.c
> @@ -149,14 +149,6 @@ struct pl08x_driver_data {
>   * PL08X specific defines
>   */
>  
> -/*
> - * Memory boundaries: the manual for PL08x says that the controller
> - * cannot read past a 1KiB boundary, so these defines are used to
> - * create transfer LLIs that do not cross such boundaries.
> - */
> -#define PL08X_BOUNDARY_SHIFT		(10)	/* 1KB 0x400 */
> -#define PL08X_BOUNDARY_SIZE		(1 << PL08X_BOUNDARY_SHIFT)
> -
>  /* Size (bytes) of each LLI buffer allocated for one transfer */
>  # define PL08X_LLI_TSFR_SIZE	0x2000
>  
> @@ -561,18 +553,6 @@ static void pl08x_fill_lli_for_desc(struct pl08x_lli_build_data *bd,
>  }
>  
>  /*
> - * Return number of bytes to fill to boundary, or len.
> - * This calculation works for any value of addr.
> - */
> -static inline size_t pl08x_pre_boundary(u32 addr, size_t len)
> -{
> -	size_t boundary_len = PL08X_BOUNDARY_SIZE -
> -			(addr & (PL08X_BOUNDARY_SIZE - 1));
> -
> -	return min(boundary_len, len);
> -}
> -
> -/*
>   * This fills in the table of LLIs for the transfer descriptor
>   * Note that we assume we never have to change the burst sizes
>   * Return 0 for error
> @@ -679,121 +659,30 @@ static int pl08x_fill_llis_for_desc(struct pl08x_driver_data *pl08x,
>  		 * width left
>  		 */
>  		while (bd.remainder > (mbus->buswidth - 1)) {
> -			size_t lli_len, target_len, tsize, odd_bytes;
> +			size_t lli_len, tsize;
>  
>  			/*
>  			 * If enough left try to send max possible,
>  			 * otherwise try to send the remainder
>  			 */
> -			target_len = min(bd.remainder, max_bytes_per_lli);
> -
> +			lli_len = min(bd.remainder, max_bytes_per_lli);
>  			/*
> -			 * Set bus lengths for incrementing buses to the
> -			 * number of bytes which fill to next memory boundary,
> -			 * limiting on the target length calculated above.
> +			 * Check against minimum bus alignment: Calculate actual
> +			 * transfer size in relation to bus width and get a
> +			 * maximum remainder of the smallest bus width - 1
>  			 */
> -			if (cctl & PL080_CONTROL_SRC_INCR)
> -				bd.srcbus.fill_bytes =
> -					pl08x_pre_boundary(bd.srcbus.addr,
> -						target_len);
> -			else
> -				bd.srcbus.fill_bytes = target_len;
> -
> -			if (cctl & PL080_CONTROL_DST_INCR)
> -				bd.dstbus.fill_bytes =
> -					pl08x_pre_boundary(bd.dstbus.addr,
> -						target_len);
> -			else
> -				bd.dstbus.fill_bytes = target_len;
> -
> -			/* Find the nearest */
> -			lli_len	= min(bd.srcbus.fill_bytes,
> -					bd.dstbus.fill_bytes);
> -
> -			BUG_ON(lli_len > bd.remainder);
> -
> -			if (lli_len <= 0) {
> -				dev_err(&pl08x->adev->dev,
> -					"%s lli_len is %zu, <= 0\n",
> -						__func__, lli_len);
> -				return 0;
> -			}
> +			tsize = lli_len / min(mbus->buswidth, sbus->buswidth);
> +			lli_len	= tsize * min(mbus->buswidth, sbus->buswidth);
>  
> -			if (lli_len == target_len) {
> -				/*
> -				 * Can send what we wanted.
> -				 * Maintain alignment
> -				 */
> -				lli_len	= (lli_len/mbus->buswidth) *
> -							mbus->buswidth;
> -				odd_bytes = 0;
> -			} else {
> -				/*
> -				 * So now we know how many bytes to transfer
> -				 * to get to the nearest boundary. The next
> -				 * LLI will past the boundary. However, we
> -				 * may be working to a boundary on the slave
> -				 * bus. We need to ensure the master stays
> -				 * aligned, and that we are working in
> -				 * multiples of the bus widths.
> -				 */
> -				odd_bytes = lli_len % mbus->buswidth;
> -				lli_len -= odd_bytes;
> -			}
> -
> -			if (lli_len) {
> -				/*
> -				 * Check against minimum bus alignment:
> -				 * Calculate actual transfer size in relation
> -				 * to bus width an get a maximum remainder of
> -				 * the smallest bus width - 1
> -				 */
> -				/* FIXME: use round_down()? */
> -				tsize = lli_len / min(mbus->buswidth,
> -						sbus->buswidth);
> -				lli_len	= tsize * min(mbus->buswidth,
> -						sbus->buswidth);
> -
> -				if (target_len != lli_len) {
> -					dev_vdbg(&pl08x->adev->dev,
> -					"%s can't send what we want. Desired "
> -					"0x%08zx, lli of 0x%08zx bytes in txd "
> -					"of 0x%08zx\n", __func__, target_len,
> -					lli_len, txd->len);
> -				}
> -
> -				cctl = pl08x_cctl_bits(cctl,
> -						bd.srcbus.buswidth,
> -						bd.dstbus.buswidth,
> -						tsize);
> -
> -				dev_vdbg(&pl08x->adev->dev,
> +			dev_vdbg(&pl08x->adev->dev,
>  					"%s fill lli with single lli chunk of "
>  					"size 0x%08zx (remainder 0x%08zx)\n",
>  					__func__, lli_len, bd.remainder);
> -				pl08x_fill_lli_for_desc(&bd, num_llis++,
> -					lli_len, cctl);
> -				total_bytes += lli_len;
> -			}
>  
> -			if (odd_bytes) {
> -				/*
> -				 * Creep past the boundary, maintaining
> -				 * master alignment
> -				 */
> -				int j;
> -				for (j = 0; (j < mbus->buswidth)
> -						&& (bd.remainder); j++) {
> -					cctl = pl08x_cctl_bits(cctl, 1, 1, 1);
> -					dev_vdbg(&pl08x->adev->dev,
> -						"%s align with boundary, single"
> -						" byte (remain 0x%08zx)\n",
> -						__func__, bd.remainder);
> -					pl08x_fill_lli_for_desc(&bd,
> -						num_llis++, 1, cctl);
> -					total_bytes++;
> -				}
> -			}
> +			cctl = pl08x_cctl_bits(cctl, bd.srcbus.buswidth,
> +					bd.dstbus.buswidth, tsize);
> +			pl08x_fill_lli_for_desc(&bd, num_llis++, lli_len, cctl);
> +			total_bytes += lli_len;
>  		}
>  
>  		/*
> @@ -808,6 +697,7 @@ static int pl08x_fill_llis_for_desc(struct pl08x_driver_data *pl08x,
>  			total_bytes++;
>  		}
>  	}
> +
>  	if (total_bytes != txd->len) {
>  		dev_err(&pl08x->adev->dev,
>  			"%s size of encoded lli:s don't match total txd, "
> diff --git a/include/linux/amba/pl08x.h b/include/linux/amba/pl08x.h
> index 5509a50..98628a8 100644
> --- a/include/linux/amba/pl08x.h
> +++ b/include/linux/amba/pl08x.h
> @@ -77,13 +77,11 @@ struct pl08x_channel_data {
>   * @addr: current address
>   * @maxwidth: the maximum width of a transfer on this bus
>   * @buswidth: the width of this bus in bytes: 1, 2 or 4
> - * @fill_bytes: bytes required to fill to the next bus memory boundary
>   */
>  struct pl08x_bus_data {
>  	dma_addr_t addr;
>  	u8 maxwidth;
>  	u8 buswidth;
> -	size_t fill_bytes;
>  };
>  
>  /**


-- 
~Vinod

