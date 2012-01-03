Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753360Ab2ACNoB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 08:44:01 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:60583 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751574Ab2ACNn7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 08:43:59 -0500
Date: Tue, 3 Jan 2012 13:43:28 +0000
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
Message-ID: <20120103134328.GR2914@n2100.arm.linux.org.uk>
References: <1323766064-13425-1-git-send-email-pratyush.anand@st.com> <1324655898.1633.11.camel@vkoul-udesk3> <4F0192F2.3010506@st.com> <1325503535.1540.17.camel@vkoul-udesk3> <20120103094048.GF2914@n2100.arm.linux.org.uk> <1325595816.1540.65.camel@vkoul-udesk3>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1325595816.1540.65.camel@vkoul-udesk3>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 03, 2012 at 06:33:36PM +0530, Vinod Koul wrote:
> On Tue, 2012-01-03 at 09:40 +0000, Russell King - ARM Linux wrote:
> > Wait a moment.  This looks like a disaster waiting to happen.  The DMA
> > engine code doesn't really handle the DMA API properly as it is - and
> > that has lead to at least one recent oops report (and it still remains
> > unresolved.)
> > 
> > The DMA API has the idea of buffer ownership: a buffer is either owned by
> > the CPU, or the DMA device.  Only its owner may explicitly access the
> > buffer.
> > 
> > Before a buffer can be used for DMA, it must be mapped to the DMA device
> > (using dma_map_sg() or dma_map_single().)  Once this call returns, the
> > mapping is setup and the CPU must not explicitly access the buffer until
> > the buffer is unmapped via dma_unmap_sg() or dma_unmap_single().
> > 
> > With the DMA engine API, the caller is responsible for mapping the buffer.
> > 
> > This means that if you want to ensure that the buffer is correctly aligned,
> > you must check the alignments _before_ mapping the buffer, and do any
> > appropriate copies at this stage.
> > 
> > So, it must be:
> > 	- align_sg_list
> > 	- map aligned lists
> > 	- prep_dma_sg
> Yes, that is something I had in mind as well.
> For slave-dma as we documented, the peripheral driver needs to take care
> of mapping hence it should do above as you suggested and not the one
> below.
> My suggestion was to have a generic alignment routine for sg list (which
> may be used by other drivers as well) in some common place.
> > and not
> > 	- map aligned lists
> > 	- align_sg_list
> > 	- prep_dma_sg
> > because then you're violating the DMA API by having the CPU access an
> > already mapped buffer - and that will lead to data corruption.
> > 
> > Finally, consider this: you have two scatterlists which ask you to copy
> > between two buffers.  The first is offset by one byte from a 32-bit word
> > boundary.  The second is offset by two bytes from a 32-bit word
> > boundary.  Your DMA engine can only perform naturally aligned 32-bit
> > transfers for both the source and destination.  How do you see this
> > situation being dealt with?
> in this case, i don't think dmaengine can perform the task.
> it should check for required alignments in the respective prepare
> function, and return error if it cant support it.
> Nevertheless, all prepare functions should be checking for word
> alignment of source and destination...

This is sub-optimal, because then you end up with:

- align_sg_list
- map lists
- prep_dma_sg
- unmap lists
- perform manual copy

which, if your map/unmap is non-trivial, means you take an unnecessary hit.

It would be much better if the dmaengine code exposed its alignment
properties in such a way that:

(a) align_sg_list could be totally generic code
(b) it can be found out whether the sg list can be handled by the DMA
    engine

I'd also argue that align_sg_list() probably shouldn't even try to align
a sg list - it should really just indicate whether the sg list _could_
be handled by the DMA engine code or not.  (The case where the source
and destination are identically mis-aligned is probably a rare corner
case of the mis-aligned sg list.)
