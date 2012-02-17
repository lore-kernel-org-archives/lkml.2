Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752065Ab2BQSHF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 13:07:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30749 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751410Ab2BQSHD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 13:07:03 -0500
Date: Fri, 17 Feb 2012 19:00:11 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: apw@canonical.com, arjan@linux.intel.com, fhrbata@redhat.com,
        john.johansen@canonical.com, rientjes@google.com,
        rusty@rustcorp.com.au, tj@kernel.org, linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Mandeep Singh Baines <msb@chromium.org>
Subject: [PATCH 0/1] hung_task: fix the broken rcu_lock_break() logic
Message-ID: <20120217180011.GA8762@redhat.com>
References: <20120214164914.GF21185@redhat.com> <20120215123049.6e938eed.akpm@linux-foundation.org> <20120216150429.GB11953@redhat.com> <20120216172626.GA30393@redhat.com> <20120216173233.GF30393@redhat.com> <201202172211.CGH81726.OStOJFLFHQVMFO@I-love.SAKURA.ne.jp> <20120217150726.GD22440@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120217150726.GD22440@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/17, Oleg Nesterov wrote:
>
> On 02/17, Tetsuo Handa wrote:
> >
> > Oleg Nesterov wrote:
> > >     int main(void)
> > >     {
> > >             vfork();
> > >             pause();
> > >     }
> >^
> > Wow!
>
> and this reminds me... check_hung_uninterruptible_tasks() is very broken,
> it can crash the kernel itself. I'll resend my ancient fixes once again
> today, maybe this resend will be successful ;)

Please apply.

The patch was sent more than a year ago, I preserved the acks I got.

I was also going to add the PF_FREEZER_SKIP check in check_hung_task(),
but this was already done: f9fab10bbd768b0e5254e53a4a8477a94bfc4b96.
This means I lied, the program above no longer creates the problem
for check_hung_uninterruptible_tasks(). But that was not the point
for make-it-killable anyway.


I simply can't understand why do we have sysctl_hung_task_check_count,
may be someone can explain... OK, we need to do rcu_read_unlock()
from time to time even if need_resched() is not set, that is why
we have HUNG_TASK_BATCHING. Although perhaps it makes sense to do

	-	if (!--batch_count)
	+	if (!--batch_count || need_resched())
			rcu_lock_break();

but max_count? I guess I missed something obvious.

Oleg.

