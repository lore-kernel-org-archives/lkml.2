Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756282Ab0IJJAr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 05:00:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28781 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754523Ab0IJJAp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 05:00:45 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: pageexec@freemail.hu
X-Fcc: ~/Mail/linus
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, oss-security@lists.openwall.com,
        Solar Designer <solar@openwall.com>,
        Kees Cook <kees.cook@canonical.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Oleg Nesterov <oleg@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Neil Horman <nhorman@tuxdriver.com>, linux-fsdevel@vger.kernel.org,
        "Brad Spengler <spender@grsecurity.net> Eugene Teo" 
	<eugene@redhat.com>
Subject: Re: [PATCH 1/3] setup_arg_pages: diagnose excessive argument size
In-Reply-To: pageexec@freemail.hu's message of  Wednesday, 8 September 2010 10:29:58 +0200 <4C874986.23581.F34F4BD@pageexec.freemail.hu>
References: <20100827220258.GF4703@outflux.net>
	<Roland McGrath's message of  Tuesday, 7 September 2010 19:34:17 -0700 <20100908023417.8B055401AF@magilla.sf.frob.com>
	<20100908023549.BFFA8401AF@magilla.sf.frob.com>
	<4C874986.23581.F34F4BD@pageexec.freemail.hu>
Emacs: a Lisp interpreter masquerading as ... a Lisp interpreter!
Message-Id: <20100910085915.8CC23405D5@magilla.sf.frob.com>
Date: Fri, 10 Sep 2010 01:59:15 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +	if (unlikely(stack_top < mmap_min_addr) ||
> 
> this could arguably elicit some warning, or even better, prevent the
> sysctl from setting mmap_min_addr too high in the first place.

This code has local checks to ensure that things don't fail worse later.
Those are good to have regardless.  If you'd like to add some constraints
on setting mmap_min_addr, that's certainly fine too.  But it's no reason
not to have this simple and clear check here.

> or alternatively, just check for
> 
> 	mmap_min_addr > stack_top - (vma->vm_end - vma->vm_start)

IMHO that is far less clear as to what the intent of the check is than what
I wrote.  It's especially subtle that this check allows overflow and then
you check for that later, rather than the formulation I gave where no
overflow is possible and it's immediately obvious why.

> which looks even better if done in shift_arg_pages as i've done it in PaX:

My change to setup_arg_pages is consistent with the existing
CONFIG_STACK_GROWSUP code.  IMHO simple fixes should go in first
and other restructuring of the code can be done later.

> > +		return -ENOMEM;
> 
> i'd say EFAULT is more consistent, ENOMEM is used for cases when the kernel
> couldn't allocate physical memory for something, EFAULT is when there's some
> issue with the address space itself (based on the reaction to find_vma or
> expand_stack failures).

I disagree.  IMHO, the only proper use of EFAULT is for the passing of a
bad pointer (including passing data that includes a bad pointer, etc.).
So execve really should only use EFAULT when the pointers passed in the
system call are bad.  I used ENOMEM purely for the reason that the
existing CONFIG_STACK_GROWSUP code I paralleled uses it.  But it
certainly does make more sense than EFAULT does.  ENOMEM is used for
cases where you couldn't get the address space you wanted (mmap), which
is a fairly close analogue to this case.

But the one error code that is actually correct for the case is E2BIG.
Obviously that's really the right thing for Argument list too long cases.

The choice of error code here is fairly academic.  Any failure of
setup_arg_pages always leads to sending ourselves a SIGKILL before
returning the error code to percolate back to execve.  So it's only the
error code seen in syscall tracing before the process dies.  It's not
"user-visible" in the usual sense (i.e. POSIX doesn't care what code we
use here).

> also what about the BUG_ON in shift_arg_pages? it could go now, right?

It is now impossible by the logic of the arithmetic, yes.  But it is
another local sanity check asserting the assumptions of the code in that
function.  So there is no reason to 

> personally, i prefer to do this the way i did it in PaX: move up the
> shift_arg_pages call a bit and turn the BUG_ON into a proper check.

I'm more comfortable with a fix that doesn't change any other aspect of the
behavior.  Probably moving the call to shift_arg_pages around is fine.  But
IMHO that belongs in a separate set of cleanup patches, and not in the
isolated fix for the BUG_ON hit.


Thanks,
Roland
