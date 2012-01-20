Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753058Ab2ATNal (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 08:30:41 -0500
Received: from mga11.intel.com ([192.55.52.93]:21038 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751820Ab2ATNaj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 08:30:39 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="114388173"
Subject: Re: [PATCH v2 0/2] Add Qualcomm MSM ADM DMAEngine driver
From: Vinod Koul <vinod.koul@intel.com>
To: Ravi Kumar V <kumarrav@codeaurora.org>
Cc: dan.j.williams@intel.com, arnd@arndb.de, linux-arch@vger.kernel.org,
        davidb@codeaurora.org, dwalker@fifo99.com, bryanh@codeaurora.org,
        linux@arm.linux.org.uk, tsoni@qualcomm.com, johlstei@qualcomm.com,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
In-Reply-To: <4F195E4C.6080805@codeaurora.org>
References: <1325854052-21402-1-git-send-email-kumarrav@codeaurora.org>
	 <1326807902.1540.116.camel@vkoul-udesk3>  <4F195E4C.6080805@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 20 Jan 2012 19:01:27 +0530
Message-ID: <1327066287.517.4.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-01-20 at 18:00 +0530, Ravi Kumar V wrote:
> On 1/17/2012 7:15 PM, Vinod Koul wrote:
> > On Fri, 2012-01-06 at 18:17 +0530, Ravi Kumar V wrote:
> > <sorry for delayed review, was on vacation and now traveling>
> >>
> >> As our ADM Scatter-gather hardware needs
> >> -32-bit command configuration parameter
> >>   apart from
> >> -32-bit source address
> >> -32-bit destination address
> >> -16-bit length
> >>
> >> So,we have added new parameter in struct scatterlist to support xfer
> >> descriptor
> >> specific private data, and for supporting ADM Box mode DMA we added
> >> new
> >> API and data structure.
> > what do you mean by "ADM Box mode"?
> >
> 
> ADM Box mode is a interleaved type of DMA where data from rows of equal 
> length and equal distance(bytes) between each other are transferred to 
> similar pattern of rows.
> Each row length and distance between each row in destination pattern may 
> not be equal to source pattern.
> Distance between beginning of any two rows are always greater than row 
> length.
> Example:
> If 4 rows of 16 bytes each are arranged such that distance between 
> beginning of any two rows are 32 bytes.
> Now they can be transferred using BOX mode to destination pattern 
> arranged in 2 rows of 32 bytes each and distance between them can be any 
> lets say 128 bytes.
> 
> Source pattern:
> 4 data rows starts address 0th byte.
> 
> 0-----16-bytes-data-----15
> 16    16 bytes void     31
> 32---------data---------47
> 48         void         63
> 64---------data---------79
> 80         void         95
> 96---------data--------111
> 
> Transferred to destination
> Destination pattern:
> 2 rows
> 0----------32-bytes-data----------31
> 32         96 bytes void         127
> 128-------------data-------------159
> 
Sounds like you should be using interleaved API

Please see this and read the patch history, which has nice details about
this

/**
 * struct dma_interleaved_template - Template to convey DMAC the
transfer pattern
 *       and attributes.
 * @src_start: Bus address of source for the first chunk.
 * @dst_start: Bus address of destination for the first chunk.
 * @dir: Specifies the type of Source and Destination.
 * @src_inc: If the source address increments after reading from it.
 * @dst_inc: If the destination address increments after writing to it.
 * @src_sgl: If the 'icg' of sgl[] applies to Source (scattered read).
 *              Otherwise, source is read contiguously (icg ignored).
 *              Ignored if src_inc is false.
 * @dst_sgl: If the 'icg' of sgl[] applies to Destination (scattered write).
 *              Otherwise, destination is filled contiguously (icg ignored).
 *              Ignored if dst_inc is false.
 * @numf: Number of frames in this template.
 * @frame_size: Number of chunks in a frame i.e, size of sgl[].
 * @sgl: Array of {chunk,icg} pairs that make up a frame.
 */
struct dma_interleaved_template {
        dma_addr_t src_start;
        dma_addr_t dst_start;
        enum dma_transfer_direction dir;
        bool src_inc;
        bool dst_inc;
        bool src_sgl;
        bool dst_sgl;
        size_t numf;
        size_t frame_size;
        struct data_chunk sgl[0];
};
using the interleaved API:
        struct dma_async_tx_descriptor *(*device_prep_interleaved_dma)(
                struct dma_chan *chan, struct dma_interleaved_template *xt,
                unsigned long flags);


-- 
~Vinod

