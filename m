Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756582Ab1BXUjB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 15:39:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7312 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756559Ab1BXUi5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 15:38:57 -0500
Date: Thu, 24 Feb 2011 21:29:41 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Roland McGrath <roland@redhat.com>,
        Denys Vlasenko <vda.linux@googlemail.com>, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
Subject: Re: [PATCH 1/1] ptrace: make sure do_wait() won't hang after
	PTRACE_ATTACH
Message-ID: <20110224202941.GA12258@redhat.com>
References: <AANLkTi=VVWVkrqqQyOtsP72S5-nWny=Ukmf_r-m1qMwV@mail.gmail.com> <20110214190141.GA19221@redhat.com> <AANLkTi=_af8+XKD+d-677JpQZA=AN2EsydscSYxk7z55@mail.gmail.com> <20110214200130.GA21559@redhat.com> <20110215152448.GL3160@htj.dyndns.org> <20110215173149.239601807B7@magilla.sf.frob.com> <20110215202747.GA20560@redhat.com> <20110218170212.GS21209@htj.dyndns.org> <20110218193709.GA9700@redhat.com> <20110221162206.GN31267@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110221162206.GN31267@htj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

On 02/21, Tejun Heo wrote:
>

Damn. Today is 02/24 ;) sorry.

> On Fri, Feb 18, 2011 at 08:37:09PM +0100, Oleg Nesterov wrote:
>
> > > As it currently stands, SIGSTOP/CONT while ptraced doesn't work
> >
> > And this is probably where we disagree the most. I think this is bug,
> > and this should be fixed.
>
> I don't think we disagree that it is a bug.  I want to fix it too but
> we definitely seem to disagree on how.

Yes, but I also think that the running tracee in the SIGNAL_STOP_STOPPED
process is bug by itself. IIUC, you think this is fine.

> I want to give more control to
> the ptracer so that the tracer has enough information and control to
> follow the group stop semantics if it wants to and you want to give
> more control to group stop so that it overrides the tracer and always
> does the right thing regarding group stop.

Yes, but debugger still has the control. It can nack SIGSTOP, or if
the tracee was already stopped it can send SIGCONT.

> > > I think it would be far cleaner to simply make ptracee always stop
> > > in TASK_TRACED and give the ptracer a way to notice what's
> > > happening to the tracee
> >
> > Well. If we accept the proposed PTRACE_CONT-needs-SIGCONT behaviour,
> > then I think this probably makes sense. The tracee stops under ptrace,
> > the possible SIGCONT shouldn't abuse debugger which wants to know, say,
> > the state of registers.
>
> The objections I have against PTRACE_CONT-needs-SIGCONT are,
>
> * It will be very different from the current behavior.

Unfortunately, you are right. Again, I think the current behaviour
is very wrong, but of course you are right that this behaviour is
very old, and thus perhaps we can't change it whatever I think.

> * ptrace, sans the odd SIGSTOP on attach which we should remove, is
>   per-task.  Sending out SIGCONT on PTRACE_CONT would break that.  I
>   really don't think that's a good idea.

Hmm. But why do you think we should always send SIGCONT after attach?

> * PTRACE_CONT would be behaving completely differently depending on
>   whether it's resuming from group stop or other traps.

Afaics, no. It does not matter from where the tracee resumes. See
the [pseudo patch] I sent. Once again, it doesn't really work, it
only tries to explain what I mean.

> > Once debugger does PTRACE_CONT, the tracee becomes TASK_STOPPED and
> > now it is "visible" to SIGCONT (or the tracee resumes if SIGCONT has
> > come in between).
> >
> > But I think you will equally blame this TRACED/STOPPED transition
> > as "behavioral subtleties" and I can understand you even if I disagree.
> > And yes, this leads to other questions. But note that this greatly
> > simplifies things. The tracee can never participate in the same
> > group-stop twice.
>
> But that's not really because the problem is solved.  The problem is
> put out of scope by forcing the tracer to always override group stop.

Hmm, can't understand... But probably I should just reply to the next
email from you.

Oleg.

