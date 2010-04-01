Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932079Ab0DAQVR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 12:21:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11081 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757673Ab0DAQUr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 12:20:47 -0400
Date: Thu, 1 Apr 2010 11:13:22 -0400
From: Neil Horman <nhorman@redhat.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Neil Horman <nhorman@tuxdriver.com>, joerg.roedel@amd.com,
       kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
       Chris Wright <chrisw@sous-sol.org>, hbabu@us.ibm.com,
       iommu@lists.linux-foundation.org
Subject: Re: [PATCH] amd iommu: force flush of iommu prior during shutdown
Message-ID: <20100401151322.GG13603@shamino.rdu.redhat.com>
References: <20100331152417.GB13406@hmsreliant.think-freely.org>
 <20100331212535.GR29241@sequoia.sous-sol.org>
 <20100401011311.GC2069@localhost.localdomain>
 <20100401022418.GA1983@redhat.com>
 <20100401125304.GA13603@shamino.rdu.redhat.com>
 <20100401150203.GD6844@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100401150203.GD6844@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 01, 2010 at 11:02:03AM -0400, Vivek Goyal wrote:
> On Thu, Apr 01, 2010 at 08:53:04AM -0400, Neil Horman wrote:
> > On Wed, Mar 31, 2010 at 10:24:18PM -0400, Vivek Goyal wrote:
> > > On Wed, Mar 31, 2010 at 09:13:11PM -0400, Neil Horman wrote:
> > > > On Wed, Mar 31, 2010 at 02:25:35PM -0700, Chris Wright wrote:
> > > > > * Neil Horman (nhorman@tuxdriver.com) wrote:
> > > > > > Flush iommu during shutdown
> > > > > > 
> > > > > > When using an iommu, its possible, if a kdump kernel boot follows a primary
> > > > > > kernel crash, that dma operations might still be in flight from the previous
> > > > > > kernel during the kdump kernel boot.  This can lead to memory corruption,
> > > > > > crashes, and other erroneous behavior, specifically I've seen it manifest during
> > > > > > a kdump boot as endless iommu error log entries of the form:
> > > > > > AMD-Vi: Event logged [IO_PAGE_FAULT device=00:14.1 domain=0x000d
> > > > > > address=0x000000000245a0c0 flags=0x0070]
> > > > > 
> > > > > We've already fixed this problem once before, so some code shift must
> > > > > have brought it back.  Personally, I prefer to do this on the bringup
> > > > > path than the teardown path.  Besides keeping the teardown path as
> > > > > simple as possible (goal is to get to kdump kernel asap), there's also
> > > > > reason to competely flush on startup in genernal in case BIOS has done
> > > > > anything unsavory.
> > > > > 
> > > > Chris,
> > > > 	Can you elaborate on what you did with the iommu to make this safe?  It
> > > > will save me time digging through the history on this code, and help me
> > > > understand better whats going on here.
> > > > 
> > > > I was starting to think that we should just leave the iommu on through a kdump,
> > > > and re-construct a new page table based on the old table (filtered by the error
> > > > log) on kdump boot, but it sounds like a better solution might be in place.
> > > > 
> > > 
> > > Hi Neil,
> > > 
> > > Is following sequence possible.
> > > 
> > > - In crashed kernel, take away the write permission from all the devices.
> > >   Mark bit 62 zero for all devices in device table.
> > > 
> > > - Leave the iommu on and let the device entries be valid in kdump kernel
> > >   so that any in-flight dma does not become pass through (which can cause
> > >   more damage and corrupt kdump kernel).
> > > 
> > > - During kdump kernel initialization, load a new device table where again
> > >   all the devices don't have write permission. looks like by default
> > >   we create a device table with all bits zero except DEV_ENTRY_VALID
> > >   and DEV_ENTRY_TRANSLATION bit.
> > > 
> > > - Reset the device where we want to setup any dma or operate on.
> > > 
> > > - Allow device to do DMA/write.
> > > 
> > > So by default all the devices will not be able to do write to memory 
> > > and selective devices are given access only after a reset.
> > > 
> > > I am not sure what are the dependencies for loading a new device table
> > > in second kernel. If it requires disabling the IOMMU, then we leave a
> > > window where in-flight dma will become passthrough and has the potential
> > > to corrupt kdump kernel.
> > > 
> > I think this is possible, but I'm a bit concerned with how some devices will
> > handle a reset.  For instance, what will happen to an HBA or a disk, if we reset
> > it as the module is loading?  Is that safe?
> 
> I think we need to reset devices in driver if "reset_devices" is set. So
> we will not reset these during normal boot.
> 
> Regarding being safe, I don't know. I am assuming that driver knows (or
> need to know), how to reset device safely while driver is initializing.
> That's the whole assumption kdump is built on, that once driver is
> initializing, it will first reset the device (if reset_devices is set), so
> that chances of device working properly in second kernel increase.
> 
Yes, I agree, I was more just asking is it safe to unilaterally reset devices
during boot?  I suppose it is, but I'm not entirely sure
Neil

> Vivek
> 
