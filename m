Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752316Ab2KXVKg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2012 16:10:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36747 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752249Ab2KXVKe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2012 16:10:34 -0500
Date: Sat, 24 Nov 2012 16:09:37 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file.rdu.redhat.com
To: Jeff Chua <jeff.chua.linux@gmail.com>
cc: Jens Axboe <axboe@kernel.dk>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jan Kara <jack@suse.cz>, lkml <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: Recent kernel "mount" slow
In-Reply-To: <CAAJw_ZvXGKcjfOAS_tRdXJ9SjpCKw1t7rNt+Q=ieCkVJwN2qcg@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1211241555470.4300@file.rdu.redhat.com>
References: <CAAJw_ZtbhE5Jtd4PsWx8a23QdFTW7aMrKBmRf-bo5Wrean9Xhg@mail.gmail.com>
 <20121120180949.GG1408@quack.suse.cz> <CAAJw_ZsQdLO5qLdGPzmPf+N2D6CZw+S-4mvRGnxfARL71LuRaw@mail.gmail.com>
 <CAAJw_ZsAyB0z0TF1mqPz1Z+H+tg7W6LVzNLKf0BkuF3u8TTMuQ@mail.gmail.com>
 <CA+55aFyvT3R3kgwJzp9mY5eE1fwMnzXnmBpHSbqjd-eJRVDkJw@mail.gmail.com>
 <50AF7901.20401@kernel.dk> <CAAJw_ZvXGKcjfOAS_tRdXJ9SjpCKw1t7rNt+Q=ieCkVJwN2qcg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 24 Nov 2012, Jeff Chua wrote:

> On Fri, Nov 23, 2012 at 9:24 PM, Jens Axboe <axboe@kernel.dk> wrote:
> > On 2012-11-22 20:21, Linus Torvalds wrote:
> >> Doesn't sound like a fsdevel issue since it seems to be independent of
> >> filesystems. More like some generic block layer thing. Adding Jens
> >> (and quoting the whole thing)
> >>
> >> Jens, any ideas? Most of your stuff came in after -rc2, which would
> >> fit with the fact that most of the slowdown seems to be after -rc2
> >> according to Jeff.
> >
> > No ideas. Looking at what went in from my side, only the rq plug sorting
> > is a core change, and that should not cause any change in behaviour for
> > a single device. That's commit 975927b9.
> >
> >> Jeff, more bisecting would be good, though.
> >
> > Probably required, yes...
> 
> 
> This one slows mount from 0.012s to 0.168s.
> 
> commit 62ac665ff9fc07497ca524bd20d6a96893d11071
> Author: Mikulas Patocka <mpatocka@redhat.com>
> Date:   Wed Sep 26 07:46:43 2012 +0200
> 
>     blockdev: turn a rw semaphore into a percpu rw semaphore
> 
> 
> There were couple of more changes to percpu-rw-semaphores after
> 3.7.0-rc2 and those slows mount further from 0.168s to 0.500s. I don't
> really know, but I'm suspecting these. Still bisecting.

The problem there is that you either use normal semaphores and slow down 
I/O or you use percpu-semaphores, you don't slow down I/O, but you slow 
down mount.

So it's better to slow down mount.

(if you don't use any semaphore at all, as it was in 3.6 kernel and 
before, there is a race condition that can crash the kernel if someone 
does mount and direct I/O read on the same device at the same time)

You can improve mount time if you change all occurences of 
synchronize_sched() in include/linux/percpu-rwsem.h to 
synchronize_sched_expedited().

But some people say that synchronize_sched_expedited() is bad for real 
time latency. (can there be something like: if (realtime) 
synchronize_sched(); else synchronize_sched_expedited(); ?)

Mikulas
