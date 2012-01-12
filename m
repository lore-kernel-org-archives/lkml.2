Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753841Ab2ALOyJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 09:54:09 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:50715 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753385Ab2ALOyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 09:54:05 -0500
X-Authority-Analysis: v=2.0 cv=A5HuztqG c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=0bKwikReyMMA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=IK5bi0CqK3u5H_2RAIsA:9 a=mx876XQdkEvs29IECm0A:7 a=PUjeQqilurYA:10 a=3ozPg8clREwOszlw:21 a=8ww1dcn6pwQp52P3:21 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1326380042.7642.73.camel@gandalf.stny.rr.com>
Subject: Re: Perf ABI (was: Re: [lttng-dev] [PATCH 09/11] sched: export
 task_prio to GPL modules)
From: Steven Rostedt <rostedt@goodmis.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: "Ted Ts'o" <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
        Greg KH <greg@kroah.com>, devel@driverdev.osuosl.org,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        lttng-dev@lists.lttng.org, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Date: Thu, 12 Jan 2012 09:54:02 -0500
In-Reply-To: <20120112140905.GA30377@Krystal>
References: <20111206214446.GD1247@kroah.com>
	 <20111208052354.GC9485@elte.hu> <20111208232709.GA19820@kroah.com>
	 <20111219104915.GA19861@elte.hu> <20111219153053.GA21548@Krystal>
	 <20111220110813.GA19105@elte.hu> <20111223164629.GA30474@Krystal>
	 <20111223172155.GA14117@thunk.org> <20111223181641.GA12681@Krystal>
	 <20111225174613.GA12732@thunk.org> <20120112140905.GA30377@Krystal>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-01-12 at 09:09 -0500, Mathieu Desnoyers wrote:


> It is important to clarify that tracing is, in my opinion, not part of
> the runtime support, which makes it very different by nature from
> filesystems and kernel runtime support. So I agree with Linus' argument
> about not breaking userspace when applied to runtime support, because
> being unable to even boot a system due to an ABI breakage is very much
> unwanted. However, I think it should not be applied as-is to tracing,
> because you cannot make a system unusable due to a tracer ABI breakage:
> if a tracer can be packaged in a set of standalone modules, that clearly
> shows it is not part of the system runtime support.

Correct that tracing is not something that needs to make the system run,
but that's still no excuse to make ABI changes any different. Note, we
don't change things within the /proc/stat or /proc/*/stat and that's not
required to make the system run. We can add onto those files, but we
can't change what the current numbers mean.

> 
> That being said, ABI versioning could still handle ABI changes without
> significantly impacting the users: when an ABI breakage is needed, we
> can keep the old code around for a while and expose both the old and new
> ABIs. This would ensure that the user-level tools can query for the
> specific ABI major version(s) they support. That should improve the user
> experience by providing "deprecated" console warnings for a few kernel
> releases before the old code ends up being removed.

ABI version numbers are meaningless, and prone to be broken. The change
would have to be added with the commit that updates the change otherwise
git bisecting can get screwed up too.

The way ABI changes in the kernel have always been was to look at the
file itself and have the tool be able to determine what version of the
ABI is there based on what files exists, or what exists in the file.
I've done this with trace-cmd and ftrace. The debugfs system has changed
a lot, and trace-cmd can handle each change. I never had a need for a
version number to do this. I simply have trace-cmd look at what is
available and what isn't.

If you need to know if a syscall exists, you try it and if you get
-ENOSYS, then you know it doesn't exist. We have no need for an
arbitrary version number that is meaningless. The existence of (or lack
of) tells us all we need to know.


> 
> So, in summary:
> 
>   * Old kernels vs new tools:
> 
> New tools can query for the latest ABI they know, and fall-back on older
> ABIs, with limited features.
> 
>   * New kernels vs old tools:
> 
> Keeping around the old ABI for a deprecation phase lets old tools work on
> a bleeding edge kernel while the ABI change is being introduced, which
> should satisfy the kernel developer use-case.

We've done this without version numbers. Just look at all the udev
changes.

-- Steve


