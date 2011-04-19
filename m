Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752608Ab1DSQyN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 12:54:13 -0400
Received: from mail.aknet.ru ([78.158.192.28]:56016 "EHLO mail.aknet.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751622Ab1DSQyM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 12:54:12 -0400
Message-ID: <4DADBE31.7000400@aknet.ru>
Date: Tue, 19 Apr 2011 20:54:09 +0400
From: Stas Sergeev <stsp@aknet.ru>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [path][rfc] add PR_DETACH prctl command [3/3]
References: <20110404160351.GA23655@redhat.com> <4D9A24A0.5050105@aknet.ru> <20110405151549.GB17490@redhat.com> <4D9B4265.6080403@aknet.ru> <20110405164557.GA23248@redhat.com> <4DADA22A.1010205@aknet.ru> <20110419155830.7ad33312@lxorguk.ukuu.org.uk> <4DADA581.9060700@aknet.ru> <20110419165429.71cb1508@lxorguk.ukuu.org.uk> <20110419161301.GA23914@redhat.com> <20110419162909.GC23914@redhat.com>
In-Reply-To: <20110419162909.GC23914@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

19.04.2011 20:29, Oleg Nesterov wrote:
>> I'll try to check these patches from the correctness pov tomorrow,
>> but to be honest I hope someone will nack them before I start ;)
> OK, I briefly looked at 3/3. It looks certainly wrong.
>
> 	notif = do_signal_parent(...);
> 	if (notif != DEATH_REAP) {
> 	....
>
> do_signal_parent() must not return DEATH_REAP (this means that
> leader->exit_signal becomes -1), but this can happen and this is bug.
>
Could you please clarify this a bit: according to the comments
in signal.c:
---
                  * We are exiting and our parent doesn't care.  POSIX.1
                  * defines special semantics for setting SIGCHLD to SIG_IGN
                  * or setting the SA_NOCLDWAIT flag: we should be reaped
                  * automatically and not left for our parent's wait4 call.
---
That's how I understand it: if DEATH_REAP is returned, the
parent ignores SIGCHILD, and in this case I am not allowing
it to read the detach code with wait(). What is the bug?

> Also. I didn't actually read the patch yet, but iiuc: if a task T does
> PR_DETACH and then exits, init can't reap it until the old parent does
> wait. This can confuse the poor admin, he can see the zombies with
> ppid = 1 and there is no way to understand why.
Oh my. :)) I guess you are not going to suggest a solution to
that "problem", other than to rip the patch? :)
