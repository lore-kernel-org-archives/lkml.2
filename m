Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753385Ab1ARCMN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 21:12:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:21008 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753359Ab1ARCMK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 21:12:10 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Tejun Heo <tj@kernel.org>
X-Fcc: ~/Mail/linus
Cc: oleg@redhat.com, jan.kratochvil@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: Re: [PATCHSET RFC] ptrace,signal: clean transition between STOPPED and TRACED
In-Reply-To: Tejun Heo's message of  Friday, 24 December 2010 15:00:50 +0100 <1293199257-11255-1-git-send-email-tj@kernel.org>
References: <1293199257-11255-1-git-send-email-tj@kernel.org>
X-Windows: more than enough rope.
Message-Id: <20110118021133.C14FA1807B7@magilla.sf.frob.com>
Date: Mon, 17 Jan 2011 18:11:33 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 1. When attaching to a STOPPED task or a traced task stops for group
>    stop, the tracee now enters TRACED instead of STOPPED.  This is
>    visible via fs/proc but, more importantly, SIGCONT is ignored if a
>    task is TRACED.

That is probably OK, but I'm still not entirely sure about it.

>    This may, for example, affect the operation of strace but given how
>    strace always need to issue further ptrace operations on trap to
>    determine what's going on, I doubt it would actually be worse.

I'm not clear on what effect on strace you have in mind.

> 2. The transition between STOPPED and TRACED involves a short window
>    of RUNNING inbetween.  On attach, the transition is hidden from the
>    tracer using GROUP_STOP_TRAPPING but it still is visible to other
>    threads in the tracer's group.  IOW, if another thread performs
>    WNOHANG wait(2) on the tracee while attach is in progress, the
>    wait(2) may fail even if the tracee is known to be in stopped state
>    before.
> 
>    The same problem exists the other direction during detach.
>    Currently, the code doesn't try to hide this transition even from
>    the tracer.  IOW, if the tracer attaches to a stopped task,
>    detaches, reattaches and then performs WNOHANG wait(2), the wait(2)
>    may fail.  However, given the previous behavior where the tracee is
>    always woken up by wake_up_process() on detach, this is highly
>    unlikely to cause any problem.

This seems more problematic to me.  I don't like that start/stop window
at all.

Saying "wait may fail" is not sufficiently precise to be helpful.  Please
be more clear.  If "fail" means ECHILD, that is unacceptable.  If "fail"
means a WNOHANG wait returns 0 when userland already "knows" that the
thread is topped, that might be more acceptable.


Thanks,
Roland
