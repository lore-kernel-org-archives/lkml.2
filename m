Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753289Ab1GYVrj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 17:47:39 -0400
Received: from mail-ey0-f171.google.com ([209.85.215.171]:61001 "EHLO
	mail-ey0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753181Ab1GYVrf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 17:47:35 -0400
Date: Tue, 26 Jul 2011 01:47:31 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ian Campbell <Ian.Campbell@citrix.com>, linux-kernel@vger.kernel.org,
        Pekka Enberg <penberg@kernel.org>, Andi Kleen <ak@linux.intel.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 0/3] minor cleanups to EFLAGS initialisation in
 ret_from_fork
Message-ID: <20110725214731.GE27137@sun>
References: <1311587883.27940.20.camel@cthulhu.hellion.org.uk>
 <20110725101902.GP4362@sun>
 <20110725182049.GD27137@sun>
 <4E2DDBAA.60200@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E2DDBAA.60200@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 25, 2011 at 02:10:02PM -0700, H. Peter Anvin wrote:
> On 07/25/2011 11:20 AM, Cyrill Gorcunov wrote:
> > On Mon, Jul 25, 2011 at 02:19:02PM +0400, Cyrill Gorcunov wrote:
> >> On Mon, Jul 25, 2011 at 10:58:03AM +0100, Ian Campbell wrote:
> >>> The following series removes the use of a global kernel_eflags variable
> >>> from the x86_64 ret_from_fork path and (very slightly) merges the 32 and
> >>> 64 bit version of that code path.
> >>>
> >>> kernel_eflags could be made a __read_mostly but actually there is no
> >>> reason to prefer the value at cpu_init() time to a compile time constant
> >>> value for the initial eflags after a fork.
> >>>
> >>> Ian.
> >>>
> >>
> >> Thanks, Ian! I think noone against this simplification, Peter, Andi?
> >>
> >> 	Cyrill
> > 
> > Ian, I've missed in first place that you've opened IRQs window _before_
> > schedule_tail() call, ie it's not 1:1 code mapping as it was before.
> > 
> > Note kernel_eflags has IF clear and what we have: the ret_from_fork on
> > x86-64 happens _only_ inside context_switch call, ie
> > 
> > schedule (sched.c)
> >         ...
> >         raw_spin_lock_irq
> >         ...
> >         context_switch
> >                 switch_to
> >                         "jnz   ret_from_fork\n\t"
> >                         pushq_cfi kernel_eflags(%rip)
> >                         popfq_cfi                               # reset kernel eflags
> > 
> > --->                    irqs are still disabled
> > 
> >                         call schedule_tail                      # rdi: 'prev' task parameter
> >                                 finish_lock_switch
> >                                         raw_spin_unlock_irq
> > 
> > I bet raw_spin_lock_irq at the beginning of the schedule() is set
> > for a reason and such change is not safe. Though I may be missing
> > something again...
> > 
> 
> This definitely doesn't look "obviously safe" to me.  However, does
> anyone see a problem with unconditionally leaving IF disabled even on 32
> bits (I haven't traced all the paths yet), i.e. doing the *opposite* of
> Ian's patch #2?
> 
> 	-hpa
> 

On x86-32 it seems to be similar (not identical in calls though)

copy_thread()
	p->thread.ip = (unsigned long)ret_from_fork;

and the task get queued into tasks queue, but later when switch_to
happens irqs are blocked at ret_from_fork call. I better poke PeterZ
here /CC'ed/ ;)

	Cyrill
