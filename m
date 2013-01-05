Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754997Ab3AEIN2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2013 03:13:28 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:51079 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754706Ab3AEINZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2013 03:13:25 -0500
Message-ID: <1357373590.5690.172.camel@marge.simpson.net>
Subject: Re: sched: Consequences of integrating the Per Entity Load Tracking
 Metric into the Load Balancer
From: Mike Galbraith <bitbucket@online.de>
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "svaidy@linux.vnet.ibm.com" <svaidy@linux.vnet.ibm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        Paul McKenney <paul.mckenney@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Ingo Molnar <mingo@kernel.org>, Paul Turner <pjt@google.com>,
        Venki Pallipadi <venki@google.com>,
        Robin Randhawa <robin.randhawa@arm.com>,
        Lists linaro-dev <linaro-dev@lists.linaro.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Alex Shi <alex.shi@intel.com>,
        srikar@linux.vnet.ibm.com
Date: Sat, 05 Jan 2013 09:13:10 +0100
In-Reply-To: <50E55F99.6090104@linux.vnet.ibm.com>
References: <50E3B61A.3040808@linux.vnet.ibm.com>
	 <1357114354.5586.39.camel@marge.simpson.net>
	 <50E55F99.6090104@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:P+aHOFj6BGjR4MCHFrwIVHofw5l+Hsf5/fwANLKCSP3
 o1Z2ZXA6kH7xvHba/lOhJ8iDDr2FYtVBdRCo8CCtjN1jw+ncY+
 af7SuNP+hFHu3YJOFGNmi/BDZiX/uV6CjRcS1O01zssT1WaQPG
 RlrDzEpIPs1KGLnS+sA4EqxA3LfYVRHWN9CSEJ++1oniVARHUS
 +xiOucrFMoYYQYjMvUaRTDLKEMSdzfueKKYjqbp/wglmPwATky
 cGlqtc8VkkUvpxa+H3cjDRmnpPaRvzxiVVI6zg6xMlweY0bI4/
 HJBhkz+RzYfdLmYrBwE+8ydJAW3j7ir0JdEvh/3V9r3QOXoKjD
 HqewnO5KDG7GiwmLJbXuxGcpZHXFeoNBojUE4rYv/Ijyfu1Koj
 0SqIiQQFpO06w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-01-03 at 16:08 +0530, Preeti U Murthy wrote:

> Subject: [PATCH] sched: Merge select_idle_sibling with the behaviour of SD_BALANCE_WAKE
> 
> The function of select_idle_sibling() is to place the woken up task in the
> vicinity of the waking cpu or on the previous cpu depending on what wake_affine() says.
> This placement being only in an idle group.If an idle group is not found,the
> fallback cpu is either the waking cpu or the previous cpu accordingly.
> 
> This results in the runqueue of the waking cpu or the previous cpu getting
> overloaded when the system is committed,which is a latency hit to these tasks.
> 
> What is required is that the newly woken up tasks be placed close to the wake
> up cpu or the previous cpu,whichever is best, for reasons to avoid latency hit and cache
> coldness respectively.This is achieved with wake_affine() deciding which
> cache domain the task should be placed on.
> 
> Once this is decided,instead of searching for a completely idle group,let us
> search for the idlest group.This will anyway return a completely idle group
> if it exists and its mechanism will fall back to what select_idle_sibling()
> was doing.But if this fails,find_idlest_group() continues the search for a
> relatively more idle group.
> 
> The argument could be that,we wish to avoid migration of the newly woken up
> task to any other group unless it is completely idle.But in this case, to
> begin with we choose a sched domain,within which a migration could be less
> harmful.We enable the SD_BALANCE_WAKE flag on the SMT and MC domains to co-operate
> with the same.

What if..

Fast movers currently suffer from traversing large package, mostly due
to traversal order walking 1:1 buddies hand in hand across the whole
package endlessly.  With only one buddy pair running, it's horrific.

Even if you change the order to be friendlier, perturbation induces
bouncing.  More spots to bounce too equals more bouncing.  Ergo, I cross
coupled cpu pairs to eliminate that.  If buddies are perturbed, having
one and only one buddy cpu pulls them back together, so can't induce a
bounce fest, only correct.  That worked well, but had the down side that
some loads really REALLY want maximum spread, so suffer when you remove
migration options as I did.  There's in_interrupt() consideration I'm
not so sure of too, in that case, going the extra mile to find an idle
hole to plug _may_ be worth some extra cost too.. dunno.  

So wrt integration, what if a buddy cpu were made a FIRST choice of
generic wake balancing vs the ONLY choice of select_idle_sibling() as I
did?  If buddy cpu is available, cool, perturbed pairs find each other
and pair back up, if not, and you were here too recently, you stay with
prev_cpu, avoid bounce and traversal at high frequency.  All tasks can
try the cheap buddy cpu first, all can try full domain as well, just not
at insane rates.  The heavier the short term load average (or such, with
instant decay on longish idle ala idle balance throttle so you ramp
well), the longer the 'forget eating full balance' interval becomes,
with cutoff affecting the cheap but also not free cross coupled buddy
cpu as well at some point.  Looking for an idle cpu at hefty load is a
waste of cycles at best, plugging micro-holes does nothing good even if
you find one, forget wake balance entirely at some cutoff, let periodic
balancing do it's thing in peace.

Hrmph, that's too many words, but basically, I think whacking
select_idle_sibling() integration into wake balance makes loads of
sense, but needs a bit more to not end up just moving the problems to a
different spot.

I still have a 2.6-rt problem I need to find time to squabble with, but
maybe I'll soonish see if what you did plus what I did combined works
out on that 4x10 core box where current is _so_ unbelievably horrible.
Heck, it can't get any worse, and the restricted wake balance alone
kinda sorta worked.

-Mike

