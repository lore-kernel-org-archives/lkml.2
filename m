Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752172Ab0KYJk2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 04:40:28 -0500
Received: from mtagate3.uk.ibm.com ([194.196.100.163]:57202 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751609Ab0KYJk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 04:40:26 -0500
Subject: Re: [patch 3/4] taskstats: Introduce cdata_acct for complete
 cumulative accounting
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Reply-To: holzheu@linux.vnet.ibm.com
To: Oleg Nesterov <oleg@redhat.com>
Cc: Shailabh Nagar <nagar1234@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        John stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org
In-Reply-To: <20101123165951.GA5938@redhat.com>
References: <20101119201108.269346583@linux.vnet.ibm.com>
	 <20101119201144.542948128@linux.vnet.ibm.com>
	 <20101123165951.GA5938@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Organization: IBM
Date: Thu, 25 Nov 2010 10:40:22 +0100
Message-ID: <1290678022.1941.29.camel@holzheu-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Oleg,

On Tue, 2010-11-23 at 17:59 +0100, Oleg Nesterov wrote: 
> On 11/19, Michael Holzheu wrote:
> > TODO:
> > -----
> > With this patch we take the siglock twice. First for the dead task
> > and second for the parent of the dead task. This give the following
> > lockdep warning (probably a lockdep annotation is needed here):
> 
> And we already discussed this ;) We do not need 2 siglock's, only
> parent's. Just move the callsite in __exit_signal() down, under
> another (lockless) group_dead check.
> 
> Or I missed something?

The problem with moving this down to the second group_dead check is that
after __unhash_process() is called, pid_alive(tsk) which is checked in
thread_group_cputime() returns false. Therefore we always get zero CPU
times.

So I probably have to introduce a second group_dead check at the
beginning of __exit_signal():

@@ -150,6 +153,9 @@ static void __exit_signal(struct task_st
        struct sighand_struct *sighand;
        struct tty_struct *uninitialized_var(tty);

+       if (group_dead)
+               __account_cdata(...);
+
        sighand = rcu_dereference_check(tsk->sighand,
                                        rcu_read_lock_held() ||
                                        
> We can do this before taking ->siglock. Not that I think this really
> matters, but otherwise this looks a bit confusing imho, as if we need
> parent's ->siglock to pin something.

ok

> 
> 
> And thanks for splitting these changes. It was much, much easier to
> read now.

My personal feeling is that probably the only acceptable thing would be
to make the new behavior configurable with a sysctl and define the
default as it currently is (POSIX compliant).

This would only introduce two additional checks in __exit_signal() and
wait_task_zombie() and would not add any new fields to the
signal_struct.

Michael

