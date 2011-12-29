Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754612Ab1L2QVa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Dec 2011 11:21:30 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:44741 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754432Ab1L2QV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Dec 2011 11:21:28 -0500
X-Authority-Analysis: v=2.0 cv=A5HuztqG c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=rrYGrSk31WUA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=pGLkceISAAAA:8 a=tiYEVMgxcTES9AiF14sA:9 a=rlNRB61zkL8a9JZLiY8A:7 a=PUjeQqilurYA:10 a=MSl-tDqOz04A:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1325175685.24045.5.camel@gandalf.stny.rr.com>
Subject: Re: ftrace performance impact with different configuration
From: Steven Rostedt <rostedt@goodmis.org>
To: Rabin Vincent <rabin@rab.in>
Cc: Lei Wen <adrian.wenl@gmail.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, leiwen@marvell.com
Date: Thu, 29 Dec 2011 11:21:25 -0500
In-Reply-To: <CAH+eYFDb4r235jAGjr7j5R5C+9YK9WeXXjVZGWQUB=330sOi0Q@mail.gmail.com>
References: <CALZhoSRVNp=Sj2u2GHiQhuHOEdrfiM58KzG+RutvJV=8CoCpTQ@mail.gmail.com>
	 <CAH+eYFDb4r235jAGjr7j5R5C+9YK9WeXXjVZGWQUB=330sOi0Q@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.0.3-3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-12-29 at 21:12 +0530, Rabin Vincent wrote:
> On Thu, Dec 29, 2011 at 14:08, Lei Wen <adrian.wenl@gmail.com> wrote:
> > 2. Seem dynamic ftrace also could involve some penalty for the running
> > system, although it patching the running kernel with nop stub...
> >
> > For the second item, is there anyone done some research before that
> > could zero the cost for the running system when the tracing is not
> > enabled yet?
> 
> One thing that needs to be fixed (for ARM) is that for the new-style
> mcounts, the nop that's currently being done is not really a nop -- it
> removes the function call, but there is still an unnecessary push/pop
> sequence.  This should be modified to have the push {lr} removed too.
> (Two instructions replaced instead of one.)


Unfortunately you can't do this, at least not when the kernel is
preemptible.

Say we have:

	push lr
	call mcount

then we convert it to:

	nop
	nop

The conversion to nop should not be an issue, and this is what would be
done when the system boots up. But then we enable tracing, some low
priority task could have been preempted after executing the first nop,
and we call stop machine to do the conversions (if no stop machine, then
lets just say a higher prio task is running while we do the
conversions). Then we add both the push lr and call back. But when that
lower priority task gets scheduled in again, it would have looked like
it ran:

	nop
	call mcount

Since the call to mcount requires that the lr was pushed, this process
will crash when the return is done and we never saved the lr.

If you don't like the push. the best thing you can do is convert to:

	jmp 1f
	call mcount
1:

This may not be as cheap as two nops, but it may be better than a push.

-- Steve


