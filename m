Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755247Ab0FRPtV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 11:49:21 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:60349 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753036Ab0FRPtU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 11:49:20 -0400
Subject: Re: [RFC][PATCH 9/9] make kvm mmu shrinker more aggressive
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Avi Kivity <avi@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
In-Reply-To: <1276701911.6437.16973.camel@nimitz>
References: <20100615135518.BC244431@kernel.beaverton.ibm.com>
	 <20100615135530.4565745D@kernel.beaverton.ibm.com>
	 <4C189830.2070300@redhat.com>  <1276701911.6437.16973.camel@nimitz>
Content-Type: text/plain
Date: Fri, 18 Jun 2010 08:49:16 -0700
Message-Id: <1276876156.6437.23323.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-06-16 at 08:25 -0700, Dave Hansen wrote:
> On Wed, 2010-06-16 at 12:24 +0300, Avi Kivity wrote:
> > On 06/15/2010 04:55 PM, Dave Hansen wrote:
> > > In a previous patch, we removed the 'nr_to_scan' tracking.
> > > It was not being used to track the number of objects
> > > scanned, so we stopped using it entirely.  Here, we
> > > strart using it again.
> > >
> > > The theory here is simple; if we already have the refcount
> > > and the kvm->mmu_lock, then we should do as much work as
> > > possible under the lock.  The downside is that we're less
> > > fair about the KVM instances from which we reclaim.  Each
> > > call to mmu_shrink() will tend to "pick on" one instance,
> > > after which it gets moved to the end of the list and left
> > > alone for a while.
> > >    
> > 
> > That also increases the latency hit, as well as a potential fault storm, 
> > on that instance.  Spreading out is less efficient, but smoother.
> 
> This is probably something that we need to go back and actually measure.
> My suspicion is that, when memory fills up and this shrinker is getting
> called a lot, it will be naturally fair.  That list gets shuffled around
> enough, and mmu_shrink() called often enough that no VMs get picked on
> too unfairly.
> 
> I'll go back and see if I can quantify this a bit, though.

The shrink _query_ (mmu_shrink() with nr_to_scan=0) code is called
really, really often.  Like 5,000-10,000 times a second during lots of
VM pressure.  But, it's almost never called on to actually shrink
anything.

Over the 20 minutes or so that I tested, I saw about 700k calls to
mmu_shrink().  But, only 6 (yes, six) calls that had a non-zero
nr_to_scan.  I'm not sure whether this is because of the .seeks argument
to the shrinker or what, but the slab code stays far, far away from
making mmu_shrink() do much real work.

That changes a few things.  I bet all the contention we were seeing was
just from nr_to_scan=0 calls and not from actual shrink operations.
Perhaps we should just stop this set after patch 4.

Any thoughts?

-- Dave

