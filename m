Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756806Ab2HTO7b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 10:59:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24948 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754308Ab2HTO73 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 10:59:29 -0400
Date: Mon, 20 Aug 2012 16:55:50 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, rostedt <rostedt@goodmis.org>,
        dhowells <dhowells@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: lockdep trace from posix timers
Message-ID: <20120820145550.GA18499@redhat.com>
References: <20120724203613.GA9637@redhat.com> <1345140478.29668.54.camel@twins> <20120817151447.GA7918@redhat.com> <1345446957.23018.14.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345446957.23018.14.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20, Peter Zijlstra wrote:
>
> On Fri, 2012-08-17 at 17:14 +0200, Oleg Nesterov wrote:
> > I still think that task_work_add() should synhronize with exit_task_work()
> > itself and fail if necessary. But I wasn't able to convince Al ;)
>
> I'm not at all sure how that relates to needing task_lock() in the
> keyctl stuff.

To serialize with exit_mm() which clears ->mm.

We shouldn't do task_work_add(task) if the exiting task has already
passed exit_task_work(). There is no way to do this after ed3e694d7
(and I think this is wrong), so keyctl relies on the fact that
exit_task_work() is called after exit_mm().

> Also, can't task_work use llist stuff? That would also avoid using
> ->pi_lock.

Not sure.... task_work_add/run can use cmpxchg, but _cancel can't.

Oleg.

