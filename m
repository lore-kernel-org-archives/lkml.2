Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755509Ab0D1Ptr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 11:49:47 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:44887 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755461Ab0D1Pto convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 11:49:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=oS4H99ZSMkMVjHO7yw5VB7x6QG57RM4CK2zndw1WaNF0FnceGu1e+DQosMjHTALHpf
         y410/SHAMEb3g94KNjb3aV4o2oKO+mjhTlDkrJMLXMU5saFzXtVfEYG+BoD2lqPq1LdH
         x/Sn2SfFSusNDL9YwDtunGmZP2Tf/71Mt2ekw=
MIME-Version: 1.0
In-Reply-To: <20100428152502.GA25569@shareable.org>
References: <1272430986-20436-1-git-send-email-xiaosuo@gmail.com> 
	<u2w7b6bb4a51004280047s8748cbfbi7ed8e2a238121fa9@mail.gmail.com> 
	<q2j412e6f7f1004280052ice434710ra17a4516236bd3f3@mail.gmail.com> 
	<20100428081545.GA19027@windriver.com> <u2t412e6f7f1004280123k642a1511gbce3ed784431dc1d@mail.gmail.com> 
	<8482.1272446987@redhat.com> <q2m412e6f7f1004280417h449c67f9g86fca3dbece106e3@mail.gmail.com> 
	<20100428132135.GA22268@shareable.org> <y2r412e6f7f1004280642n49b8d6f2vcd08774531cb59da@mail.gmail.com> 
	<20100428152502.GA25569@shareable.org>
From: Changli Gao <xiaosuo@gmail.com>
Date: Wed, 28 Apr 2010 23:49:19 +0800
Message-ID: <m2l412e6f7f1004280849gf8ab11a0l6f25542014a71c38@mail.gmail.com>
Subject: Re: [RFC] sched: implement the exclusive wait queue as a LIFO queue
To: Jamie Lokier <jamie@shareable.org>
Cc: David Howells <dhowells@redhat.com>, Yong Zhang <yong.zhang@windriver.com>,
       Xiaotian Feng <xtfeng@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Roland Dreier <rolandd@cisco.com>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "David S. Miller" <davem@davemloft.net>,
       Eric Dumazet <dada1@cosmosbay.com>, Christoph Lameter <cl@linux.com>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       Thomas Gleixner <tglx@linutronix.de>, Takashi Iwai <tiwai@suse.de>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 28, 2010 at 11:25 PM, Jamie Lokier <jamie@shareable.org> wrote:
> Changli Gao wrote:
>> On Wed, Apr 28, 2010 at 9:21 PM, Jamie Lokier <jamie@shareable.org> wrote:
>> > Changli Gao wrote:
>> >>
>> >> fs/eventpoll.c: 1443.
>> >>                 wait.flags |= WQ_FLAG_EXCLUSIVE;
>> >>                 __add_wait_queue(&ep->wq, &wait);
>> >
>> > The same thing about assumptions applies here.  The userspace process
>> > may be waiting for an epoll condition to get access to a resource,
>> > rather than being a worker thread interchangeable with others.
>>
>> Oh, the lines above are the current ones. So the assumptions applies
>> and works here.
>
> No, because WQ_FLAG_EXCLUSIVE doesn't have your LIFO semantic at the moment.
>
> Your patch changes the behaviour of epoll, though I don't know if it
> matters.  Perhaps all programs which have multiple tasks waiting on
> the same epoll fd are "interchangeable worker thread" types anyway :-)
>

No. You are wrong. I meant epoll implemented LIFO on its own. You
should check the code. :)

>> > For example, userspace might be using a pipe as a signal-safe lock, or
>> > signal-safe multi-token semaphore, and epoll to wait for that pipe.
>> >
>> > WQ_FLAG_EXCLUSIVE means there is no point waking all tasks, to avoid a
>> > pointless thundering herd.  It doesn't mean unfairness is ok.
>>
>> The users should not make any assumption about the waking up sequence,
>> neither LIFO nor FIFO.
>
> Correct, but they should be able to assume non-starvation (eventual
> progress) for all waiters.
>
> It's one of those subtle things, possibly a unixy thing: Non-RT tasks
> should always make progress when the competition is just other non-RT
> tasks, even if the progress is slow.
>
> Starvation can spread out beyond the starved process, to cause
> priority inversions in other tasks that are waiting on a resource
> locked by the starved process.  Among other things, that can cause
> higher priority tasks, and RT priority tasks, to block permanently.
> Very unpleasant.
>
>> > The LIFO idea _might_ make sense for interchangeable worker-thread
>> > situations - including userspace.  It would make sense for pipe
>> > waiters, socket waiters (especially accept), etc.
>>
>> Yea, and my following patches are for socket waiters.
>
> Occasionally unix socketpairs are occasionally used in the above ways too.
>
> I'm not against your patch, but I worry that starvation is a new
> semantic, and it may have a significant effect on something - either
> in the kernel, or in userspace which is harder to check.

Thanks for your reminding.

>
> I suspect it's possible to combine LIFO-ish and FIFO-ish queuing to
> prevent starvation while getting some of the locality benefit.
> Something like add-LIFO and increment a small counter in the next wait
> entry, but never add in front of an entry whose counter has reached
> MAX_LIFO_WAITERS? :-)
>

It is a little complex, and I'll keep it simple and improve it when necessary.


-- 
Regards，
Changli Gao(xiaosuo@gmail.com)
