Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757186Ab1EZJKt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 05:10:49 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:46692 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753806Ab1EZJKr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 05:10:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=l5JbXf6HGU9RhL7c/fy80K9geC5wEc2/RHh1yH9enOlBUiJeHbTys40AGyEMe7xLgu
         66A8r3VHtw4mGsp2TnPxVFpFVMv2Q7D/g1XgZ3Hxaxn/FOXn+cYuQqFrVkiV1pNNz+YU
         iPGWAgOrW4E+BLQQ1Ug+5QmjSXs3AvFhPzaT8=
Date: Thu, 26 May 2011 11:10:41 +0200
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Pedro Alves <pedro@codesourcery.com>,
        Denys Vlasenko <vda.linux@googlemail.com>, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, bdonlan@gmail.com
Subject: Re: [PATCH 03/10] ptrace: implement PTRACE_SEIZE
Message-ID: <20110526091041.GC9715@htj.dyndns.org>
References: <1305569849-10448-1-git-send-email-tj@kernel.org>
 <201105241049.58921.pedro@codesourcery.com>
 <20110524120013.GD10334@htj.dyndns.org>
 <201105241336.04298.pedro@codesourcery.com>
 <20110524140215.GF10334@htj.dyndns.org>
 <20110525181856.GA16575@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110525181856.GA16575@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

On Wed, May 25, 2011 at 08:18:56PM +0200, Oleg Nesterov wrote:
> > Now that thinking more about it, TRAP_STOP (INTERRUPT trap) would
> > probably be better.  I'll think more about it.  For fork, it doesn't
> > really matter but deliverying SIGSTOP on CLONE isn't too good.  From
> > user's POV, TRAP_STOP should work too, right?
> 
> I am a bit confused, sorry if I missed/misunderstood the context...
> 
> I thought, we already discussed this. Obviously, PT_SEIZED should be
> inherited by the child during the auto-attach (and it is indeed copied
> by ptrace_init_task). Why should we send SIGSTOP to the child then?
> Even in the fork case, this leads to the same problems as the current
> PTRACE_ATTACH has with the bogus SIGSTOP it sends. I think TRAP_STOP
> is the only sane option, no?

I forgot about that and was thinking about events reported by
SIGTRAPs.  :)

Yes, in this case, TRAP_STOP is the only sane solution.

> Btw. Speaking of SEIZE->execvd->INTERRUPT which makes the tracee see
> a SIGTRAP. Stupid question. Perhaps PTRACE_SEIZE should set
> PT_TRACESYSGOOD | PT_TRACE_EXEC along with PT_SEIZED automatically?
> PT_SEIZED implies the new behaviour anyway.

Yeap, it makes sense to set them by default.  I was thinking about
defining a new PTRACE_EVENT_* rather than using 0x80 tho.  That way we
should be able to distinguish between enter and exit too.

This reminded me of another issue.  Currently we have two different
methods of reporting debug events.  One is direct ptrace event trap,
which ends up in ptrace_stop() from the event site and thus is
synchronous.  The other is sending SIGTRAP, literally.  Besides the
usual problems related with implicitly sending signals, this also
makes it difficult to determine which event is happening exactly and
makes the whole signal delivery/injection thing much worse.

I suspect that all ptrace traps probably started as actual SIGTRAPs
and so all the events were reported via signal delivery path and so
the signal "injection" worked; however, now we have synchronous traps
and some SIGTRAPs, which are confusing and unreliable.  I don't see
any reason why the events which are currently reported via SIGTRAPs
can't be reported via ptrace traps with unique PTRACE_EVENT_*.  I
don't think we can take synchronous traps directly but we can schedule
them, record relevant information in preallocated area and just set
TIF_SIGPENDING and let the signal delivery path report the trap.  This
will make all the events reliable and easily distinguishible and we
can fix the SIGTRAP signal problem.  What do you think?

Thanks.

-- 
tejun
