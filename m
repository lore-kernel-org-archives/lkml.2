Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933660Ab0HEVUs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 17:20:48 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:34356 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754603Ab0HEVUn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 17:20:43 -0400
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
	<m1zkx04y40.fsf@fess.ebiederm.org>
	<AANLkTim=VMoC+wG6Hikzic95Avooi=-9Fu=mjSCxNXEZ@mail.gmail.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Thu, 05 Aug 2010 14:20:36 -0700
In-Reply-To: <AANLkTim=VMoC+wG6Hikzic95Avooi=-9Fu=mjSCxNXEZ@mail.gmail.com> (Linus Torvalds's message of "Thu\, 5 Aug 2010 13\:26\:21 -0700")
Message-ID: <m1lj8k21uj.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=67.188.4.80;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.188.4.80
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Thu, Aug 5, 2010 at 1:13 PM, Eric W. Biederman <ebiederm@xmission.com> wrote:
>>
>> I think it is totally reasonable to add a per pid lock,
>> that would protect the pid->task[...] hlist.  That would make
>> things clearer and finer grained without a lot of effort.  Just
>> a little more struct pid bloat, and a little extra care in fork,
>> when we add to those lists.
>
> Hmm. Have you taken a look at Nick Piggin's VFS scalability patches?
> They introduce this "RCU-safe hash chain lock", where each hashchain
> has a lock-bit in the low bit. I wonder if that would be the right
> thing to use?

Interesting.  I haven't looked but a lock bit in the low bit of the
hlist head in struct pid would not add any space, and would not add
any extra cache line bounces.  So that would just be a matter of
adding the extra locks and getting the lock ordering correct.

>> Even with the per-pgrp lock we still need a lock on the global process
>> list for the kill -KILL -1 case.  Which suggests that tasklist_lock is
>> still needed for part of kill_something_info.
>
> Well, that -1 case is special anyway. The fact that we might want to
> use the tasklist_lock there is not very relevant, I think. That is
> _not_ a hotpath, really (at least not under any relevant loads, I'm
> sure you could make a silly benchmark of "kill(-1,0)").

I expect even signal deliver to process groups is relatively rare.

The interesting question is can we kill the tasklist_lock and/or the
tasklist.   A quick grep shows that we have maybe 100 users of the tasklist
in the entire kernel.  Poking a little deeper it looks like man of those
are connected to scheduling and are uses that today take the tasklist_lock
but would be fine with the rcu_read_lock().

Eric
