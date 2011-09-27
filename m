Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753646Ab1I0LuN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 07:50:13 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:57858 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753513Ab1I0LuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 07:50:10 -0400
Date: Tue, 27 Sep 2011 13:50:05 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Pavel Ivanov <paivanof@gmail.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 1/7] rcu: Fix preempt-unsafe debug check of rcu extended
 quiescent state
Message-ID: <20110927115002.GH18553@somewhere>
References: <1317032352-25571-1-git-send-email-fweisbec@gmail.com>
 <1317032352-25571-2-git-send-email-fweisbec@gmail.com>
 <CAG1a4rtKc0ZPZEeAsde-u7Xw9w36Oi05Zd--ueHT2XHbqRr6cg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAG1a4rtKc0ZPZEeAsde-u7Xw9w36Oi05Zd--ueHT2XHbqRr6cg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 26, 2011 at 06:04:06PM -0400, Pavel Ivanov wrote:
> On Mon, Sep 26, 2011 at 6:19 AM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > In the rcu_check_extended_qs() function that is used to check
> > illegal uses of RCU under extended quiescent states, we look
> > at the local value of dynticks that is even if an extended
> > quiescent state or odd otherwise.
> >
> > We are looking at it without disabling the preemption though
> > and this opens a race window where we may read the state of
> > a remote CPU instead, like in the following scenario:
> >
> > CPU 1                                                        CPU 2
> >
> > bool rcu_check_extended_qs(void)
> > {
> >        struct rcu_dynticks *rdtp;
> >
> >        rdtp = &per_cpu(rcu_dynticks,
> >                        raw_smp_processor_id());
> >
> >        < ---- Task is migrated here ---- >
> >
> >        // CPU 1 goes idle and increase rdtp->dynticks
> >                                                        /* Here we are reading the value for
> >                                                        the remote CPU 1 instead of the local CPU */
> >                                                        if (atomic_read(&rdtp->dynticks) & 0x1)
> >                                                                return false;
> >
> >                                                        return true;
> >                                                        }
> >
> > The possible result of this is false positive return value of that
> > function, suggesting we are in an extended quiescent state in random
> > places.
> 
> How is this different from what your patch allows?
> 
> CPU 1                                               CPU 2
> 
> bool rcu_check_extended_qs(void)
> {
>        struct rcu_dynticks *rdtp =
>                &get_cpu_var(rcu_dynticks);
>        bool ext_qs = true;
> 
>        if (atomic_read(&rdtp->dynticks) & 0x1)
>                ext_qs = false;
> 
>        put_cpu_var(rcu_dynticks);
> 
>        < ---- Task is migrated here ---- >
> 
>                                                   /* Here we return true/false
>                                                      based on the value for the
>                                                      remote CPU 1 instead of the
>                                                      local CPU */
> 
>                                                   return ext_qs;
>                                                   }
> 
> 
> Looks like it can result in the same false positive result.

Why?

While calling rcu_read_lock(), the task can still be migrated
for example from CPU 0 to CPU 1, until we do our check
in rcu_check_extended_qs() with preemption disabled. But that's
not a problem, we are going to do our check either in CPU 0 or
CPU 1, that's doesn't matter much.

What matters is that we do that check by ensuring we are really
checking the value of the cpu var in the CPU we are currently
running and not some other random one that can change its dynticks
value at the same time.
