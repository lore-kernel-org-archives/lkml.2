Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752421Ab1JJHBA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 03:01:00 -0400
Received: from mga03.intel.com ([143.182.124.21]:7902 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751957Ab1JJHA7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 03:00:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,515,1312182000"; 
   d="scan'208";a="24755086"
Subject: Re: [PATCHv4] DMAEngine: Define interleaved transfer request api
From: Vinod Koul <vinod.koul@intel.com>
To: Jassi Brar <jaswinder.singh@linaro.org>
Cc: "Williams, Dan J" <dan.j.williams@intel.com>,
        Russell King <rmk@arm.linux.org.uk>, Barry Song <21cnbao@gmail.com>,
        linux-kernel@vger.kernel.org,
        DL-SHA-WorkGroupLinux <workgroup.linux@csr.com>,
        Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <CAJe_ZhdSRmQmHOyOSvzyduu1pxR5K3aSd+1fCW2TB36=1ZwUUg@mail.gmail.com>
References: <1317191992-3635-1-git-send-email-jaswinder.singh@linaro.org>
	 <1317200618.1573.1765.camel@vkoul-udesk3>
	 <CAJe_ZhfDk7O_O7LDh7GrpcaPMzQuzs9nBA8BeN0VxG8_Oe93wg@mail.gmail.com>
	 <1317295068.1573.1780.camel@vkoul-udesk3>
	 <CAGsJ_4y+ageAqg1DQtQJ-g2j6im_e3KdvkcBaDFLz8fUniJpuA@mail.gmail.com>
	 <CAJe_ZhfyTBgH7wqB1HWtkjDNusecTOTZrqyYKF=Lwb9xQAXA3w@mail.gmail.com>
	 <CAGsJ_4x=F41Fbsw9gB3y=Vzyhf8a9yXB=sd6xbxSNUbTAYdjOA@mail.gmail.com>
	 <CAJe_Zhd86uqhzRHaA8ci2GHQgz6TadPR5hTuuUKqCWOFJwn6qg@mail.gmail.com>
	 <CAGsJ_4zOUFUkGv_-BB5sqjVZF1gBe-MVJS3Vxmi9Jo4sqYCLAg@mail.gmail.com>
	 <CAJe_Zhc8zdZzse+jutYERec5bKBPqWmq9v0xYrou0x1BSKyCLQ@mail.gmail.com>
	 <20111003161349.GB28287@flint.arm.linux.org.uk>
	 <CAJe_ZhfS=4vSS0OiSuNx3S+fW8R4-=khrHtt8suLeHjTFYBVeA@mail.gmail.com>
	 <CABE8wwsQKF9eTTU_N305hR=G5qW4Rzb7Lo-nHbc9RVYwSJVSVA@mail.gmail.com>
	 <1317966346.1573.2252.camel@vkoul-udesk3>
	 <CAJe_ZhdFA641AzmEmYaz++iRNYQmrHDFmAWOkrwmR_h2ie176g@mail.gmail.com>
	 <1317997177.1573.2275.camel@vkoul-udesk3>
	 <CAJe_ZhdSRmQmHOyOSvzyduu1pxR5K3aSd+1fCW2TB36=1ZwUUg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 10 Oct 2011 12:23:12 +0530
Message-ID: <1318229592.1573.2298.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-10-07 at 20:08 +0530, Jassi Brar wrote:
> On 7 October 2011 19:49, Vinod Koul <vinod.koul@intel.com> wrote:
> > On Fri, 2011-10-07 at 16:57 +0530, Jassi Brar wrote:
> 
> >> > I would still argue that if we split this on same lines as current
> >> > mechanism, we have clean way to convey all details for both cases.
> >> >
> >> Do you mean to have separate interleaved transfer apis for Slave
> >> and Mem->Mem ? Please clarify.
> > If we can make API cleaner and well defined that way then Yes :)
> >
> I assume if you suggest you already have an idea....
> Please do tell roughly how the api should look for Slave and for Mem->Mem ?
Okay, I think at this point we have discussed the parameters and agree
on them. Only issue being direction, which makes sense in slave, and
doesn't matter to be passed/dudeced in memcpy cases by dmac driver
What we can do is like below or tweaks to it:

+struct dmaxfer_memcpy_template {
+	dma_addr_t src_start;
+	dma_addr_t dst_start;
+	bool src_inc;
+	bool dst_inc;
+	bool src_sgl;
+	bool dst_sgl;
+	size_t numf;
+	size_t frame_size;
+	struct data_chunk sgl[0];
+};
+
+struct dmaxfer_slave_template {	
+	dma_addr_t mem;
+	bool mem_inc;
+	size_t numf;
+	size_t frame_size;
+	struct data_chunk sgl[0];
+};
 /* last transaction type for creation of the capabilities mask */
 #define DMA_TX_TYPE_END (DMA_CYCLIC + 1)
 
@@ -495,6 +521,13 @@ struct dma_device {
 	struct dma_async_tx_descriptor *(*device_prep_dma_cyclic)(
 		struct dma_chan *chan, dma_addr_t buf_addr, size_t buf_len,
 		size_t period_len, enum dma_data_direction direction);
+	struct dma_async_tx_descriptor *(*device_prep_interleaved_memcpy)(
+		struct dma_chan *chan, struct dmaxfer_memcpy_template,
+		unsigned long flags);
+	struct dma_async_tx_descriptor *(*device_prep_interleaved_slave)(
+		struct dma_chan *chan, struct dmaxfer_slave_template,
+		enum dma_data_direction direction, unsigned long flags);
+
 	int (*device_control)(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
 		unsigned long arg);
 
I was tempted to create a single dmaxfer structure which can be common
to both slave and memcpy. In former you pass this along with direction
and in latter you can pass pair of these to describe src and dstn.

I will leave the choice to you :)

The point is that it makes it simpler to understand what we are doing
rather than resort to parsing to find out if its memcpy or slave and
what is the direction.

-- 
~Vinod

