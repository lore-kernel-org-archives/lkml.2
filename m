Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753710Ab2LLJic (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 04:38:32 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:35941 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753622Ab2LLJi3 convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:1>);
	Wed, 12 Dec 2012 04:38:29 -0500
Message-Id: <50C85E9F02000078000AFD65@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.1 
Date: Wed, 12 Dec 2012 09:38:23 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Dongxiao Xu" <dongxiao.xu@intel.com>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>
Cc: "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH] xen/swiotlb: Exchange to contiguous
 memory for map_sg hook
References: <1354799322-6000-1-git-send-email-dongxiao.xu@intel.com>
 <20121207140852.GC3140@phenom.dumpdata.com>
 <40776A41FC278F40B59438AD47D147A90FEBE741@SHSMSX102.ccr.corp.intel.com>
 <20121211170653.GG9347@localhost.localdomain>
 <40776A41FC278F40B59438AD47D147A90FEBFB64@SHSMSX102.ccr.corp.intel.com>
In-Reply-To: <40776A41FC278F40B59438AD47D147A90FEBFB64@SHSMSX102.ccr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 12.12.12 at 02:03, "Xu, Dongxiao" <dongxiao.xu@intel.com> wrote:
>> From: Konrad Rzeszutek Wilk [mailto:konrad.wilk@oracle.com]
>> On Tue, Dec 11, 2012 at 06:39:35AM +0000, Xu, Dongxiao wrote:
>> > > From: Konrad Rzeszutek Wilk [mailto:konrad.wilk@oracle.com]
>> > > What if this check was done in the routines that provide the
>> > > software static buffers and there try to provide a nice DMA contingous
>> swatch of pages?
>> >
>> > Yes, this approach also came to our mind, which needs to modify the driver
>> itself.
>> > If so, it requires driver not using such static buffers (e.g., from 
> kmalloc) to do
>> DMA even if the buffer is continuous in native.
>> 
>> I am bit loss here.
>> 
>> Is the issue you found only with drivers that do not use DMA API?
>> Can you perhaps point me to the code that triggered this fix in the first 
> place?
> 
> Yes, we met this issue on a specific SAS device/driver, and it calls into 
> libata-core code, you can refer to function ata_dev_read_id() called from 
> ata_dev_reread_id() in drivers/ata/libata-core.c.
> 
> In the above function, the target buffer is (void *)dev->link->ap->sector_buf, 
> which is 512 bytes static buffer and unfortunately it across the page 
> boundary.

I wonder whether such use of sg_init_one()/sg_set_buf() is correct
in the first place. While there aren't any restrictions documented for
its use, one clearly can't pass in whatever one wants (a pointer into
vmalloc()-ed memory, for instance, won't work afaict).

I didn't go through all other users of it, but quite a few of the uses
elsewhere look similarly questionable.

>> I am still not completely clear on what you had in mind. The one method I
>> thought about that might help in this is to have Xen-SWIOTLB track which
>> memory ranges were exchanged (so xen_swiotlb_fixup would save the *buf
>> and the size for each call to xen_create_contiguous_region in a list or 
> array).
>> 
>> When xen_swiotlb_map/xen_swiotlb_map_sg_attrs care called they would
>> consult said array/list to see if the region they retrieved crosses said 2MB
>> chunks. If so.. and here I am unsure of what would be the best way to 
> proceed.
> 
> We thought we can solve the issue in several ways:
> 
> 1) Like the previous patch I sent out, we check the DMA region in 
> xen_swiotlb_map_page() and xen_swiotlb_map_sg_attr(), and if DMA region 
> crosses page boundary, we exchange the memory and copy the content. However 
> it has race condition that when copying the memory content (we introduced two 
> memory copies in the patch), some other code may also visit the page, which 
> may encounter incorrect values.

That's why, after mapping a buffer (or SG list) one has to call the
sync functions before looking at data. Any race as described by
you is therefore a programming error.

Jan


