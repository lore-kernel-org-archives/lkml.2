Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754128Ab2LKRHF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 12:07:05 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:41177 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753788Ab2LKRHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 12:07:03 -0500
Date: Tue, 11 Dec 2012 12:06:54 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: "Xu, Dongxiao" <dongxiao.xu@intel.com>
Cc: "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xen/swiotlb: Exchange to contiguous memory for map_sg
 hook
Message-ID: <20121211170653.GG9347@localhost.localdomain>
References: <1354799322-6000-1-git-send-email-dongxiao.xu@intel.com>
 <20121207140852.GC3140@phenom.dumpdata.com>
 <40776A41FC278F40B59438AD47D147A90FEBE741@SHSMSX102.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <40776A41FC278F40B59438AD47D147A90FEBE741@SHSMSX102.ccr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 11, 2012 at 06:39:35AM +0000, Xu, Dongxiao wrote:
> > -----Original Message-----
> > From: Konrad Rzeszutek Wilk [mailto:konrad.wilk@oracle.com]
> > Sent: Friday, December 07, 2012 10:09 PM
> > To: Xu, Dongxiao
> > Cc: xen-devel@lists.xen.org; linux-kernel@vger.kernel.org
> > Subject: Re: [PATCH] xen/swiotlb: Exchange to contiguous memory for map_sg
> > hook
> > 
> > On Thu, Dec 06, 2012 at 09:08:42PM +0800, Dongxiao Xu wrote:
> > > While mapping sg buffers, checking to cross page DMA buffer is also
> > > needed. If the guest DMA buffer crosses page boundary, Xen should
> > > exchange contiguous memory for it.
> > 
> > So this is when we cross those 2MB contingous swatch of buffers.
> > Wouldn't we get the same problem with the 'map_page' call? If the driver tried
> > to map say a 4MB DMA region?
> 
> Yes, it also needs such check, as I just replied to Jan's mail.
> 
> > 
> > What if this check was done in the routines that provide the software static
> > buffers and there try to provide a nice DMA contingous swatch of pages?
> 
> Yes, this approach also came to our mind, which needs to modify the driver itself.
> If so, it requires driver not using such static buffers (e.g., from kmalloc) to do DMA even if the buffer is continuous in native.

I am bit loss here.

Is the issue you found only with drivers that do not use DMA API?
Can you perhaps point me to the code that triggered this fix in the first
place?
> Is this acceptable by kernel/driver upstream?

I am still not completely clear on what you had in mind. The one method I
thought about that might help in this is to have Xen-SWIOTLB
track which memory ranges were exchanged (so xen_swiotlb_fixup
would save the *buf and the size for each call to
xen_create_contiguous_region in a list or array).

When xen_swiotlb_map/xen_swiotlb_map_sg_attrs care called they
would consult said array/list to see if the region they retrieved
crosses said 2MB chunks. If so.. and here I am unsure of
what would be the best way to proceed.
