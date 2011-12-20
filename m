Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753315Ab1LTKPb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 05:15:31 -0500
Received: from eu1sys200aog120.obsmtp.com ([207.126.144.149]:54378 "EHLO
	eu1sys200aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752047Ab1LTKP0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 05:15:26 -0500
Message-ID: <4EF0602C.4070001@st.com>
Date: Tue, 20 Dec 2011 15:45:08 +0530
From: Pratyush Anand <pratyush.anand@st.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Vinod Koul <vinod.koul@intel.com>
Cc: "Williams, Dan J" <dan.j.williams@intel.com>,
        Viresh KUMAR <viresh.kumar@st.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Shiraz HASHIM <shiraz.hashim@st.com>,
        Armando VISCONTI <armando.visconti@st.com>,
        Deepak SIKRI <deepak.sikri@st.com>, Vipin KUMAR <vipin.kumar@st.com>,
        Vipul Kumar SAMAR <vipulkumar.samar@st.com>,
        Vincenzo FRASCINO <Vincenzo.FRASCINO@st.com>,
        Mirko GARDI <mirko.gardi@st.com>,
        Rajeev KUMAR <rajeev-dlh.kumar@st.com>, Amit VIRDI <Amit.VIRDI@st.com>,
        Bhupesh SHARMA <bhupesh.sharma@st.com>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>
Subject: Re: dmaengine/Query: What about scatter/gather for mem to mem transfers.
References: <4EE038BD.7010705@st.com>  <1323329870.1641.27.camel@vkoul-udesk3> <4EE06C3C.8080003@st.com>  <4EE8469B.8050201@st.com> <4EE97E77.8060703@st.com>  <8D3F6266AEB6384E807C6FFC6FE195E327F2B0@BGSMSX101.gar.corp.intel.com>  <4EE98478.5070209@st.com>  <4EE99A15.8010608@st.com> <1324372895.1641.10087.camel@vkoul-udesk3>
In-Reply-To: <1324372895.1641.10087.camel@vkoul-udesk3>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/20/2011 2:51 PM, Vinod Koul wrote:
> On Thu, 2011-12-15 at 12:26 +0530, Pratyush Anand wrote:
>>>> That way existing mechanism would work well for you.
>>>> You need to split the chunks properly, which is what dma would do
>> anyway
>>>>
>>>
>>> Yes, they can be split like this, but then splitting onus will go on
>> dma
>>> user driver, and so there would be replication of similar logic at
>>> several places. Therefore, I was thinking to make device_prep_dma_sg
>> as
>>> generic by adding these flags.
> Well I am not sure how adding flags handles this?

device_prep_dma_sg has last argument as flags. dma user driver can pass 
information about inc/dec of src/dst in this flag, which can be used by 
the dma driver. I have put one such implementation at the end of mail.

> There are few things you should consider
> 1) do you have h/w support for these, if yes then we can talk about
> dmaengine APIs doing such a thing

No, there is not any specific HW option.

> 2) if objective is to support such transfers from dma driver POV, then I
> wouldn't agree, as these can be split easily to standard dma sg list.
>> From the code POV, it wouldn't hurt to create a wrapper which take in
> these non standard sg list list and converts then to uniform list

Yes, a wrapper function can do that.

>
> Most important question:
> in which practical scenario would src and dstn lengths be different?

Let me explain my sceberio.

Actual memory has been allocated by malloc in user space and pinned 
using mlock. Now src to dest copy (memcpy) has to be implemented using 
dma. A kernel module takes these addresses and transfer length as input. 
It extracts physical address each page by page. Now, it may happen that 
src address is like page 1-5, 7, 9 while dst address is like page 20-26. 
So here, for src there would have 3 nodes in sg list while for dest 
number of nodes would be 1. One option could be, as you has suggested 
earlier to equalize src and dst addresses gap and length by the dma user 
driver itself and then call device_prep_interleaved_dma. Other option 
what I think,  could be to pass these LLIs as it is and then manage it 
in device_prep_dma_sg using flags.

>
>>
>> I see one more issue in using device_prep_interleaved_dma.
>>
>> Src and Dst address has been allocated in user space.
>> Now a kernel module extracts physical addresses from these pages and
>> prepares a sg list, which it submits to DMA.
>> These addresses would be virtually contiguous and incrementing. But,
>> I
>> am not sure if they are always physically incrementing too. If they
>> are
>> not guaranteed to be incrementing, then I see issue.
>>
>> Otherwise also, a situation can arise when scattered memory is not
>> always incrementing or decrementing in the same sg list.
> What _exactly_ are you trying to do?
>
> DMA would need buffers which are physically contagious. Also the user
> pages can be swapped out, you would need to pin these pages.
>

