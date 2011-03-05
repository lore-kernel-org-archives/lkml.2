Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752773Ab1CEIdp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Mar 2011 03:33:45 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:57186 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752180Ab1CEIdo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Mar 2011 03:33:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=cohNsuIeKToynZaxMCVe7KKHZdNo+LoKqF/gTE7dv1Ol/8KiH4UaHkGGlXi8/if2le
         2ZvEpk1p4eoaXYW4aJw1T/d4tyUcCwdPnTFkXptTaEnCLR5fv5TMyqvQvtOR9OFsG9MC
         /aC+ZTsGROly2qqVhgUkXkNYCL81tXfkML6O4=
Date: Sat, 5 Mar 2011 09:33:39 +0100
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>, jan.kratochvil@redhat.com,
        Denys Vlasenko <vda.linux@googlemail.com>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
Subject: Re: [RFC] Proposal for ptrace improvements
Message-ID: <20110305083339.GD20499@htj.dyndns.org>
References: <20110301152457.GE26074@htj.dyndns.org>
 <20110303173422.GA27960@redhat.com>
 <20110303202246.GB32152@redhat.com>
 <20110304082329.GA20499@htj.dyndns.org>
 <20110304181630.GA28729@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110304181630.GA28729@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, Oleg.

On Fri, Mar 04, 2011 at 07:16:30PM +0100, Oleg Nesterov wrote:
> > The question is whether to make group
> >   stop state available for other trap sites too or just enable it in
> >   the new trap site.  ATM, I'm leaning toward the latter.

I changed my mind and am now leaning toward the former.  That would
make things easier for debuggers which resume the tracee but wants to
keep track of the job control state.  Let's see how implementation
turns out.  Planning can do only so much and implementation often
comes with surprises of its own.

> There is another corner case. Suppose that another SIGSTOP comes
> while the tracee runs the endless loop above.
> 
> In this case nothing changes, the tracee should report this signal.
> But what should it do if the debugger does PTRACE_CONT(SIGSTOP) after
> that?
> 
> Should it stop and report another job control stop after that, or
> should it ignore this signal? In the first case, at least we should
> not notify the real parent again. In the latter case, perhaps the
> naive debugger can be confused and this differs from the current
> behaviour.

Interesting.  Ignoring would be the cleaner choice but I think we're
bound to deliver it to the tracer and suppress notification to the
real parent; otherwise, the behavior would change a bit too much - an
invisible stop signal mask out of nowhere wouldn't be too pleasant.

> And, if it stops, should this also stop other PTRACE_CONT'ed threads
> as well? Currently we do...

I think so; otherwise, again, the behavior would change too much for
the current users.  This definitely needs to be documented in detail.

> Not that I think this is terribly important, but I think it makes
> sense to discuss/document this case anyway.

Yeah, definitely.  I wasn't thinking about cases like the above but we
need to so please keep them coming.  :-)

> Anyway. I think this RFC is fine.

Great.  Thanks.

-- 
tejun
