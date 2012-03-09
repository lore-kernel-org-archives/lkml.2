Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753944Ab2CION4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 09:13:56 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:38331 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752854Ab2CIONx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 09:13:53 -0500
Date: Fri, 9 Mar 2012 18:13:49 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Matt Helsley <matthltc@us.ibm.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Kees Cook <keescook@chromium.org>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] c/r: prctl: Add ability to set new mm_struct::exe_file v3
Message-ID: <20120309141349.GC13346@moon>
References: <20120308182623.GA17221@redhat.com>
 <20120308190303.GG21812@moon>
 <20120308190534.GA19827@redhat.com>
 <20120308192504.GH21812@moon>
 <20120308192559.GA20782@redhat.com>
 <20120308214817.GO21812@moon>
 <20120309124811.GA610@redhat.com>
 <20120309125735.GB13346@moon>
 <20120309133555.GA23040@moon>
 <20120309134732.GA3696@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120309134732.GA3696@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 09, 2012 at 02:47:32PM +0100, Oleg Nesterov wrote:
> On 03/09, Cyrill Gorcunov wrote:
> >
> > On Fri, Mar 09, 2012 at 04:57:35PM +0400, Cyrill Gorcunov wrote:
> > >
> > > yeah, thanks, will update.
> > >
> >
> > This one should fit all requirements I hope.
> 
> Oh, sorry Cyrill, I simply can't resist...

Hehe ;) No problem, please continue complaining,
I don't wanna miss something and try to merge a
patch with nit/error/or-whatever.

> > +	/*
> > +	 * Setting new mm::exe_file is only allowed
> > +	 * when no VM_EXECUTABLE vma's left. This is
> > +	 * a special C/R case when a restored program
> > +	 * need to change own /proc/$pid/exe symlink.
> > +	 * After this call mm::num_exe_file_vmas become
> > +	 * meaningless. If mm::num_exe_file_vmas will
> > +	 * ever increase back from zero -- this code
> > +	 * needs to be revised, thus WARN_ here, just
> > +	 * to be sure.
> 
> To be shure in what??

To be sure it's not increased somewhere else before
down_write taken.

> 
> > +	 */
> > +	down_write(&mm->mmap_sem);
> > +	WARN_ON_ONCE(mm->num_exe_file_vmas);
> 
> We already checked it is zero. Yes, it shouldn't grow. But why
> do we need another check here?
> 
> If it can grow, it can grow after we drop mmap_sem as well and
> this would be wrong. So may be we need another WARN_ON() at the
> end?
> 
> I'd understand if you add something like
> 
> 	WARN_ON(!mm->num_exe_file_vmas && !current->in_exec);
> 
> into added_exe_file_vma().
> 
> Or
> 	WARN_ON(mm->num_exe_file_vmas <= 0);
> 
> into removed_exe_file_vma().

This one looks like a good idea for me -- it's cheap and
not a hot path.

> 
> But imho your WARN looks like "OK, I checked it lockless but I
> am not sure this is correct".

Oleg, I bet if someone will be changing num_exe_file_vmas overall
idea -- this prctl code will be fixed at last moment (if ever) only
because it's very specific, so I wanted to not miss such moment
and add some check that the rest of the kernel is in a good state.
This test is cheap but may prevent potential problem if one day
mm::exe_file concept will be reworked.

Sure I can simply drop this WARN_ON ;)

	Cyrill