but, even after using mlock, will it insure that allocated pages are 
always physically incrementing. If not then , probably we can not use 
device_prep_interleaved_dma.

Regards
Pratyush

Code which I referred:

+dwc_prep_dma_sg(struct dma_chan *chan,
+		struct scatterlist *dst_sg, unsigned int dst_nents,
+		struct scatterlist *src_sg, unsigned int src_nents,
+		unsigned long flags)
+{
+	struct dw_dma_chan *dwc = to_dw_dma_chan(chan);
+	struct dw_desc *first = NULL, *desc, *prev;
+	unsigned int offset, xfer_count, xfer_bytes;
+	unsigned int best_width, width, misalignment;
+	u32 ctllo;
+	dma_addr_t src, dst;
+	unsigned int slen = 0, dlen = 0, len = 0, total_len = 0;
+	unsigned int si = 0, di = 0;
+	unsigned long def_flags = 0;
+
+	if (unlikely(src_nents == 0 || dst_nents == 0))
+		return NULL;
+
+	/*
+	 * TODO: Currently We only support src and dst both as either
+	 * incrementing or decrementing.
+	 */
+	if ((flags & DMA_SRC_INC) && !(flags & DMA_DST_INC))
+		return NULL;
+
+	if ((flags & DMA_SRC_DEC) && !(flags & DMA_DST_DEC))
+		return NULL;
+
+	if (flags & DMA_SRC_INC)
+		def_flags |= DWC_CTLL_SRC_INC;
+	else if (flags & DMA_SRC_DEC)
+		def_flags |= DWC_CTLL_SRC_DEC;
+
+	if (flags & DMA_DST_INC)
+		def_flags |= DWC_CTLL_DST_INC;
+	else if (flags & DMA_DST_DEC)
+		def_flags |= DWC_CTLL_DST_DEC;
+
+	/* silence gcc warnings */
+	src = dst = 0;
+	prev = NULL;
+
+	while (si < src_nents || di < dst_nents) {
+		if (slen == 0) {
+			si++;
+			src = sg_dma_address(src_sg);
+			slen = sg_dma_len(src_sg);
+			/* If decrementing then start from end address */
+			if (flags & DMA_SRC_DEC)
+				src = src + slen;
+			src_sg = sg_next(src_sg);
+			if (unlikely (si < src_nents && src_sg == NULL)) {
+				dev_printk(KERN_ERR, chan2dev(chan),
+					"Invalid src scattergather list: "
+					"entry %u of %u has last flag\n",
+					si, src_nents);
+				goto err_sg_len;
+			} else if (unlikely (si == src_nents
+						&& src_sg != NULL)) {
+				dev_printk(KERN_ERR, chan2dev(chan),
+					"Invalid src scattergather list: "
+					"entry %u of %u has no last flag\n",
+					si, src_nents);
+				goto err_sg_len;
+			}
+		} else {
+			if (flags & DMA_SRC_INC)
+				src += len;
+			else if (flags & DMA_SRC_DEC)
+				src -= len;
+			else
+				goto err_sg_len;
+		}
+
+		if (dlen == 0) {
+			di++;
+			dst = sg_dma_address(dst_sg);
+			dlen = sg_dma_len(dst_sg);
+			/* If decrementing then start from end address */
+			if (flags & DMA_DST_DEC)
+				dst = dst + dlen;
+			dst_sg = sg_next(dst_sg);
+			if (unlikely (di < dst_nents && dst_sg == NULL)) {
+				dev_printk(KERN_ERR, chan2dev(chan),
+					"Invalid dst scattergather list: "
+					"entry %u of %u has last flag\n",
+					di, dst_nents);
+				goto err_sg_len;
+			} else if (unlikely (di == dst_nents
+						&& dst_sg != NULL)) {
+				dev_printk(KERN_ERR, chan2dev(chan),
+					"Invalid dst scattergather list: "
+					"entry %u of %u has no last flag\n",
+					di, dst_nents);
+				goto err_sg_len;
+			}
+		} else {
+			if (flags & DMA_DST_INC)
+				dst += len;
+			else if (flags & DMA_DST_DEC)
+				dst -= len;
+			else
+				goto err_sg_len;
+		}
+
+		len = min(slen, dlen);
+		slen -= len;
+		dlen -= len;
+
+		/* src-dst relative misalignment */
+		misalignment = src ^ dst;
+		best_width = __ffs(DWC_MAX_WIDTH | misalignment);
+
+		/* We want the transfer to be performed in 3 parts:
+		 *
+		 * - align src and dest to the best possible alignment
+		 *   (up to the maximum width of 8)
+		 *
+		 * - perform most of the transfer using the most
+		 *   efficient alignment
+		 *
+		 * - complete the transfer using whatever alignment is
+		 *   needed to total len bytes
+		 */
+
+		/* First part of the transfer: align src and dst*/
+
+		/* misalignment of src and dst with respect to 0 */
+		misalignment = src | dst;
+		width = __ffs(DWC_MAX_WIDTH | misalignment);
+
+		/* If we're already aligned, the first part is a
+		 * no-op, skip to the second */
+		if (width != best_width
+				&& len >> best_width > __ffs(DWC_MAX_WIDTH)) {
+			/* align src and dst to (1 << best_width) */
+			unsigned int align = 1 << best_width;
+			xfer_bytes = (align-src) & (align-dst) & (align-1);
+		} else
+			xfer_bytes = len;
+
+		offset = 0;
+		xfer_count = xfer_bytes >> width;
+
+		if (flags & (DMA_SRC_DEC | DMA_DST_DEC)){
+			src -= (1 << width);
+			dst -= (1 << width);
+		}
+
+		do {
+			ctllo = DWC_DEFAULT_CTLLO(chan->private)
+				| DWC_CTLL_DST_WIDTH(width)
+				| DWC_CTLL_SRC_WIDTH(width)
+				| def_flags
+				| DWC_CTLL_FC_M2M;
+
+			while (xfer_count > 0) {
+				xfer_count = min_t(size_t, xfer_count,
+						DWC_MAX_COUNT);
+
+				desc = dwc_desc_get(dwc);
+				if (unlikely (desc == NULL))
+					goto err_desc_get;
+
+				if (flags & (DMA_SRC_INC | DMA_DST_INC)){
+					desc->lli.sar = src + offset;
+					desc->lli.dar = dst + offset;
+				} else {
+					desc->lli.sar = src - offset;
+					desc->lli.dar = dst - offset;
+				}
+				desc->lli.ctllo = ctllo;
+				desc->lli.ctlhi = xfer_count;
+
+				if (first == NULL) {
+					first = desc;
+				} else {
+					prev->lli.llp = desc->txd.phys;
+					dma_sync_single_for_device(
+							chan2parent(chan),
+							prev->txd.phys,
+							sizeof(prev->lli),
+							DMA_TO_DEVICE);
+					list_add_tail(&desc->desc_node,
+							&first->tx_list);
+				}
+
+				prev = desc;
+
+				offset += xfer_count << width;
+				xfer_bytes -= xfer_count << width;
+
+				xfer_count = xfer_bytes >> width;
+			}
+
+			xfer_bytes = len - offset;
+
+			/*
+			 * The first part has been done. If there is
+			 * some data to be transferred using
+			 * best_width-aligned operations, do
+			 * it. Otherwise, choose an alignment that is
+			 * works for all of the remaining transfer.
+			 */
+			if (xfer_bytes >> best_width > 0) {
+				width = best_width;
+			} else {
+				/* misalignment of the remaining part
+				 * of src, dst and len */
+				misalignment = (src+offset) | (dst+offset)
+					| xfer_bytes;
+				width = __ffs(DWC_MAX_WIDTH | misalignment);
+			}
+
+			xfer_count = xfer_bytes >> width;
+		} while (offset < len);
+
+		total_len += len;
+		if (flags & (DMA_SRC_DEC | DMA_DST_DEC)){
+			src += (1 << width);
+			dst += (1 << width);
+		}
+
+	}
+
+	if (flags & DMA_PREP_INTERRUPT)
+		/* Trigger interrupt after last block */
+		prev->lli.ctllo |= DWC_CTLL_INT_EN;
+
+	prev->lli.llp = 0;
+	dma_sync_single_for_device(chan2parent(chan),
+				prev->txd.phys, sizeof(prev->lli),
+				DMA_TO_DEVICE);
+
+	first->txd.flags = flags;
+	first->len = total_len;
+
+	return &first->txd;
+
+err_sg_len:
+err_desc_get:
+	dwc_desc_put(dwc, first);
+	return NULL;
+}
+
+static struct dma_async_tx_descriptor *
  dwc_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
  		unsigned int sg_len, enum dma_data_direction direction,
  		unsigned long flags)
@@ -1474,6 +1728,7 @@ static int __init dw_probe(struct platform_device 
*pdev)
  	dw->dma.device_free_chan_resources = dwc_free_chan_resources;

  	dw->dma.device_prep_dma_memcpy = dwc_prep_dma_memcpy;
+	dw->dma.device_prep_dma_sg = dwc_prep_dma_sg;

  	dw->dma.device_prep_slave_sg = dwc_prep_slave_sg;
  	dw->dma.device_control = dwc_control;
