Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757579Ab0GASyq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 14:54:46 -0400
Received: from kroah.org ([198.145.64.141]:35311 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757185Ab0GASWl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 14:22:41 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:32:07 2010
Message-Id: <20100701173207.748122852@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:30:37 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Andrey Vagin <avagin@openvz.org>, Oleg Nesterov <oleg@tv-sign.ru>,
       Pavel Emelyanov <xemul@openvz.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [patch 011/149] posix_timer: Fix error path in timer_create
In-Reply-To: <20100701175144.GA2116@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Andrey Vagin <avagin@openvz.org>

commit 45e0fffc8a7778282e6a1514a6ae3e7ae6545111 upstream.

Move CLOCK_DISPATCH(which_clock, timer_create, (new_timer)) after all
posible EFAULT erros.

*_timer_create may allocate/get resources.
(for example posix_cpu_timer_create does get_task_struct)

[ tglx: fold the remove crappy comment patch into this ]

Signed-off-by: Andrey Vagin <avagin@openvz.org>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Pavel Emelyanov <xemul@openvz.org>
Reviewed-by: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

--- a/kernel/posix-timers.c
+++ b/kernel/posix-timers.c
@@ -559,14 +559,7 @@ SYSCALL_DEFINE3(timer_create, const clockid_t, which_clock,
 	new_timer->it_id = (timer_t) new_timer_id;
 	new_timer->it_clock = which_clock;
 	new_timer->it_overrun = -1;
-	error = CLOCK_DISPATCH(which_clock, timer_create, (new_timer));
-	if (error)
-		goto out;
 
-	/*
-	 * return the timer_id now.  The next step is hard to
-	 * back out if there is an error.
-	 */
 	if (copy_to_user(created_timer_id,
 			 &new_timer_id, sizeof (new_timer_id))) {
 		error = -EFAULT;
@@ -597,6 +590,10 @@ SYSCALL_DEFINE3(timer_create, const clockid_t, which_clock,
 	new_timer->sigq->info.si_tid   = new_timer->it_id;
 	new_timer->sigq->info.si_code  = SI_TIMER;
 
+	error = CLOCK_DISPATCH(which_clock, timer_create, (new_timer));
+	if (error)
+		goto out;
+
 	spin_lock_irq(&current->sighand->siglock);
 	new_timer->it_signal = current->signal;
 	list_add(&new_timer->list, &current->signal->posix_timers);


