Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752460Ab2CHK2T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 05:28:19 -0500
Received: from casper.infradead.org ([85.118.1.10]:47870 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751876Ab2CHK2R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 05:28:17 -0500
Message-ID: <1331202480.11248.375.camel@twins>
Subject: Re: runnable tasks never making it to a runqueue where they can run?
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Roland Dreier <roland@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Paul Turner <pjt@google.com>, Venkatesh Pallipadi <venki@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Date: Thu, 08 Mar 2012 11:28:00 +0100
In-Reply-To: <CAG4TOxM2yGvFo5O9x0M6H2GONPyF9XVOLwonfS-1gkpskkO+0w@mail.gmail.com>
References: <CAL1RGDUbxcx+cCM_mf1nFJ=Jz0SyaiW0ffxiY4gZ6KNWzJCnMg@mail.gmail.com>
	 <1331137905.11248.355.camel@twins>
	 <CAG4TOxM2yGvFo5O9x0M6H2GONPyF9XVOLwonfS-1gkpskkO+0w@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-03-07 at 10:03 -0800, Roland Dreier wrote:
> 
> So could the fact that we don't have CPU 11 in our affinity
> mask cause the scheduler not to try the CPU 23 runqueue?
> Is it only looking at the first SMT sibling or something? 

Yes, I think we've conspired against your use-case here.

select_task_rq_fair() will very likely end up in select_idle_sibling()
which will never select the smt1 if smt0 is idle (even if smt0 isn't in
the cpus allowed mask) -- Vatsa is currently reworking that area, this
is something he might want to consider.

The regular load-balancer works by pulling tasks towards itself, this
works on the sched domains, it iterates bottom up through the domains,
but only the first cpu in the specific domain gets to go up.

This means that SMT1 will only ever pull from SMT0, and only SMT0 will
go up to the core level and (possibly) beyond to pull load. Now your
task -- due to its affinity mask -- can never be pulled to SMT0 and
hence will never end up on SMT1.

There's a number of very convoluted hacks in the load-balancer to
kinda-sort-of deal with affinity masks that are miss-aligned wrt the
domain setup, but they're painful and very likely lacking (as
demonstrated here).

For a while I've been toying with the idea of making the least-loaded
cpu in the mask go up in the balance pass -- as opposed to the first cpu
in the mask. This might be the justification, and push, I was needing.

In any case, load-balancing in the presence of affinity masks is an
'interesting' problem :-)
