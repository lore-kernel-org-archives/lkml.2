Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751626Ab1EJSJw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 14:09:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49942 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750986Ab1EJSJv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 14:09:51 -0400
Date: Tue, 10 May 2011 20:08:11 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: jan.kratochvil@redhat.com, vda.linux@googlemail.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu
Subject: Re: [PATCH 04/11] ptrace: implement PTRACE_INTERRUPT
Message-ID: <20110510180811.GB32637@redhat.com>
References: <1304869745-1073-1-git-send-email-tj@kernel.org> <1304869745-1073-5-git-send-email-tj@kernel.org> <20110509165857.GA30607@redhat.com> <20110510095022.GR1661@htj.dyndns.org> <20110510140620.GB21834@redhat.com> <20110510142033.GY1661@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110510142033.GY1661@htj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/10, Tejun Heo wrote:
>
> > And, you know, I am not sure this is very clear. What if we change the
> > rules so that PTRACE_SEIZE always reports PTRACE_EVENT_INTERRUPT like
> > PTRACE_INTERRUPT? This looks more symmetrical and simple to me. IOW,
> > ptrace(PTRACE_SEIZE) simply implies the implicit PTRACE_INTERRUPT.
>
> Actually, that was my initial implementation but as we don't guarantee
> that the first trap would be an INTERRUPT one,

Yes, and ptrace(PTRACE_INTERRUPT) doesn't guarantee this too,

> so it seemed nicer to
> avoid double trapping after SEIZE.

Why? We can simply say that ptrace(PTRACE_SEIZE) == attach + INTERRUPT,
the rules are the same.

Hmm. Suddenly I got lost. Perhaps instead JOBCTL_TRAP_INTERRUPT should
be cleared on any trap too, like SEIZE.

Again, agaian, I don't have the strong opinion, I am asking.

> Maybe we can make sure that
> INTERRUPT is always the trap to be taken

I don't know. Personally, I do not think this will make the API much
better.

> but it would be a tad bit
> more complex than the current implementation.

Yes.

> > Oh. And this reminds me the previous discussion. Should PTRACE_SEIZE
> > stop the tracee? Perhaps it should only attach or do PTRACE_INTERRUPT
> > depending on flags? Personally I think it should stop...
> >
> > To clarify, personally I do not know. Jan, Denys, all, please comment.
> > If PTRACE_SEIZE doesn't stop the tracee, then we should probably pass
> > more options.
>
> I'm rather strongly against not trapping and somebody would have to
> give me _very_ convincing rationales to change my mind on the subject.

Yes, I agree.

> > Either way, these changes do not handle the auto-attach case correctly.
> > tracehook_report_clone() shouldn't send SIGSTOP unconditionally, we
> > should check PT_SEIZED. And perhaps we can do auto-attach better, but
> > right now this is off-topic.
>
> Oh yeah, that's something I meant to ask you but forgot.  The SEIZE
> behaviors are not complete after this patchset and thus there's no
> patch to remove the DEVEL flag yet. ISTR you telling me there are two
> or three conditions where the reporting/stopping isn't transparent in
> a previous mail, which I can't find anymore.

Hmm. No, I can't recall anything related...

> One apparently is clone.
> What were the others?

clone() is special because (I think) auto-attach should obviously
inherit PT_SEIZED. ptrace_init_task() copies PT_SEIZED correctly, so
we should only change tracehook_report_clone().

Another special (and nasty!) case is PTRACE_TRACEME. I do not know
how often it is used, but probabaly it is important enough. At least,
iirc, it is used by strace. Probably we need PTRACE_SEIZEME as well.

> > Well. Perhaps PTRACE_INTERRUPT should return -EALREADY or something if
> > JOBCTL_TRAP_INTERRUPT is already set? Again, again, it is not that I think
> > this is really useful. But since we are going to add the new API it is
> > better to discuss every detail.
>
> At first I made PTRACE_INTERRUPT noop if it was already in INTERRUPT
> trap but then changed my mind because guaranteeing that there will be
> at least one PTRACE_EVENT_INTERRUPT trap after PTRACE_INTERRUPT seems
> better than having subtle behavior difference which might be nicer in
> limited use cases.

No, I meant -EALREADY if JOBCTL_TRAP_INTERRUPT is pending set but not
yet reported. But anyway, this is really minor.

Oleg.

