Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755071Ab0DEOcb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 10:32:31 -0400
Received: from 8bytes.org ([88.198.83.132]:44696 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754913Ab0DEOcZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 10:32:25 -0400
Date: Mon, 5 Apr 2010 16:32:24 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Chris Wright <chrisw@sous-sol.org>, Neil Horman <nhorman@redhat.com>,
       Neil Horman <nhorman@tuxdriver.com>, kexec@lists.infradead.org,
       linux-kernel@vger.kernel.org, hbabu@us.ibm.com,
       iommu@lists.linux-foundation.org,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH 1/2] x86/amd-iommu: enable iommu before attaching
	devices
Message-ID: <20100405143224.GC29758@8bytes.org>
References: <20100401144736.GA14069@shamino.rdu.redhat.com> <20100401155643.GG24846@8bytes.org> <20100401171149.GH13603@shamino.rdu.redhat.com> <20100401201433.GK24846@8bytes.org> <20100402000012.GA8930@hmsreliant.think-freely.org> <20100402003034.GX29241@sequoia.sous-sol.org> <20100402012353.GY29241@sequoia.sous-sol.org> <20100402155932.GA3516@redhat.com> <20100403173836.GP24846@8bytes.org> <20100405141750.GB876@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100405141750.GB876@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 05, 2010 at 10:17:50AM -0400, Vivek Goyal wrote:

> And by default valid PTEs are not present (except for some unity mappings
> as specified by ACPI tables), so we will end the transaction with
> IO_PAGE_FAULT? I am assuming that we will not set unity mappings for
> kernel reserved area and so either an in-flight DMA will not be allowed
> and IO_PAGE_FAULT will be logged or it will be allowed to some unity
> mapping which is not mapped to kdump kernel area hence no corruption of
> capture kernel?

Right. The unity-mappings are typically used for devices that are
controled by the BIOS and define memory regions owned by the BIOS. So
Linux will not use the unity mapped regions anyway, not in the first
kernel and not in the kdump kernel.

> > With paging mode == 0 your statement about read-write
> > unity-mapping is true. This is used for a pass-through domain (iommu=pt)
> > btw.
> 
> Ok, so in case of pass through, I think one just needs to make sure that
> don't use iommu=pt in second kernel if one did not use iommu=pt in first kernel.
> Otherwise you can redirect the the in-flight DMAs in second kernel to an
> entirely unintended physical memory.

The kdump kernel should use the same setting as the plain kernel.

> So following seems to be the summary.
> 
> - Don't disable AMD IOMMU after crash in machine_crash_shutdown(), because
>   disabling it can direct in-flight DMAs to unintended physical meory
>   areas and can corrupt other data structures.

Right, that really seems to be the best solution.

> - Once the iommu is enabled in second kernel, most likely in-flight DMAs
>   will end with IO_PAGE_FAULT (iommu!=pt). Only selective unity mapping
>   areas will be setup based on ACPI tables and these should be BIOS region
>   and should not overlap with kdump reserved memory. iommu=pt should also
>   be safe if iommu=pt was used in first kernel also.

Right. With Chris' patches the DTE entries of newly attached domains are
flushed at IOMMU initialization in the kdump kernel. So the new data
structures are in place and used by the hardware.

> - Only small window where in-flight DMA can corrupt things is when we
>   are initializing iommu in second kernel. (We first disable iommu and then
>   enable it back). During this small period translation will be disabled and
>   some IO can go to unintended address. And there does not seem to be any easy
>   way to plug this hole.

Right.

> Have I got it right?

Yes :-)


	Joerg
