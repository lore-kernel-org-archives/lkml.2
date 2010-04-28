Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754009Ab0D1NWt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 09:22:49 -0400
Received: from mail2.shareable.org ([80.68.89.115]:40376 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754421Ab0D1NWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 09:22:46 -0400
Date: Wed, 28 Apr 2010 14:21:35 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Changli Gao <xiaosuo@gmail.com>
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
Subject: Re: [RFC] sched: implement the exclusive wait queue as a LIFO queue
Message-ID: <20100428132135.GA22268@shareable.org>
References: <1272430986-20436-1-git-send-email-xiaosuo@gmail.com> <u2w7b6bb4a51004280047s8748cbfbi7ed8e2a238121fa9@mail.gmail.com> <q2j412e6f7f1004280052ice434710ra17a4516236bd3f3@mail.gmail.com> <20100428081545.GA19027@windriver.com> <u2t412e6f7f1004280123k642a1511gbce3ed784431dc1d@mail.gmail.com> <8482.1272446987@redhat.com> <q2m412e6f7f1004280417h449c67f9g86fca3dbece106e3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <q2m412e6f7f1004280417h449c67f9g86fca3dbece106e3@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changli Gao wrote:
> On Wed, Apr 28, 2010 at 5:29 PM, David Howells <dhowells@redhat.com> wrote:
> > Changli Gao <xiaosuo@gmail.com> wrote:
> >
> >> If there isn't enough work to be done, we'd better not disrupt them
> >> and  leave them sleeping forever to keep the scheduler happier. Do we
> >> have reason to keep fair to all the workers? Does it have benefit?
> >
> > You've made one important assumption: the processes on the wait queue are
> > sleeping waiting to service things... but what if the wait queue governs
> > access to a resource, and all the processes on that wait queue need access to
> > that resource to do things?  Some of the processes waiting for it may never
> > get a go, and so necessary work may be left undone.
> >
> 
> You are right. I made the wrong assumption. But we indeed need some
> primitive to add wait_queue at the head of the wait_queue_head, and I
> know epoll needs it, at least.
> 
> fs/eventpoll.c: 1443.
>                 wait.flags |= WQ_FLAG_EXCLUSIVE;
>                 __add_wait_queue(&ep->wq, &wait);

The same thing about assumptions applies here.  The userspace process
may be waiting for an epoll condition to get access to a resource,
rather than being a worker thread interchangeable with others.

For example, userspace might be using a pipe as a signal-safe lock, or
signal-safe multi-token semaphore, and epoll to wait for that pipe.

WQ_FLAG_EXCLUSIVE means there is no point waking all tasks, to avoid a
pointless thundering herd.  It doesn't mean unfairness is ok.

The LIFO idea _might_ make sense for interchangeable worker-thread
situations - including userspace.  It would make sense for pipe
waiters, socket waiters (especially accept), etc.

Do you have any measurements which showing the LIFO mode performing
better than FIFO, and by how much?

-- Jamie
