Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755651Ab1DTUgu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 16:36:50 -0400
Received: from mail.aknet.ru ([78.158.192.28]:51894 "EHLO mail.aknet.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751421Ab1DTUgt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 16:36:49 -0400
Message-ID: <4DAF439A.5020204@aknet.ru>
Date: Thu, 21 Apr 2011 00:35:38 +0400
From: Stas Sergeev <stsp@aknet.ru>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [path][rfc] add PR_DETACH prctl command [2/2]
References: <20110405151549.GB17490@redhat.com> <4D9B4265.6080403@aknet.ru> <20110405164557.GA23248@redhat.com> <4DADA22A.1010205@aknet.ru> <20110419155830.7ad33312@lxorguk.ukuu.org.uk> <4DADA581.9060700@aknet.ru> <20110419165429.71cb1508@lxorguk.ukuu.org.uk> <4DAEDC3F.5010208@aknet.ru> <20110420165023.GA24455@redhat.com> <4DAF29AD.1080603@aknet.ru> <20110420193307.GA1445@redhat.com>
In-Reply-To: <20110420193307.GA1445@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

20.04.2011 23:33, Oleg Nesterov wrote:

> I still do not understand the point of PR_DETACH. Why do you think it is
> needed without reparenting? OK, I do not really care ;)
Hmm, but that's really interesting, I wonder why do
you ask this. In my eyes, the reparenting was just a
"trick", which is now avoided for good. And I saved
a lot of per-thread memory by throwing that, and
shrunk the patch twice. Why do you think no-reparenting
changed something real? Could this change any use case?

>>> And. To hide the pr_detached task from do_wait(). you changed
>>> do_notify_parent() to returnd DEATH_REAP.
>> No, its hidden by the check in wait_consider_task().
>> do_notify_parent() was changed only to not allow the
>> second notification to the same parent.
> Not only. Please look at your own code ;) wait_consider_task() checks
> exit_state == EXIT_ZOMBIE before p->pr_detached, and thus do_notify_parent()
> haas to return DEATH_REAP so that the caller will set EXIT_DEAD. Otherwise
> the old parent could see EXIT_ZOMBIE&&  pr_detached task again.
Yes, but that's not to hide from do_wait().
At least as far as I understand, exit_notify() does
release_task() in this case, so that's not hiding: I
literally terminate the child this way.
Or am I missing something?

> But. What if the child stops after PR_DETACH? It will notify the parent
> anyway, no?
Ah, so that should be disallowed too, will fix.

>>> task_pid_vnr(p). Hmm, the change in reparent_leader doesn't look right,
>>> at least in case we reparent to sub-thread.
>> Why not? Whereever we reparented, I allow reparenting again.
> Even if the child reparents to the original parent's sub-thread?
OK. :)

> Everything. ptrace relies on do_wait(). wait_consider_task() doesn't
> work if pr_detached (except for WEXITED of course).
OK.

>> I am not that sure the last ones are very buggy.
> Well, I am not sure.
OK, at least the above 2 bugs are trivial to fix... :))
Thanks!

