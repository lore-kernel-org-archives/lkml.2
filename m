Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753467Ab1L3NHU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Dec 2011 08:07:20 -0500
Received: from smtp4.epfl.ch ([128.178.224.218]:39123 "HELO smtp4.epfl.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753334Ab1L3NHR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Dec 2011 08:07:17 -0500
From: Philippe =?ISO-8859-1?Q?R=E9tornaz?= <philippe.retornaz@epfl.ch>
To: linux-arm-kernel@lists.infradead.org
Cc: Steven Rostedt <rostedt@goodmis.org>, Rabin Vincent <rabin@rab.in>,
        leiwen@marvell.com, Lei Wen <adrian.wenl@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: ftrace performance impact with different configuration
Date: Fri, 30 Dec 2011 14:07:11 +0100
Message-ID: <23257775.9kkYY4quUh@laptop>
Organization: EPFL - STI - LSRO1
User-Agent: KMail/4.7.4 (Linux/3.1.6-1.fc16.x86_64; KDE/4.7.4; x86_64; ; )
In-Reply-To: <1325175685.24045.5.camel@gandalf.stny.rr.com>
References: <CALZhoSRVNp=Sj2u2GHiQhuHOEdrfiM58KzG+RutvJV=8CoCpTQ@mail.gmail.com> <CAH+eYFDb4r235jAGjr7j5R5C+9YK9WeXXjVZGWQUB=330sOi0Q@mail.gmail.com> <1325175685.24045.5.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 29 décembre 2011 11:21:25 Steven Rostedt a écrit :
> On Thu, 2011-12-29 at 21:12 +0530, Rabin Vincent wrote:
> > On Thu, Dec 29, 2011 at 14:08, Lei Wen <adrian.wenl@gmail.com> wrote:
> > > 2. Seem dynamic ftrace also could involve some penalty for the
> > > running
> > > system, although it patching the running kernel with nop stub...
> > > 
> > > For the second item, is there anyone done some research before that
> > > could zero the cost for the running system when the tracing is not
> > > enabled yet?
> > 
> > One thing that needs to be fixed (for ARM) is that for the new-style
> > mcounts, the nop that's currently being done is not really a nop -- it
> > removes the function call, but there is still an unnecessary push/pop
> > sequence.  This should be modified to have the push {lr} removed too.
> > (Two instructions replaced instead of one.)
> 
> Unfortunately you can't do this, at least not when the kernel is
> preemptible.
> 
> Say we have:
> 
> 	push lr
> 	call mcount
> 
> then we convert it to:
> 
> 	nop
> 	nop
> 
> The conversion to nop should not be an issue, and this is what would be
> done when the system boots up. But then we enable tracing, some low
> priority task could have been preempted after executing the first nop,
> and we call stop machine to do the conversions (if no stop machine, then
> lets just say a higher prio task is running while we do the
> conversions). Then we add both the push lr and call back. But when that
> lower priority task gets scheduled in again, it would have looked like
> it ran:
> 
> 	nop
> 	call mcount
> 
> Since the call to mcount requires that the lr was pushed, this process
> will crash when the return is done and we never saved the lr.
> 
> If you don't like the push. the best thing you can do is convert to:
> 
> 	jmp 1f
> 	call mcount
> 1:
> 
> This may not be as cheap as two nops, but it may be better than a push.

Sorry about being a bit naive, but why it is not possible to do it in two 
steps ?
call stop_machine to put the jmp which skip the call to mcount
Then wait until all tasks hits schedule() (synchronize_sched() ?)
Then modify both instructions to put in place the two nops since we know that 
nobody is calling mcount.

Thanks,

Philippe


