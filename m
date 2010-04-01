Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756253Ab0DAMvt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 08:51:49 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:33705 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752993Ab0DAMvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 08:51:42 -0400
Date: Thu, 1 Apr 2010 08:49:30 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, iommu@lists.linux-foundation.org,
       joerg.roedel@amd.com, hbabu@us.ibm.com, kexec@lists.infradead.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] amd iommu: force flush of iommu prior during shutdown
Message-ID: <20100401124929.GA13625@shamino.rdu.redhat.com>
References: <20100331152417.GB13406@hmsreliant.think-freely.org>
 <20100331155430.GF14011@redhat.com>
 <20100331182824.GC13406@hmsreliant.think-freely.org>
 <m1wrwsuxn9.fsf@fess.ebiederm.org>
 <20100331191811.GD13406@hmsreliant.think-freely.org>
 <m1sk7guv5u.fsf@fess.ebiederm.org>
 <20100331202745.GE13406@hmsreliant.think-freely.org>
 <m1vdcbstro.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1vdcbstro.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-Spam-Score: -2.9 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 31, 2010 at 09:04:27PM -0700, Eric W. Biederman wrote:
> Neil Horman <nhorman@tuxdriver.com> writes:
> 
> > On Wed, Mar 31, 2010 at 12:51:25PM -0700, Eric W. Biederman wrote:
> >> Neil Horman <nhorman@tuxdriver.com> writes:
> >> 
> >> > On Wed, Mar 31, 2010 at 11:57:46AM -0700, Eric W. Biederman wrote:
> >> >> Neil Horman <nhorman@tuxdriver.com> writes:
> >> >> 
> >> >> > On Wed, Mar 31, 2010 at 11:54:30AM -0400, Vivek Goyal wrote:
> >> >> 
> >> >> >> So this call amd_iommu_flush_all_devices() will be able to tell devices
> >> >> >> that don't do any more DMAs and hence it is safe to reprogram iommu
> >> >> >> mapping entries.
> >> >> >> 
> >> >> > It blocks the cpu until any pending DMA operations are complete.  Hmm, as I
> >> >> > think about it, there is still a small possibility that a device like a NIC
> >> >> > which has several buffers pre-dma-mapped could start a new dma before we
> >> >> > completely disabled the iommu, althought thats small.  I never saw that in my
> >> >> > testing, but hitting that would be fairly difficult I think, since its literally
> >> >> > just a few hundred cycles between the flush and the actual hardware disable
> >> >> > operation.
> >> >> >
> >> >> > According to this though:
> >> >> > http://support.amd.com/us/Processor_TechDocs/34434-IOMMU-Rev_1.26_2-11-09.pdf
> >> >> > That window could be closed fairly easily, but simply disabling read and write
> >> >> > permissions for each device table entry prior to calling flush.  If we do that,
> >> >> > then flush the device table, any subsequently started dma operation would just
> >> >> > get noted in the error log, which we could ignore, since we're abot to boot to
> >> >> > the kdump kernel anyway.
> >> >> >
> >> >> > Would you like me to respin w/ that modification?
> >> >> 
> >> >> Disabling permissions on all devices sounds good for the new virtualization
> >> >> capable iommus.  I think older iommus will still be challenged.  I think
> >> >> on x86 we have simply been able to avoid using those older iommus.
> >> >> 
> >> >> I like the direction you are going but please let's put this in a
> >> >> paranoid iommu enable routine.
> >> >> 
> >> > You mean like initialize the device table so that all devices are default
> >> > disabled on boot, and then selectively enable them (perhaps during a
> >> > device_attach)?  I can give that a spin.
> >> 
> >> That sounds good.
> >> 
> >
> > So I'm officially rescinding this patch.  It apparently just covered up the
> > problem, rather than solved it outright.  This is going to take some more
> > thought on my part.  I read the code a bit closer, and the amd iommu on boot up
> > currently marks all its entries as valid and having a valid translation (because
> > if they're marked as invalid they're passed through untranslated which strikes
> > me as dangerous, since it means a dma address treated as a bus address could
> > lead to memory corruption.  The saving grace is that they are marked as
> > non-readable and non-writeable, so any device doing a dma after the reinit
> > should get logged (which it does), and then target aborted (which should
> > effectively squash the translation)
> >
> > I'm starting to wonder if:
> >
> > 1) some dmas are so long lived they start aliasing new dmas that get mapped in
> > the kdump kernel leading to various erroneous behavior
> 
> I do know things like arp refreshes used to cause me trouble.  I have
> a particular memory of kexec into memtest86 and a little while later 
> memory corruption.
> 
> 
> > 2) a slew of target aborts to some hardware results in them being in an
> > inconsistent state
> >
> > I'm going to try marking the dev table on shutdown such that all devices have no
> > read/write permissions to see if that changes the situation.  It should I think
> > give me a pointer as to weather (1) or (2) is the more likely problem.
> >
> > Lots more thinking to do....
> 
> I guess I can see devices getting confused by target aborts.
> I'm wondering if (a) we can suppress these DMAs.  or (b) we can reset the pci
> devices before we use them.  With pcie that should be possible.
> 
> We used to be able simply not to use the IOMMU in x86 and avoid this trouble.
> Now with per device enables it looks like we need to do something with it.
> 
Agreed.  Another strategy I think worth considering is:
1) Leave the iommu on throughout the kdump reboot process, so as to allow dma's
to complete without any interference

2) Make sure the log configuration is enabled prior to kdump reboot

3) Flush the page table cache in the iommu prior to shutdown

4) on re-init in the kdump kernel, query the log.  If its non-empty, recognize
that we're in a kdump boot, and instead of creating a new devtable/page
table/domain table, just clone the old ones from the previous kernels memory

5) use the log to detect which entries in the iommu have been touched, and
assume those touched entries are done, marking them as invalid, until such time
a minimum of free entries in the table are provided

6) continue use with those available free entries

with this approach, we could let the 'old' dmas complete without interference,
and just allocate new dma's from the unused entries in the new kernel.

Just a thought.
Neil

> Eric
> 
> 
