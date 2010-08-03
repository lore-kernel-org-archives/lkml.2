Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932423Ab0HCQu2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 12:50:28 -0400
Received: from smtp.outflux.net ([198.145.64.163]:41516 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932283Ab0HCQuY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 12:50:24 -0400
Date: Tue, 3 Aug 2010 09:50:10 -0700
From: Kees Cook <kees.cook@canonical.com>
To: Valdis.Kletnieks@vt.edu
Cc: Christoph Hellwig <hch@infradead.org>, James Morris <jmorris@namei.org>,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Al Viro <viro@ftp.linux.org.uk>
Subject: Re: Preview of changes to the Security susbystem for 2.6.36
Message-ID: <20100803165010.GG3948@outflux.net>
References: <alpine.LRH.2.00.1007301852110.14431@tundra.namei.org>
 <alpine.LRH.2.00.1008021216520.31941@tundra.namei.org>
 <20100802122421.GA12130@infradead.org>
 <20100802165936.GV3948@outflux.net>
 <15424.1280775073@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <15424.1280775073@localhost>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 02, 2010 at 02:51:13PM -0400, Valdis.Kletnieks@vt.edu wrote:
> On Mon, 02 Aug 2010 09:59:36 PDT, Kees Cook said:
> > > Al gave you some very clear advice how a the sticky check should be
> > 
> > This is patently false. "Very clear advice" would have included actionable
> > instructions. He (and everyone else) has ignored my requests for
> > clarification[2]. If you see how the check should be implemented, please
> > send a patch demonstrating how. I would greatly prefer having these
> > protections in the VFS itself.
> 
> You're overlooking step zero of Al's advice: First, *think* about the issue
> in a deep fashion, rather than a knee-jerk patch to fix one instance of
> the problem.

I think this is unfair. This solution has been used for 15 years in other
hardened kernel patches. It's not knee-jerk at all. Not fixing this is not
getting the "good" for the sake of wanting the "perfect".

> The problem is that although your patch closes *one set* of symlink attacks
> that has been traditionally a problem, it doesn't do a very good job of
> creating a conceptual model and then *really* dealing with the issue. That's
> the big distinction between SELinux, Tomoyo, Smack, and your proposal - they
> form a *model* of what's important to protect, and what actions need to be
> taken to *actually* protect them.  They don't just apply one arbitrary rule
> that closes some attacks - they make an honest effort to deal with all
> variants of the attack, and other attacks that allow bypass, and so on.

Okay, thanks for this explanation of why people don't want Yama as an LSM.
I disagree with the logic, but at least I understand the reasoning now.
"Since Yama does not provide a security model, it cannot be an LSM." This
then leaves a gap for people wanting to make small changes to the logic of
how the kernel works without resorting to endlessly carrying a patchset.

> The reason people are worried that this might grow into a "large" LSM is that
> quite often, throwing in a bunch of ad-hoc rules may create *apparent*
> security, but not provide any *real* security.  You yourself admit that Yama

I can accept this as a theoretical position, but it's not like I've
suddenly invented some new unproven protection. Given a choice between
fighting to have it be an LSM and fighting to have it in the VFS, I prefer
the VFS, since I'm trying to fix a flaw in DAC.

> only closes one set of symlink attacks without addressing the general issue of
> symlinks, hard links, TOCTOU races, and a lot of *other* similar "the file you
> actually opened is not the one you intended to open" attacks. And the reason it
> doesn't address the general issue is because it lacks a security model.  And
> the reason you're having so much trouble getting it into the tree is because if
> you're going to apply this at either the VFS or LSM layers, you need to address
> the *general* problem and not one ad-hoc variant of it.

Well, here we disagree. DAC is flawed, this fixes a giant class of security
problems. The model is "fix what sticky means for symlinks" and "fix when
hardlinks are created". :P

> And quite frankly, the idea of this morphing into a "large" LSM containing a
> lot of ad-hoc rules scares most security people, because without a good
> conceptual model, it's hard to define if the security is in fact working, or
> what the problem is if it isn't working.

I have regression tests for all the Yama features. I can prove if it's
working or not.

> > I've seen two so far. Both are addressed with a one line fix. And I would
> > stress that no other existing subsystem in the kernel can provide the same
> > level of control that my ptrace exception logic provides. SELinux cannot do
> > this.
> 
> Quick question: Now is that "SELinux doesn't consider the added granularity
> important and doesn't bother doing it", or "SELinux can't do it *currently*",
> or "there are innate structural reasons why SELinux is by design unable to do
> it"?  Note that it's a big difference, and it's dangerous for your cause to
> bring it up without understanding which it is, and why...

I don't know the answer to this, but other people I've asked have said they
didn't think it was possible. I would tend to agree since it requires an
explicit action from the debugee.

MAC is system-owner defined. This is programmer defined. I want my program
to be able to declare that a single specific pid can PTRACE it and nothing
else. Another example of programmer defined access control would be the
ability to "give up" access to syscalls, a finer-grained version of
SECCOMP.

> You were told to go back and form an actual *security model*. What's important
> to protect? What attacks can be made against it? What syscalls are included in
> the forseeable attacks (hint - probably more than you think - if you're
> mediating symlink access, a bit of thought will show symlinks aren't the only
> problem you need to worry about to *actually* secure the resource).

Cross-uid symlink following and cross-permission hardlink creation are
flaws in DAC that lead to a large persistent class of ToCToU
vulnerabilities that are trivially avoidable. It's been fixed for 15 years.
I'm not exactly sure how to model this. We've discussed how shared /tmp is
one aspect of the problem, but it's not the entire problem. We've discussed
how per-user /tmp is untenable in the short-term, etc. This is a way to get
there now while per-user /tmp is slowly adopted over the next 15 years.

-Kees

-- 
Kees Cook
Ubuntu Security Team
