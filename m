Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751235Ab2JFC5q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 22:57:46 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:5302 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738Ab2JFC5o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 22:57:44 -0400
X-Authority-Analysis: v=2.0 cv=a96yBDuF c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=zYQHrSgTeTAA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=_67WK3i7ub8A:10 a=07d9gI8wAAAA:8 a=HG3UJ18f1ZxKMLFSTBQA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1349492261.6755.87.camel@gandalf.local.home>
Subject: Re: [PATCH v4] trace,x86: add x86 irq vector tracepoints
From: Steven Rostedt <rostedt@goodmis.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Seiji Aguchi <seiji.aguchi@hds.com>,
        "Thomas Gleixner (tglx@linutronix.de)" <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "'mingo@elte.hu' (mingo@elte.hu)" <mingo@elte.hu>,
        "x86@kernel.org" <x86@kernel.org>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Date: Fri, 05 Oct 2012 22:57:41 -0400
In-Reply-To: <506F7849.2080805@zytor.com>
References: <A5ED84D3BB3A384992CBB9C77DEDA4D41385F33C@USINDEM103.corp.hds.com>
	  <50612729.2080307@zytor.com>
	  <A5ED84D3BB3A384992CBB9C77DEDA4D41386426D@USINDEM103.corp.hds.com>
	  <50650A7E.90807@zytor.com>
	  <A5ED84D3BB3A384992CBB9C77DEDA4D413869FD7@USINDEM103.corp.hds.com>
	 <1349446428.6755.56.camel@gandalf.local.home> <506F7849.2080805@zytor.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-10-05 at 17:16 -0700, H. Peter Anvin wrote:
> On 10/05/2012 07:13 AM, Steven Rostedt wrote:
> > 
> > Peter,
> > 
> > I agree that the IDT version is a zero cost in performance, where as the
> > tracepoint version is a negligible cost in performance. But my worry is
> > the complexity (read error prone and possible openings of security
> > exploits) worth it?
> > 
> > Switching of the IDT is not that trivial, and to make it something for
> > common activities such as reading tracepoints by tools like ftrace and
> > perf, that do it often, even on production machines, may lead to issues
> > if its not done right.
> > 
> 
> It's a table of pointers... there really isn't anything magic about it
> (except perhaps the slightly weird format.)

I didn't say anything magic, but a table of pointers that are very
critical for the system running. Should we implement it with a single
switch, like we discussed in San Diego to do with the system call table?

That is, have a "normal" table, and a "trace" table. The trace table
points to functions that have tracepoints. The first enabler of tracing
switches the table to use the tracepoints, and the last disabler
switches it back?

> 
> > You are the maintainer and are responsible for the outcome of changes to
> > the x86 arch, thus you do have final say. And if you think there's
> > nothing to worry about with an IDT change then Seiji should implement
> > it.
> > 
> > I just want to point out some possible repercussions of doing it in a
> > more complex way. As tracepoints use nops, and I may be pushing to even
> > out-of-line the tracepoint unlikely part even more, I'm not sure the
> > complexity is worth the amount of savings it would be against just
> > adding the tracepoint in the code.
> 
> The problem I'm seeing is the constant "oh, just a little bit more."  My
> experience over the years is that there is always demand for "just one
> more debug feature", each of which has negible cost, because they always
> use the previous thing as a baseline... noone ever looks at the grand
> total cost of the package (and by the time that happens, it is too late.)

Now I can turn this back at you ;-)  We can implement the simple "just
add the tracepoints in the code" first, and then later implement the
table swap version and we can say "hey! we just made the code faster!".

> 
> tracepoints in particular are something I'm getting concerned about,
> because they are one of those things that turn kernel internals into an
> ABI, which means misdesigned tracepoints can actually make kernel
> internal changes very hard to do.  The cost of those kinds of issues go
> up over time as the strain between where we'd like the code to be vs.
> where the code is increases.

Honestly, I'm extremely concerned about this too. In fact, I've bitched
about this so many times in the past, but it just fell to deaf ears:

http://lwn.net/Articles/412685/
http://lwn.net/Articles/415591/
http://lwn.net/Articles/416665/
http://lwn.net/Articles/416684/

-- Steve


