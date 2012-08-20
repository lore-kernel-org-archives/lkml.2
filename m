Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757179Ab2HTPpd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 11:45:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28404 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753040Ab2HTPpb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 11:45:31 -0400
Date: Mon, 20 Aug 2012 17:41:54 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, rostedt <rostedt@goodmis.org>,
        dhowells <dhowells@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: lockdep trace from posix timers
Message-ID: <20120820154154.GB20258@redhat.com>
References: <20120724203613.GA9637@redhat.com> <1345140478.29668.54.camel@twins> <20120817151447.GA7918@redhat.com> <1345446957.23018.14.camel@twins> <1345463081.23018.34.camel@twins> <20120820150507.GC18499@redhat.com> <1345475530.23018.50.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345475530.23018.50.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20, Peter Zijlstra wrote:
>
> On Mon, 2012-08-20 at 17:05 +0200, Oleg Nesterov wrote:
> >
> > Yes, we can add the explicit argument to __task_work_run(), but it can
> > check PF_EXITING instead, this looks simpler to me.
>
> I guess we could.. but I thought the explicit callback was simpler ;-)

I won't insist. The patch I sent uses PF_EXITING and the fake
"struct callback_head* TWORK_EXITED", but this looks almost the same.

> > Note also your patch breaks fifo, but this is fixable.
>
> Why do you care about the order?

IMHO, this is just more natural.

For example. keyctl_session_to_parent() does _cancel only to protect
from exploits doing keyctl(KEYCTL_SESSION_TO_PARENT) in an endless
loop. It could simply do task_work_add(), but in this case we need
fifo for correctness.

> Iterating a single linked queue in fifo
> seems more expensive than useful.

Currently the list is fifo (we add to the last element), this is O(1).

But the list should be short, we can reverse it in _run() if we change
task_work_add() to add to the head.

Oleg.

