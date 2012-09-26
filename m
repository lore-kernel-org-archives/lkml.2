Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756000Ab2IZMir (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 08:38:47 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:56412 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754025Ab2IZMip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 08:38:45 -0400
Date: Wed, 26 Sep 2012 08:27:26 -0400
From: Konrad Rzeszutek Wilk <konrad@kernel.org>
To: Dor Laor <dlaor@redhat.com>
Cc: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Chegu Vinod <chegu_vinod@hp.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Avi Kivity <avi@redhat.com>, Rik van Riel <riel@redhat.com>,
        Srikar <srikar@linux.vnet.ibm.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, Jiannan Ouyang <ouyang@cs.pitt.edu>,
        "Andrew M. Theurer" <habanero@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>,
        Gleb Natapov <gleb@redhat.com>, Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH RFC 0/2] kvm: Improving undercommit,overcommit scenarios
 in PLE handler
Message-ID: <20120926122725.GE7356@phenom.dumpdata.com>
References: <20120921115942.27611.67488.sendpatchset@codeblue>
 <505C691D.4080801@hp.com>
 <505CA5BA.4020801@linux.vnet.ibm.com>
 <50601CE7.60801@redhat.com>
 <50604BF0.1070607@linux.vnet.ibm.com>
 <5061C70E.2090308@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5061C70E.2090308@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 25, 2012 at 05:00:30PM +0200, Dor Laor wrote:
> On 09/24/2012 02:02 PM, Raghavendra K T wrote:
> >On 09/24/2012 02:12 PM, Dor Laor wrote:
> >>In order to help PLE and pvticketlock converge I thought that a small
> >>test code should be developed to test this in a predictable,
> >>deterministic way.
> >>
> >>The idea is to have a guest kernel module that spawn a new thread each
> >>time you write to a /sys/.... entry.
> >>
> >>Each such a thread spins over a spin lock. The specific spin lock is
> >>also chosen by the /sys/ interface. Let's say we have an array of spin
> >>locks *10 times the amount of vcpus.
> >>
> >>All the threads are running a
> >>while (1) {
> >>
> >>spin_lock(my_lock);
> >>sum += execute_dummy_cpu_computation(time);
> >>spin_unlock(my_lock);
> >>
> >>if (sys_tells_thread_to_die()) break;
> >>}
> >>
> >>print_result(sum);
> >>
> >>Instead of calling the kernel's spin_lock functions, clone them and make
> >>the ticket lock order deterministic and known (like a linear walk of all
> >>the threads trying to catch that lock).
> >
> >By Cloning you mean hierarchy of the locks?
> 
> No, I meant to clone the implementation of the current spin lock
> code in order to set any order you may like for the ticket
> selection.
> (even for a non pvticket lock version)

Wouldn't that defeat the purpose of trying the test the different
implementations that try to fix the lock-holder preemption problem?
You want something that you can shoe-in for all work-loads - also
for this test system.
> 
> For instance, let's say you have N threads trying to grab the lock,
> you can always make the ticket go linearly from 1->2...->N.
> Not sure it's a good idea, just a recommendation.

So round-robin. Could you make NCPUS threads, pin them to CPUs, and set
them to be SCHED_RR? Or NCPUS*2 to overcommit.

> 
> >Also I believe time should be passed via sysfs / hardcoded for each
> >type of lock we are mimicking
> 
> Yap
> 
> >
> >>
> >>This way you can easy calculate:
> >>1. the score of a single vcpu running a single thread
> >>2. the score of sum of all thread scores when #thread==#vcpu all
> >>taking the same spin lock. The overall sum should be close as
> >>possible to #1.
> >>3. Like #2 but #threads > #vcpus and other versions of #total vcpus
> >>(belonging to all VMs) > #pcpus.
> >>4. Create #thread == #vcpus but let each thread have it's own spin
> >>lock
> >>5. Like 4 + 2
> >>
> >>Hopefully this way will allows you to judge and evaluate the exact
> >>overhead of scheduling VMs and threads since you have the ideal result
> >>in hand and you know what the threads are doing.
> >>
> >>My 2 cents, Dor
> >>
> >
> >Thank you,
> >I think this is an excellent idea. ( Though I am trying to put all the
> >pieces together you mentioned). So overall we should be able to measure
> >the performance of pvspinlock/PLE improvements with a deterministic
> >load in guest.
> >
> >Only thing I am missing is,
> >How to generate different combinations of the lock.
> >
> >Okay, let me see if I can come with a solid model for this.
> >
> 
> Do you mean the various options for PLE/pvticket/other? I haven't
> thought of it and assumed its static but it can also be controlled
> through the temporary /sys interface.
> 
> Thanks for following up!
> Dor
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
