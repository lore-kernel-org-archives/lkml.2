Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932193Ab0F2QlU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 12:41:20 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41308 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932124Ab0F2QlR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 12:41:17 -0400
MIME-Version: 1.0
In-Reply-To: <20100629084230.GE6215@tiehlicka.suse.cz>
References: <20100623091307.GA11072@tiehlicka.suse.cz>
	<4C2417AA.4030306@us.ibm.com>
	<20100625082711.GA32765@tiehlicka.suse.cz>
	<4C24ED34.9040808@us.ibm.com>
	<4C253D32.6040304@us.ibm.com>
	<20100628144246.GA14201@tiehlicka.suse.cz>
	<20100628153214.GA24127@tiehlicka.suse.cz>
	<20100628155845.GC24127@tiehlicka.suse.cz>
	<20100628163952.GD24127@tiehlicka.suse.cz>
	<1277743748.3561.139.camel@laptop>
	<20100629084230.GE6215@tiehlicka.suse.cz>
Date: Tue, 29 Jun 2010 09:41:02 -0700
Message-ID: <AANLkTinyoyZVg8iYOuUx6aA4XlUlLywl4q6GLXmeYP-x@mail.gmail.com>
Subject: Re: [PATCH] futex: futex_find_get_task make credentials check 
	conditional
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: Ingo Molnar <mingo@elte.hu>, Darren Hart <dvhltc@us.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, Nick Piggin <npiggin@suse.de>,
       Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
       Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 29, 2010 at 1:42 AM, Michal Hocko <mhocko@suse.cz> wrote:
>
> futex_find_get_task is currently used (through lookup_pi_state) from two
> contexts, futex_requeue and futex_lock_pi_atomic. While credentials check
> makes sense in the first code path, the second one is more problematic
> because this check requires that the PI lock holder (pid parameter) has
> the same uid and euid as the process's euid which is trying to lock the
> same futex (current).

So exactly why does it make sense to check the credentials in the
first code path then? Shouldn't the futex issue in the end depend on
whether you have a shared page or not - and not on credentials at all?
Any two processes that share a futex in the same shared page should be
able to use that without any regard for whether they are the same
user. That's kind of the point, no?

IOW, I personally dislike these kinds of conditional checks,
especially since the discussion (at least the part I've seen) hasn't
made it clear why it should be conditional - or exist - in the first
place.

So I'd like the patch to include an explanation of exactly why the two
cases are different.

The other thing I'd like to see is to move the whole cred checking up
a level. There's no reason to check the credentials in
futex_find_get_task() that I can see - why not do it in the caller
instead? IOW, I think futex_find_get_task() should just look something
like this instead:


  static struct task_struct * futex_find_get_task(pid_t pid)
  {
        struct task_struct *p;

        rcu_read_lock();
        p = find_task_by_vpid(pid);
        if (p)
                get_task_struct(p);
        rcu_read_unlock();

        return p;
  }

and then in the caller we'd do something like

      p = futex_find_get_task(pid);
      if (!p)
         return -ESEARCH;

      if ( .. check p credentials is necessary and fails..)
         goto put_task_and_exit;

because especially with not everybody needing the credentials check, I
do not think it should be done at the lowest level (it's clearly not
fundamental to the operation, so it shouldn't be part of the core
lookup).

With some re-factoring, it might even be possible to avoid a dynamic
check at all, and just have two different static paths for the two
cases. That's a separate issue, though.

                  Linus
