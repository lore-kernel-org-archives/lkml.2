Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755515Ab1DDUG2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 16:06:28 -0400
Received: from mail.aknet.ru ([78.158.192.28]:44509 "EHLO mail.aknet.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755454Ab1DDUG1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 16:06:27 -0400
Message-ID: <4D9A24A0.5050105@aknet.ru>
Date: Tue, 05 Apr 2011 00:05:52 +0400
From: Stas Sergeev <stsp@aknet.ru>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [path][rfc] add PR_DETACH prctl command
References: <4D6510A3.90905@aknet.ru> <20110223191442.GA717@redhat.com> <4D656F87.3090005@aknet.ru> <20110224132906.GA15733@redhat.com> <4D6675B0.2010700@aknet.ru> <20110224153221.GA22770@redhat.com> <4D94A788.1050806@aknet.ru> <20110331170244.GA13271@redhat.com> <4D99D6E6.4070008@aknet.ru> <20110404160351.GA23655@redhat.com>
In-Reply-To: <20110404160351.GA23655@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

04.04.2011 20:03, Oleg Nesterov wrote:
>> I still haven't solved the problems with checking
>> parent and checking ptrace, so ignore them for
>> now (or give me the hints:)
> Not sure I understand your question...
I wonder how to check whether the child was
reparented to init, and not is a child on init's
subthread. You suggested to check
same_thread_group(real_parent, ns->child_reaper),
but I don't understand that suggestion because in
our case real_parent==ns->child_reaper, yet it is not
enough, as it could be of CLONE_PARENT (I suppose).

>> +			while_each_thread(me, p) {
>> +				if (!ptrace_reparented(p))
>> +					p->parent = pid_ns->child_reaper;
>> +				p->real_parent = pid_ns->child_reaper;
> Eek. Even ignoring ptrace, this is weird. We change parent/real_parent,
> but we do not do list_move_tail(sibling) until wait_task_detached() !
> No, I think we should not do this even if this was correct. I'll try
> to nack this in any case, even if there were no immediate problems ;)
> IMHO, this is insane.
>
> But this is wrong. Well. Suppose that the caller of PR_DETACH exits
> before the old parent does do_wait(). What /sbin/init (who is the new
> parent) can do after it gets SIGCHLD? If can't see this zombie. Nor
> the old parent can release this task due to ->detaching. Eventually
> /sbin/init can reap it if it does, say, waitpid(-1), but still this
> is wrong.
No, the idea was like that: the old parent either wait()s or
exits, then init became a "real" parent of that process, and
reaps it immediately. I think that's natural: the very same will happen
if the child didn't do pr_detach. If it exits, its current parent
have to either wait(), or exit. If it doesn't do so - zombie.
I decided that if I still allow wait() for the old parent, I'd better
leave that logic untouched. So: until the old parent wait()s
or exits, we have zombie, and that's what I supposed to implement.

> Or. Suppose that the old parent exits after its child does PR_DETACH.
> You changed forget_original_parent() but this is not enough, note that
> find_new_reaper() can pick the live sub-thread. In this case the child
> will be moved to init's ->children list, and after that we are changing
> ->real_parent back.
How? I think I prevented that with this:
---

+			p->detaching = 0;
+			continue;
---
So it should not go down to get reparented back.
Or am I missing something?

Thanks for your time!

