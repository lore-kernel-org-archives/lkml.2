Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751704Ab0K1UBW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Nov 2010 15:01:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24231 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750911Ab0K1UBV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Nov 2010 15:01:21 -0500
Date: Sun, 28 Nov 2010 20:54:42 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: roland@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        "rjw@sisk.plpavel"@ucw.cz, Jan Kratochvil <jan.kratochvil@redhat.com>
Subject: Re: [PATCH 08/14] ptrace: make do_signal_stop() use ptrace_stop()
	if the task is being ptraced
Message-ID: <20101128195442.GB12896@redhat.com>
References: <1290768569-16224-1-git-send-email-tj@kernel.org> <1290768569-16224-9-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290768569-16224-9-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26, Tejun Heo wrote:
>
> A ptraced task would still stop at do_signal_stop() when it's stopping
> for stop signals and do_signal_stop() behaves the same whether the
> task is ptraced or not.  However, in addition to stopping,
> ptrace_stop() also does ptrace specific stuff like calling
> architecture specific callbacks, so this behavior makes the code more
> fragile and difficult to understand.

OK. This patch adds the obviously user-visible change. It looks
very minor, but I never know when it comes to ptrace.

To simplify, suppose that we have a single-thread tracee, and
debugger "acks" SIGSTOP, say, it does ptrace(PTRACE_CONT, SIGSTOP).

Before this patch, the tracee stops in TASK_STOPPED, now it calls
ptrace_stop() and goes to TASK_TRACED state.

Add Jan. I hope this is OK, but this might break the tracer if
it looks into fs/proc (probably only test-cases do this).


At least, with or without this patch ->last_siginfo is NULL, good.


The check in do_signal_stop() looks racy though, see the next
email.

Oleg.

