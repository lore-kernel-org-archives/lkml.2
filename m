Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758614Ab0FCJ0U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 05:26:20 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:43218 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758102Ab0FCJ0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 05:26:19 -0400
Date: Thu, 3 Jun 2010 14:56:13 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Avi Kivity <avi@redhat.com>, Gleb Natapov <gleb@redhat.com>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org, hpa@zytor.com,
       mingo@elte.hu, npiggin@suse.de, tglx@linutronix.de, mtosatti@redhat.com
Subject: Re: [PATCH] use unfair spinlock when running on hypervisor.
Message-ID: <20100603092612.GE4035@linux.vnet.ibm.com>
Reply-To: vatsa@in.ibm.com
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
> > Fyi - I have a early patch ready to address this issue. Basically I am using
> > host-kernel memory (mmap'ed into guest as io-memory via ivshmem driver) to hint 
> > host whenever guest is in spin-lock'ed section, which is read by host scheduler 
> > to defer preemption.
> 
> Looks like a ni.ce simple way to handle this for the kernel.

The idea is not new. It has been discussed for example at [1].

> However I suspect user space will hit the same issue sooner
> or later. I assume your way is not easily extensable to futexes?

I had thought that most userspace lock implementation avoid spinning for long
times? i.e they would spin for a short while and sleep beyond a threshold?
If that is the case, we shouldn't be burning lot of cycles unnecessarily
spinning in userspace ..

> So do you defer during the whole spinlock region or just during the spin?
> 
> I assume the the first?

My current implementation just blindly defers by a tick and checks if it is safe
to preempt in the next tick - otherwise gives more grace ticks until the
threshold is crossed (after which we forcibly preempt it).

In future, I was thinking that host scheduler can hint back to guest that it was
given some "grace" time which can be used in guest to yield when it comes out of
the locked section.

- vatsa

1.  http://l4ka.org/publications/2004/Towards-Scalable-Multiprocessor-Virtual-Machines-VM04.pdf
