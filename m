Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933807Ab0FCKWX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 06:22:23 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34832 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933749Ab0FCKWT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 06:22:19 -0400
Date: Thu, 3 Jun 2010 20:22:12 +1000
From: Nick Piggin <npiggin@suse.de>
To: Andi Kleen <andi@firstfloor.org>
Cc: Srivatsa Vaddagiri <vatsa@in.ibm.com>, Avi Kivity <avi@redhat.com>,
       Gleb Natapov <gleb@redhat.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de,
       mtosatti@redhat.com
Subject: Re: [PATCH] use unfair spinlock when running on hypervisor.
Message-ID: <20100603102212.GF6822@laptop>
References: <87sk56ycka.fsf@basil.nowhere.org>
 <20100601162414.GA6191@redhat.com>
 <20100601163807.GA11880@basil.fritz.box>
 <4C053ACC.5020708@redhat.com>
 <20100601172730.GB11880@basil.fritz.box>
 <4C05C722.1010804@redhat.com>
 <20100602085055.GA14221@basil.fritz.box>
 <4C061DAB.6000804@redhat.com>
 <20100603042051.GA5953@linux.vnet.ibm.com>
 <20100603085251.GA4166@basil.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100603085251.GA4166@basil.fritz.box>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 03, 2010 at 10:52:51AM +0200, Andi Kleen wrote:
> On Thu, Jun 03, 2010 at 09:50:51AM +0530, Srivatsa Vaddagiri wrote:
> > On Wed, Jun 02, 2010 at 12:00:27PM +0300, Avi Kivity wrote:
> > > 
> > > There are two separate problems: the more general problem is that
> > > the hypervisor can put a vcpu to sleep while holding a lock, causing
> > > other vcpus to spin until the end of their time slice.  This can
> > > only be addressed with hypervisor help.
> > 
> > Fyi - I have a early patch ready to address this issue. Basically I am using
> > host-kernel memory (mmap'ed into guest as io-memory via ivshmem driver) to hint 
> > host whenever guest is in spin-lock'ed section, which is read by host scheduler 
> > to defer preemption.
> 
> Looks like a ni.ce simple way to handle this for the kernel.
> 
> However I suspect user space will hit the same issue sooner
> or later. I assume your way is not easily extensable to futexes?

Well userspace has always had the problem, hypervisor or not. So
sleeping locks obviously help a lot with that.

But we do hit the problem at times. The MySQL sysbench scalability
problem was a fine example

http://ozlabs.org/~anton/linux/sysbench/

Performance would tank when threads oversubscribe CPUs because lock
holders would start getting preempted.

This was due to nasty locking in MySQL as well, mind you.

There are some ways to improve it. glibc I believe has an option to
increase thread priority when taking a mutex, which is similar to
what we have here.

But it's a fairly broad problem for userspace. The resource may not
be just a lock but it could be IO as well.

 
