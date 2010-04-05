Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754876Ab0DEOSa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 10:18:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27656 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753619Ab0DEOSY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 10:18:24 -0400
Date: Mon, 5 Apr 2010 10:17:50 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Joerg Roedel <joro@8bytes.org>
Cc: Chris Wright <chrisw@sous-sol.org>, Neil Horman <nhorman@redhat.com>,
       Neil Horman <nhorman@tuxdriver.com>, kexec@lists.infradead.org,
       linux-kernel@vger.kernel.org, hbabu@us.ibm.com,
       iommu@lists.linux-foundation.org,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH 1/2] x86/amd-iommu: enable iommu before attaching
	devices
Message-ID: <20100405141750.GB876@redhat.com>
References: <20100401142902.GF24846@8bytes.org> <20100401144736.GA14069@shamino.rdu.redhat.com> <20100401155643.GG24846@8bytes.org> <20100401171149.GH13603@shamino.rdu.redhat.com> <20100401201433.GK24846@8bytes.org> <20100402000012.GA8930@hmsreliant.think-freely.org> <20100402003034.GX29241@sequoia.sous-sol.org> <20100402012353.GY29241@sequoia.sous-sol.org> <20100402155932.GA3516@redhat.com> <20100403173836.GP24846@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100403173836.GP24846@8bytes.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 03, 2010 at 07:38:36PM +0200, Joerg Roedel wrote:
> On Fri, Apr 02, 2010 at 11:59:32AM -0400, Vivek Goyal wrote:
> > 1. kernel crashes, we leave IOMMU enabled.
> 
> True for everything except gart and amd iommu.
> 
> > 	a. So during this small window when iommu is disabled and we enable
> > 	   it back, any inflight DMA will passthrough possibly to an
> > 	   unintended physical address as translation is disabled and it
> > 	   can corrupt the kdump kenrel.
> 
> Right.
> 
> > 	b. Even after enabling the iommu, I guess we will continue to
> > 	   use cached DTE, and translation information to handle any
> > 	   in-flight DMA. The difference is that now iommus are enabled
> > 	   so any in-flight DMA should go to the address as intended in
> > 	   first kenrel and should not corrupt anything.
> 
> Right.
> 
> > 
> > 3. Once iommus are enabled again, we allocated and initilize protection
> >    domains. We attach devices to domains. In the process we flush the
> >    DTE, PDE and IO TLBs.
> > 
> > 	c. Looks like do_attach->set_dte_entry(), by default gives write
> > 	   permission (IW) to all the devices. I am assuming that at
> > 	   this point of time translation is enabled and possibly unity
> > 	   mapped.
> 
> No, The IW bit in the DTE must be set because all write permission bits
> (DTE and page tabled) are ANDed to determine if a device can write to a
> particular address. So as long as the paging mode is unequal to zero the
> hardware will walk the page-table first to find out if the device has
> write permission.

And by default valid PTEs are not present (except for some unity mappings
as specified by ACPI tables), so we will end the transaction with
IO_PAGE_FAULT? I am assuming that we will not set unity mappings for
kernel reserved area and so either an in-flight DMA will not be allowed
and IO_PAGE_FAULT will be logged or it will be allowed to some unity
mapping which is not mapped to kdump kernel area hence no corruption of
capture kernel?

> With paging mode == 0 your statement about read-write
> unity-mapping is true. This is used for a pass-through domain (iommu=pt)
> btw.

Ok, so in case of pass through, I think one just needs to make sure that
don't use iommu=pt in second kernel if one did not use iommu=pt in first kernel.
Otherwise you can redirect the the in-flight DMAs in second kernel to an
entirely unintended physical memory.


So following seems to be the summary.

- Don't disable AMD IOMMU after crash in machine_crash_shutdown(), because
  disabling it can direct in-flight DMAs to unintended physical meory
  areas and can corrupt other data structures.

- Once the iommu is enabled in second kernel, most likely in-flight DMAs
  will end with IO_PAGE_FAULT (iommu!=pt). Only selective unity mapping
  areas will be setup based on ACPI tables and these should be BIOS region
  and should not overlap with kdump reserved memory. iommu=pt should also
  be safe if iommu=pt was used in first kernel also.  

- Only small window where in-flight DMA can corrupt things is when we
  are initializing iommu in second kernel. (We first disable iommu and then
  enable it back). During this small period translation will be disabled and
  some IO can go to unintended address. And there does not seem to be any easy
  way to plug this hole.

Have I got it right?
 
Thanks
Vivek
