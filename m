Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754272Ab0E1AL1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 20:11:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49764 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750831Ab0E1ALZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 20:11:25 -0400
Date: Thu, 27 May 2010 21:10:57 -0300
From: Glauber Costa <glommer@redhat.com>
To: Zachary Amsden <zamsden@redhat.com>
Cc: Avi Kivity <avi@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add Documentation/kvm/msr.txt
Message-ID: <20100528001057.GI3445@mothafucka.localdomain>
References: <1274897088-8587-1-git-send-email-glommer@redhat.com>
 <4BFE2A2F.50209@redhat.com>
 <20100527160248.GF3445@mothafucka.localdomain>
 <4BFED258.40501@redhat.com>
 <20100527203638.GH3445@mothafucka.localdomain>
 <4BFEDDEB.9020700@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BFEDDEB.9020700@redhat.com>
X-ChuckNorris: True
User-Agent: Jack Bauer
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 27, 2010 at 11:02:35AM -1000, Zachary Amsden wrote:
> On 05/27/2010 10:36 AM, Glauber Costa wrote:
> >On Thu, May 27, 2010 at 10:13:12AM -1000, Zachary Amsden wrote:
> >>On 05/27/2010 06:02 AM, Glauber Costa wrote:
> >>>On Thu, May 27, 2010 at 11:15:43AM +0300, Avi Kivity wrote:
> >>>>On 05/26/2010 09:04 PM, Glauber Costa wrote:
> >>>>>This patch adds a file that documents the usage of KVM-specific
> >>>>>MSRs.
> >>>>>
> >>>>Looks good.  A few comments:
> >>>>
> >>>>>+
> >>>>>+Custom MSR list
> >>>>>+--------
> >>>>>+
> >>>>>+The current supported Custom MSR list is:
> >>>>>+
> >>>>>+MSR_KVM_WALL_CLOCK:  0x11
> >>>>>+
> >>>>>+	data: physical address of a memory area.
> >>>>Which must be in guest RAM (i.e., don't point it somewhere random
> >>>>and expect the hypervisor to allocate it for you).
> >>>>
> >>>>Must be aligned to 4 bytes (we don't enforce it though).
> >>>I don't see the reason for it.
> >>>
> >>>If this is a requirement, our own implementation
> >>>is failing to meet it.
> >>It's so the atomic write actually is atomic.
> >Which atomic write? This is the wallclock, we do no atomic writes for
> >querying it. Not to confuse with system time (the other msr).
> >
> >>Stating a 4 -byte
> >>alignment requirement prevents the wall clock from crossing a page
> >>boundary.
> >Yes, but why require it?
> >
> >reading the wallclock is not a hot path for anybody, is usually done
> >just once, and crossing a page boundary here does not pose any correctness
> >issue.
> 
> Little-endian non-atomic page crossing writes will write the small
> part of the wallclock first, so another CPU may observe the
> following wallclock sequence:
> 
> 0x01ff .. 0x0100 .. 0x0200
> 
> Big-endian writes also have similar failure:
> 
> 0x01ff .. 0x02ff .. 0x0200
> 
> This won't happen if there is a single instruction write of the wall
> clock word.

We already specify that users can only trust the value of the wallclock
after we have an even version field.
When we start the update, and during the time of all writes to it,
it is odd, and thus, invalid.
The ABI guarantees to the guest that we'll only bump version
after we're done updating.

So why bother?
