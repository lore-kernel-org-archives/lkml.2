Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932114Ab1BXVRM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 16:17:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22410 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754950Ab1BXVRI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 16:17:08 -0500
Date: Thu, 24 Feb 2011 22:08:19 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Denys Vlasenko <vda.linux@googlemail.com>,
        Roland McGrath <roland@redhat.com>, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
Subject: Re: [PATCH 1/1] ptrace: make sure do_wait() won't hang after
	PTRACE_ATTACH
Message-ID: <20110224210819.GB12258@redhat.com>
References: <20110207174821.GA1237@redhat.com> <20110209141803.GH3770@htj.dyndns.org> <201102132325.55353.vda.linux@googlemail.com> <20110214151340.GP18742@htj.dyndns.org> <AANLkTi=Djwcf9YoUrGtTEOp8W_YhsefzrNhMxVhtw_Lp@mail.gmail.com> <20110214173012.GA18742@htj.dyndns.org> <AANLkTinntVGcOdZSS3gWz39eq3EDiMxXgYfc6+M1Z0iE@mail.gmail.com> <20110221151619.GM31267@htj.dyndns.org> <20110221152855.GA20769@redhat.com> <20110222162454.GB31267@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110222162454.GB31267@htj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/22, Tejun Heo wrote:
>
> Okay, I think I finally caught up with the discussion (hopefully).
>
> On Mon, Feb 21, 2011 at 04:28:55PM +0100, Oleg Nesterov wrote:
> > However, I am starting to agree that TASK_TRACED looks more clean.
> >
> > What is important, I think ptrace should respect SIGNAL_STOP_STOPPED.
> > IOW, when the tracee is group-stopped (TASK_STOPPED or TASK_TRACED,
> > doesn't matter), ptrace_resume() should not wake it up, but merely
> > do set_task_state(TASK_STATE) and make it resumeable by SIGCONT.
>
> I don't think that's gonna fly.  It first is a very user-visible
> change to how ptrace_resume() works

Yes. But can't resist, this is a bit unfair ;) It was you who convinced
me we should cleanup this horror somehow, even if we break some corner
cases.

However, again, I can't argue. Perhaps this change is too radical.

In particular, if Jan thinks this is not acceptable - I'll shut up
immediately.

> and it removes a lot of debugging
> capability.

Well. I don't think it limits the current ptrace interface somehow,
but:

> As Jan's examples showed, there are things which the
> debugger does behind group stop's back and some of them are quite
> legitimate and useful things to do like running some code

Yes. This can surprise a user which runs the unmodified debugger.

> If you mix ptrace trap and group stop and then fix group stop
> notification, not only multithreaded debugging becomes quite
> cumbersome (suddenly ptracing becomes per-process thing instead of
> per-thread),

It should be, imho. Like SIGKILL, SIGSTOP/SIGCONT are not per-thread.
This is per-process thing.

> it becomes almost impossible to debug jctl behaviors.
> Jctl becomes completely intertwined with ptracing and the real parent
> would get numerous notifications during the course of debugging.

Again, I think this is a win. The real parent should know that, say,
its child becomes running after it was stopped. It does not matter
why it was CLD_CONTINUED, it was resumed and that is all.

> I think they belong to different layers and they should stack instead
> of mix.  I'll try to write up a summary for how I think it can be done
> later

OK. You know, we already spent sooooooooooooooooooooooooooooooooooooooo
much time discussing this, I have the strong desire to agree in advance
with anything new ;)

> but in short I think we just need two more PTRACE calls (one for
> combined SIGSTOPless attach + INTERRUPT

Yes, we are discussing these requests on archer,

> and the other for jctl
> monitoring)

Of course, we can add the new requests to help gdb/strace/whatever
to handle jctl. In fact I think we should in any case.

But this is "easy". In the context of this discussion, my only concern
is the current behaviour.

> and there doesn't need to be any fundamental revolt in how
> ptrace and jctl interact with each other. The current ptrace behavior
> is quirky and rough on the edges but I think the fundamentals are
> correct in that it's something which is fundamentally bound to a task
> (not task group)

Aha. see above. I feel this is not true. But, as usual, can't prove.

> That way, most current users won't notice (e.g. entering TASK_TRACED
> directly on SIGSTOP doesn't make any different to strace or gdb,

Just in case, let me repeat...  Yes, I think you are right, TASK_TRACE
looks more clean if the tracee does do_signal_stop().

Oleg.

