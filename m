Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752461Ab1BRRIc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 12:08:32 -0500
Received: from mail-bw0-f42.google.com ([209.85.214.42]:44839 "EHLO
	mail-bw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182Ab1BRRI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 12:08:29 -0500
X-Greylist: delayed 360 seconds by postgrey-1.27 at vger.kernel.org; Fri, 18 Feb 2011 12:08:29 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=FkFtc9rFGqQj081HrwXurKKBXKaah8PTWoRmPHM7hCTDbc9piC/JvlnVxDeeed7yUZ
         kFTQiUL8tFxBG5d5bFIR8LtzXGx23FiCRtphktRszU9d9jLmFpYPhCeFiff5C+p21kyD
         6dMig9j492TrDOH54cgARNnDrjbHU0aa7P6e0=
Date: Fri, 18 Feb 2011 18:02:12 +0100
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>,
        Denys Vlasenko <vda.linux@googlemail.com>, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
Subject: Re: [PATCH 1/1] ptrace: make sure do_wait() won't hang after
 PTRACE_ATTACH
Message-ID: <20110218170212.GS21209@htj.dyndns.org>
References: <20110214151340.GP18742@htj.dyndns.org>
 <AANLkTi=Djwcf9YoUrGtTEOp8W_YhsefzrNhMxVhtw_Lp@mail.gmail.com>
 <20110214175144.GC15847@redhat.com>
 <AANLkTi=VVWVkrqqQyOtsP72S5-nWny=Ukmf_r-m1qMwV@mail.gmail.com>
 <20110214190141.GA19221@redhat.com>
 <AANLkTi=_af8+XKD+d-677JpQZA=AN2EsydscSYxk7z55@mail.gmail.com>
 <20110214200130.GA21559@redhat.com>
 <20110215152448.GL3160@htj.dyndns.org>
 <20110215173149.239601807B7@magilla.sf.frob.com>
 <20110215202747.GA20560@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110215202747.GA20560@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Oleg.

Still trying to follow the new discussion.

On Tue, Feb 15, 2011 at 09:27:47PM +0100, Oleg Nesterov wrote:
> > The reason for the transition to TASK_TRACED is to prevent a race with
> > SIGCONT waking the task.  There is always a race with SIGKILL waking it,
> > but the circumstances where that can really matter are far fewer.
> > You need to make sure that the work PTRACE_GETSIGINFO does to access
> > last_siginfo cannot race with that pointer disappearing or the stack
> > space it points to becoming invalid.  I think the use of siglock ensures
> > that, but Oleg should verify it.
> 
> Yes, I think this is safe.
> 
> I do not really like this idea because it looks a bit strange to treat
> PTRACE_GETSIGINFO specially, and this doesn't solve all problems. And,
> once again, I still hope we can change ptrace_resume() so that it doesn't
> wakeup the stopped (I mean, SIGNAL_STOP_STOPPED) tracee, in this case this
> hack is not needed.
> 
> And. We are going to add the new requests which doesn't need the stopped
> tracee anyway. So we can just add PTRACE_HAS_SIGINFO which returns
> child->last_siginfo != NULL. This looks simpler, and this is compatible.
> Of course this check is racy, but this doesn't matter. PTRACE_GETSIGINFO
> is equally racy if it doesn't change the state to TASK_TRACED.

This is probably where we disagree the most but I think the weird part
isn't making PTRACE_GETSIGINFO exempt from TASK_TRACE transition.  The
weirdness starts when the tracee is put into TASK_STOPPED while being
ptraced.  I think such dual modes of operation inherently lead to
strange problems.

Instead of having simple "a ptracer stops in TASK_TRACED and its
execution is under the control of ptrace", we end up with the tracee
stopping here or there depending on why it stops and the involved
behavioral subtleties like consumption of wait state and the mentioned
GETSIGINFO problem.  The patch which puts the tracee into TASK_TRACED
on ATTACH already fix two problems discussed in this thread without
doing anything wonky.  I think it says a lot.

As it currently stands, SIGSTOP/CONT while ptraced doesn't work and
even if we bend the rules subtly and provide sneaky ways like the
above, userland needs to be modified to make use of it anyway.  I
think it would be far cleaner to simply make ptracee always stop in
TASK_TRACED and give the ptracer a way to notice what's happening to
the tracee w.r.t. group stop, so that it can comply if it wants to.
What do you think?

Thank you.

-- 
tejun
