Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933487Ab0HEUNP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 16:13:15 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:41658 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932599Ab0HEUNN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 16:13:13 -0400
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Howells <dhowells@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        paulmck@linux.vnet.ibm.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH 2/2] CRED: Fix __task_cred()'s lockdep check and banner  comment
References: <20100729114549.29508.44899.stgit@warthog.procyon.org.uk>
	<20100729114555.29508.4525.stgit@warthog.procyon.org.uk>
	<20100802204000.GH2405@linux.vnet.ibm.com>
	<201008030055.o730tgXK091413@www262.sakura.ne.jp>
	<30552.1280828047@redhat.com>
	<AANLkTikwM0+cxJqgQ+N_svzyyc+FKreO8XPr8oYNh6OU@mail.gmail.com>
	<m1d3txzfuq.fsf@fess.ebiederm.org>
	<AANLkTikavQKkvmdY5=8jh8KSV7vit=WcmDHWjnZfVWnv@mail.gmail.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Thu, 05 Aug 2010 13:13:03 -0700
In-Reply-To: <AANLkTikavQKkvmdY5=8jh8KSV7vit=WcmDHWjnZfVWnv@mail.gmail.com> (Linus Torvalds's message of "Thu\, 5 Aug 2010 09\:14\:50 -0700")
Message-ID: <m1zkx04y40.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=67.188.4.80;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.188.4.80
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Thu, Aug 5, 2010 at 12:19 AM, Eric W. Biederman
> <ebiederm@xmission.com> wrote:
>>
>> No.  When we send a signal to multiple processes it needs to be an
>> atomic operation so that kill -KILL -pgrp won't let processes escape.
>> It is what posix specifies, it is what real programs expect, and it
>> is the useful semantic in userspace.
>
> Ok. However, in that case, it's not really about the whole list
> traversal, it's a totally separate thing, and it's really sad that we
> end up using the (rather hot) tasklist_lock for something like that.
> With the dcache/inode locks basically going away, I think
> tasklist_lock ends up being one of the few hot locks left.

It is about the list traversal.  In the process group case it is about
traversing the pid->tasks[PIDTYPE_PGID] hlist, which is also protected
by the tasklist_lock.

> Wouldn't it be much nicer to:
>  - make it clear that all the "real" signal locking can rely on RCU
>  - use a separate per-pgrp lock that ends up being the one that gives
> the signal _semantic_ meaning?
>
> That would automatically document why we get the lock too, which
> certainly isn't clear from the code as-is.
>
> The per-pgrp lock might be something as simple as a silly hash that
> just spreads out the process groups over some random number of simple
> spinlocks.

I think it is totally reasonable to add a per pid lock,
that would protect the pid->task[...] hlist.  That would make
things clearer and finer grained without a lot of effort.  Just
a little more struct pid bloat, and a little extra care in fork,
when we add to those lists.

Even with the per-pgrp lock we still need a lock on the global process
list for the kill -KILL -1 case.  Which suggests that tasklist_lock is
still needed for part of kill_something_info.

Eric
