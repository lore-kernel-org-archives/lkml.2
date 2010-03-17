Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753418Ab0CQH1r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 03:27:47 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:41385 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752807Ab0CQH1q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 03:27:46 -0400
Date: Wed, 17 Mar 2010 08:27:27 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Joerg Roedel <joro@8bytes.org>
Cc: Avi Kivity <avi@redhat.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       Jes Sorensen <Jes.Sorensen@redhat.com>, Gleb Natapov <gleb@redhat.com>,
       Zachary Amsden <zamsden@redhat.com>, ziteng.huang@intel.com
Subject: Re: [PATCH] Enhance perf to collect KVM guest os statistics from
 host side
Message-ID: <20100317072727.GB16374@elte.hu>
References: <20100316072449.GB11881@elte.hu>
 <4B9F4D74.4090403@redhat.com>
 <20100316095336.GI7961@elte.hu>
 <4B9F59DE.1060008@redhat.com>
 <20100316102052.GC10069@elte.hu>
 <4B9F603B.4080004@redhat.com>
 <20100316105021.GA14344@elte.hu>
 <4B9F671D.5060001@redhat.com>
 <20100316112500.GA5337@elte.hu>
 <20100316223040.GH13108@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100316223040.GH13108@8bytes.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* oerg Roedel <joro@8bytes.org> wrote:

> On Tue, Mar 16, 2010 at 12:25:00PM +0100, Ingo Molnar wrote:
> > Hm, that sounds rather messy if we want to use it to basically expose kernel 
> > functionality in a guest/host unified way. Is the qemu process discoverable in 
> > some secure way? Can we trust it? Is there some proper tooling available to do 
> > it, or do we have to push it through 2-3 packages to get such a useful feature 
> > done?
> 
> Since we want to implement a pmu usable for the guest anyway why we don't 
> just use a guests perf to get all information we want? [...]

Look at the previous posting of this patch, this is something new and rather 
unique. The main power in the 'perf kvm' kind of instrumentation is to profile 
_both_ the host and the guest on the host, using the same tool (often using 
the same kernel) and using similar workloads, and do profile comparisons using 
'perf diff'.

Note that KVM's in-kernel design makes it easy to offer this kind of 
host/guest shared implementation that Yanmin has created. Other virtulization 
solutions with a poorer design (for example where the hypervisor code base is 
split away from the guest implementation) will have it much harder to create 
something similar.

That kind of integrated approach can result in very interesting finds straight 
away, see:

  http://lkml.indiana.edu/hypermail/linux/kernel/1003.0/00613.html

( the profile there demoes the need for spinlock accelerators for example - 
  there's clearly assymetrically large overhead in guest spinlock code. Guess 
  how much else we'll be able to find with a full 'perf kvm' implementation. )

One of the main goals of a virtualization implementation is to eliminate as 
many performance differences to the host kernel as possible. From the first 
day KVM was released the overriding question from users was always: 'how much 
slower is it than native, and which workloads are hit worst, and why, and 
could you pretty please speed up important workload XYZ'.

'perf kvm' helps exactly that kind of development workflow.

Note that with oprofile you can already do separate guest space and host space 
profiling (with the timer driven fallbackin the guest). One idea with 'perf 
kvm' is to change that paradigm of forced separation and forced duplication 
and to supprt the workflow that most developers employ: use the host space for 
development and unify instrumentation in an intuitive framework. Yanmin's 
'perf kvm' patch is a very good step towards that goal.

Anyway ... look at the patches, try them and see it for yourself. Back in the 
days when i did KVM performance work i wish i had something like Yanmin's 
'perf kvm' feature. I'd probably still be hacking KVM today ;-)

So, the code is there, it's useful and it's up to you guys whether you live 
with this opportunity - the perf developers are certainly eager to help out 
with the details. There's already tons of per kernel subsystem perf helper 
tools: perf sched, perf kmem, perf lock, perf bench, perf timechart.

'perf kvm' is really a natural and good next step IMO that underlines the main 
design goodness KVM brought to the world of virtualization: proper guest/host 
code base integration.

Thanks,

	Ingo
