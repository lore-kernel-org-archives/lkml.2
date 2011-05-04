Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753878Ab1EDQjY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 12:39:24 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:34610 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751354Ab1EDQjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 12:39:23 -0400
X-Authority-Analysis: v=1.1 cv=ZtuXOl23UuD1yoJUTgnZ6i6Z5VPlPhPMWCeUNtN8OGA= c=1 sm=0 a=Not3D1qn5yUA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=YtslZGTt60e5TVNe-y4A:9 a=rqssKgy7qvKfgPrabsQA:7 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 5/7] seccomp_filter: Document what seccomp_filter is
 and how it works.
From: Steven Rostedt <rostedt@goodmis.org>
To: Eric Paris <eparis@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Will Drewry <wad@chromium.org>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        kees.cook@canonical.com, agl@chromium.org, jmorris@namei.org,
        Randy Dunlap <rdunlap@xenotime.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tom Zanussi <tzanussi@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1304526163.10692.33.camel@localhost.localdomain>
References: <1303960136-14298-1-git-send-email-wad@chromium.org>
	 <1303960136-14298-4-git-send-email-wad@chromium.org>
	 <20110428070636.GC952@elte.hu>
	 <1304002571.2101.38.camel@localhost.localdomain>
	 <BANLkTi=5NYTM5T2LthVL+8kjQvYWwHSVPg@mail.gmail.com>
	 <20110429131845.GA1768@nowhere>
	 <BANLkTimhWZURqgAXG45=3CG-bNhv+g-Ftg@mail.gmail.com>
	 <20110503012857.GA8399@nowhere>
	 <BANLkTimhugGCnMQ4f2T2HOvwVLrGTREPkg@mail.gmail.com>
	 <1304511396.25414.2422.camel@gandalf.stny.rr.com>
	 <1304524465.10692.21.camel@localhost.localdomain>
	 <1304525169.25414.2427.camel@gandalf.stny.rr.com>
	 <1304526163.10692.33.camel@localhost.localdomain>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 04 May 2011 12:39:21 -0400
Message-ID: <1304527161.25414.2438.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-05-04 at 12:22 -0400, Eric Paris wrote:

> > SECCOMP_FILTER_SET, __NR_foo, "a=0"
> > SECCOMP_FILTER_SET, __NR_read, "1" == EPERM
> 
> When I said "== EPERM" I meant that the given prctl call would return
> EPERM.  I'm going to pretend that you didn't type it.

I was confused about that, but I didn't type that. You did. I just cut
and pasted it ;)

> 
> > SECCOPM_FILTER_APPLY
> > 
> > SECCOMP_FILTER_SET, __NR_foo, "b=0"
> > SECCOPM_FILTER_APPLY
> > 
> > Will end up being:
> > 
> > (foo: a == 0 || read: "1") && (foo: b == 0)
> > 
> > The second set/apply now removes the read option, and foo only works if
> > a is 0 and b is 0.
> > 
> > This would also work for children, as they can only restrict (with
> > 'and') and can not add more control.
> 
> I think we pretty much agree although I'm pretty that we will have 1
> filter per syscall.  So the rules would really be (in your syntax)
> 
> Rule1: (foo: a == 0 && b == 0)
> OR
> Rule2: (read: "1")
> 
> Although logically the same, it's not just one huge rule.  I don't see
> any need for any operation other than an &&.  Before the first "set" you
> can add new syscalls.  After the first set you can only && onto existing
> syscalls.  So the following set of operations:
> 
> SECCOMP_FILTER_SET, __NR_foo, "a=0"
> SECCOMP_FILTER_SET, __NR_read, "1"
> SECCOPM_FILTER_APPLY
>  
> SECCOMP_FILTER_SET, __NR_foo, "b=0"
> SECCOMP_FILTER_APPLY
> 
> SECCOMP_FILTER_SET, __NR_write, "1"
> SECCOMP_FILTER_APPLY
> 
> Would return EPERM for the __NR_write entry since it was a new syscall
> after a set.  I think we agree on all this.

Do you mean "after a apply"? As the second line above is a new syscall
after the first set.


> 
> I do have a question on some syntax proposed a while back.  Given:
> SECCOMP_FILTER_SET, __NR_foo, "a=0"
> SECCOMP_FILTER_SET, __NR_foo, "b=0"
> SECCOMP_FILTER_APPLY
> 
> I would think to keep the interface consistent that should result in
> foo: (a=0) && (b=0)

I agree.

> 
> But I think the proposal was that we should instead have just
> foo: (b=0)

Yeah, that's what it looked like Frederic showed. I rather have the
first instance.

Perhaps we could have a "unset"? that would only work on things that
haven't been applied yet.

> 
> What's the logic behind having a second call overwrite uncommitted
> changes?  I sorta feel like if I put it in there, I must have wanted it
> in there   :)

Perhaps for making the user code simpler?

SET a=1
SET b=2

[ some nasty if logic ]

   UNSET b=2

APPLY


Thus a default setting can be made and then we can selectively remove
settings before we do the apply based on information about the process
that we will exec. We can start out with "limit the hell out of it" and
then selectively remove things. I think this is a simply way to
understand what is being done. Kind of like iptables, where you can set
up default rules, but then selectively override them.

One thing I know about security, the easier it is to set up, the more
secure it becomes.

-- Steve


