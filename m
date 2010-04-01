Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757139Ab0DAP4v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 11:56:51 -0400
Received: from 8bytes.org ([88.198.83.132]:44845 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756998Ab0DAP4p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 11:56:45 -0400
Date: Thu, 1 Apr 2010 17:56:43 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, kexec@lists.infradead.org,
       linux-kernel@vger.kernel.org, hbabu@us.ibm.com,
       iommu@lists.linux-foundation.org, Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH] amd iommu: force flush of iommu prior during shutdown
Message-ID: <20100401155643.GG24846@8bytes.org>
References: <20100331152417.GB13406@hmsreliant.think-freely.org> <20100331155430.GF14011@redhat.com> <20100331182824.GC13406@hmsreliant.think-freely.org> <m1wrwsuxn9.fsf@fess.ebiederm.org> <20100331191811.GD13406@hmsreliant.think-freely.org> <m1sk7guv5u.fsf@fess.ebiederm.org> <20100331202745.GE13406@hmsreliant.think-freely.org> <20100401142902.GF24846@8bytes.org> <20100401144736.GA14069@shamino.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100401144736.GA14069@shamino.rdu.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 01, 2010 at 10:47:36AM -0400, Neil Horman wrote:
> On Thu, Apr 01, 2010 at 04:29:02PM +0200, Joerg Roedel wrote:
> > I am back in office next tuesday and will look into this problem too.
> > 
> Thank you.

Just took a look and I think the problem is that the devices are
attached to domains before the IOMMU hardware is enabled. This happens
in the function prealloc_protection_domains(). The attach code issues
the dte-invalidate commands but they are not executed because the
hardware is off. I will verify this when I have access to hardware
again.
The possible fix will be to enable the hardware earlier in the
initialization path.

> > Right. The default for all devices is to forbid DMA.
> > 
> Thanks, glad to know I read that right, took me a bit to understand it :)

I should probably add a comment :-)

> > Thats indeed true. I have seen that with ixgbe cards for example. They
> > seem to be really confused after an target abort.
> > 
> Yeah, this part worries me, target aborts lead to various brain dead hardware
> pieces.  What are you thoughts on leaving the iommu on through a reboot to avoid
> this issue (possibly resetting any pci device that encounters a target abort, as
> noted in the error log on the iommu?

This would only prevent possible data corruption. When the IOMMU is off
the devices will not get a target abort but will only write to different
physical memory locations. The window where a target abort can happen
starts when the kdump kernel re-enables the IOMMU and ends when the new
driver for that device attaches. This is a small window but there is not
a lot we can do to avoid this small time window.

	Joerg

