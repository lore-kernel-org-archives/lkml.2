Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755954Ab1EKPzR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 11:55:17 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56873 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753859Ab1EKPzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 11:55:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=X5hLGz6s6Vkl9tOUDCNr4JfuwMm8oYLY6FOWa2T1nRG5zUP2VX3huC5ciasMz5fH5e
         uBXC2aNXmq36Rz37s68srycGwhsRlfodj4vw1wT4FqVlUtc+fHXT0GMqKNxAfOK+mVGV
         EQdSflEe0U4mtZNNQwlCIP4WEbVUeyQj8a2rs=
Date: Wed, 11 May 2011 10:29:47 +0200
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: jan.kratochvil@redhat.com, vda.linux@googlemail.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu
Subject: Re: [PATCH 04/11] ptrace: implement PTRACE_INTERRUPT
Message-ID: <20110511082947.GB1661@htj.dyndns.org>
References: <1304869745-1073-1-git-send-email-tj@kernel.org>
 <1304869745-1073-5-git-send-email-tj@kernel.org>
 <20110509165857.GA30607@redhat.com>
 <20110510095022.GR1661@htj.dyndns.org>
 <20110510140620.GB21834@redhat.com>
 <20110510142033.GY1661@htj.dyndns.org>
 <20110510180811.GB32637@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110510180811.GB32637@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, May 10, 2011 at 08:08:11PM +0200, Oleg Nesterov wrote:
> On 05/10, Tejun Heo wrote:
> > > And, you know, I am not sure this is very clear. What if we change the
> > > rules so that PTRACE_SEIZE always reports PTRACE_EVENT_INTERRUPT like
> > > PTRACE_INTERRUPT? This looks more symmetrical and simple to me. IOW,
> > > ptrace(PTRACE_SEIZE) simply implies the implicit PTRACE_INTERRUPT.
> >
> > Actually, that was my initial implementation but as we don't guarantee
> > that the first trap would be an INTERRUPT one,
> 
> Yes, and ptrace(PTRACE_INTERRUPT) doesn't guarantee this too,

Yeah, sure.

> > so it seemed nicer to
> > avoid double trapping after SEIZE.
> 
> Why? We can simply say that ptrace(PTRACE_SEIZE) == attach + INTERRUPT,
> the rules are the same.

I guess the thing I wanted to avoid was programs looping over
PTRACE_CONT waiting for the INTERRUPT trap to happen.

But, yeah, it might be easier to explain that way.  Maybe I'll change
it.  I don't know.

> Hmm. Suddenly I got lost. Perhaps instead JOBCTL_TRAP_INTERRUPT should
> be cleared on any trap too, like SEIZE.

I don't think that's a good idea especially because there are
functionality differences among different traps.  ie. group stop and
interrupt traps support re-trapping on job control events while other
traps don't, so there will be cases where the debugger wants to put
tracee specifically into INTERRUPT trap.  It's just cleaner to use and
say that if you ask for INTERRUPT, you get an INTERRUPT.

> > One apparently is clone.  What were the others?
> 
> clone() is special because (I think) auto-attach should obviously
> inherit PT_SEIZED. ptrace_init_task() copies PT_SEIZED correctly, so
> we should only change tracehook_report_clone().

Alright.

> Another special (and nasty!) case is PTRACE_TRACEME. I do not know
> how often it is used, but probabaly it is important enough. At least,
> iirc, it is used by strace. Probably we need PTRACE_SEIZEME as well.

I don't agree.  PTRACE_TRACEME predates PTRACE_ATTACH and is
completely redundant.  If you can make the child do PTRACE_TRACEME,
you might as well just make it do pause() and PTRACE_SEIZE yourself,
so unless there's something PTRACE_SEIZE can't do, I don't think I'll
be adding SEIZEME.

> > At first I made PTRACE_INTERRUPT noop if it was already in INTERRUPT
> > trap but then changed my mind because guaranteeing that there will be
> > at least one PTRACE_EVENT_INTERRUPT trap after PTRACE_INTERRUPT seems
> > better than having subtle behavior difference which might be nicer in
> > limited use cases.
> 
> No, I meant -EALREADY if JOBCTL_TRAP_INTERRUPT is pending set but not
> yet reported. But anyway, this is really minor.

Sure, noop or -EALREADY or whatever.  As I wrote above, I think it's
better not to add special cases, so the rule becomes "if you schedule
an INTERRUPT, you'll get at least one INTERRUPT in the future, no
matter what."

Thanks.

-- 
tejun
