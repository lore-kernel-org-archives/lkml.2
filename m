Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755873Ab1BYPqD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 10:46:03 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:42783 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752888Ab1BYPqB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 10:46:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=uvSrSuawqozAV3p3mFF8xVoP3pl2U/Ri1ehQu/hnr3QNeUPr8ET7tancLYooRwEqU3
         rbTchuszF0iPEDfaiRMkoWp4UtUTR7vfYXUJrJeDMBrIKwj2YcNz1T4H7EvkemENYOE3
         u/8HTyx9CxrXhxFGY+w+pLxr2zlpK+PfWh4oE=
Date: Fri, 25 Feb 2011 16:45:55 +0100
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Denys Vlasenko <vda.linux@googlemail.com>,
        Roland McGrath <roland@redhat.com>, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
Subject: Re: [PATCH 1/1] ptrace: make sure do_wait() won't hang after
 PTRACE_ATTACH
Message-ID: <20110225154555.GP24828@htj.dyndns.org>
References: <20110209141803.GH3770@htj.dyndns.org>
 <201102132325.55353.vda.linux@googlemail.com>
 <20110214151340.GP18742@htj.dyndns.org>
 <AANLkTi=Djwcf9YoUrGtTEOp8W_YhsefzrNhMxVhtw_Lp@mail.gmail.com>
 <20110214173012.GA18742@htj.dyndns.org>
 <AANLkTinntVGcOdZSS3gWz39eq3EDiMxXgYfc6+M1Z0iE@mail.gmail.com>
 <20110221151619.GM31267@htj.dyndns.org>
 <20110221152855.GA20769@redhat.com>
 <20110222162454.GB31267@htj.dyndns.org>
 <20110224210819.GB12258@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110224210819.GB12258@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Feb 24, 2011 at 10:08:19PM +0100, Oleg Nesterov wrote:
> On 02/22, Tejun Heo wrote:
> > > What is important, I think ptrace should respect SIGNAL_STOP_STOPPED.
> > > IOW, when the tracee is group-stopped (TASK_STOPPED or TASK_TRACED,
> > > doesn't matter), ptrace_resume() should not wake it up, but merely
> > > do set_task_state(TASK_STATE) and make it resumeable by SIGCONT.
> >
> > I don't think that's gonna fly.  It first is a very user-visible
> > change to how ptrace_resume() works
> 
> Yes. But can't resist, this is a bit unfair ;) It was you who convinced
> me we should cleanup this horror somehow, even if we break some corner
> cases.

Okay, but I don't think I have changed my position.  Things like the
weird race windows visible from some other thread fall in weird corner
cases but the basic stop/resume behavior is much more fundamental than
that and I don't think it would be wise to change that when there are
other ways to solve the problems.  I was referring more to the subtle
implementation details which prevent the problems from being solved
than changing the model itself.

> However, again, I can't argue. Perhaps this change is too radical.

Or maybe I'm just throwing out different arguments as I see fit.  :-P

Anyways, I'm opposed to changing the principles of the current
behavior for two reasons.

1. Changing those would be too visible and can be avoided by taking a
   different approach.

2. I think, in principle, the current per-task behavior is better than
   the proposed behavior of making jctl and ptrace intertwined.

> > As Jan's examples showed, there are things which the
> > debugger does behind group stop's back and some of them are quite
> > legitimate and useful things to do like running some code
> 
> Yes. This can surprise a user which runs the unmodified debugger.

Yeap, it would.

> > If you mix ptrace trap and group stop and then fix group stop
> > notification, not only multithreaded debugging becomes quite
> > cumbersome (suddenly ptracing becomes per-process thing instead of
> > per-thread),
> 
> It should be, imho. Like SIGKILL, SIGSTOP/SIGCONT are not per-thread.
> This is per-process thing.

jctl should be and will stay to be per-process, but that doesn't mean
ptrace needs to interact with them at process level.  ptrace can still
be per-task and operate beneath jctl, which is what I'm proposing to
do.

Requiring ptrace to follow jctl's rules might be conceptually
appealing (not to me) but it changes the current behavior a lot and
affects multithread debugging capability significantly.  I really
can't see much upside of such change.

> > it becomes almost impossible to debug jctl behaviors.
> > Jctl becomes completely intertwined with ptracing and the real parent
> > would get numerous notifications during the course of debugging.
> 
> Again, I think this is a win. The real parent should know that, say,
> its child becomes running after it was stopped. It does not matter
> why it was CLD_CONTINUED, it was resumed and that is all.

I see and we do disagree.  :-)

> > I think they belong to different layers and they should stack instead
> > of mix.  I'll try to write up a summary for how I think it can be done
> > later
> 
> OK. You know, we already spent sooooooooooooooooooooooooooooooooooooooo
> much time discussing this, I have the strong desire to agree in advance
> with anything new ;)

Yeah!!  I'll try to write it up tomorrow.

> > but in short I think we just need two more PTRACE calls (one for
> > combined SIGSTOPless attach + INTERRUPT
> 
> Yes, we are discussing these requests on archer,

Can we please do that on LKML?  It's a kernel change after all.

> > and the other for jctl monitoring)
> 
> Of course, we can add the new requests to help gdb/strace/whatever
> to handle jctl. In fact I think we should in any case.
> 
> But this is "easy". In the context of this discussion, my only concern
> is the current behaviour.

IMHO, as long as we don't break the current users in any significant
way, it should be okay, but I don't think we can or should make
fundamental changes to the existing behaviors.  My position is, I
guess, to change the things which prevent us from implementing the new
things.

Thank you.

-- 
tejun
