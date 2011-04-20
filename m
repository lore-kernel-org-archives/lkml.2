Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755239Ab1DTQvR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 12:51:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39443 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753931Ab1DTQvO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 12:51:14 -0400
Date: Wed, 20 Apr 2011 18:50:23 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Stas Sergeev <stsp@aknet.ru>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [path][rfc] add PR_DETACH prctl command [2/2]
Message-ID: <20110420165023.GA24455@redhat.com>
References: <20110404160351.GA23655@redhat.com> <4D9A24A0.5050105@aknet.ru> <20110405151549.GB17490@redhat.com> <4D9B4265.6080403@aknet.ru> <20110405164557.GA23248@redhat.com> <4DADA22A.1010205@aknet.ru> <20110419155830.7ad33312@lxorguk.ukuu.org.uk> <4DADA581.9060700@aknet.ru> <20110419165429.71cb1508@lxorguk.ukuu.org.uk> <4DAEDC3F.5010208@aknet.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DAEDC3F.5010208@aknet.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/20, Stas Sergeev wrote:
>
> The attached patch implements the PR_DETACH prctl
> command. It detaches the entire process group from
> its parent, allowing the parent to still read the detach
> code with normal wait().
> Can be used to daemonize process with threads.

Now I do not understand this patch at all.

Stas, I already asked you, please describe the semantics of PR_DETACH.
Looking at the code, I can only see it was changed again, but I have
no idea what is the supposed behaviour.

At first glance, this version does not reparent the caller to init,
but still PR_DETACH checks ->real_parent != /sbin/init for unknown
reason...

IIUC, PR_DETACH simply fools ->real_parent so that it think this child
exits, while the child in fact runs after that but do_wait() can't see it.

Why? I don't understand the point.

And. To hide the pr_detached task from do_wait(). you changed
do_notify_parent() to returnd DEATH_REAP. I guess you did this to ensure
exit_notify() paths will set EXIT_DEAD and thus do_wait() can't see this
child again. This looks very ugly I must admit. And not 100% correct, we
notify the parent twice if ->detaching != 0. Also, because of this logic,
once wait_task_detached() drops tasklist it can race with exit_notify()
doing release_task(). Yes, task_struct can't go away, but we can't trust
task_pid_vnr(p). Hmm, the change in reparent_leader doesn't look right,
at least in case we reparent to sub-thread.

And of course, this breaks ptrace _completely_. I didn't read the patch
further, perhaps there are more problems.



Stas, I am sorry, I am tired ;) You are sending more and more versions
with the different semantics and they all are buggy. Please add Linus
and ask him if he is going to accept the new feature, and please describe
exactly what you are trying to achieve. Until then I do not want to spend
my time trying to understand yet another implementation of the hack which
I personally dislike.

Oleg.

