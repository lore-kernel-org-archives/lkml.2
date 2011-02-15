Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756007Ab1BOUga (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 15:36:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:27959 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753140Ab1BOUg2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 15:36:28 -0500
Date: Tue, 15 Feb 2011 21:27:47 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Denys Vlasenko <vda.linux@googlemail.com>,
        jan.kratochvil@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: Re: [PATCH 1/1] ptrace: make sure do_wait() won't hang after
	PTRACE_ATTACH
Message-ID: <20110215202747.GA20560@redhat.com>
References: <201102132325.55353.vda.linux@googlemail.com> <20110214151340.GP18742@htj.dyndns.org> <AANLkTi=Djwcf9YoUrGtTEOp8W_YhsefzrNhMxVhtw_Lp@mail.gmail.com> <20110214175144.GC15847@redhat.com> <AANLkTi=VVWVkrqqQyOtsP72S5-nWny=Ukmf_r-m1qMwV@mail.gmail.com> <20110214190141.GA19221@redhat.com> <AANLkTi=_af8+XKD+d-677JpQZA=AN2EsydscSYxk7z55@mail.gmail.com> <20110214200130.GA21559@redhat.com> <20110215152448.GL3160@htj.dyndns.org> <20110215173149.239601807B7@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110215173149.239601807B7@magilla.sf.frob.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/15, Roland McGrath wrote:
>
> > Actually I was thinking along this line.  We can allow
> > PTRACE_GETSIGINFO to proceed without forcing the tracee into TRACED
> > state, the rationale being the operation is required to tell between
> > group stop and ptrace trap.  Am I missing something?
>
> The reason for the transition to TASK_TRACED is to prevent a race with
> SIGCONT waking the task.  There is always a race with SIGKILL waking it,
> but the circumstances where that can really matter are far fewer.
> You need to make sure that the work PTRACE_GETSIGINFO does to access
> last_siginfo cannot race with that pointer disappearing or the stack
> space it points to becoming invalid.  I think the use of siglock ensures
> that, but Oleg should verify it.

Yes, I think this is safe.

I do not really like this idea because it looks a bit strange to treat
PTRACE_GETSIGINFO specially, and this doesn't solve all problems. And,
once again, I still hope we can change ptrace_resume() so that it doesn't
wakeup the stopped (I mean, SIGNAL_STOP_STOPPED) tracee, in this case this
hack is not needed.

And. We are going to add the new requests which doesn't need the stopped
tracee anyway. So we can just add PTRACE_HAS_SIGINFO which returns
child->last_siginfo != NULL. This looks simpler, and this is compatible.
Of course this check is racy, but this doesn't matter. PTRACE_GETSIGINFO
is equally racy if it doesn't change the state to TASK_TRACED.

But I won't argue if you/Denys/Tejun prefer to change PTRACE_GETSIGINFO.

Oleg.

