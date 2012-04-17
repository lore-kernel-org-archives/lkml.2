Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756148Ab2DQOLk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 10:11:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60530 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755605Ab2DQOLi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 10:11:38 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20120414021236.GB23393@redhat.com>
References: <20120414021236.GB23393@redhat.com> <20120414021201.GA23385@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: dhowells@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alexander Gordeev <agordeev@redhat.com>,
        Chris Zankel <chris@zankel.net>, David Smith <dsmith@redhat.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Larry Woodman <lwoodman@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 2/3] genirq: reimplement exit_irq_thread() hook via task_work_add()
Date: Tue, 17 Apr 2012 15:11:18 +0100
Message-ID: <26830.1334671878@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@redhat.com> wrote:

> 2. change irq_thread() to do task_queue_work(irq_thread_dtor)
>    at the start and task_work_cancel() before return.
> 
>    tracehook_notify_resume() can never play with kthreads,
>    only do_exit()->exit_task_work() can call the callback
>    and this is what we want.

Hmmm...  This seems wrong.  You're now using the hook in two distinct ways:
the primary use of that the hook is to detect that userspace is about to
resume processing (via TIF_NOTIFY_RESUME) and then you're abusing the fact
that the hook is also invoked via do_exit() to perform a clean up because
we've got to get rid of it somehow under that circumstance.

This only works for you because you're operating in a kernel thread which
doesn't have a userspace (and so will never see TIF_NOTIFY_RESUME).  However,
if someone tries that in an ordinary thread, it is liable to malfunction as
the record could be executed and deleted at some unpredictable point in the
future.

David
