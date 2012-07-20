Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753323Ab2GTRII (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 13:08:08 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33761 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753168Ab2GTRIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 13:08:06 -0400
Date: Fri, 20 Jul 2012 10:08:02 -0700
From: Tejun Heo <tj@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        tglx@linutronix.de, linux-pm@vger.kernel.org
Subject: Re: [PATCHSET] workqueue: reimplement CPU hotplug to keep idle
 workers
Message-ID: <20120720170802.GF32763@google.com>
References: <1342545149-3515-1-git-send-email-tj@kernel.org>
 <1342802391.2583.11.camel@twins>
 <20120720165213.GD32763@google.com>
 <1342803700.2583.29.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1342803700.2583.29.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Peter.

On Fri, Jul 20, 2012 at 07:01:40PM +0200, Peter Zijlstra wrote:
> On Fri, 2012-07-20 at 09:52 -0700, Tejun Heo wrote:
> > Ooh, yeah, I agree.  That's next on the wq to-do list.  The problem is
> > that queue_work() is implemented in terms of queue_work_on().  
> 
> But that's trivial to fix, both could use __queue_work() without too
> much bother, right?

Hmmm?  Not really.  We need to keep count of the ones which reqested
fixed binding - ie. the ones which explicitly used queue_work_on() -
and then flush on wq CPU_DOWN.  Then, we need to audit the current
users which are using queue_work{_on}() + explicit FLUSH on CPU_DOWN
and convert them.

> > The assumption was that they should flush during CPU_DOWN but it
> > probably will be much better to require users which need CPU affinity
> > to always use queue_work_on() - instead of implicit local affinity
> > from queue_work() - and flush them automatically from wq callback.
> 
> Right, and when you create this new mode, which you need to know to
> flush on DOWN, you can simply put a BUG_ON in queue_work_on() when this
> mode is set.

BUG_ON() on queue_work_on()?  Do you mean if the target CPU is down?
If so, yeah, I'd probably go with WARN_ON_ONCE() but we should whine
on it.

Thanks.

-- 
tejun
