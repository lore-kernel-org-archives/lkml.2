Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755441Ab1BXPOA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 10:14:00 -0500
Received: from mail.aknet.ru ([78.158.192.28]:52065 "EHLO mail.aknet.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755035Ab1BXPN5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 10:13:57 -0500
Message-ID: <4D6675B0.2010700@aknet.ru>
Date: Thu, 24 Feb 2011 18:13:52 +0300
From: Stas Sergeev <stsp@aknet.ru>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [path][rfc] add PR_DETACH prctl command
References: <4D6510A3.90905@aknet.ru> <20110223191442.GA717@redhat.com> <4D656F87.3090005@aknet.ru> <20110224132906.GA15733@redhat.com>
In-Reply-To: <20110224132906.GA15733@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

24.02.2011 16:29, Oleg Nesterov wrote:
>> And I really think there is no other
>> way to daemonize the process with threads, than to use something
>> like this patch, or is there?
> Depends on what "daemonize" means. Even with this patch, setsid()
> after PR_DETACH can fail because we do not change the pids and
> the caller can still be pgrp leader.
Yes, I am using TIOCNOTTY ioctl instead.
It doesn't detach the entire group from tty though, but the plan
is to implement also TIOCNOTTY_GRP, in case PR_DETACH is done.

> And. What if the parent of PR_DETACH caller blocks or ignores
> SIGCHLD or simply doesn't call do_wait()? The caller can run with
> PR_DETACH set without any effect "forever".
I am currently rewriting the patch to solve this all.
What I am trying to do now, is to reparent directly in prctl(),
but delay the list_move_tail(&p->sibling, &p->real_parent->children);
to the wait() call. If this is a feasible solution, I'll post the new patch.

> So, to be honest, I do not think this idea will be accepted, and I don't
> really understand your motivation. But once again, I never argue with the
> "we need this feature" requests, no need to convince me.
Lets see if the clean implementation is possible first. :)

> The problem is that ptrace uses this ->exit_code member as well.
> Suppose that the (ptraced) task calls PR_DETACH and, say, recieves
> a signal after that. See ptrace_signal().
Also do_signal_stop() seems to alter it.
Do you mean right now it can't happen that multiple events
alter the exit_code, and the parent notices only the last one?
In this case I need to add a separate variable.

> I understand why you added PF_EXITING. And, once again, this is not
> right afaics. The current condition is more or less "random" and mostly
> historical, although correct. If we want to take PF_EXITING into account,
> we should just add BUG_ON(!(tsk->flags&  PF_EXITING)). IOW, it is just
> wrong to call this function unless this tsk exits.
OK, I'll address also this.

Thanks for your time, I am hoping to post the patch that addresses
the pointed problems.
