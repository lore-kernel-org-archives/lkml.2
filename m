Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752102Ab0HBSw0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 14:52:26 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:43963 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754454Ab0HBSwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 14:52:22 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Kees Cook <kees.cook@canonical.com>
Cc: Christoph Hellwig <hch@infradead.org>, James Morris <jmorris@namei.org>,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Al Viro <viro@ftp.linux.org.uk>
Subject: Re: Preview of changes to the Security susbystem for 2.6.36
In-Reply-To: Your message of "Mon, 02 Aug 2010 09:59:36 PDT."
             <20100802165936.GV3948@outflux.net>
From: Valdis.Kletnieks@vt.edu
References: <alpine.LRH.2.00.1007301852110.14431@tundra.namei.org> <alpine.LRH.2.00.1008021216520.31941@tundra.namei.org> <20100802122421.GA12130@infradead.org>
            <20100802165936.GV3948@outflux.net>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1280775073_3871P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 02 Aug 2010 14:51:13 -0400
Message-ID: <15424.1280775073@localhost>
X-Mirapoint-Received-SPF: 128.173.14.107 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=vivi.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020201.4C5713A1.00F3,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1280775073_3871P
Content-Type: text/plain; charset=us-ascii

On Mon, 02 Aug 2010 09:59:36 PDT, Kees Cook said:

> > Al gave you some very clear advice how a the sticky check should be
> 
> This is patently false. "Very clear advice" would have included actionable
> instructions. He (and everyone else) has ignored my requests for
> clarification[2]. If you see how the check should be implemented, please
> send a patch demonstrating how. I would greatly prefer having these
> protections in the VFS itself.

You're overlooking step zero of Al's advice: First, *think* about the issue
in a deep fashion, rather than a knee-jerk patch to fix one instance of
the problem.

> > done for symlinks (if we need it at all, which I tend to disagree with),
> 
> I can see how one might disagree with it, but anyone who handles day-to-day
> security threats understands this protection to be a clear and obvious
> solution for the past decade.

The problem is that although your patch closes *one set* of symlink attacks
that has been traditionally a problem, it doesn't do a very good job of
creating a conceptual model and then *really* dealing with the issue. That's
the big distinction between SELinux, Tomoyo, Smack, and your proposal - they
form a *model* of what's important to protect, and what actions need to be
taken to *actually* protect them.  They don't just apply one arbitrary rule
that closes some attacks - they make an honest effort to deal with all variants
of the attack, and other attacks that allow bypass, and so on.

The reason people are worried that this might grow into a "large" LSM is that
quite often, throwing in a bunch of ad-hoc rules may create *apparent*
security, but not provide any *real* security.  You yourself admit that Yama
only closes one set of symlink attacks without addressing the general issue of
symlinks, hard links, TOCTOU races, and a lot of *other* similar "the file you
actually opened is not the one you intended to open" attacks. And the reason it
doesn't address the general issue is because it lacks a security model.  And
the reason you're having so much trouble getting it into the tree is because if
you're going to apply this at either the VFS or LSM layers, you need to address
the *general* problem and not one ad-hoc variant of it.

And quite frankly, the idea of this morphing into a "large" LSM containing a
lot of ad-hoc rules scares most security people, because without a good
conceptual model, it's hard to define if the security is in fact working, or
what the problem is if it isn't working.

> > and the ptrace check completely breaks crash handlers that we have
> > in all kinds of applications.  If you can get it into the main ptrace
> 
> I've seen two so far. Both are addressed with a one line fix. And I would
> stress that no other existing subsystem in the kernel can provide the same
> level of control that my ptrace exception logic provides. SELinux cannot do
> this.

Quick question: Now is that "SELinux doesn't consider the added granularity
important and doesn't bother doing it", or "SELinux can't do it *currently*",
or "there are innate structural reasons why SELinux is by design unable to do
it"?  Note that it's a big difference, and it's dangerous for your cause to
bring it up without understanding which it is, and why...

> This advice is precisely counter to prior advise. It would seem that no one
> knows how to handle these patches. I find it very simple; either:
>  - let me put them in an LSM that people can choose to enable
>  - help me get the patches into shape for the subsystems directly

You're still missing the point:

> [2] http://lkml.org/lkml/2010/6/4/44

You were told to go back and form an actual *security model*. What's important
to protect? What attacks can be made against it? What syscalls are included in
the forseeable attacks (hint - probably more than you think - if you're
mediating symlink access, a bit of thought will show symlinks aren't the only
problem you need to worry about to *actually* secure the resource).



--==_Exmh_1280775073_3871P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFMVxOhcC3lWbTT17ARAnn5AKDrft/mLb/A/MfmZG2a94i7tqdG2ACgzGkN
pzDS9rNv6X8fRA//WUgApeM=
=ATf+
-----END PGP SIGNATURE-----

--==_Exmh_1280775073_3871P--

