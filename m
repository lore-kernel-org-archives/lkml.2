Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752561Ab1EDQXP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 12:23:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48542 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750802Ab1EDQXO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 12:23:14 -0400
Subject: Re: [PATCH 5/7] seccomp_filter: Document what seccomp_filter is and
 how it works.
From: Eric Paris <eparis@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
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
Date: Wed, 04 May 2011 12:22:40 -0400
In-Reply-To: <1304525169.25414.2427.camel@gandalf.stny.rr.com>
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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Message-ID: <1304526163.10692.33.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-05-04 at 12:06 -0400, Steven Rostedt wrote:
> On Wed, 2011-05-04 at 11:54 -0400, Eric Paris wrote:
> 
> > As this is a deny by default interface which only allows you to further
> > restrict you couldn't add more than 1 syscall if you didn't have an
> > explict 'apply' action.
> > 
> > SECCOMP_FILTER_SET, __NR_fo, "a=0"
> > SECCOMP_FILTER_SET, __NR_read, "1" == EPERM
> > 
> > Maybe apply on set is fine after the first apply, but we definitely need
> > some way to do more than 1 set before the rules are applied....
> 
> So we could have SET be 'or' and APPLY be 'and'.
> 
> SECCOMP_FILTER_SET, __NR_foo, "a=0"
> SECCOMP_FILTER_SET, __NR_read, "1" == EPERM

When I said "== EPERM" I meant that the given prctl call would return
EPERM.  I'm going to pretend that you didn't type it.

> SECCOPM_FILTER_APPLY
> 
> SECCOMP_FILTER_SET, __NR_foo, "b=0"
> SECCOPM_FILTER_APPLY
> 
> Will end up being:
> 
> (foo: a == 0 || read: "1") && (foo: b == 0)
> 
> The second set/apply now removes the read option, and foo only works if
> a is 0 and b is 0.
> 
> This would also work for children, as they can only restrict (with
> 'and') and can not add more control.

I think we pretty much agree although I'm pretty that we will have 1
filter per syscall.  So the rules would really be (in your syntax)

Rule1: (foo: a == 0 && b == 0)
OR
Rule2: (read: "1")

Although logically the same, it's not just one huge rule.  I don't see
any need for any operation other than an &&.  Before the first "set" you
can add new syscalls.  After the first set you can only && onto existing
syscalls.  So the following set of operations:

SECCOMP_FILTER_SET, __NR_foo, "a=0"
SECCOMP_FILTER_SET, __NR_read, "1"
SECCOPM_FILTER_APPLY
 
SECCOMP_FILTER_SET, __NR_foo, "b=0"
SECCOMP_FILTER_APPLY

SECCOMP_FILTER_SET, __NR_write, "1"
SECCOMP_FILTER_APPLY

Would return EPERM for the __NR_write entry since it was a new syscall
after a set.  I think we agree on all this.

I do have a question on some syntax proposed a while back.  Given:
SECCOMP_FILTER_SET, __NR_foo, "a=0"
SECCOMP_FILTER_SET, __NR_foo, "b=0"
SECCOMP_FILTER_APPLY

I would think to keep the interface consistent that should result in
foo: (a=0) && (b=0)

But I think the proposal was that we should instead have just
foo: (b=0)

What's the logic behind having a second call overwrite uncommitted
changes?  I sorta feel like if I put it in there, I must have wanted it
in there   :)

-Eric

