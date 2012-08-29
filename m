Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753964Ab2H2PXh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 11:23:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10915 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753764Ab2H2PXf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 11:23:35 -0400
Date: Wed, 29 Aug 2012 17:25:55 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, rostedt <rostedt@goodmis.org>,
        dhowells <dhowells@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: lockdep trace from posix timers
Message-ID: <20120829152555.GA27704@redhat.com>
References: <1345478211.23018.69.camel@twins> <20120820161012.GC21400@redhat.com> <1345479590.23018.75.camel@twins> <20120820162302.GA22354@redhat.com> <20120821182751.GA11243@redhat.com> <20120821183408.GA11721@redhat.com> <20120824185619.GA16719@redhat.com> <1346171342.2296.4.camel@laptop> <20120828170121.GA30165@redhat.com> <1346174930.2296.13.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346174930.2296.13.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/28, Peter Zijlstra wrote:
>
> Surely we can do this locklessly.. I'll go try harder still.

I doubt...

Even ignore work->func check, somehow you need to ensure that
work->next == new can't be changed durung cmpxchg(..., new).

Anyway, if this is possible, can't you do this on top of 1-4
I sent? There are simple, and solve the problems we discusssed.

Off-topic. This is really minor, bur can't we simplify llist_add()?

	static inline bool llist_add(struct llist_node *new, struct llist_head *head)
	{
		struct llist_node *old;

		do {
			old = ACCESS_ONCE(head->first);
			new->next = old;
		} while (cmpxchg(&head->first, old, new) != old);

		return old == NULL;
	}

looks simpler and saves a couple of insns. The likely case should
assume that cmpxchg() succeeds after the 1st attempt. If it fails,
another LOAD from head->first should be very cheap.

And note this ACCESS_ONCE(head->first) above. I think that (in theory)
the current code needs it too. But only in theory, I guess.

Oleg.

