Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752225Ab2HTQNy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 12:13:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54727 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751107Ab2HTQNv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 12:13:51 -0400
Date: Mon, 20 Aug 2012 18:10:12 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, rostedt <rostedt@goodmis.org>,
        dhowells <dhowells@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: lockdep trace from posix timers
Message-ID: <20120820161012.GC21400@redhat.com>
References: <20120724203613.GA9637@redhat.com> <1345140478.29668.54.camel@twins> <20120817151447.GA7918@redhat.com> <1345446957.23018.14.camel@twins> <1345463081.23018.34.camel@twins> <20120820150507.GC18499@redhat.com> <1345475530.23018.50.camel@twins> <20120820154154.GB20258@redhat.com> <1345478211.23018.69.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345478211.23018.69.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20, Peter Zijlstra wrote:
>
> On Mon, 2012-08-20 at 17:41 +0200, Oleg Nesterov wrote:
>
> > IMHO, this is just more natural.
>
> Depends on what you're used to I guess ;-)

I have to agree ;)

> > For example. keyctl_session_to_parent() does _cancel only to protect
> > from exploits doing keyctl(KEYCTL_SESSION_TO_PARENT) in an endless
> > loop. It could simply do task_work_add(), but in this case we need
> > fifo for correctness.
>
> I'm not entirely sure I see, not doing the cancel would delay the free
> until the executing of key_change_session_keyring()? doing that keyctl()
> in an indefinite loop involves going back to userspace, so where's the
> resource issue?

But the child does task_work_add(current->parent). IOW, there are 2
different tasks. Now suppose that ->parent sleeps.

> Also, I'm not seeing where the FIFO requirement comes from.

Again, suppose that ->parent sleeps. The last KEYCTL_SESSION_TO_PARENT
request should "win". Although I agree, this is not that important.

> > > Iterating a single linked queue in fifo
> > > seems more expensive than useful.
> >
> > Currently the list is fifo (we add to the last element), this is O(1).
>
> depends on what way you look at the list I guess, with a single linked
> list there's only one end you can add to in O(1), so we're calling that
> the tail?

Sorry, can't understand...

task->task_works points to the last node in the circular single-linked list,
task_work_add() adds the new element after the last one and updates
task->task_works. This is O(1).

> > But the list should be short, we can reverse it in _run() if we change
> > task_work_add() to add to the head.
>
> Reversing a (single linked) list is O(n^2)..

Hmm. This is O(n). You can simply iterate over this list once, changing
the ->next pointer to point back.

> which is indeed doable for
> short lists, but why assume its short?

I agree, it is better to not do this.

Oleg.

