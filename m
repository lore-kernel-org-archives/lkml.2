Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757938Ab0HCWfK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 18:35:10 -0400
Received: from smtp.outflux.net ([198.145.64.163]:60448 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755997Ab0HCWfI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 18:35:08 -0400
Date: Tue, 3 Aug 2010 15:34:51 -0700
From: Kees Cook <kees.cook@canonical.com>
To: Valdis.Kletnieks@vt.edu
Cc: Christoph Hellwig <hch@infradead.org>, James Morris <jmorris@namei.org>,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Al Viro <viro@ftp.linux.org.uk>
Subject: Re: Preview of changes to the Security susbystem for 2.6.36
Message-ID: <20100803223451.GB4138@outflux.net>
References: <alpine.LRH.2.00.1007301852110.14431@tundra.namei.org>
 <alpine.LRH.2.00.1008021216520.31941@tundra.namei.org>
 <20100802122421.GA12130@infradead.org>
 <20100802165936.GV3948@outflux.net>
 <15424.1280775073@localhost>
 <20100803165010.GG3948@outflux.net>
 <78690.1280871500@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <78690.1280871500@localhost>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 03, 2010 at 05:38:20PM -0400, Valdis.Kletnieks@vt.edu wrote:
> On Tue, 03 Aug 2010 09:50:10 PDT, Kees Cook said:
> > > You're overlooking step zero of Al's advice: First, *think* about the issue
> > > in a deep fashion, rather than a knee-jerk patch to fix one instance of
> > > the problem.
> > 
> > I think this is unfair. This solution has been used for 15 years in other
> > hardened kernel patches. It's not knee-jerk at all. Not fixing this is not
> > getting the "good" for the sake of wanting the "perfect".
> 
> The fact that a patch for one case has been used for years doesn't mean
> that it's a well thought out fix for the general case.

Well, we clearly disagree on this point. :)

> It will likely not be accepted as an in-tree LSM, especially given that currently
> it's rather difficult to stack two LSM's - which means that if a site wants to
> run Yama, it becomes unable to take advantage of all the *other* security
> features of SELinux or something similar.  In other words - if you want to be
> an LSM, you need to be full-featured enough to cover all the bases, not just
> a few cherry-picked ones.

Well, I can make Yama stack, but I suspect I shouldn't waste my time on
that since Yama itself would be rejected on different grounds. I'm sure you
can see how this appears to be a catch 22. "We don't need stacking because
nothing needs to be stacked, and we don't need a micro-LSM because it can't
be used due to lack of stacking."

> protect".  I won't disagree with the concept that DAC isn't usually sufficient
> - the point is that ad-hoc fixes for the low-hanging fruit isn't doing anybody
> any favors.

This is the basis of our disagreement. Fixing it does do people a favor. At
the very least, it does me a favor because now I don't have to publish
security updates for an entire class of vulnerability.

> The problem is that "proving it does what it claims" and "proving it
> actually provides security" are two very different things.

Understood. I get what you're saying about the models, and my only real
defense here is that I didn't want these features in an LSM to begin with,
so I don't mind it not being an LSM. That said, again, we disagree, it does
actually provide security. I can point to lists of vulnerabilities where
the symlink/hardlink protection actually does really block the exploit.

> If somebody attacks via a different symlink attack than Yama checks for, is it
> a Yama failure? If somebody attacks via a non-symlink attack, was that a Yama
> failure or no?

I think this is irrelevant; the symlink/hardlink combo fixes a
vulnerability with DAC. It's a break in the DAC security model.

> If I find a way to trick SELinux into allowing me to scribble on /etc/passwd,
> that's an SELinux failure.  If I find a way to do an end-run around Tomoyo, or
> Smack, or AppArmor, that's a failure. And if I write to the SELinux or Tomoyo
> or Smack or AppArmor folks, I'm quite certain they'll all send back a reply "Oh
> damn, that shouldn't happen, we'll think about a policy or code fix to prevent
> that".

Right, though my objection to all MACs is that they are on top of DAC, and
that large portions of the Linux user base do not use a MAC, but they
cannot avoid DAC. Since the symlink/hardlink issue is with DAC, it should
be fixed there, not in a MAC layer above.

> But scribbling on /etc/passwd by using any of the 4,394 different known attacks
> against Linux except the 1 that Yama protects against isn't considered a
> problem.
> 
> Do you see the difference?

I get what you're saying. It is convincing me that the symlink/hardlink
features make no sense as an LSM.

> "There are two kinds of cryptography in this world: cryptography that will stop
> your kid sister from reading your files, and cryptography that will stop major
> governments from reading your files.  This book is about the latter."
> 		-- Bruce Schneier, "Applied Cryptography"
> 
> The same sort of distinction applies to security.

Right. But I'm trying to help protect people from their kid sister too.
Unfortunately, the use-case is where it's both the kid sister admin with no
MAC policy being attacked by the kid sister script kiddie with a symlink
race exploit due to the kid sister programmer who wrote an application that
uses a guessable /tmp file. (With apologies to kid sisters everywhere; I
just wanted to continue the quoted metaphor.)

> I'm sure there's several dozen other practical attacks that a motivated
> attacker can come up with. So now you've traded "protect one ptrace() syscall"
> for "protect against abuse of at least a dozen system calls".

You're completely right that the PTRACE exception idea isn't perfect. It
could be raced between the crasher's fork()/exec() and prctl(). There are
probably more cases, but it sure is better than just letting everything
PTRACE everything else.

While waiting for smarter people than me make it impossible to exploit
security vulnerabilities in the future, I want to make it harder for
attackers to exploit security vulnerabilities now.

> That's why you need an actual model, not ad-hoc rules.  Start with "This program
> has data we don't want leaked, by ptrace or any other means".  Work from there.

Heh, well, I have a PTRACE model. :) "Only CAP_SYSADMIN can PTRACE_ATTACH."
Unfortunately, I'm stuck with these damned crash handlers which are really
just hacks to avoid writing a core to disk. Oddly, this is a solved problem
(via core dump patterns and distro-wide crash handlers), but some
applications want to opt out of it instead of providing proper system hooks
to do crash analysis. Of course, with PTRACE still allowed, there's no
carrot (or stick) to encourage application writers to use distro-provided
crash handlers.

-Kees

-- 
Kees Cook
Ubuntu Security Team
