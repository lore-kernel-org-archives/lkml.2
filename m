Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755211Ab1BUPhP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 10:37:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50641 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751278Ab1BUPhN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 10:37:13 -0500
Date: Mon, 21 Feb 2011 16:28:55 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Denys Vlasenko <vda.linux@googlemail.com>,
        Roland McGrath <roland@redhat.com>, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
Subject: Re: [PATCH 1/1] ptrace: make sure do_wait() won't hang after
	PTRACE_ATTACH
Message-ID: <20110221152855.GA20769@redhat.com>
References: <20110204105343.GA12133@htj.dyndns.org> <20110207174821.GA1237@redhat.com> <20110209141803.GH3770@htj.dyndns.org> <201102132325.55353.vda.linux@googlemail.com> <20110214151340.GP18742@htj.dyndns.org> <AANLkTi=Djwcf9YoUrGtTEOp8W_YhsefzrNhMxVhtw_Lp@mail.gmail.com> <20110214173012.GA18742@htj.dyndns.org> <AANLkTinntVGcOdZSS3gWz39eq3EDiMxXgYfc6+M1Z0iE@mail.gmail.com> <20110221151619.GM31267@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110221151619.GM31267@htj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/21, Tejun Heo wrote:
>
> 1. The distinction between the first SIGSTOP trapping and the second
>    can only be reliably done by GETSIGINFO which in turn will put the
>    tracee into TASK_TRACED making the tracee ignore the future SIGCONT

Yes, but please see below.

> 2. Due to reparenting, wait(2) notifications (including the SIGCLDs)
>    don't get to the real parent at all.
>
> #2 just needs fixing.

Yes.

> That preciesly is what is being discussed.  IIUC, Oleg and Roland are
> saying that the tracee should enter group stop but not ptrace trap at
> that point and then transition into ptrace trap on the first PTRACE
> call.

Actually I am not saying this (at least now, probably I did).

Once again. We have the bug with arch_ptrace_stop_needed(), but lets
ignore it to simplify the discussion.

Suppose that the tracee calls do_signal_stop() and participates in the
group stop. To me, it doesn't really matter (in the context of this
discussion) if it stops in TASK_STOPPED or TASK_TRACED (and where it
stops).

However, I am starting to agree that TASK_TRACED looks more clean.

What is important, I think ptrace should respect SIGNAL_STOP_STOPPED.
IOW, when the tracee is group-stopped (TASK_STOPPED or TASK_TRACED,
doesn't matter), ptrace_resume() should not wake it up, but merely
do set_task_state(TASK_STATE) and make it resumeable by SIGCONT.

Oleg.

