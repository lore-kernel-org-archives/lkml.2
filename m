Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752007Ab1BENjd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 08:39:33 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48079 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751712Ab1BENjb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 08:39:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=hTu5v7GYtgOlB6OpA1aA4GNQDJubPip+S3OQ8W2nFh8/DUfQrT9psJ/ds7TFebYAnR
         g+DOoVFpAT8fsg2i2VZkWOXc//EMiYrNbh1TbO3ghvdTubNBCIG6ySZ8qe3f8PNUN1HX
         eDtOBSRDRD/4cI8nrVx2WCR+e1VxykqF8ZpZM=
Date: Sat, 5 Feb 2011 14:39:26 +0100
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
Subject: Re: [PATCH 1/1] ptrace: make sure do_wait() won't hang after
 PTRACE_ATTACH
Message-ID: <20110205133926.GM12133@htj.dyndns.org>
References: <1296227324-25295-1-git-send-email-tj@kernel.org>
 <1296227324-25295-11-git-send-email-tj@kernel.org>
 <20110203204122.GA26371@redhat.com>
 <20110203204154.GB26371@redhat.com>
 <20110203213640.1F516180995@magilla.sf.frob.com>
 <20110203214450.GA29496@redhat.com>
 <20110204105343.GA12133@htj.dyndns.org>
 <20110204130455.GA3671@redhat.com>
 <20110204144858.GI12133@htj.dyndns.org>
 <20110204170602.GB15301@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110204170602.GB15301@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Oleg.

On Fri, Feb 04, 2011 at 06:06:02PM +0100, Oleg Nesterov wrote:
> > I think a good compromise would be guaranteeing that when the ptracer
> > goes away, the tracee would put into the state the real parent can
> > agree to and the real parent to be notified that it has happened.
> 
> I am not sure. The tracing should be transparent as much as possible.

Yes but there are different ways to achieve that.  Please read on.

> > We are already skipping all notifications to the real parent for
> > ptraced children, there's no pressing need to change that.  If
> > there becomes a real pressing requirement to change that.
> 
> And this looks just wrong to me. Say, why the ptraced application
> doesn't react to ^Z ? It does, just it parent have no chance to see
> this. (yes, yes, we should also change do_wait).

That's the shortcomings of the current implementation.  The specific
problem sure can be fixed by putting group stop on top of ptrace but
that is not the only direction.  In fact, that actually is the
direction we CAN'T take with ptrace because changing that will create
a lot more problems that can't be worked around.

We can introduce something completely new but we can also augment the
current implementation with what's necessary to remedy the problem.
The ptracer is already notified when the ptracee enters group stop.
There's nothing stopping us giving ptracer the ability to tell ptracee
to participate in group stop completion and notify the real parent.
It will be an extra feature, probably a new PTRACE_ operation.  This
way, the existing users behave the same way while the ones which are
updated to use the new feature would behave better w.r.t. group stop
while being ptraced.

The above is one of may possibilities and it might not be possible /
desirable as described.  I haven't thought that much about it, but my
point is that "oh, we'll have something completely new which cures
everything at once, so let's reject changes to the current code as
much as possible" does not help anyone.  Approaches like that rarely
work.  For example, the problem in this thread is cleanly solved by
really examining the problem and fixing the problem at the source (the
mixup of group and ptrace stop) and accumulating those proper
improvments and thus evolving the code base is a much more effective
way.

So, let's stop chasing unicorns.  Cake is a lie.  Let's work on what
we already have and incrementally improve it.  There might be some
extreme corner cases where userland might notice differences but as I
wrote before given the wide range of inconsistencies the current code
is showing, I think we actually have good amount of latitude.  It'll
be mostly about making sensible tradeoffs and testing the existing
users.

> > I could be wrong (with pretty high probability) but I don't really see
> > the pressing need for a completely new API.  ptrace sure is ugly and
> > quirky but it's something people are already used to.
> 
> I won't argue. And yes, in any case ptrace can't go away, we should
> try to improve it anyway. The obvious problem is that almost any
> "visible" improvement breaks something.

I don't believe any 'visible' improvement breaks something.  In fact,
the current users seem quite resillient to behavior changes (they
should as the current code behaves inconsistently in many places).
There sure will be some cases which would be put into
undefined/unsupported area but there's no reason to preserve every
single inconsistent detail of the current behavior.  As everything
else, it is a trade off we can make.

Thank you.

-- 
tejun
