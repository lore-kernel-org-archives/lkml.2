Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752420Ab2ACJlP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 04:41:15 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:39945 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751627Ab2ACJlL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 04:41:11 -0500
Date: Tue, 3 Jan 2012 09:40:48 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Pratyush Anand <pratyush.anand@st.com>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        Vipul Kumar SAMAR <vipulkumar.samar@st.com>,
        Bhavna YADAV <bhavna.yadav@st.com>,
        Bhupesh SHARMA <bhupesh.sharma@st.com>,
        Armando VISCONTI <armando.visconti@st.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Vipin KUMAR <vipin.kumar@st.com>, Shiraz HASHIM <shiraz.hashim@st.com>,
        Amit VIRDI <Amit.VIRDI@st.com>, Mirko GARDI <mirko.gardi@st.com>,
        Deepak SIKRI <deepak.sikri@st.com>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        Rajeev KUMAR <rajeev-dlh.kumar@st.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Vincenzo FRASCINO <Vincenzo.FRASCINO@st.com>,
        Viresh KUMAR <viresh.kumar@st.com>
Subject: Re: [PATCH] dmaengine/dw_dmac: Add support for device_prep_dma_sg
Message-ID: <20120103094048.GF2914@n2100.arm.linux.org.uk>
References: <1323766064-13425-1-git-send-email-pratyush.anand@st.com> <1324655898.1633.11.camel@vkoul-udesk3> <4F0192F2.3010506@st.com> <1325503535.1540.17.camel@vkoul-udesk3>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1325503535.1540.17.camel@vkoul-udesk3>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 02, 2012 at 04:55:35PM +0530, Vinod Koul wrote:
> On Mon, 2012-01-02 at 16:50 +0530, Pratyush Anand wrote:
> > On 12/23/2011 9:28 PM, Vinod Koul wrote:
> > > On Tue, 2011-12-13 at 14:17 +0530, Pratyush Anand wrote:
> > >> Memory to memory copy with scatter gather option has been implemented in
> > >> this patch. Driver can manage even if number of nodes in src and dst
> > >> list is different.
> > > The logic looks okay, but it would be great if we could split this
> > > prepare here.
> > > Possibly later when we have multiple such cases we can create templates
> > > for parsing the non linear sg list and create linear lists from it.
> > >
> > 
> > Ok. So you suggest to have one patch with a function to align sglist
> > w.r.t length, and to implement this dwc_prep_dma_sg with aligned list only.
> IMO that would be a much better approach
> > 
> > Caller of dwc_prep_dma_sg function will also call something like
> > align_sg_list(unaligned_dsgl, unaligned ssgl, aligned dsgl,aligned ssgl);
> and this one can be common code in dmaengine

Wait a moment.  This looks like a disaster waiting to happen.  The DMA
engine code doesn't really handle the DMA API properly as it is - and
that has lead to at least one recent oops report (and it still remains
unresolved.)

The DMA API has the idea of buffer ownership: a buffer is either owned by
the CPU, or the DMA device.  Only its owner may explicitly access the
buffer.

Before a buffer can be used for DMA, it must be mapped to the DMA device
(using dma_map_sg() or dma_map_single().)  Once this call returns, the
mapping is setup and the CPU must not explicitly access the buffer until
the buffer is unmapped via dma_unmap_sg() or dma_unmap_single().

With the DMA engine API, the caller is responsible for mapping the buffer.

This means that if you want to ensure that the buffer is correctly aligned,
you must check the alignments _before_ mapping the buffer, and do any
appropriate copies at this stage.

So, it must be:
	- align_sg_list
	- map aligned lists
	- prep_dma_sg
and not
	- map aligned lists
	- align_sg_list
	- prep_dma_sg
because then you're violating the DMA API by having the CPU access an
already mapped buffer - and that will lead to data corruption.

Finally, consider this: you have two scatterlists which ask you to copy
between two buffers.  The first is offset by one byte from a 32-bit word
boundary.  The second is offset by two bytes from a 32-bit word
boundary.  Your DMA engine can only perform naturally aligned 32-bit
transfers for both the source and destination.  How do you see this
situation being dealt with?
