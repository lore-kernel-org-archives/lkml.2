Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753801Ab1DSRVT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 13:21:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55110 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752673Ab1DSRVS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 13:21:18 -0400
Date: Tue, 19 Apr 2011 19:20:36 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Stas Sergeev <stsp@aknet.ru>
Cc: Linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [path][rfc] add PR_DETACH prctl command [3/3]
Message-ID: <20110419172036.GA27213@redhat.com>
References: <20110405151549.GB17490@redhat.com> <4D9B4265.6080403@aknet.ru> <20110405164557.GA23248@redhat.com> <4DADA22A.1010205@aknet.ru> <20110419155830.7ad33312@lxorguk.ukuu.org.uk> <4DADA581.9060700@aknet.ru> <20110419165429.71cb1508@lxorguk.ukuu.org.uk> <20110419161301.GA23914@redhat.com> <20110419162909.GC23914@redhat.com> <4DADBE31.7000400@aknet.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DADBE31.7000400@aknet.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/19, Stas Sergeev wrote:
>
> 19.04.2011 20:29, Oleg Nesterov wrote:
>>> I'll try to check these patches from the correctness pov tomorrow,
>>> but to be honest I hope someone will nack them before I start ;)
>> OK, I briefly looked at 3/3. It looks certainly wrong.
>>
>> 	notif = do_signal_parent(...);
>> 	if (notif != DEATH_REAP) {
>> 	....
>>
>> do_signal_parent() must not return DEATH_REAP (this means that
>> leader->exit_signal becomes -1), but this can happen and this is bug.
>>
> Could you please clarify this a bit: according to the comments
> in signal.c:
> ---
>                  * We are exiting and our parent doesn't care.  POSIX.1
>                  * defines special semantics for setting SIGCHLD to SIG_IGN
>                  * or setting the SA_NOCLDWAIT flag: we should be reaped
>                  * automatically and not left for our parent's wait4 call.
> ---
> That's how I understand it: if DEATH_REAP is returned, the
> parent ignores SIGCHILD, and in this case I am not allowing
> it to read the detach code with wait(). What is the bug?

Indeed. But, once again, that is why do_notify_parent() expects the dead
tsk! Please note that if it returns DEATH_REAP it sets ->exit_signal = -1.
And this is _only_ allowed if the leader is already dead and we are going
to reap it.

>> Also. I didn't actually read the patch yet, but iiuc: if a task T does
>> PR_DETACH and then exits, init can't reap it until the old parent does
>> wait. This can confuse the poor admin, he can see the zombies with
>> ppid = 1 and there is no way to understand why.
> Oh my. :)) I guess you are not going to suggest a solution to
> that "problem", other than to rip the patch? :)

Cough... well, the mentioned solution looks very nice to me ;)

Oleg.

