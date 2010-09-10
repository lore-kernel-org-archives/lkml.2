Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756644Ab0IJJTw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 05:19:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36194 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754579Ab0IJJTv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 05:19:51 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Brad Spengler <spender@grsecurity.net>
X-Fcc: ~/Mail/linus
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, oss-security@lists.openwall.com,
        Solar Designer <solar@openwall.com>,
        Kees Cook <kees.cook@canonical.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Oleg Nesterov <oleg@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Neil Horman <nhorman@tuxdriver.com>, linux-fsdevel@vger.kernel.org,
        pageexec@freemail.hu,
        "Brad Spengler <spender@grsecurity.net> Eugene Teo" 
	<eugene@redhat.com>
Subject: Re: [PATCH 1/3] setup_arg_pages: diagnose excessive argument size
In-Reply-To: Brad Spengler's message of  Wednesday, 8 September 2010 07:57:28 -0400 <20100908115728.GB11762@grsecurity.net>
References: <20100827220258.GF4703@outflux.net>
	<20100830005648.431B7400D9@magilla.sf.frob.com>
	<20100830032331.GA22773@openwall.com>
	<20100830100616.78971400D9@magilla.sf.frob.com>
	<20100908023417.8B055401AF@magilla.sf.frob.com>
	<20100908023549.BFFA8401AF@magilla.sf.frob.com>
	<20100908115728.GB11762@grsecurity.net>
X-Antipastobozoticataclysm: Bariumenemanilow
Message-Id: <20100910091830.F0893405D5@magilla.sf.frob.com>
Date: Fri, 10 Sep 2010 02:18:30 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I still don't think this addresses the whole problem.  

You're responding to one of three patches, and I said to begin with that
all together they only address part of the problem (not the OOM part).
So the import of this remark is somewhat mysterious.

> Without question, the rlimit / 4 check is bogus.  

I question that assertion.  For a non-RLIM_INFINITY limit, there is nothing
in particular wrong with it.  The kernel is free to pick its upper bound
for ARG_MAX by whatever method.  I don't see anything much to object to
about the rlimit/4 method.  It has no useful effect for RLIM_INFINITY and
IMHO should not try to impose any limit in that case.  But that's the only
thing I see a reason to change.

> If nobody agrees with the intent of that check, then it should be
> removed, but I think the better solution is to fix the check so that it
> matches its original intent: let the initial stack setup be up to 1/Xth
> of the min(rlimit, TASK_SIZE dependent upon personality), which allows
> space for additional stack setup in the ELF loader and then further
> growth once the process is live.  

I see no reason to suspect this was the "original intent".  It seems most
likely to me that the original intent was 1/4th the RLIMIT_STACK size, and
just nobody thought about what that meant when RLIMIT_STACK was RLIM_INFINITY.

> If that amount is overstepped, then the exec will return an error to the
> calling process instead of being terminated.

That's what happens now when RLIMIT_STACK is smaller, and that's what
people really care about.  What you suggest would require some more
significant changes to the exec code path, touching all the binfmt modules
(though probably only binfmt_elf matters).  

In the current structure of the code, the arch-dependent SET_PERSONALITY
macro used by {compat_,}binfmt_elf is the only place that knows what arch
bits to set for the new address space size.  This is itself destructive,
but also runs after flush_old_exec (the point of no return).  So you'd have
to reorganize things significantly, or add an entirely new arch macro tied
into struct binfmt somehow, or something like that.

> It might be useful to consult with the people who introduced/approved 
> the check in the first place, as they seemed to have reasons for 
> implementing it.

This was done in commit b6a2fea by Ollie Wild <aaw@google.com>:
	mm: variable length argument support
It was part of going from a fixed maximum to no fixed maximum.
The log includes:
    [a.p.zijlstra@chello.nl: limit stack size]
So perhaps it was Peter who devised the rlimit/4 idea.


Thanks,
Roland
