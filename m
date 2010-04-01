Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751589Ab0DAEEl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 00:04:41 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:59779 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735Ab0DAEEe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 00:04:34 -0400
To: Neil Horman <nhorman@tuxdriver.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, iommu@lists.linux-foundation.org,
       joerg.roedel@amd.com, hbabu@us.ibm.com, kexec@lists.infradead.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] amd iommu: force flush of iommu prior during shutdown
References: <20100331152417.GB13406@hmsreliant.think-freely.org>
	<20100331155430.GF14011@redhat.com>
	<20100331182824.GC13406@hmsreliant.think-freely.org>
	<m1wrwsuxn9.fsf@fess.ebiederm.org>
	<20100331191811.GD13406@hmsreliant.think-freely.org>
	<m1sk7guv5u.fsf@fess.ebiederm.org>
	<20100331202745.GE13406@hmsreliant.think-freely.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Wed, 31 Mar 2010 21:04:27 -0700
In-Reply-To: <20100331202745.GE13406@hmsreliant.think-freely.org> (Neil Horman's message of "Wed\, 31 Mar 2010 16\:27\:45 -0400")
Message-ID: <m1vdcbstro.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: nhorman@tuxdriver.com, linux-kernel@vger.kernel.org, kexec@lists.infradead.org, hbabu@us.ibm.com, joerg.roedel@amd.com, iommu@lists.linux-foundation.org, vgoyal@redhat.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Neil Horman <nhorman@tuxdriver.com> writes:

> On Wed, Mar 31, 2010 at 12:51:25PM -0700, Eric W. Biederman wrote:
>> Neil Horman <nhorman@tuxdriver.com> writes:
>> 
>> > On Wed, Mar 31, 2010 at 11:57:46AM -0700, Eric W. Biederman wrote:
>> >> Neil Horman <nhorman@tuxdriver.com> writes:
>> >> 
>> >> > On Wed, Mar 31, 2010 at 11:54:30AM -0400, Vivek Goyal wrote:
>> >> 
>> >> >> So this call amd_iommu_flush_all_devices() will be able to tell devices
>> >> >> that don't do any more DMAs and hence it is safe to reprogram iommu
>> >> >> mapping entries.
>> >> >> 
>> >> > It blocks the cpu until any pending DMA operations are complete.  Hmm, as I
>> >> > think about it, there is still a small possibility that a device like a NIC
>> >> > which has several buffers pre-dma-mapped could start a new dma before we
>> >> > completely disabled the iommu, althought thats small.  I never saw that in my
>> >> > testing, but hitting that would be fairly difficult I think, since its literally
>> >> > just a few hundred cycles between the flush and the actual hardware disable
>> >> > operation.
>> >> >
>> >> > According to this though:
>> >> > http://support.amd.com/us/Processor_TechDocs/34434-IOMMU-Rev_1.26_2-11-09.pdf
>> >> > That window could be closed fairly easily, but simply disabling read and write
>> >> > permissions for each device table entry prior to calling flush.  If we do that,
>> >> > then flush the device table, any subsequently started dma operation would just
>> >> > get noted in the error log, which we could ignore, since we're abot to boot to
>> >> > the kdump kernel anyway.
>> >> >
>> >> > Would you like me to respin w/ that modification?
>> >> 
>> >> Disabling permissions on all devices sounds good for the new virtualization
>> >> capable iommus.  I think older iommus will still be challenged.  I think
>> >> on x86 we have simply been able to avoid using those older iommus.
>> >> 
>> >> I like the direction you are going but please let's put this in a
>> >> paranoid iommu enable routine.
>> >> 
>> > You mean like initialize the device table so that all devices are default
>> > disabled on boot, and then selectively enable them (perhaps during a
>> > device_attach)?  I can give that a spin.
>> 
>> That sounds good.
>> 
>
> So I'm officially rescinding this patch.  It apparently just covered up the
> problem, rather than solved it outright.  This is going to take some more
> thought on my part.  I read the code a bit closer, and the amd iommu on boot up
> currently marks all its entries as valid and having a valid translation (because
> if they're marked as invalid they're passed through untranslated which strikes
> me as dangerous, since it means a dma address treated as a bus address could
> lead to memory corruption.  The saving grace is that they are marked as
> non-readable and non-writeable, so any device doing a dma after the reinit
> should get logged (which it does), and then target aborted (which should
> effectively squash the translation)
>
> I'm starting to wonder if:
>
> 1) some dmas are so long lived they start aliasing new dmas that get mapped in
> the kdump kernel leading to various erroneous behavior

I do know things like arp refreshes used to cause me trouble.  I have
a particular memory of kexec into memtest86 and a little while later 
memory corruption.


> 2) a slew of target aborts to some hardware results in them being in an
> inconsistent state
>
> I'm going to try marking the dev table on shutdown such that all devices have no
> read/write permissions to see if that changes the situation.  It should I think
> give me a pointer as to weather (1) or (2) is the more likely problem.
>
> Lots more thinking to do....

I guess I can see devices getting confused by target aborts.
I'm wondering if (a) we can suppress these DMAs.  or (b) we can reset the pci
devices before we use them.  With pcie that should be possible.

We used to be able simply not to use the IOMMU in x86 and avoid this trouble.
Now with per device enables it looks like we need to do something with it.

Eric

