Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753386Ab1EHOC2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 10:02:28 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:35323 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752242Ab1EHOC1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 10:02:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=DGeh2n6zunnOP+Iv1o/6C8pK+Xu2Nb0TCUeNHYRm5hjJzjITEGN++g0GlMCgo5T/VR
         chVZ4Vz5oK6zAK8kiiVkvfrFjPKgATUT+szjr7NKx0HaSRB0apZz2AIEB5oUcBF4ZQq3
         CrDtQOw84tCwarMiMT34vVmxrhlCKOFhlxqQk=
Date: Sun, 8 May 2011 16:02:21 +0200
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH ptrace] ptrace: fix signal->wait_chldexit usage in
 task_clear_group_stop_trapping()
Message-ID: <20110508140221.GA29783@htj.dyndns.org>
References: <20110506095222.GB8824@htj.dyndns.org>
 <20110508133543.GA4820@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110508133543.GA4820@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Oleg.

On Sun, May 08, 2011 at 03:35:43PM +0200, Oleg Nesterov wrote:
> > Given the relative low frequency of ptrace use, we would be much
> > better off leaving already complex wait_chldexit alone and using bit
> > waitqueue.
> 
> Well, I don't think so. wait_on_bit() looks as unnecessary complication
> to me. See below.

Why is wait_on_bit() a complication?  It's a well defined event
construct.

> But. Why do we need signal->wait_chldexit or bit waitqueue at all?
> Previously this was needed because wait_event(!GROUP_STOP_TRAPPING)
> was called from ptrace_check_attach(), and the tracer can do anything
> after ptrace_attach() which sets GROUP_STOP_TRAPPING.
>
> With the current code we know that GROUP_STOP_TRAPPING means: the
> tracer can't go away from ptrace_attach() until we clear this bit.

Several reasons.

* Because I'm gonna use TRAPPING for end of group stop notification
  too and move TRAPPING waiting to ptrace_check_attach() and
  wait_task_stopped().

* I dislike adding unqualified wake_up_process() unless the
  interlocked behavior with the waiter is very obvious.  The waiter is
  waiting for an event to happen and the waker is generating the
  event.  It's much more clear and robust to describe that
  relationship explicitly rather than depending on "on yeah, if the
  waiter wasn't expecting this event yet, other sleeping places are
  supposed to be safe against spurious wakeups so we're all good".

* I think it's a bad idea to design such tightly coupled waiter/waker
  relationship as in "because the waiter is not gonna do anything
  else, just waking up is safe".  It's way too fragile and prone to
  error when code gets updated later and it's not like we gain
  anything from it.  Let's make waiter wait for a well defined event
  and waker generate that event.  We have pretty good facilities for
  that kind of things.

> Hmm. This is minor and off-topic, but perhaps it makes sense to move
> the code which sets/waits GROUP_STOP_TRAPPING from ptrace_attach() to
> the separate function, it can be called outside of tasklist_lock and
> cred_guard_mutex.

I'm confused.  It should be set while siglock is held.  Which place
are you suggesting?

> And. Could you remind why ptrace_attach() does signal_wake_up() instead
> of wake_up_state(TASK_STOPPED) ? OK, in general we shouldn't set
> GROUP_STOP_PENDING without TIF_SIGPENDING, but in this case?

I don't know.  I can't find any good reason there.  Feel free to
change it to wake_up_state(TASK_STOPPED) but leaving it as
signal_wake_up() would look prettier after SEIZE addition, and I think
using the same @resume abstraction for all ptrace wakeups make things
easier to understand too.  I'll soon post the patchset.

Thanks.

-- 
tejun
