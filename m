Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752593Ab2DQQab (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 12:30:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51709 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751148Ab2DQQa3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 12:30:29 -0400
Date: Tue, 17 Apr 2012 18:29:42 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: David Howells <dhowells@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alexander Gordeev <agordeev@redhat.com>,
        Chris Zankel <chris@zankel.net>, David Smith <dsmith@redhat.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Larry Woodman <lwoodman@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 2/3] genirq: reimplement exit_irq_thread() hook via
	task_work_add()
Message-ID: <20120417162942.GB14527@redhat.com>
References: <20120414021236.GB23393@redhat.com> <20120414021201.GA23385@redhat.com> <26830.1334671878@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <26830.1334671878@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/17, David Howells wrote:
>
> Oleg Nesterov <oleg@redhat.com> wrote:
>
> > 2. change irq_thread() to do task_queue_work(irq_thread_dtor)
> >    at the start and task_work_cancel() before return.
> >
> >    tracehook_notify_resume() can never play with kthreads,
> >    only do_exit()->exit_task_work() can call the callback
> >    and this is what we want.
>
> Hmmm...  This seems wrong.

I don't agree...

> You're now using the hook in two distinct ways:
> the primary use of that the hook is to detect that userspace is about to
> resume processing (via TIF_NOTIFY_RESUME)

Yes,

> and then you're abusing the fact
> that the hook is also invoked via do_exit() to perform a clean up because
> we've got to get rid of it somehow under that circumstance.

Yes, and please note that this cleanup is only needed if irq thread
crashes.

> This only works for you because you're operating in a kernel thread which
> doesn't have a userspace (and so will never see TIF_NOTIFY_RESUME).

Yes,

> However,
> if someone tries that in an ordinary thread,

Sure, nobody should do this with the ordinary thread. At least
exactly this.

> it is liable to malfunction as
> the record could be executed and deleted at some unpredictable point in the
> future.

"In the future" is not possible (and this doesn't depend on
PF_KTHREAD). irq_thread() does task_work_cancel() before return.
And until it returns it returns the work can't be executed
unless this task exits in between.

Oleg.

