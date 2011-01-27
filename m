Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752735Ab1A0RFT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 12:05:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11441 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751269Ab1A0RFS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 12:05:18 -0500
Date: Thu, 27 Jan 2011 17:57:12 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Alan Stern <stern@rowland.harvard.edu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>, Prasad <prasad@linux.vnet.ibm.com>,
        Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: Q: perf_install_in_context/perf_event_enable are racy?
Message-ID: <20110127165712.GC25060@redhat.com>
References: <20110120193033.GA13924@redhat.com> <1295611905.28776.269.camel@laptop> <20110121130323.GA12900@elte.hu> <1295617185.28776.273.camel@laptop> <20110121142616.GA31165@redhat.com> <1295622304.28776.293.camel@laptop> <20110121204014.GA2870@nowhere> <20110124114234.GA12166@redhat.com> <20110126175322.GA28617@redhat.com> <1296134077.15234.161.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1296134077.15234.161.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/27, Peter Zijlstra wrote:
>
> Right, so the fact of introducing extra scheduling makes me feel
> uncomfortable... the whole purpose is to observe without perturbing (as
> much as possible).

Yes, agreed.

Well, otoh the patch removes the code which sets ->task_ctx from
__perf_install_in_context() and __perf_event_enable(), and perhaps
we could simplify the things further, but anyway I agree.

> Should I think suffice to get the ctx in sync with the task state, we've
> got the following cases:
>  1) task is in the middle of scheduling in
>  2) task is in the middle of scheduling out
>  3) task is running
>
> Without __ARCH_WANT_INTERRUPT_ON_CTXSW everything is boring and works,
> 1: the IPI will be delayed until 3, 2: the IPI finds another task and
> the next schedule in will sort things.
>
> With, however, things are more interesting. 2 seems to be adequately
> covered by the patch I just send, the IPI will bail and the next
> sched-in of the relevant task will pick matters up. 1 otoh doesn't seem
> covered, the IPI will bail, leaving us stranded.

Hmm, yes... Strangely, I missed that when I was thinking about in_ctxsw.

Perhaps, we can change task_oncpu_function_call() so that it returns
-EAGAIN in case it hits in_ctxsw != 0? If the caller sees -EAGAIN, it
should always retry even if !ctx->is_active.

Oleg.

