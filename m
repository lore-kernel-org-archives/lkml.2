Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753321Ab2GTRDB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 13:03:01 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53525 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752855Ab2GTRDA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 13:03:00 -0400
Date: Fri, 20 Jul 2012 10:02:55 -0700
From: Tejun Heo <tj@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        tglx@linutronix.de, linux-pm@vger.kernel.org
Subject: Re: [PATCHSET] workqueue: reimplement CPU hotplug to keep idle
 workers
Message-ID: <20120720170255.GE32763@google.com>
References: <1342545149-3515-1-git-send-email-tj@kernel.org>
 <1342799311.2583.7.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1342799311.2583.7.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, Peter.

On Fri, Jul 20, 2012 at 05:48:31PM +0200, Peter Zijlstra wrote:
> On Tue, 2012-07-17 at 10:12 -0700, Tejun Heo wrote:
> > While this makes rebinding somewhat more complicated, as it has to be
> > able to rebind idle workers too, it allows overall hotplug path to be
> > much simpler.  
> 
> I really don't see the point of re-binding.. at that point you've well
> and proper violated any per-cpu expectation, so why not complete running
> the works on the disassociated thing and let new works accrue on the
> per-cpu things again?

We've discussed this a couple times now, so the existing reasons were,

* Local affinity is more often used as a form of affinity optimization
  since the beginning.  This, mixed with queue_work() /
  queue_work_on(), does make things muddy.

* With local affinity used for optimization, we better support
  detaching running workers - before cmwq, this used to be one of the
  sources of trouble during power state changes.

* So, we have unbound workers which started as bound while a CPU is
  down.  When the CPU comes back up again, we can do one of the
  followings - 1. migrate the unbound ones to WORK_CPU_UNBOUND (can
  also do this on CPU_DOWN), 2. leave them unbound and keep them
  running in parallel with bound ones, or 3. rebind them.  #2 is the
  hariest - it contaminates the usual !hotplug code paths.  #1 or #3,
  unsure, but given how global_cwq's don't usually interact with each
  other, I thought #3 would be lower impact on hot paths.

So, the above was my rationale before this "we need to stop destroying
and re-creating kthreads across CPU hotplug events because phones do
it gazillion times".  Now, I don't think we have any other way.

Thanks.

-- 
tejun
