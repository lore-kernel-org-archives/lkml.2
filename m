Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757064Ab2GMT4h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 15:56:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40981 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752121Ab2GMT4e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 15:56:34 -0400
Date: Fri, 13 Jul 2012 15:56:15 -0400
From: Dave Jones <davej@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Darren Hart <darren@dvhart.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: 3.5-rc6 futex_wait_requeue_pi oops.
Message-ID: <20120713195615.GC1707@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Rusty Russell <rusty@rustcorp.com.au>,
	Darren Hart <darren@dvhart.com>,
	Peter Zijlstra <peterz@infradead.org>
References: <20120713180823.GA24972@redhat.com>
 <alpine.LFD.2.02.1207132032330.32033@ionos>
 <20120713185402.GA1707@redhat.com>
 <alpine.LFD.2.02.1207132108340.32033@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1207132108340.32033@ionos>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 13, 2012 at 09:11:57PM +0200, Thomas Gleixner wrote:
 > On Fri, 13 Jul 2012, Dave Jones wrote:
 > 
 > > On Fri, Jul 13, 2012 at 08:47:38PM +0200, Thomas Gleixner wrote:
 > >  > On Fri, 13 Jul 2012, Dave Jones wrote:
 > >  > 
 > >  > > Looks like calling futex() with garbage makes things unhappy.
 > >  > 
 > >  >                 WARN_ON(!&q.pi_state);
 > >  >                 pi_mutex = &q.pi_state->pi_mutex;
 > >  >                 ret = rt_mutex_finish_proxy_lock(pi_mutex, to, &rt_waiter, 1);
 > >  >                 debug_rt_mutex_free_waiter(&rt_waiter);
 > >  > 
 > >  > So there is some weird way which causes q.pi_state = NULL. Dave, did
 > >  > you see the warning before the oops happened ?
 > > 
 > > No, that didn't seem to trigger.
 > 
 > Yuck. The rt_mutex is embedded in pi_state and not a pointer and the
 > thing explodes in __lock_acquire if the raw lock protecting the
 > rtmutex internals. 
 > 
 > Can you decode the exact code line ?
 
Hmm. I think I rebuilt the kernel, so things may be slightly different, though
what I see surprises me..

decoding the Code: line shows..

Code: d8 45 0f 45 e0 4c 89 75 f0 4c 89 7d f8 85 c0 0f 84 f8 00 00 00 8b 05 e2 af fa 00 49 89 ff 89 f3 41 89 d2 85 c0 0f 84 02 01 00 00 <49> 8b 07 ba 01 00 00 00 48 3d 20 c4 0c 82 44 0f 44 e2 83 fb 01



0000000000000000 <.text>:
   0:	d8 45 0f             	fadds  0xf(%rbp)
   3:	45 e0 4c             	rex.RB loopne 0x52
   6:	89 75 f0             	mov    %esi,-0x10(%rbp)
   9:	4c 89 7d f8          	mov    %r15,-0x8(%rbp)
   d:	85 c0                	test   %eax,%eax
   f:	0f 84 f8 00 00 00    	je     0x10d
  15:	8b 05 e2 af fa 00    	mov    0xfaafe2(%rip),%eax        # 0xfaaffd
  1b:	49 89 ff             	mov    %rdi,%r15
  1e:	89 f3                	mov    %esi,%ebx
  20:	41 89 d2             	mov    %edx,%r10d
  23:	85 c0                	test   %eax,%eax
  25:	0f 84 02 01 00 00    	je     0x12d

/home/davej/tmp/tmp.SI8vbYzuK6.o:     file format elf64-x86-64


Disassembly of section .text:

0000000000000000 <.text>:
   0:	49 8b 07             	mov    (%r15),%rax
   3:	ba 01 00 00 00       	mov    $0x1,%edx
   8:	48 3d 20 c4 0c 82    	cmp    $0xffffffff820cc420,%rax
   e:	44 0f 44 e2          	cmove  %edx,%r12d
  12:	83 fb 01             	cmp    $0x1,%ebx




The only instance of 49 8b 07 followed by ba 01 in kernel/lockdep.o is this ..

        /*
         * Lockdep should run with IRQs disabled, otherwise we could
         * get an interrupt which would want to take locks, which would
         * end up in lockdep and have you got a head-ache already?
         */
        if (DEBUG_LOCKS_WARN_ON(!irqs_disabled()))
    3f88:       8b 05 00 00 00 00       mov    0x0(%rip),%eax        # 3f8e <__lock_acquire+0x4e>
    3f8e:       49 89 ff                mov    %rdi,%r15
    3f91:       89 f3                   mov    %esi,%ebx
    3f93:       41 89 d2                mov    %edx,%r10d
    3f96:       85 c0                   test   %eax,%eax
    3f98:       0f 84 02 01 00 00       je     40a0 <__lock_acquire+0x160>
                return 0;

        if (lock->key == &__lockdep_no_validate__)
    3f9e:       49 8b 07                mov    (%r15),%rax		<<<<<<<<<<<<<<<<<<
                check = 1;
    3fa1:       ba 01 00 00 00          mov    $0x1,%edx


Seems to add up.  Though the bytes in the code: line following don't match what's in the object..

    3fa6:       48 3d 00 00 00 00       cmp    $0x0,%rax
    3fac:       44 0f 44 e2             cmove  %edx,%r12d


That line at 3fa6 got changed from an actual address to a NULL.
I guess that's the &__lockdep_no_validate__ comparison.
Though it seems odd that the kernel text would change.
Does lockdep do that when it gets disabled or something ?

	Dave

