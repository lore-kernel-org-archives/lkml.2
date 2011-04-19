Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753938Ab1DSRlG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 13:41:06 -0400
Received: from mail.aknet.ru ([78.158.192.28]:36687 "EHLO mail.aknet.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753663Ab1DSRlF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 13:41:05 -0400
Message-ID: <4DADC92E.3010409@aknet.ru>
Date: Tue, 19 Apr 2011 21:41:02 +0400
From: Stas Sergeev <stsp@aknet.ru>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [path][rfc] add PR_DETACH prctl command [3/3]
References: <20110405151549.GB17490@redhat.com> <4D9B4265.6080403@aknet.ru> <20110405164557.GA23248@redhat.com> <4DADA22A.1010205@aknet.ru> <20110419155830.7ad33312@lxorguk.ukuu.org.uk> <4DADA581.9060700@aknet.ru> <20110419165429.71cb1508@lxorguk.ukuu.org.uk> <20110419161301.GA23914@redhat.com> <20110419162909.GC23914@redhat.com> <4DADBE31.7000400@aknet.ru> <20110419172036.GA27213@redhat.com>
In-Reply-To: <20110419172036.GA27213@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

19.04.2011 21:20, Oleg Nesterov wrote:

>>> do_signal_parent() must not return DEATH_REAP (this means that
>>> leader->exit_signal becomes -1), but this can happen and this is bug.
>>>
>> Could you please clarify this a bit: according to the comments
>> in signal.c:
>> ---
>>                   * We are exiting and our parent doesn't care.  POSIX.1
>>                   * defines special semantics for setting SIGCHLD to SIG_IGN
>>                   * or setting the SA_NOCLDWAIT flag: we should be reaped
>>                   * automatically and not left for our parent's wait4 call.
>> ---
>> That's how I understand it: if DEATH_REAP is returned, the
>> parent ignores SIGCHILD, and in this case I am not allowing
>> it to read the detach code with wait(). What is the bug?
> Indeed. But, once again, that is why do_notify_parent() expects the dead
> tsk! Please note that if it returns DEATH_REAP it sets ->exit_signal = -1.
> And this is _only_ allowed if the leader is already dead and we are going
> to reap it.
Ah, so, by saying "do_signal_parent() must not return DEATH_REAP (this means that
leader->exit_signal becomes -1)", you actually meant
"do_signal_parent(), when returning DEATH_REAP, must not
set ->exit_signal = -1, because only do_notify_parent()
can do that"? In other words, do_signal_parent() can return
DEATH_REAP after all?
If so - will fix, thanks.

