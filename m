Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934786Ab1KJFI6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 00:08:58 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42346 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934774Ab1KJD1C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:27:02 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:27:14 2011
Message-Id: <20111109212713.986369827@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:27:35 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Tejun Heo <htejun@gmail.com>,
        Luke Macken <lmacken@redhat.com>, stable@kernel.org,
        Oleg Nesterov <oleg@redhat.com>
Subject: [133/262] ptrace: dont clear GROUP_STOP_SIGMASK on double-stop
In-Reply-To: <20111109212847.GA20838@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oleg Nesterov <oleg@redhat.com>

[This does not correspond to any specific patch in the upstream tree as it was
fixed accidentally by rewriting the code in the 3.1 release]

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/signal.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/kernel/signal.c
+++ b/kernel/signal.c
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


