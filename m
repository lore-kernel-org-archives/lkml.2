Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754805Ab2IQIEf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 04:04:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1414 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754664Ab2IQIEa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 04:04:30 -0400
Date: Mon, 17 Sep 2012 10:02:38 +0200
From: Andrew Jones <drjones@redhat.com>
To: Konrad Rzeszutek Wilk <konrad@kernel.org>
Cc: habanero@linux.vnet.ibm.com,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Rik van Riel <riel@redhat.com>,
        KVM <kvm@vger.kernel.org>, chegu vinod <chegu_vinod@hp.com>,
        LKML <linux-kernel@vger.kernel.org>, X86 <x86@kernel.org>,
        Gleb Natapov <gleb@redhat.com>,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>, rkrcmar@redhat.com
Subject: Re: [RFC][PATCH] Improving directed yield scalability for PLE handler
Message-ID: <20120917080237.GA2104@turtle.usersys.redhat.com>
References: <1347283005.10325.55.camel@oc6622382223.ibm.com>
 <1347293035.2124.22.camel@twins>
 <20120910165653.GA28033@linux.vnet.ibm.com>
 <1347297124.2124.42.camel@twins>
 <1347307972.7332.78.camel@oc2024037011.ibm.com>
 <504ED54E.6040608@linux.vnet.ibm.com>
 <1347388061.19098.20.camel@oc2024037011.ibm.com>
 <20120913114813.GA11797@linux.vnet.ibm.com>
 <1347571858.5586.44.camel@oc2024037011.ibm.com>
 <CACJDEmqP7u0R_TmgZ2O=3vDS0DG5fOZLwBJ0pnviWiTehn92OA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACJDEmqP7u0R_TmgZ2O=3vDS0DG5fOZLwBJ0pnviWiTehn92OA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 14, 2012 at 04:34:24PM -0400, Konrad Rzeszutek Wilk wrote:
> > The concern I have is that even though we have gone through changes to
> > help reduce the candidate vcpus we yield to, we still have a very poor
> > idea of which vcpu really needs to run.  The result is high cpu usage in
> > the get_pid_task and still some contention in the double runqueue lock.
> > To make this scalable, we either need to significantly reduce the
> > occurrence of the lock-holder preemption, or do a much better job of
> > knowing which vcpu needs to run (and not unnecessarily yielding to vcpus
> > which do not need to run).
> 
> The patches that Raghavendra  has been posting do accomplish that.
> >
> > On reducing the occurrence:  The worst case for lock-holder preemption
> > is having vcpus of same VM on the same runqueue.  This guarantees the
> > situation of 1 vcpu running while another [of the same VM] is not.  To
> > prove the point, I ran the same test, but with vcpus restricted to a
> > range of host cpus, such that any single VM's vcpus can never be on the
> > same runqueue.  In this case, all 10 VMs' vcpu-0's are on host cpus 0-4,
> > vcpu-1's are on host cpus 5-9, and so on.  Here is the result:
> >
> > kvm_cpu_spin, and all
> > yield_to changes, plus
> > restricted vcpu placement:  8823 +/- 3.20%   much, much better
> >
> > On picking a better vcpu to yield to:  I really hesitate to rely on
> > paravirt hint [telling us which vcpu is holding a lock], but I am not
> > sure how else to reduce the candidate vcpus to yield to.  I suspect we
> > are yielding to way more vcpus than are prempted lock-holders, and that
> > IMO is just work accomplishing nothing.  Trying to think of way to
> > further reduce candidate vcpus....
> 
> ... the patches are posted -  you could try them out?

Radim and I have done some testing with the pvticketlock series. While we
saw a gain over PLE alone, it wasn't huge, and without PLE also enabled it
could hardly support 2.0x overcommit. spinlocks aren't the only place
where cpu_relax() is called within a relatively tight loop, so it's likely
that PLE yielding just generally helps by getting schedule() called more
frequently.

Drew
