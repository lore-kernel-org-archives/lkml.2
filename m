Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757946Ab1ELQAe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 12:00:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57591 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757331Ab1ELQAc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 12:00:32 -0400
Date: Thu, 12 May 2011 17:59:10 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: jan.kratochvil@redhat.com, vda.linux@googlemail.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu
Subject: Re: [PATCH 10/11] ptrace: move JOBCTL_TRAPPING wait to wait(2) and
	ptrace_check_attach()
Message-ID: <20110512155910.GD18599@redhat.com>
References: <1304869745-1073-1-git-send-email-tj@kernel.org> <1304869745-1073-11-git-send-email-tj@kernel.org> <20110511164947.GA26383@redhat.com> <20110511195333.GE24245@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110511195333.GE24245@mtj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/11, Tejun Heo wrote:
>
> On Wed, May 11, 2011 at 06:49:47PM +0200, Oleg Nesterov wrote:
> > On 05/08, Tejun Heo wrote:
> > > this patch moves TRAPPING wait from attach completion path to
> > > operations which are actually affected by the transition - wait(2) and
> > > following ptrace(2) requests.
> >
> > You know, I'd wish I could find the serious bugs in this patch. The
> > code becomes really hairy. -EAGAIN in do_wait() doesn't make it more
> > simple ;)
>
> I don't know.  Why is retrying hairy?  The whole waiting logic is
> built for clean retries.  The suggested change just does it without
> intervening sleeping and waking up.  I don't see anything particularly
> hairy there.

As always, this is subjective. But I didn't mean -EAGAIN itself. In fact
I was going to add this (simple) logic some time ago and kill the EXIT_DEAD
state. Hmm, and I'd still like to do this...

I meant the whole ptrace_wait_trapping() + lock dance + retry thing.
But of course I do not pretend my feeling is right.

Also. _Perhaps_ we can rethink the SIGCONT trapping, and perhaps in
this case do_wait() won't need any changes. May be.

> > > Both wait and ptrace paths are updated to retry the operation after
> > > TRAPPING wait.  Note that wait_task_stopped() now always grabs siglock
> > > for ptrace waits.  This can be avoided with "task_stopped_code() ->
> > > rmb() -> TRAPPING -> rmb() -> task_stopped_code()" sequence
> >
> > And so far I think this would be better, because it seems we can avoid
> > the retry logic.
>
> Well, the above memory barrier dance wouldn't really change whether
> retry logic is required or not and I'd _really_ like to avoid complex
> barrier dances.

Agreed, the barriers always complicate the understanding.

Oleg.

