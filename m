Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759295Ab0JFTmi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 15:42:38 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56367 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755139Ab0JFTmg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 15:42:36 -0400
MIME-Version: 1.0
In-Reply-To: <20101006190434.GA5783@Krystal>
References: <20101006175635.GA21652@Krystal> <AANLkTik3MWtEpi=mzf2-_x4_kdrwv-EOjeVHNzbmfian@mail.gmail.com>
 <20101006190434.GA5783@Krystal>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 6 Oct 2010 12:41:44 -0700
Message-ID: <AANLkTin6na1PyFDK5Oua0_ep8PzUNi=iceYdGQ03=F-Y@mail.gmail.com>
Subject: Re: [RFC PATCH] poll(): add poll_wait_set_exclusive()
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
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
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 6, 2010 at 12:04 PM, Mathieu Desnoyers
<mathieu.desnoyers@efficios.com> wrote:
>
> You are right. My approach breaks the select/poll semantics. This is why I'm
> asking for input if we want to solve the more general problem. For the moment,
> the poll_wait_set_exclusive() solution was only meant to be used for debugfs
> kernel pseudo-files, which fall out of the POSIX scope.

The thing is, I don't think "that file isn't mentioned by POSIX" is a
valid excuse for having different semantics for any particular file.

So no, I don't think it's acceptable to say that certain files just
act differently wrt "poll".

> Maybe what I am trying to do is too far from the poll() semantic and does not
> apply in the general case, but I clearly see the need, at least in the use-case
> detailed below, to wake up only one thread at a time, whether we call this
> "poll" or something else. One way to make it available more generally might be
> to add a new open() flag and require that all open() of a given file should use
> the flag to provide the "wakeup only one thread" behavior.

I think that would be a better interface, but still sucky and badly
designed. Why? Because the obvious case where you might want to have
the whole "only wake up a single thread" is actually for sockets, so
having an open-time flag is just insane.

Making it be an file status flag (and then use fcntl F_[GS]ETFL on it)
might work. At the same time, I have the suspicion that it would be
much nicer to embed it into the "requested events" field to poll, and
simply add a "exclusive read" poll event (POLLINEX or whatever).
Because it's really the "poll()" function itself that says "I promise
that if you return a readable file descriptor, I will read everything
from it" - it's really an attribute local to the "poll()", not to the
file descriptor.

Regardless, I really think that for anything like this to make sense,
it needs way more than a single use case. So you'd really want to get
some web server developers excited or something like that. Over the
years we have learnt that one-off use cases are worthless.

Also, doesn't eventpoll already support exclusive polling? I dunno.
Davide might be interested in the discussion regardless.

                     Linus
