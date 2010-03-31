Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756756Ab0CaS2p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 14:28:45 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:35262 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756059Ab0CaS2n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 14:28:43 -0400
Date: Wed, 31 Mar 2010 14:28:24 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: iommu@lists.linux-foundation.org, joerg.roedel@amd.com, hbabu@us.ibm.com,
       kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] amd iommu: force flush of iommu prior during shutdown
Message-ID: <20100331182824.GC13406@hmsreliant.think-freely.org>
References: <20100331152417.GB13406@hmsreliant.think-freely.org>
 <20100331155430.GF14011@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100331155430.GF14011@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-Spam-Score: -2.9 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 31, 2010 at 11:54:30AM -0400, Vivek Goyal wrote:
> On Wed, Mar 31, 2010 at 11:24:17AM -0400, Neil Horman wrote:
> > Flush iommu during shutdown
> > 
> > When using an iommu, its possible, if a kdump kernel boot follows a primary
> > kernel crash, that dma operations might still be in flight from the previous
> > kernel during the kdump kernel boot.  This can lead to memory corruption,
> > crashes, and other erroneous behavior, specifically I've seen it manifest during
> > a kdump boot as endless iommu error log entries of the form:
> > AMD-Vi: Event logged [IO_PAGE_FAULT device=00:14.1 domain=0x000d
> > address=0x000000000245a0c0 flags=0x0070]
> > 
> > Followed by an inability to access hard drives, and various other resources.
> > 
> > I've written this fix for it.  In short it just forces a flush of the in flight
> > dma operations on shutdown, so that the new kernel is certain not to have any
> > in-flight dmas trying to complete after we've reset all the iommu page tables,
> > causing the above errors.  I've tested it and it fixes the problem for me quite
> > well.
> 
> CCing Eric also.
> 
> Neil, this is interesting. In the past we noticed similar issues,
> especially on PPC. But I was told that we could not clear the iommu
> mapping entries as we had no control on in flight DMA and if a DMA comes
> later after clearing an entry and entry is not present, it is an error.
> 
Yes, the problem is (as I understand it) is that the triggering of DMA
operations to/from a device doesn't have synchronization with the iommu itself.
I.e. to conduct a dma you have to:

1) map the in-memory buffer to a dma address using something like
pci_map_single.  This results (in systems with an iommu) getting page table
space allocated in the iommu for the translation.

2) triggering the dma to/from the device by tickling whatever hardware the
device has mapped.

3) completing the dma by calling pci_unmap_single (or other function) which
frees the page table space in the iommu

The problem, exactly as you indicate is that on a kdump panic, we might boot the
new kernel and re-enable the iommu with these dmas still in flight.  If we start
messing about with the iommu page tables then, we start getting all sorts of
errors, and other various failures.

> Hence one of the suggestions was not to clear iommu mapping entries but
> reserve some for kdump operation and use those in kdump kernel.
> 
Yeah, thats a solution, but it seems awfully complex to me.  To do that, we need
to teach every iommu we support about kdump, by telling it how much space to
reserve, and when to use it and when not to (i.e. we'd have to tell it to use
the kdump space, vs the normal space dependent on the status of the
reset_devices flag, or something equally unpleasant).

Actually, thinking about it, I'm not sure that will even work, as IIRC the iommu
only has one page table base pointer.  So we would either need to re-write that
pointer to point into the kdump kernels memory space (invalidating the old table
entries, which perpetuates this bug), or we would need to further enhance the
iommu code to be able to access the old page tables via
read_from_oldmem/write_to_oldmem when booting a kdump kernel, wouldn't we?

Using this method, all we really do is try to ensure that, prior to disabling
the iommu, we make sure that any pending dmas are complete.  That way, when we
re-enable the iommu in the kdump kernel, we can safely maniuplate the new page
tables, knowing that no pending dma is using them

In fairness to this debate, my proposal does have a small race condition.  In
the above sequence, because the cpu triggers a dma independently of the setup of
the mapping in the iommu, it is possible that a dma might be triggered
immediately after we flush the iotlb, which may leave an in-flight dma pending
while we boot the kdump kernel.  In practice though, this will never happen.  By
the time we arrive at this code, we've already executed
native_machine_crash_shutdown which:

1) halts all the other cpus in the system
2) disables local interrupts

Because of those two events, we're effectively on a path that we can't be
preempted-from.  So as long as we don't trigger any dma operations between our
return from iommu_shutdown and machine_kexec (which is the next call), we're
safe.


> So this call amd_iommu_flush_all_devices() will be able to tell devices
> that don't do any more DMAs and hence it is safe to reprogram iommu
> mapping entries.
> 
It blocks the cpu until any pending DMA operations are complete.  Hmm, as I
think about it, there is still a small possibility that a device like a NIC
which has several buffers pre-dma-mapped could start a new dma before we
completely disabled the iommu, althought thats small.  I never saw that in my
testing, but hitting that would be fairly difficult I think, since its literally
just a few hundred cycles between the flush and the actual hardware disable
operation.

According to this though:
http://support.amd.com/us/Processor_TechDocs/34434-IOMMU-Rev_1.26_2-11-09.pdf
That window could be closed fairly easily, but simply disabling read and write
permissions for each device table entry prior to calling flush.  If we do that,
then flush the device table, any subsequently started dma operation would just
get noted in the error log, which we could ignore, since we're abot to boot to
the kdump kernel anyway.

Would you like me to respin w/ that modification?

Neil

> 
