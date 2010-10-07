Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753064Ab0JGQxI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 12:53:08 -0400
Received: from mail.openrapids.net ([64.15.138.104]:57586 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751075Ab0JGQxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 12:53:07 -0400
Date: Thu, 7 Oct 2010 12:53:03 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Christoph Hellwig <hch@lst.de>,
        Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Tom Zanussi <tzanussi@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Davide Libenzi <davidel@xmailserver.org>
Subject: Re: [RFC PATCH] poll(): add poll_wait_set_exclusive()
Message-ID: <20101007165303.GA799@Krystal>
References: <20101006175635.GA21652@Krystal> <AANLkTik3MWtEpi=mzf2-_x4_kdrwv-EOjeVHNzbmfian@mail.gmail.com> <20101006190434.GA5783@Krystal> <AANLkTin6na1PyFDK5Oua0_ep8PzUNi=iceYdGQ03=F-Y@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTin6na1PyFDK5Oua0_ep8PzUNi=iceYdGQ03=F-Y@mail.gmail.com>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 12:03:41 up 14 days, 20:05,  5 users,  load average: 0.16, 0.12,
	0.09
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Linus Torvalds (torvalds@linux-foundation.org) wrote:
> On Wed, Oct 6, 2010 at 12:04 PM, Mathieu Desnoyers
> <mathieu.desnoyers@efficios.com> wrote:
[...]
> So no, I don't think it's acceptable to say that certain files just
> act differently wrt "poll".

Agreed.

> 
> > Maybe what I am trying to do is too far from the poll() semantic and does not
> > apply in the general case, but I clearly see the need, at least in the use-case
> > detailed below, to wake up only one thread at a time, whether we call this
> > "poll" or something else. One way to make it available more generally might be
> > to add a new open() flag and require that all open() of a given file should use
> > the flag to provide the "wakeup only one thread" behavior.
> 
> I think that would be a better interface, but still sucky and badly
> designed. Why? Because the obvious case where you might want to have
> the whole "only wake up a single thread" is actually for sockets, so
> having an open-time flag is just insane.

Good point.

> Making it be an file status flag (and then use fcntl F_[GS]ETFL on it)
> might work. At the same time, I have the suspicion that it would be
> much nicer to embed it into the "requested events" field to poll, and
> simply add a "exclusive read" poll event (POLLINEX or whatever).
> Because it's really the "poll()" function itself that says "I promise
> that if you return a readable file descriptor, I will read everything
> from it" - it's really an attribute local to the "poll()", not to the
> file descriptor.

This is interesting. I'm just concerned that if we have many poll() waiting on
the same file descriptor, some with POLLINEX and others without, the poll()
calls expecting the standard POSIX behavior might be hurt. Having a single
poll() call with POLLINEX would affect the behavior of the wakeup list for the
whole file descriptor, with side-effect on non-POLLINEX poll() calls.

Also, the whole question seems to depend on the notion of edge-triggered vs
level-triggered, which is better defined in epoll(). The poll specification by
the opengroup states that "The poll() function shall identify those file
descriptors on which an application can read or write data, or on which certain
events have occurred.", which is basically some blurry definition allowing both
edge- or level- triggering.

I think the POLLINEX scheme you propose here would only work with
the level-triggering semantic, and seems to have a blurry semantic for mix of
POLLINEX/non-POLLINEX poll() calls. I would personally be inclined to go for the
fnctl F_[GS]ETFL solution that applies to the whole file descriptor, so all
users of a file descriptor would agree that the poll semantic of this fd.

> Regardless, I really think that for anything like this to make sense,
> it needs way more than a single use case. So you'd really want to get
> some web server developers excited or something like that. Over the
> years we have learnt that one-off use cases are worthless.

Indeed.

> Also, doesn't eventpoll already support exclusive polling? I dunno.
> Davide might be interested in the discussion regardless.

Looking at epoll(7), the behavior of EPOLLONESHOT when there are multiple epoll
instances monitoring a file descriptor seems unclear: does it stop event
propagation after delivery to the first epoll instance (this is the behavior I
am looking for), or does it stop the event delivery after having woken up all
epoll instances monitoring the file descriptor ? Davide might have the answer to
this one.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
