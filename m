Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753068Ab2GTQwU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 12:52:20 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:51916 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752890Ab2GTQwS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 12:52:18 -0400
Date: Fri, 20 Jul 2012 09:52:13 -0700
From: Tejun Heo <tj@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        tglx@linutronix.de, linux-pm@vger.kernel.org
Subject: Re: [PATCHSET] workqueue: reimplement CPU hotplug to keep idle
 workers
Message-ID: <20120720165213.GD32763@google.com>
References: <1342545149-3515-1-git-send-email-tj@kernel.org>
 <1342802391.2583.11.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1342802391.2583.11.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Peter.

On Fri, Jul 20, 2012 at 06:39:51PM +0200, Peter Zijlstra wrote:
> On Tue, 2012-07-17 at 10:12 -0700, Tejun Heo wrote:
> > Currently, workqueue destroys all workers for offline CPUs unless
> > there are lingering work items. 
> 
> _that_ is the root of all ugly in that thing. I still find it utterly
> insane you can create 'per-cpu' workqueues and then violate the per-cpu
> property with hotplug and get your work ran on a different CPU.

Let's talk about this part in the other reply you made.

> It should be a hard error to use queue_work_on() and then run the work
> on a different cpu. Yet somehow this isn't so.

Ooh, yeah, I agree.  That's next on the wq to-do list.  The problem is
that queue_work() is implemented in terms of queue_work_on().  In most
cases, the local binding serves as locality optimization than anything
else.  There are use cases where affinity is required for correctness.
The assumption was that they should flush during CPU_DOWN but it
probably will be much better to require users which need CPU affinity
to always use queue_work_on() - instead of implicit local affinity
from queue_work() - and flush them automatically from wq callback.

Thanks.

-- 
tejun
