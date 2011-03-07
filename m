Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754000Ab1CGPQn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 10:16:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11973 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751160Ab1CGPQm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 10:16:42 -0500
Date: Mon, 7 Mar 2011 16:08:03 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Roland McGrath <roland@redhat.com>, jan.kratochvil@redhat.com,
        Denys Vlasenko <vda.linux@googlemail.com>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
Subject: PTRACE_SEIZE/INTERRUPT: [RFC] Proposal for ptrace improvements
Message-ID: <20110307150803.GA16521@redhat.com>
References: <20110301152457.GE26074@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110301152457.GE26074@htj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/01, Tejun Heo wrote:
>
> P4. PTRACE_SEIZE

Now that we more or less agree with Tejun's ideas, I'd like to
discuss the "cosmetic" issues. But first of all let me repeat,
I do not have the strong opinion, I agree with everything in
advance.

The only really important thing (to me) is that ATTACH/INTERRUPT do
not induce SIGSTOP but force the tracee to trap (if needed), this
looks obviously good.

> I don't think it's a good idea to attach without putting the tracee
> into TASK_TRACED.

Agreed.

Jan, do you have any reason for attach-without-putting-into-TRACED?

> I can't see much, if any, benefit in implementing ATTACH and INTERRUPT
> separately.

I can ;) Although the benefit is minor.

First of all, the single request can "hide" the user-space bugs.
For example, gdb is very complex, suppose that it uses the wrong
pid during the debugging session. In this case it would be nice if
the kernel returns the error instead of attaching to the wrong
thread.

Of course, gdb can use the wrong pid during attach as well, but
this is less likely. Sometimes gdb doesn't even know that some
thread has gone away, suppose that it blindly does PTRACE_SEIZE
after that and this pid was alredy reused.

Or. Suppose that gdb tries to attach the whole thread group (it
always does this), and attaches to the same thread twice by mistake.
The kernel can help in this case and return the error.

And I think there are other reasons. Say, suppose we want to add
the options for ATTACH/INTERRUPT. Right now I do not see the need,
but who knows.


And. Error codes. Currently ptrace_check_attach() can only return
ESRCH, this doesn't look very convenient. If we add INTERRUPT we
can make this more informative. The same for PTRACE_ATTACH, btw.
EPERM should mean security error, nothing else. IOW, error codes
should be different depending on attach/interrupt mode.


In any case. Jan, Denys, what do you think? Your opinion is more
important, I can only speculate.



Final note... Previously I thought that we should not (I meant, can
not) change the current behaviour of PTRACE_O_TRACECLONE/etc which
sends SIGSTOP during the auto-attach. Now I am not sure, probably
we can avoid SIGSTOP if the forking task was PTRACE_SEIZE'ed. IOW,
perhaps the new ATTACH can have other "side effects". But, otoh,
this can complicate the transition to the new requests. Say, you
can't simply change strace to use PTRACE_SEIZE without auditing
the "-f" code.


And. This is off-topic, but we can also add PTRACE_DETACH_XXX which
does not require the stopped tracee. strace certainly needs it,
although INTERRUPT can solve most of the problems.

Oleg.

