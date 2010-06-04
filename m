Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752348Ab0FDGY1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 02:24:27 -0400
Received: from smtp.outflux.net ([198.145.64.163]:45492 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751612Ab0FDGYZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 02:24:25 -0400
Date: Thu, 3 Jun 2010 23:23:29 -0700
From: Kees Cook <kees.cook@canonical.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Dave Young <hidave.darkstar@gmail.com>, Eric Paris <eparis@redhat.com>,
       Christoph Hellwig <hch@infradead.org>, James Morris <jmorris@namei.org>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org,
       Randy Dunlap <rdunlap@xenotime.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jiri Kosina <jkosina@suse.cz>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       David Howells <dhowells@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Tim Gardner <tim.gardner@canonical.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>
Subject: Re: [PATCH v6] fs: allow protected cross-uid sticky symlinks
Message-ID: <20100604062328.GL4714@outflux.net>
References: <20100603080158.GE4971@outflux.net>
 <20100603104149.78402075@lxorguk.ukuu.org.uk>
 <20100603184054.GA4714@outflux.net>
 <20100604043906.GB31073@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100604043906.GB31073@ZenIV.linux.org.uk>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 04, 2010 at 05:39:06AM +0100, Al Viro wrote:
> On Thu, Jun 03, 2010 at 11:40:54AM -0700, Kees Cook wrote:
> 
> > At this point, I believe I've addressed the specific concerns that Al Viro,
> > Eric Paris, and a few others pointed out.  What else needs fixing?
> 
> The hell you have.  Let me spell it out for you:
> 
> 1) You _still_ have not posted the analysis of changes it causes, let alone
> explained why they are the right thing to do.

I have to say I don't know specifically what you want here.  Do you
want runtime analysis?  What sort of analysis?  What would be meaningful
for you?  I have a small testsuite[1] that I've been using to validate
my patch attempts.  That's a form of analysis.

As for "why", I thought that was already pretty clear: stop the largest
class of malicious symlink races that read, write, or truncate files
through a single-depth symlink living in a sticky world-writable
directory.

I cannot know everything, but I can demonstrate that this method is
well tested in the traditionally security-hardened distros like OWL
and grsecurity.  This isn't some new crazy idea, it's an old crazy idea
that happens to provide a solid protection.  Could it be better?  Maybe.
But let's work towards incremental improvement.

> 2) You are still doing that for each symlink, no matter where in the path
> it might be.  Do (1) and you'll see why it is a BS.

I've asked for help on this, and I'm sorry I keep getting it wrong.
Based on your hints on earlier patches, I chose do_filp_open() for v4 of
the patch.  It seems I was right, at least in that part, based on your
comment[2] on LWN that actually answers the question I asked earlier[3]
on lkml that went unanswered.

I'd really like to be improving this patch in one thread of discussion
instead of having to go collecting hints from multiple sources.  Your
objection here now is that I still did it wrong.  Can you please help?
This is the point of collaborative development, right?  It seems to
me that it's really close (near "do_last", in the check for "trailing
symlink") so I'd really appreciate some better direction.

> 3) You have not bothered to explain why e.g. stat(2) should fail on such
> symlinks.  Nevermind figuring out which syscalls need that and which do
> not.  Again, (1) would be the starting point required for the rest.  And
> it is needed to decide how to deal with these checks.  Really.

Well, I think this is a bit of a tangent, but okay.  I would say stat(2)
is blocked because it's inconsistent to allow stat but block open.
But I also feel like this is a trick question.  :)  I was originally for
blocking all following, since that doesn't seem to actually break any
valid use-cases.  But I'm happy to more finely specify the limitations.
I was figuring it provided a more understandable behavior in the more
general case.

You mention in the later LWN comments:

> It's not a matter of overhead; it's not that large to start with. The
> real issue here is that you generally want the behaviour of system to
> make sense and its mental model to be understandable. I.e. the rationale
> for restrictions should be simple and specific; the more arbitrary they
> are, the worse.
> 
> Again, I have no serious objections against that kind of restrictions.
> open()/creat() and probably truncate() on the final step of pathname
> resolution. But it really needs to be done right.

Can you propose a patch you're happy with?  You seem to have a very clear
understanding of what you want to see that would fix this, and you know the
code much better than I do.

Thanks,

-Kees

[1] http://bazaar.launchpad.net/%7Eubuntu-bugcontrol/qa-regression-testing/master/annotate/head%3A/scripts/test-kernel-hardening.py#L62
[2] http://lwn.net/Articles/390889/
[3] http://lkml.org/lkml/2010/6/1/473

-- 
Kees Cook
Ubuntu Security Team
