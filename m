Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932281Ab2AJQhc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 11:37:32 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:61088 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932114Ab2AJQhb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 11:37:31 -0500
Message-ID: <1326213442.19095.9.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Subject: Re: [BUG] kernel freezes with latest tree
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Tue, 10 Jan 2012 17:37:22 +0100
In-Reply-To: <CA+55aFwNVutn=Z8N9k3CHLri=EKWX2UcN8skZvMfJ9Tg1LHCpg@mail.gmail.com>
References: <1326171444.6638.3.camel@edumazet-laptop>
	 <1326171798.6638.4.camel@edumazet-laptop>
	 <1326183371.6638.6.camel@edumazet-laptop>
	 <1326212033.19095.3.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <CA+55aFwNVutn=Z8N9k3CHLri=EKWX2UcN8skZvMfJ9Tg1LHCpg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 10 janvier 2012 à 08:28 -0800, Linus Torvalds a écrit :
> On Tue, Jan 10, 2012 at 8:13 AM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> >
> > Here are two traces of the lockups, since I had some free time to reproduce the
> > bug on current tree (plus a minor change in bnx2 driver to avoid a
> > netconsole related stack trace)
> 
> Hmm. You have load_balance() and idle_balance() there in the trace, so
> I'm getting more hopeful that it really is just the fact that
> set_cpu_sd_state_idle() really needs to just be run with interrupts
> disabled. That was my main concern about that merge, so if it's that,
> I'll be relieved.
> 
> If you can please try that change out, that would be great.
> 
> [ And if that's not it - Ingo & co, please check out the traces on lkml ]
> 

Just to make sure I understood well, here is what I tested :


diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 7656642..acd88a1 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -466,6 +466,8 @@ void tick_nohz_idle_enter(void)
 
 	WARN_ON_ONCE(irqs_disabled());
 
+	local_irq_disable();
+
 	/*
  	 * Update the idle state in the scheduler domain hierarchy
  	 * when tick_nohz_stop_sched_tick() is called from the idle loop.
@@ -474,8 +476,6 @@ void tick_nohz_idle_enter(void)
  	 */
 	set_cpu_sd_state_idle();
 
-	local_irq_disable();
-
 	ts = &__get_cpu_var(tick_cpu_sched);
 	/*
 	 * set ts->inidle unconditionally. even if the system did not


