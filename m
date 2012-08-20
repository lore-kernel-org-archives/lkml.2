Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754754Ab2HTP5E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 11:57:04 -0400
Received: from merlin.infradead.org ([205.233.59.134]:43062 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752860Ab2HTP5C convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 11:57:02 -0400
Message-ID: <1345478211.23018.69.camel@twins>
Subject: Re: lockdep trace from posix timers
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, rostedt <rostedt@goodmis.org>,
        dhowells <dhowells@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>
Date: Mon, 20 Aug 2012 17:56:51 +0200
In-Reply-To: <20120820154154.GB20258@redhat.com>
References: <20120724203613.GA9637@redhat.com>
	 <1345140478.29668.54.camel@twins> <20120817151447.GA7918@redhat.com>
	 <1345446957.23018.14.camel@twins> <1345463081.23018.34.camel@twins>
	 <20120820150507.GC18499@redhat.com> <1345475530.23018.50.camel@twins>
	 <20120820154154.GB20258@redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-08-20 at 17:41 +0200, Oleg Nesterov wrote:

> I won't insist. The patch I sent uses PF_EXITING and the fake
> "struct callback_head* TWORK_EXITED", but this looks almost the same.

Right, I used a fake callback_head because it avoided a few special
cases since its a dereferencable pointer.

> > > Note also your patch breaks fifo, but this is fixable.
> >
> > Why do you care about the order?
> 
> IMHO, this is just more natural.

Depends on what you're used to I guess ;-) Both RCU and irq_work are
filo, this seems to be the natural way for single linked lists.

> For example. keyctl_session_to_parent() does _cancel only to protect
> from exploits doing keyctl(KEYCTL_SESSION_TO_PARENT) in an endless
> loop. It could simply do task_work_add(), but in this case we need
> fifo for correctness.

I'm not entirely sure I see, not doing the cancel would delay the free
until the executing of key_change_session_keyring()? doing that keyctl()
in an indefinite loop involves going back to userspace, so where's the
resource issue?

Also, I'm not seeing where the FIFO requirement comes from.

> > Iterating a single linked queue in fifo
> > seems more expensive than useful.
> 
> Currently the list is fifo (we add to the last element), this is O(1).

depends on what way you look at the list I guess, with a single linked
list there's only one end you can add to in O(1), so we're calling that
the tail?

> But the list should be short, we can reverse it in _run() if we change
> task_work_add() to add to the head.

Reversing a (single linked) list is O(n^2).. which is indeed doable for
short lists, but why assume its short?
