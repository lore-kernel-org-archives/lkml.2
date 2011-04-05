Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754081Ab1DEPQQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 11:16:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44272 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753255Ab1DEPQO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 11:16:14 -0400
Date: Tue, 5 Apr 2011 17:15:49 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Stas Sergeev <stsp@aknet.ru>
Cc: Linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [path][rfc] add PR_DETACH prctl command
Message-ID: <20110405151549.GB17490@redhat.com>
References: <20110223191442.GA717@redhat.com> <4D656F87.3090005@aknet.ru> <20110224132906.GA15733@redhat.com> <4D6675B0.2010700@aknet.ru> <20110224153221.GA22770@redhat.com> <4D94A788.1050806@aknet.ru> <20110331170244.GA13271@redhat.com> <4D99D6E6.4070008@aknet.ru> <20110404160351.GA23655@redhat.com> <4D9A24A0.5050105@aknet.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D9A24A0.5050105@aknet.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/05, Stas Sergeev wrote:
>
> 04.04.2011 20:03, Oleg Nesterov wrote:
>>> I still haven't solved the problems with checking
>>> parent and checking ptrace, so ignore them for
>>> now (or give me the hints:)
>> Not sure I understand your question...
> I wonder how to check whether the child was
> reparented to init, and not is a child on init's
> subthread.

I don't understand the "and not is a child on init's subthread".
If the child was created by init's sub-thread, it is the child
of the whole thread group.

->real_parent points to thread, yes. But the parent is the whole
process, not thread. The only reason for this oddity is __WNOTHREAD.

> You suggested to check
> same_thread_group(real_parent, ns->child_reaper),

Yes. This means: our parent is the init process.

>>> +			while_each_thread(me, p) {
>>> +				if (!ptrace_reparented(p))
>>> +					p->parent = pid_ns->child_reaper;
>>> +				p->real_parent = pid_ns->child_reaper;
>> Eek. Even ignoring ptrace, this is weird. We change parent/real_parent,
>> but we do not do list_move_tail(sibling) until wait_task_detached() !
>> No, I think we should not do this even if this was correct. I'll try
>> to nack this in any case, even if there were no immediate problems ;)
>> IMHO, this is insane.
>>
>> But this is wrong. Well. Suppose that the caller of PR_DETACH exits
>> before the old parent does do_wait(). What /sbin/init (who is the new
>> parent) can do after it gets SIGCHLD? If can't see this zombie. Nor
>> the old parent can release this task due to ->detaching. Eventually
>> /sbin/init can reap it if it does, say, waitpid(-1), but still this
>> is wrong.
> No, the idea was like that: the old parent either wait()s or
> exits, then init became a "real" parent of that process, and
> reaps it immediately.

I understand this, but

> I think that's natural:

I strongly disagree, this is not natural. I mean, ->real_parent
and the head of ->sibling list should match each other.

For example. Ignoring other problems, you are doing list_move() in
do_wait() pathes. This happens to work now because everything is
protected by the global tasklist. But we are going to change the
locking, it should be per-process.

> If it exits,

If it exits, it notifies the new ->real_parent == init. init receives
SIGCHLD, but do_wait() can't see this process on ->children lists.

> its current parent
> have to either wait(), or exit. If it doesn't do so - zombie.

Indeed. And, if the old parent does wait(), this simply does
list_move_tail(p->sibling), a zombie won't be reaped. And nobody will
reap it, until init does waitpid(-1). This was my point, this is wrong.

>> Or. Suppose that the old parent exits after its child does PR_DETACH.
>> You changed forget_original_parent() but this is not enough, note that
>> find_new_reaper() can pick the live sub-thread. In this case the child
>> will be moved to init's ->children list, and after that we are changing
>> ->real_parent back.
> How? I think I prevented that with this:
> ---
>
> +			p->detaching = 0;
> +			continue;

Yes, thanks, I didn't notice "continue". But then this is wrong again.
This can race with wait_task_detached() called by our sub-thread, it
can clear ->detaching before we check it.

Oleg.

