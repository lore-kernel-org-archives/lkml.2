Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755447Ab1DTSpJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 14:45:09 -0400
Received: from mail.aknet.ru ([78.158.192.28]:43279 "EHLO mail.aknet.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753521Ab1DTSpI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 14:45:08 -0400
Message-ID: <4DAF29AD.1080603@aknet.ru>
Date: Wed, 20 Apr 2011 22:45:01 +0400
From: Stas Sergeev <stsp@aknet.ru>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [path][rfc] add PR_DETACH prctl command [2/2]
References: <20110404160351.GA23655@redhat.com> <4D9A24A0.5050105@aknet.ru> <20110405151549.GB17490@redhat.com> <4D9B4265.6080403@aknet.ru> <20110405164557.GA23248@redhat.com> <4DADA22A.1010205@aknet.ru> <20110419155830.7ad33312@lxorguk.ukuu.org.uk> <4DADA581.9060700@aknet.ru> <20110419165429.71cb1508@lxorguk.ukuu.org.uk> <4DAEDC3F.5010208@aknet.ru> <20110420165023.GA24455@redhat.com>
In-Reply-To: <20110420165023.GA24455@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

20.04.2011 20:50, Oleg Nesterov wrote:
>> The attached patch implements the PR_DETACH prctl
>> command. It detaches the entire process group from
>> its parent, allowing the parent to still read the detach
>> code with normal wait().
>> Can be used to daemonize process with threads.
> At first glance, this version does not reparent the caller to init,
> but still PR_DETACH checks ->real_parent != /sbin/init for unknown
> reason...
The reason is that the task could have been reparented
to ini by some other means (parent died) - in this case no
detaching.

> IIUC, PR_DETACH simply fools ->real_parent so that it think this child
> exits, while the child in fact runs after that but do_wait() can't see it.
It can check si_code to see what actually happened.

> Why? I don't understand the point.
It was the same also when reparenting was done: the
original parent was only able to read the detach code,
and nothing more. _Nothing_ was changed, the semantic
is completely the same! The implementation changed only.


> And. To hide the pr_detached task from do_wait(). you changed
> do_notify_parent() to returnd DEATH_REAP.
No, its hidden by the check in wait_consider_task().
do_notify_parent() was changed only to not allow the
second notification to the same parent. Again, this is
to completely preserve the old semantic, where's the
original parent was always notified only once.
So, the original parent gets only one notification on
PR_DETACH, and on exit() - it does not. Nothing was
changed.

>   I guess you did this to ensure
> exit_notify() paths will set EXIT_DEAD and thus do_wait() can't see this
> child again. This looks very ugly I must admit. And not 100% correct, we
> notify the parent twice if ->detaching != 0.
No: the do_dignal_parent() is not called in that case too.

> task_pid_vnr(p). Hmm, the change in reparent_leader doesn't look right,
> at least in case we reparent to sub-thread.
Why not? Whereever we reparented, I allow reparenting again.
But, more importantly, I unhide that task in wait() and allow the
notifications again, so without this change it can't work.

> And of course, this breaks ptrace _completely_.
Why? What exactly breaks?

> Stas, I am sorry, I am tired ;) You are sending more and more versions
> with the different semantics and they all are buggy.
I am not that sure the last ones are very buggy.
Of course some bugs are possible, but at least that semantic
was a kind of "agreed on", and didn't change at all.
