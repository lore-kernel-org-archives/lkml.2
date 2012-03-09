Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755954Ab2CIOdm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 09:33:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64697 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754605Ab2CIOdk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 09:33:40 -0500
Date: Fri, 9 Mar 2012 15:26:20 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Matt Helsley <matthltc@us.ibm.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Kees Cook <keescook@chromium.org>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] c/r: prctl: Add ability to set new mm_struct::exe_file v3
Message-ID: <20120309142620.GA5334@redhat.com>
References: <20120308190303.GG21812@moon> <20120308190534.GA19827@redhat.com> <20120308192504.GH21812@moon> <20120308192559.GA20782@redhat.com> <20120308214817.GO21812@moon> <20120309124811.GA610@redhat.com> <20120309125735.GB13346@moon> <20120309133555.GA23040@moon> <20120309134732.GA3696@redhat.com> <20120309141349.GC13346@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120309141349.GC13346@moon>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/09, Cyrill Gorcunov wrote:
>
> > > +	/*
> > > +	 * Setting new mm::exe_file is only allowed
> > > +	 * when no VM_EXECUTABLE vma's left. This is
> > > +	 * a special C/R case when a restored program
> > > +	 * need to change own /proc/$pid/exe symlink.
> > > +	 * After this call mm::num_exe_file_vmas become
> > > +	 * meaningless. If mm::num_exe_file_vmas will
> > > +	 * ever increase back from zero -- this code
> > > +	 * needs to be revised, thus WARN_ here, just
> > > +	 * to be sure.
> >
> > To be shure in what??
>
> To be sure it's not increased somewhere else before
> down_write taken.

Who can do this? Only another CLONE_VM thread. And _only_ if we
already have the bug in mm_exe accounting logic. And only if that
thread does something to trigger the bug in the small window
between.

> > I'd understand if you add something like
> >
> > 	WARN_ON(!mm->num_exe_file_vmas && !current->in_exec);
> >
> > into added_exe_file_vma().
> >
> > Or
> > 	WARN_ON(mm->num_exe_file_vmas <= 0);
> >
> > into removed_exe_file_vma().
>
> This one looks like a good idea for me -- it's cheap and
> not a hot path.

But not in this patch, please.

> > But imho your WARN looks like "OK, I checked it lockless but I
> > am not sure this is correct".
>
> Oleg, I bet if someone will be changing num_exe_file_vmas overall
> idea -- this prctl code will be fixed at last moment (if ever) only
> because it's very specific, so I wanted to not miss such moment
> and add some check that the rest of the kernel is in a good state.
> This test is cheap but may prevent potential problem if one day
> mm::exe_file concept will be reworked.

The test is cheap indeed. If you mean performance-wise.

But it looks confusing, imho. I do not care about a couple of CPU
cycles. The code should be optimized for the reading in the first
place, not for executing ;) Imho, of course.

And once again. Following your logic you need another WARN_ON()
right after we drop mmap_sem. Why? To be sure it's not increased
somewhere else _after_ down_write taken. And another one after
fput.

Sure, bugs are possible. And yes, in theory this WARN_ON() can
catch some problem. But there is tradeoff. Given that you need
another thread to trigger the (potential) bug and the window is
tiny, how high do you estimate the probability it can help?

> Sure I can simply drop this WARN_ON ;)

Oh, keep it if you like it ;)

Yes I hate it, but you are the author and this is almost cosmetic.

Oleg.

