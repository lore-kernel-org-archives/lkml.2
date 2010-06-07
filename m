Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753410Ab0FGVHU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 17:07:20 -0400
Received: from smtp.outflux.net ([198.145.64.163]:41310 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753067Ab0FGVHQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 17:07:16 -0400
Date: Mon, 7 Jun 2010 14:06:18 -0700
From: Kees Cook <kees.cook@canonical.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Valdis.Kletnieks@vt.edu, Dave Young <hidave.darkstar@gmail.com>,
       Al Viro <viro@zeniv.linux.org.uk>, Eric Paris <eparis@redhat.com>,
       Christoph Hellwig <hch@infradead.org>, James Morris <jmorris@namei.org>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org,
       Randy Dunlap <rdunlap@xenotime.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jiri Kosina <jkosina@suse.cz>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       David Howells <dhowells@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Tim Gardner <tim.gardner@canonical.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>, tytso@mit.edu,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH v6] fs: allow protected cross-uid sticky symlinks
Message-ID: <20100607210618.GI6839@outflux.net>
References: <20100603080158.GE4971@outflux.net>
 <m11vcnlw9j.fsf@fess.ebiederm.org>
 <20100603210051.GD4714@outflux.net>
 <6305.1275927536@localhost>
 <20100607164257.GD6839@outflux.net>
 <m1631ug05u.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1631ug05u.fsf@fess.ebiederm.org>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 07, 2010 at 11:36:29AM -0700, Eric W. Biederman wrote:
> Kees Cook <kees.cook@canonical.com> writes:
> > On Mon, Jun 07, 2010 at 12:18:56PM -0400, Valdis.Kletnieks@vt.edu wrote:
> >> On Thu, 03 Jun 2010 14:00:51 PDT, Kees Cook said:
> >> > On Thu, Jun 03, 2010 at 01:02:48PM -0700, Eric W. Biederman wrote:
> >> > > Kees Cook <kees.cook@canonical.com> writes:
> >> > > > A long-standing class of security issues is the symlink-based
> >> > > > time-of-check-time-of-use race, most commonly seen in world-writable
> >> > > > directories like /tmp. The common method of exploitation of this flaw
> >> > > 
> >> > > Nacked-by: "Eric W. Biederman" <ebiederm@xmission.com>
> >> > > 
> >> > > This approach to fix the problem to of /tmp looks to me like it
> >> > > will have the opposite effect.  I think this patch will encourage
> >> > > more badly written applications.
> >> > 
> >> > How to safely deal with /tmp has been well understood for well over
> >> > a decade.  I don't think this change would "encourage" poor code.
> >> 
> >> The fact that you're proposing this patch a decade after we "well understood"
> >> the problem should suggest that it *will* encourage poor code, as the same
> >> programmers who don't currently get it right (and are thus the targets of your
> >> patch) will quite likely just say "Oh, I saw a patch for that, I don't have to
> >> try to do it right..."
> >
> > This objection and its rebuttal are entirely conjecture and I don't think
> > it matters since we can never know the objective truth about the education
> > or motivation of nameless coders. 
> 
> But we can know about distributions.
> 
> I see a patch put forward with the argument that it solves all the
> problems of /tmp.  The patch does not actually solve all of the
> problems of /tmp but more refined claims have not been made.

I never claimed this solved "all the problems of /tmp".  I think my
original descriptions were not specific enough, and I made a refined
claim for what it should be expected to solve:

"stop the largest class of malicious symlink races that read, write, or
truncate files through a single-depth symlink living in a sticky
world-writable directory."  -- http://lkml.org/lkml/2010/6/4/44

> With the existence of that patch I see no interest in actually solving
> the slightly more challenging problem at the distribution level of
> unnecessary sharing in /tmp because a handful of uses of /tmp will
> have to be fixed.

We seem to disagree here.  I do concede that the urgency of per-user-/tmp
is reduced if this patch is in use.  I don't feel it eliminates the need
for per-user-/tmp, though.

> > That said, I would assume that anyone
> > well-educated enough about /tmp races to think "oh I saw a kernel patch
> > for that" was either going to get it right to begin with or was going to
> > ignore best practices anyway.  The issue is more about the people that
> > just don't think about it at all.  I would argue that people are still
> > doing it, for over a decade, when it's still vulnerable, is evidence
> > that it is not something that will improve.
> 
> Furthermore making it impossible to exploit the races with symlinks
> (the best your patch can do).  Is not going to make the races impossible
> to exploit by placing a different file in place of the one to be
> created, or using hard links instead of symlinks.

Right, so we agree: this patch doesn't eliminate the need for
per-user-/tmp.

> So I would be surprised if after just your patch a system is actually
> more secure from attack, once the attackers notice the change.

It sounds like you object on the basis that the patch does not provide
perfect security.  I do not feel perfect security is a realistic goal.
Incremental layered security is; this patch helps.  We can move on to the
next thing in need of securing after that.

If it helps to have a concrete example, I will choose the first
vulnerability of 2010 listed in a search for "/tmp" at Mitre:

 CVE-2010-0156: Puppet 0.24.x before 0.24.9 and 0.25.x before 0.25.2 allows
 local users to overwrite arbitrary files via a symlink attack on the (1)
 /tmp/daemonout, (2) /tmp/puppetdoc.txt, (3) /tmp/puppetdoc.tex, or (4)
 /tmp/puppetdoc.aux temporary file. 

The patch would make all cases unexploitable.  So, if you find a
system using Puppet before the above versions, with multiple local
users, where /tmp is its own filesystem, that system is more secure.
(Though to put a finer point on your "actually more secure" qualifier,
I would have to additionally add "with a malicious local attacker" to
my above system definition, since without the attacker, the system is
no more safe than it was, since there was no real danger to start with if
no one is attacking it.)


For the people objecting to what semantic changes the patch makes,
we clearly differ in opinion.  I and others think it is a valuable
protection, some do not.  I don't think this disagreement can be resolved
as it tends to boil down to "perfect security" vs "layered security",
which is why I don't object to having a sysctl.  I want to have the
choice to make my systems more secure without forcing it on for those
that want to wait for their distributions to provide a per-user /tmp.

For the people objecting to the actual code of the patch, I'm very
interested in finding a solution.  I am obviously not a Linux kernel VFS
maintainer.  I'm very keen to find an acceptable version of the patch
based on feedback from those that know this area of the kernel intimately.

-Kees

-- 
Kees Cook
Ubuntu Security Team
