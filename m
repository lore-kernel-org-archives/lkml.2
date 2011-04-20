Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755674Ab1DTTd7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 15:33:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58198 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752651Ab1DTTd6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 15:33:58 -0400
Date: Wed, 20 Apr 2011 21:33:07 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Stas Sergeev <stsp@aknet.ru>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [path][rfc] add PR_DETACH prctl command [2/2]
Message-ID: <20110420193307.GA1445@redhat.com>
References: <20110405151549.GB17490@redhat.com> <4D9B4265.6080403@aknet.ru> <20110405164557.GA23248@redhat.com> <4DADA22A.1010205@aknet.ru> <20110419155830.7ad33312@lxorguk.ukuu.org.uk> <4DADA581.9060700@aknet.ru> <20110419165429.71cb1508@lxorguk.ukuu.org.uk> <4DAEDC3F.5010208@aknet.ru> <20110420165023.GA24455@redhat.com> <4DAF29AD.1080603@aknet.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DAF29AD.1080603@aknet.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/20, Stas Sergeev wrote:
>
> 20.04.2011 20:50, Oleg Nesterov wrote:
>>> The attached patch implements the PR_DETACH prctl
>>> command. It detaches the entire process group from
>>> its parent, allowing the parent to still read the detach
>>> code with normal wait().
>>> Can be used to daemonize process with threads.
>> At first glance, this version does not reparent the caller to init,
>> but still PR_DETACH checks ->real_parent != /sbin/init for unknown
>> reason...
> The reason is that the task could have been reparented
> to ini by some other means (parent died)

This is clear,

- in this case no
> detaching.

Why? Now that we do not reparent PR_DETACH could works in this case too.
Nevermind, this is minor and probably makes sense, forget.

I still do not understand the point of PR_DETACH. Why do you think it is
needed without reparenting? OK, I do not really care ;)

>> IIUC, PR_DETACH simply fools ->real_parent so that it think this child
>> exits, while the child in fact runs after that but do_wait() can't see it.
> It can check si_code to see what actually happened.
>
>> Why? I don't understand the point.
> It was the same also when reparenting was done: the
> original parent was only able to read the detach code,
> and nothing more. _Nothing_ was changed, the semantic
> is completely the same!

The same? what about, say, ppid?

>> And. To hide the pr_detached task from do_wait(). you changed
>> do_notify_parent() to returnd DEATH_REAP.
> No, its hidden by the check in wait_consider_task().
> do_notify_parent() was changed only to not allow the
> second notification to the same parent.

Not only. Please look at your own code ;) wait_consider_task() checks
exit_state == EXIT_ZOMBIE before p->pr_detached, and thus do_notify_parent()
haas to return DEATH_REAP so that the caller will set EXIT_DEAD. Otherwise
the old parent could see EXIT_ZOMBIE && pr_detached task again.

> Again, this is
> to completely preserve the old semantic, where's the
> original parent was always notified only once.

Of course, it should be notified only once. but afaics it can be notified
twice.

>> This looks very ugly I must admit. And not 100% correct, we
>> notify the parent twice if ->detaching != 0.
>
> No: the do_dignal_parent() is not called in that case too.

OK, I misread this code. In fact I missed something else, can't recall
what I meant. Probably I was wrong anyway.

But. What if the child stops after PR_DETACH? It will notify the parent
anyway, no? And this can even happen after wait(WEXITED) succeeded.

>> task_pid_vnr(p). Hmm, the change in reparent_leader doesn't look right,
>> at least in case we reparent to sub-thread.
> Why not? Whereever we reparented, I allow reparenting again.

Even if the child reparents to the original parent's sub-thread?

> But, more importantly, I unhide that task in wait() and allow the
> notifications again, so without this change it can't work.

This is clear but see above.

>> And of course, this breaks ptrace _completely_.
> Why? What exactly breaks?

Everything. ptrace relies on do_wait(). wait_consider_task() doesn't
work if pr_detached (except for WEXITED of course).

>> Stas, I am sorry, I am tired ;) You are sending more and more versions
>> with the different semantics and they all are buggy.
> I am not that sure the last ones are very buggy.

Well, I am not sure.

> but at least that semantic
> was a kind of "agreed on", and didn't change at all.

Cough. So far nobody except you agrees with this semantics ;)

Oleg.

