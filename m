Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756770Ab0CaTSz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 15:18:55 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:53311 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756510Ab0CaTSy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 15:18:54 -0400
Date: Wed, 31 Mar 2010 15:18:11 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, iommu@lists.linux-foundation.org,
       joerg.roedel@amd.com, hbabu@us.ibm.com, kexec@lists.infradead.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] amd iommu: force flush of iommu prior during shutdown
Message-ID: <20100331191811.GD13406@hmsreliant.think-freely.org>
References: <20100331152417.GB13406@hmsreliant.think-freely.org>
 <20100331155430.GF14011@redhat.com>
 <20100331182824.GC13406@hmsreliant.think-freely.org>
 <m1wrwsuxn9.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1wrwsuxn9.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-Spam-Score: -2.9 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 31, 2010 at 11:57:46AM -0700, Eric W. Biederman wrote:
> Neil Horman <nhorman@tuxdriver.com> writes:
> 
> > On Wed, Mar 31, 2010 at 11:54:30AM -0400, Vivek Goyal wrote:
> 
> >> So this call amd_iommu_flush_all_devices() will be able to tell devices
> >> that don't do any more DMAs and hence it is safe to reprogram iommu
> >> mapping entries.
> >> 
> > It blocks the cpu until any pending DMA operations are complete.  Hmm, as I
> > think about it, there is still a small possibility that a device like a NIC
> > which has several buffers pre-dma-mapped could start a new dma before we
> > completely disabled the iommu, althought thats small.  I never saw that in my
> > testing, but hitting that would be fairly difficult I think, since its literally
> > just a few hundred cycles between the flush and the actual hardware disable
> > operation.
> >
> > According to this though:
> > http://support.amd.com/us/Processor_TechDocs/34434-IOMMU-Rev_1.26_2-11-09.pdf
> > That window could be closed fairly easily, but simply disabling read and write
> > permissions for each device table entry prior to calling flush.  If we do that,
> > then flush the device table, any subsequently started dma operation would just
> > get noted in the error log, which we could ignore, since we're abot to boot to
> > the kdump kernel anyway.
> >
> > Would you like me to respin w/ that modification?
> 
> Disabling permissions on all devices sounds good for the new virtualization
> capable iommus.  I think older iommus will still be challenged.  I think
> on x86 we have simply been able to avoid using those older iommus.
> 
> I like the direction you are going but please let's put this in a
> paranoid iommu enable routine.
> 
You mean like initialize the device table so that all devices are default
disabled on boot, and then selectively enable them (perhaps during a
device_attach)?  I can give that a spin.
Neil

> Eric
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
