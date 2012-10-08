Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754679Ab2JHS6i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 14:58:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37497 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752644Ab2JHS6f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 14:58:35 -0400
Date: Mon, 8 Oct 2012 20:59:51 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: dl8bcu@dl8bcu.de, peterz@infradead.org, mingo@kernel.org,
        linux-kernel@vger.kernel.org, linux-alpha@vger.kernel.org,
        Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>
Subject: Re: [regression] boot failure on alpha, bisected
Message-ID: <20121008185951.GA9717@redhat.com>
References: <20121006204736.GA1830@ds20.borg.net> <20121007165534.GA8024@redhat.com> <20121007170850.GJ2616@ZenIV.linux.org.uk> <20121007173336.GA14804@redhat.com> <20121007193909.GK2616@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121007193909.GK2616@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/07, Al Viro wrote:
>
> On Sun, Oct 07, 2012 at 07:33:36PM +0200, Oleg Nesterov wrote:
>
> > > Um...  There's a bunch of architectures that are in the same situation.
> > > grep for do_notify_resume() and you'll see...
> >
> > And every do_notify_resume() should be changed anyway, do_signal() and
> > tracehook_notify_resume() should be re-ordered.
>
> There's a bit more to it.
> [...big snip...]

Thanks Al. I need to read your email carefully.

But what do you think we should do right now to fix this particular
bug?

So far I am going to send the patch below. This was always wrong,
even before task_works were added. key_replace_session_keyring()
was might_sleep() too but it also did lock_irq/unlock_irq, so this
was not noticed before.

Or do you think we should add local_irq_enable() into
arch/alpha/kernel/signal.c:do_notify_resume() before
tracehook_notify_resume and wait for other similar report?

Oleg.
---

diff --git a/kernel/task_work.c b/kernel/task_work.c
index 65bd3c9..fd18bd7 100644
--- a/kernel/task_work.c
+++ b/kernel/task_work.c
@@ -51,6 +51,10 @@ void task_work_run(void)
 	struct task_struct *task = current;
 	struct callback_head *work, *head, *next;
 
+	if (WARN_ONCE(irqs_disabled(),
+		      "do_notify_resume() with irqs disabled, fix this arch."))
+		local_irq_enable();
+
 	for (;;) {
 		/*
 		 * work->func() can do task_work_add(), do not set

