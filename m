Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753727Ab3AGPzS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 10:55:18 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:37785 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753671Ab3AGPzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 10:55:12 -0500
Date: Mon, 7 Jan 2013 10:55:03 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: "Xu, Dongxiao" <dongxiao.xu@intel.com>
Cc: Jan Beulich <JBeulich@suse.com>,
        "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH] xen/swiotlb: Exchange to contiguous memory
 for map_sg hook
Message-ID: <20130107155503.GH3219@phenom.dumpdata.com>
References: <1354799322-6000-1-git-send-email-dongxiao.xu@intel.com>
 <20121207140852.GC3140@phenom.dumpdata.com>
 <40776A41FC278F40B59438AD47D147A90FEBE741@SHSMSX102.ccr.corp.intel.com>
 <20121211170653.GG9347@localhost.localdomain>
 <40776A41FC278F40B59438AD47D147A90FEBFB64@SHSMSX102.ccr.corp.intel.com>
 <50C85E9F02000078000AFD65@nat28.tlf.novell.com>
 <20121219200904.GG15037@phenom.dumpdata.com>
 <40776A41FC278F40B59438AD47D147A90FECC3EC@SHSMSX102.ccr.corp.intel.com>
 <50D2E0C102000078000B1B1C@nat28.tlf.novell.com>
 <40776A41FC278F40B59438AD47D147A90FED9A52@SHSMSX102.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <40776A41FC278F40B59438AD47D147A90FED9A52@SHSMSX102.ccr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 07, 2013 at 07:17:33AM +0000, Xu, Dongxiao wrote:
> > -----Original Message-----
> > From: Jan Beulich [mailto:JBeulich@suse.com]
> > Sent: Thursday, December 20, 2012 4:56 PM
> > To: Xu, Dongxiao
> > Cc: xen-devel@lists.xen.org; Konrad Rzeszutek Wilk;
> > linux-kernel@vger.kernel.org
> > Subject: RE: [Xen-devel] [PATCH] xen/swiotlb: Exchange to contiguous memory
> > for map_sg hook
> > 
> > >>> On 20.12.12 at 02:23, "Xu, Dongxiao" <dongxiao.xu@intel.com> wrote:
> > > Sorry, maybe I am still not describing this issue clearly.
> > 
> > No, at least I understood you the way you re-describe below.
> > 
> > > Take the libata case as an example, the static DMA buffer locates
> > > (dev->link->ap->sector_buf , here we use Data Structure B in the graph) in
> > > the following structure:
> > >
> > > -------------------------------------Page boundary
> > > <Data Structure A>
> > > <Data Structure B>
> > > -------------------------------------Page boundary
> > > <Data Structure B (cross page)>
> > > <Data Structure C>
> > > -------------------------------------Page boundary
> > >
> > > Where Structure B is our DMA target.
> > >
> > > For Data Structure B, we didn't care about the simultaneous access, either
> > > lock or sync function will take care of it.
> > > What we are not sure is "read/write of A and C from other processor". As we
> > > will have memory copy for the pages, and at the same time, other CPU may
> > > access A/C.
> > 
> > The question is whether what libata does here is valid in the first
> > place - fill an SG list entry with something that crosses a page
> > boundary and is not a compound page.
> 
> Sorry for the late response about this thread.
> 
> To make sure I understand you correctly, so do you mean the correct fix should be applied to libata driver, and make sure it DMA from/to correct place (for example, some memory allocated by DMA API), but not such certain field in a static structure?

Or with baremetal swiotlb if the user booted with 'swiotlb=force'.

> 
> If we fix it in device driver side, then we may not need to modify the xen-swiotlb part.
> 
Correct. This is a bug in the device driver where it checks the contents of its buffer
_before_ doing an DMA unmap or DMA sync.
