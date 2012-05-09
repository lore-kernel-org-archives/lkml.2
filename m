Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932430Ab2EIVPL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 17:15:11 -0400
Received: from mga03.intel.com ([143.182.124.21]:63057 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932405Ab2EIVPF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 17:15:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="141068815"
Subject: Re: [PATCH 2/3] x86, xsave: remove thread_has_fpu() bug check in
 __sanitize_i387_state()
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: torvalds@linux-foundation.org, hpa@zytor.com, mingo@elte.hu,
        linux-kernel@vger.kernel.org, suresh@aristanetworks.com
Date: Wed, 09 May 2012 14:18:37 -0700
In-Reply-To: <20120509203047.GA334@redhat.com>
References: <1336421341.19423.4.camel@sbsiddha-desk.sc.intel.com>
	 <1336519085-27450-1-git-send-email-suresh.b.siddha@intel.com>
	 <1336519085-27450-3-git-send-email-suresh.b.siddha@intel.com>
	 <20120509203047.GA334@redhat.com>
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1336598317.4634.34.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-09 at 22:30 +0200, Oleg Nesterov wrote:
> On 05/08, Suresh Siddha wrote:
> >
> > BUG_ON() in __sanitize_i387_state() is checking that the fpu state
> > is not live any more. But for preempt kernels, task can be scheduled
> > out and in at any place and the preload_fpu logic during context switch
> > can make the fpu registers live again.
> 
> And? Do you see any particular scenario when this BUG_ON() is wrong?
> 
> Afaics, __sanitize_i387_state() should not be called if the task can
> be scheduled in with ->fpu_counter != 0.

It is not easy, that is why we haven't seen any issues for so long. I
can give an example with 64-bit kernel with preempt enabled.

Task-A which uses fpu frequently and as such you will find its
fpu_counter mostly non-zero. During its time slice, kernel used fpu by
doing kernel_fpu_begin/kernel_fpu_end(). After this, in the same
scheduling slice, task-A got a signal to handle. Then during the signal
setup path we got preempted when we are just before the
sanitize_i387_state() call in
arch/x86/kernel/xsave.c:save_i387_xstate(). And when we come back we
will have the fpu registers live that can hit the bug_on.

This doesn't happen with 32-bit kernel because they do clear_used_math()
before doing sanitize_i387_state() and any preempt shouldn't preload the
fpu state.

64-bit kernel didn't do this earlier because they do an optimization of
copying the live fpu registers on to the stack directly (see
xsave_user() in the same file) etc.

I am planning to remove this 64-bit specific signal handling
optimization and share the same signal handling code between 32bit/64bit
kernels (infact someone posted those patches before and I am planning to
dust them off soon and repost).

Also, in future because of some xstate that can't be handled in lazy
manner (for example AMD's LWP state), we will always pre-load during
context-switch. But that is a different story.

> > Similarly during core dump, thread dumping the core can schedule out
> > and in for page-allocations etc in non-preempt case.
> 
> Again, can't understand. The core-dumping thread does init_fpu()
> before it calls sanitize_i387_state().

Here I actually meant other threads context-switching in and out, while
the main thread dumps the core. For example, other threads can
context-switch in and out (because of preempt or the explicit schedule()
in kernel/exit.c:exit_mm()) and the main thread dumping core can run
into this bug when it finds some other thread with its fpu registers
live on some other cpu.

thanks,
suresh

