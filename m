Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758506Ab2EJQiA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 12:38:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26632 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754626Ab2EJQh6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 12:37:58 -0400
Date: Thu, 10 May 2012 18:36:47 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: torvalds@linux-foundation.org, hpa@zytor.com, mingo@elte.hu,
        linux-kernel@vger.kernel.org, suresh@aristanetworks.com
Subject: Re: [PATCH 2/3] x86, xsave: remove thread_has_fpu() bug check in
	__sanitize_i387_state()
Message-ID: <20120510163647.GA20106@redhat.com>
References: <1336421341.19423.4.camel@sbsiddha-desk.sc.intel.com> <1336519085-27450-1-git-send-email-suresh.b.siddha@intel.com> <1336519085-27450-3-git-send-email-suresh.b.siddha@intel.com> <20120509203047.GA334@redhat.com> <1336598317.4634.34.camel@sbsiddha-desk.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1336598317.4634.34.camel@sbsiddha-desk.sc.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/09, Suresh Siddha wrote:
>
> On Wed, 2012-05-09 at 22:30 +0200, Oleg Nesterov wrote:
> > On 05/08, Suresh Siddha wrote:
> > >
> > > BUG_ON() in __sanitize_i387_state() is checking that the fpu state
> > > is not live any more. But for preempt kernels, task can be scheduled
> > > out and in at any place and the preload_fpu logic during context switch
> > > can make the fpu registers live again.
> >
> > And? Do you see any particular scenario when this BUG_ON() is wrong?
> >
> > Afaics, __sanitize_i387_state() should not be called if the task can
> > be scheduled in with ->fpu_counter != 0.
>
> It is not easy, that is why we haven't seen any issues for so long. I
> can give an example with 64-bit kernel with preempt enabled.
>
> Task-A which uses fpu frequently and as such you will find its
> fpu_counter mostly non-zero. During its time slice, kernel used fpu by
> doing kernel_fpu_begin/kernel_fpu_end(). After this, in the same
> scheduling slice, task-A got a signal to handle. Then during the signal
> setup path we got preempted when we are just before the
> sanitize_i387_state() call in
> arch/x86/kernel/xsave.c:save_i387_xstate(). And when we come back we
> will have the fpu registers live that can hit the bug_on.

Indeed. Thanks a lot for your explanation.

> I am planning to remove this 64-bit specific signal handling
> optimization and share the same signal handling code between 32bit/64bit
> kernels (infact someone posted those patches before and I am planning to
> dust them off soon and repost).

Cool ;)

> > > Similarly during core dump, thread dumping the core can schedule out
> > > and in for page-allocations etc in non-preempt case.
> >
> > Again, can't understand. The core-dumping thread does init_fpu()
> > before it calls sanitize_i387_state().
>
> Here I actually meant other threads context-switching in and out, while
> the main thread dumps the core.

I see, thanks.

Oleg.

