Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752113Ab1IZRfD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 13:35:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23099 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751581Ab1IZRfB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 13:35:01 -0400
Date: Mon, 26 Sep 2011 19:06:32 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Greg KH <gregkh@suse.de>
Cc: Tejun Heo <htejun@gmail.com>, Luke Macken <lmacken@redhat.com>,
        stable@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH stable-3.0] ptrace: don't clear GROUP_STOP_SIGMASK on
	double-stop
Message-ID: <20110926170632.GA16936@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

https://bugzilla.redhat.com/show_bug.cgi?id=740121

1. Luke Macken triggered WARN_ON(!(group_stop & GROUP_STOP_SIGMASK))
   in do_signal_stop().

   This is because do_signal_stop() clears GROUP_STOP_SIGMASK part
   unconditionally but doesn't update it if task_is_stopped().

2. Looking at this problem I noticed that WARN_ON_ONCE(!ptrace) is
   not right, a stopped-but-resumed tracee can clone the untraced
   thread in the SIGNAL_STOP_STOPPED group, the new thread can start
   another group-stop.

   Remove this warning, we need more fixes to make it true.

Reported-by: Luke Macken <lmacken@redhat.com>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>

--- 3.0/kernel/signal.c
+++ 3.0/kernel/signal.c
@@ -1894,21 +1894,19 @@ static int do_signal_stop(int signr)
 		 */
 		if (!(sig->flags & SIGNAL_STOP_STOPPED))
 			sig->group_exit_code = signr;
-		else
-			WARN_ON_ONCE(!task_ptrace(current));
 
 		current->group_stop &= ~GROUP_STOP_SIGMASK;
 		current->group_stop |= signr | gstop;
 		sig->group_stop_count = 1;
 		for (t = next_thread(current); t != current;
 		     t = next_thread(t)) {
-			t->group_stop &= ~GROUP_STOP_SIGMASK;
 			/*
 			 * Setting state to TASK_STOPPED for a group
 			 * stop is always done with the siglock held,
 			 * so this check has no races.
 			 */
 			if (!(t->flags & PF_EXITING) && !task_is_stopped(t)) {
+				t->group_stop &= ~GROUP_STOP_SIGMASK;
 				t->group_stop |= signr | gstop;
 				sig->group_stop_count++;
 				signal_wake_up(t, 0);

