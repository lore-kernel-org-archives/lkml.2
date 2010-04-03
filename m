Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755698Ab0DCRin (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Apr 2010 13:38:43 -0400
Received: from 8bytes.org ([88.198.83.132]:56690 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753130Ab0DCRih (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Apr 2010 13:38:37 -0400
Date: Sat, 3 Apr 2010 19:38:36 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Chris Wright <chrisw@sous-sol.org>, Neil Horman <nhorman@redhat.com>,
       Neil Horman <nhorman@tuxdriver.com>, kexec@lists.infradead.org,
       linux-kernel@vger.kernel.org, hbabu@us.ibm.com,
       iommu@lists.linux-foundation.org,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH 1/2] x86/amd-iommu: enable iommu before attaching
	devices
Message-ID: <20100403173836.GP24846@8bytes.org>
References: <20100331202745.GE13406@hmsreliant.think-freely.org> <20100401142902.GF24846@8bytes.org> <20100401144736.GA14069@shamino.rdu.redhat.com> <20100401155643.GG24846@8bytes.org> <20100401171149.GH13603@shamino.rdu.redhat.com> <20100401201433.GK24846@8bytes.org> <20100402000012.GA8930@hmsreliant.think-freely.org> <20100402003034.GX29241@sequoia.sous-sol.org> <20100402012353.GY29241@sequoia.sous-sol.org> <20100402155932.GA3516@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100402155932.GA3516@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 02, 2010 at 11:59:32AM -0400, Vivek Goyal wrote:
> 1. kernel crashes, we leave IOMMU enabled.

True for everything except gart and amd iommu.

> 	a. So during this small window when iommu is disabled and we enable
> 	   it back, any inflight DMA will passthrough possibly to an
> 	   unintended physical address as translation is disabled and it
> 	   can corrupt the kdump kenrel.

Right.

> 	b. Even after enabling the iommu, I guess we will continue to
> 	   use cached DTE, and translation information to handle any
> 	   in-flight DMA. The difference is that now iommus are enabled
> 	   so any in-flight DMA should go to the address as intended in
> 	   first kenrel and should not corrupt anything.

Right.

> 
> 3. Once iommus are enabled again, we allocated and initilize protection
>    domains. We attach devices to domains. In the process we flush the
>    DTE, PDE and IO TLBs.
> 
> 	c. Looks like do_attach->set_dte_entry(), by default gives write
> 	   permission (IW) to all the devices. I am assuming that at
> 	   this point of time translation is enabled and possibly unity
> 	   mapped.

No, The IW bit in the DTE must be set because all write permission bits
(DTE and page tabled) are ANDed to determine if a device can write to a
particular address. So as long as the paging mode is unequal to zero the
hardware will walk the page-table first to find out if the device has
write permission. With paging mode == 0 your statement about read-write
unity-mapping is true. This is used for a pass-through domain (iommu=pt)
btw.

	Joerg

