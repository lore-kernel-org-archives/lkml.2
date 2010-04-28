Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752421Ab0D1Nmf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 09:42:35 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:39620 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751386Ab0D1Nmd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 09:42:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=nHfHeRaZjXsLCNFz0VyxA3GQ7Nkao1zcKLZ0lMi5GuODlTblHOl8JrqfFkku88uiAl
         +JEZpB2WZbyyd8h59hSb1BCw7eL+12ANGe93ncX/EHnGB4Y6LNn77GkZg4MEV9nEwvRS
         kmMrGEKzd3fpdArem7fGpQnDd37JmJFCBZigo=
MIME-Version: 1.0
In-Reply-To: <20100428132135.GA22268@shareable.org>
References: <1272430986-20436-1-git-send-email-xiaosuo@gmail.com> 
	<u2w7b6bb4a51004280047s8748cbfbi7ed8e2a238121fa9@mail.gmail.com> 
	<q2j412e6f7f1004280052ice434710ra17a4516236bd3f3@mail.gmail.com> 
	<20100428081545.GA19027@windriver.com> <u2t412e6f7f1004280123k642a1511gbce3ed784431dc1d@mail.gmail.com> 
	<8482.1272446987@redhat.com> <q2m412e6f7f1004280417h449c67f9g86fca3dbece106e3@mail.gmail.com> 
	<20100428132135.GA22268@shareable.org>
From: Changli Gao <xiaosuo@gmail.com>
Date: Wed, 28 Apr 2010 21:42:12 +0800
Message-ID: <y2r412e6f7f1004280642n49b8d6f2vcd08774531cb59da@mail.gmail.com>
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

On Wed, Apr 28, 2010 at 9:21 PM, Jamie Lokier <jamie@shareable.org> wrote:
> Changli Gao wrote:
>>
>> fs/eventpoll.c: 1443.
>>                 wait.flags |= WQ_FLAG_EXCLUSIVE;
>>                 __add_wait_queue(&ep->wq, &wait);
>
> The same thing about assumptions applies here.  The userspace process
> may be waiting for an epoll condition to get access to a resource,
> rather than being a worker thread interchangeable with others.

Oh, the lines above are the current ones. So the assumptions applies
and works here.

>
> For example, userspace might be using a pipe as a signal-safe lock, or
> signal-safe multi-token semaphore, and epoll to wait for that pipe.
>
> WQ_FLAG_EXCLUSIVE means there is no point waking all tasks, to avoid a
> pointless thundering herd.  It doesn't mean unfairness is ok.

The users should not make any assumption about the waking up sequence,
neither LIFO nor FIFO.

>
> The LIFO idea _might_ make sense for interchangeable worker-thread
> situations - including userspace.  It would make sense for pipe
> waiters, socket waiters (especially accept), etc.

Yea, and my following patches are for socket waiters.

>
> Do you have any measurements which showing the LIFO mode performing
> better than FIFO, and by how much?
>

I didn't do any test yet. But some work done by LSE project years ago
showed that it is better.

http://lse.sourceforge.net/io/aionotes.txt

" Also in view of
better cache utilization the wake queue mechanism is LIFO by default.
(A new exclusive LIFO wakeup option has been introduced for this purpose)"

-- 
Regards，
Changli Gao(xiaosuo@gmail.com)
