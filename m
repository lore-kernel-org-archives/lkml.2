Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757560Ab0HCVjf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 17:39:35 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:55792 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753993Ab0HCVjb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 17:39:31 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Kees Cook <kees.cook@canonical.com>
Cc: Christoph Hellwig <hch@infradead.org>, James Morris <jmorris@namei.org>,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Al Viro <viro@ftp.linux.org.uk>
Subject: Re: Preview of changes to the Security susbystem for 2.6.36
In-Reply-To: Your message of "Tue, 03 Aug 2010 09:50:10 PDT."
             <20100803165010.GG3948@outflux.net>
From: Valdis.Kletnieks@vt.edu
References: <alpine.LRH.2.00.1007301852110.14431@tundra.namei.org> <alpine.LRH.2.00.1008021216520.31941@tundra.namei.org> <20100802122421.GA12130@infradead.org> <20100802165936.GV3948@outflux.net> <15424.1280775073@localhost>
            <20100803165010.GG3948@outflux.net>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1280871500_4165P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 03 Aug 2010 17:38:20 -0400
Message-ID: <78690.1280871500@localhost>
X-Mirapoint-Received-SPF: 128.173.34.103 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=zidane.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020206.4C588C4D.0303,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1280871500_4165P
Content-Type: text/plain; charset=us-ascii

On Tue, 03 Aug 2010 09:50:10 PDT, Kees Cook said:

> > You're overlooking step zero of Al's advice: First, *think* about the issue
> > in a deep fashion, rather than a knee-jerk patch to fix one instance of
> > the problem.
> 
> I think this is unfair. This solution has been used for 15 years in other
> hardened kernel patches. It's not knee-jerk at all. Not fixing this is not
> getting the "good" for the sake of wanting the "perfect".

The fact that a patch for one case has been used for years doesn't mean
that it's a well thought out fix for the general case.

> Okay, thanks for this explanation of why people don't want Yama as an LSM.
> I disagree with the logic, but at least I understand the reasoning now.
> "Since Yama does not provide a security model, it cannot be an LSM." This
> then leaves a gap for people wanting to make small changes to the logic of
> how the kernel works without resorting to endlessly carrying a patchset.

It will likely not be accepted as an in-tree LSM, especially given that currently
it's rather difficult to stack two LSM's - which means that if a site wants to
run Yama, it becomes unable to take advantage of all the *other* security
features of SELinux or something similar.  In other words - if you want to be
an LSM, you need to be full-featured enough to cover all the bases, not just
a few cherry-picked ones.

You're of course free to keep a patchset that adds a private LSM, which should
be fairly immune to inter-release changes because the LSM hooks are pretty
set in stone and rarely change.

> Well, here we disagree. DAC is flawed, this fixes a giant class of security
> problems. The model is "fix what sticky means for symlinks" and "fix when
> hardlinks are created". :P

That's not a model.  A model is "these are the things that need to be
protected, these are the threats/attacks, and here are the ways we do to
protect".  I won't disagree with the concept that DAC isn't usually sufficient
- the point is that ad-hoc fixes for the low-hanging fruit isn't doing anybody
any favors.

> > And quite frankly, the idea of this morphing into a "large" LSM containing a
> > lot of ad-hoc rules scares most security people, because without a good
> > conceptual model, it's hard to define if the security is in fact working, or
> > what the problem is if it isn't working.

> I have regression tests for all the Yama features. I can prove if it's
> working or not.

The problem is that "proving it does what it claims" and "proving it
actually provides security" are two very different things.

If somebody attacks via a different symlink attack than Yama checks for, is it
a Yama failure? If somebody attacks via a non-symlink attack, was that a Yama
failure or no?

If I find a way to trick SELinux into allowing me to scribble on /etc/passwd,
that's an SELinux failure.  If I find a way to do an end-run around Tomoyo, or
Smack, or AppArmor, that's a failure. And if I write to the SELinux or Tomoyo
or Smack or AppArmor folks, I'm quite certain they'll all send back a reply "Oh
damn, that shouldn't happen, we'll think about a policy or code fix to prevent
that".

But scribbling on /etc/passwd by using any of the 4,394 different known attacks
against Linux except the 1 that Yama protects against isn't considered a
problem.

Do you see the difference?

"There are two kinds of cryptography in this world: cryptography that will stop
your kid sister from reading your files, and cryptography that will stop major
governments from reading your files.  This book is about the latter."
		-- Bruce Schneier, "Applied Cryptography"

The same sort of distinction applies to security.

> MAC is system-owner defined. This is programmer defined. I want my program
> to be able to declare that a single specific pid can PTRACE it and nothing
> else.

So let's see - the program needs some way to *find* said "single specific pid".
It checks the value of getppid()? Easily spoofable - I fork/exec it, wait for
it to say "parent can trace", then trace.  It checks in a file? If I can fake that
file out (with, perhaps, a symlink or race that Yama doesn't protect against),
I can do the ptrace.  Send it via a unix-domain socket or mmap or shmem?
See passing in a file. Or maybe I can force an OOM to kill the "real" pid,
then a quick fork() loop till I get that pid on the wrap-around. Or  maybe I'm
just a bastard and get control of the pid the program declares as "may ptrace'
and then do nothing at all just to DoS the process that you *wanted* tracing you.

I'm sure there's several dozen other practical attacks that a motivated
attacker can come up with. So now you've traded "protect one ptrace() syscall"
for "protect against abuse of at least a dozen system calls".

That's why you need an actual model, not ad-hoc rules.  Start with "This program
has data we don't want leaked, by ptrace or any other means".  Work from there.





--==_Exmh_1280871500_4165P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFMWIxMcC3lWbTT17ARAvCaAJ0aGoiS5m9xAmHjn0aLmrKUgarB3ACg3UqK
+/sTmQXiDS6OqtKJNuTGrCM=
=D6ii
-----END PGP SIGNATURE-----

--==_Exmh_1280871500_4165P--

