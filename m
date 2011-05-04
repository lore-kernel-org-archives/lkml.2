Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755197Ab1EDSDV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 14:03:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22616 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755110Ab1EDSDU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 14:03:20 -0400
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
Date: Wed, 04 May 2011 14:02:20 -0400
In-Reply-To: <1304527161.25414.2438.camel@gandalf.stny.rr.com>
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
	 <1304527161.25414.2438.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Message-ID: <1304532144.10692.64.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-05-04 at 12:39 -0400, Steven Rostedt wrote:
> On Wed, 2011-05-04 at 12:22 -0400, Eric Paris wrote:

[rewriting history]
> > Although logically the same, it's not just one huge rule.  I don't see
> > any need for any operation other than an &&.  Before the first "apply" you
> > can add new syscalls.  After the first apply you can only && onto existing
> > syscalls.  So the following set of operations:
> > 
> > SECCOMP_FILTER_SET, __NR_foo, "a=0"
> > SECCOMP_FILTER_SET, __NR_read, "1"
> > SECCOPM_FILTER_APPLY
> >  
> > SECCOMP_FILTER_SET, __NR_foo, "b=0"
> > SECCOMP_FILTER_APPLY
> > 
> > SECCOMP_FILTER_SET, __NR_write, "1"
> > SECCOMP_FILTER_APPLY
> > 
> > Would return EPERM for the __NR_write entry since it was a new syscall
> > after an apply.  I think we agree on all this.
> 
> Do you mean "after a apply"? As the second line above is a new syscall
> after the first set.

Clearly.  Especially since given my revisionist history it's what I
said!

> > 
> > I do have a question on some syntax proposed a while back.  Given:
> > SECCOMP_FILTER_SET, __NR_foo, "a=0"
> > SECCOMP_FILTER_SET, __NR_foo, "b=0"
> > SECCOMP_FILTER_APPLY
> > 
> > I would think to keep the interface consistent that should result in
> > foo: (a=0) && (b=0)
> 
> I agree.
> 
> > 
> > But I think the proposal was that we should instead have just
> > foo: (b=0)
> 
> Yeah, that's what it looked like Frederic showed. I rather have the
> first instance.
> 
> Perhaps we could have a "unset"? that would only work on things that
> haven't been applied yet.
> 
> > 
> > What's the logic behind having a second call overwrite uncommitted
> > changes?  I sorta feel like if I put it in there, I must have wanted it
> > in there   :)
> 
> Perhaps for making the user code simpler?
> 
> SET a=1
> SET b=2
> 
> [ some nasty if logic ]
> 
>    UNSET b=2
> 
> APPLY
> 
> 
> Thus a default setting can be made and then we can selectively remove
> settings before we do the apply based on information about the process
> that we will exec. We can start out with "limit the hell out of it" and
> then selectively remove things. I think this is a simply way to
> understand what is being done. Kind of like iptables, where you can set
> up default rules, but then selectively override them.
> 
> One thing I know about security, the easier it is to set up, the more
> secure it becomes.

I'm ok with an explicit unset/remove/delete for rules since the last
apply if anyone thinks it will be useful.  But I don't like an implicit
'overwrite.'

I'm starting to debate if I think between rules should be an implicit &&
or should be an implicit ||.  After an 'apply' I believe the next block
definitely needs an &&.  I feel like the code in userspace becomes
simpler with || but maybe it would be more confusing for the human coder
to have to know the distinctions.  The example in my head, which I think
will be common, involves handling multiple fd's for read.  We could
either do:

int handle_read_fd(int fd)
{
	char buf[4096];
	snprintf(buf, 4096, "a0=%d", fd)
	return prctl(SECCOMP_FILTER_SET, __NR_read, buf);
}

main()
{
....
	fd1 = open("readfile1", O_RDONLY);
	if (fd1 < 0) return
	if (handle_read_fd(fd1)) return
....
	fd2 = open("readfile2, O_RDONLY);
	if (fd2 < 0) return
	if (handle_read_fd(fd2)) return
....
	prctl(SECCOMP_FILTER_APPLY);
}

Or case2 with the implicit && like we talked about to handle an
arbitrary number of read fd's you need (pseudocode):
int handle_read_fds(int *fds, int len)
{
	char buf[4096];
	size_t saved;
	while(len--) {
		saved = snprintf(buf, 4096, "a0=%d ||");
		buf += saved;
	}
	return prctl(SECCOMP_FILTER_SET, __NR_read, buf)
}
main()
{
	int fd[2];
....
	fd[0] = open("readfile1", O_RDONLY);
	if (fd[0] < 0) return
....
	fd[1] = open("readfile2, O_RDONLY);
	if (fd[1] < 0) return
....
	handle_read_fds(fd, 2)
	prctl(SECCOMP_FILTER_APPLY);
}

The latter of the examples requires what I think to be the common case
of complex rules to be required to hold state whereas the other is done
in the kernel.  It's a lot easier to code the first one but it might be
harder on the coder to decide "now is than an && or an ||"?  Like I
said, I'm ok with just declaring everything &&, especially if people
think complex filters are likely to be anything more than rule1 || rule2
|| rule3 || rule4 where ruleX is an independent clause, but I figured
I'd throw it out there....

No matter what after the APPLY I think that:
SECCOMP_FILTER, __NR_read, "0" should result in:
(rule1 || rule2 || rule3 || rule4) && 0

-Eric

