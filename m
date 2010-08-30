Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753840Ab0H3WPz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 18:15:55 -0400
Received: from grsecurity.net ([173.10.160.233]:53375 "EHLO grsecurity.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753404Ab0H3WPv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 18:15:51 -0400
X-Greylist: delayed 423 seconds by postgrey-1.27 at vger.kernel.org; Mon, 30 Aug 2010 18:15:51 EDT
Date: Mon, 30 Aug 2010 18:08:47 -0400
From: Brad Spengler <spender@grsecurity.net>
To: Solar Designer <solar@openwall.com>
Cc: Roland McGrath <roland@redhat.com>, Kees Cook <kees.cook@canonical.com>,
        linux-kernel@vger.kernel.org, oss-security@lists.openwall.com,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Neil Horman <nhorman@tuxdriver.com>, linux-fsdevel@vger.kernel.org,
        pageexec@freemail.hu
Subject: Re: [PATCH] exec argument expansion can inappropriately trigger
	OOM-killer
Message-ID: <20100830220847.GA24980@grsecurity.net>
References: <20100827220258.GF4703@outflux.net> <20100830005648.431B7400D9@magilla.sf.frob.com> <20100830032331.GA22773@openwall.com> <20100830174920.GA25091@openwall.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wac7ysb48OaltWcw"
Content-Disposition: inline
In-Reply-To: <20100830174920.GA25091@openwall.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wac7ysb48OaltWcw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi guys,

I see you're having fun with my code ;)  Just wanted to remind you that=20
I do exist; I reported this in December 2009 to Ted Tso and again=20
recently (forwarded the same email from 2009) to Kees Cook and James=20
Morris.  So even though nobody's actually emailed me about the issue(s),=20
I am available to answer any questions.  Just CC me on the email as I'm=20
not subscribed to the list.

Anyway, I did actually research the bug(s) involved quite a bit around=20
the time I reported it, so hopefully some of the below will help.

The bug seems to have been introduced in 2.6.23, see:
http://thread.gmane.org/gmane.linux.ports.hppa/752
http://www.spinics.net/lists/linux-arch/msg01584.html
http://www.mail-archive.com/linux-kernel@vger.kernel.org/msg170491.html
though I'm guessing the functionality was also backported to major=20
distros

The check using the current stack limit as a byte value (including when=20
it's RLIMIT_INFINITY) by dividing it by 4 is completely broken for a=20
number of reasons:
1/4th of a 64bit ~0 is several times larger than the size of addressable=20
userland address space on most 64bit architectures (amd64 is 47 bits)
1/4th of a 64bit ~0 is way bigger than any 32bit value
No other place in the kernel treats a limit in this way
With a high rlimit and high usage, the code doesn't do what it intends=20
to do -- be able to return a meaningful error message to execve, instead=20
of having the process doing the execve terminated with a SIGKILL in=20
later stages of ELF loading.

Combined with the fact that the max arg size * max number of args=20
(~256TB) is also again larger than the 32bit address space and the=20
amd64 userland address space (as well as the address space of several other=
=20
64bit architectures), lots of problems appear.  This was exacerbated by=20
the behavior that, until recently fixed, allowed the stack to grow over=20
any other existing mappings.  Combine this with ASLR and shifting that=20
whole stack range down a random amount via shift_arg_pages/adjust_vma=20
which skips many of the sanity checks that exist elsewhere, and even=20
more problems appear (I think this latter problem may make it possible=20
to still trigger the BUG_ON() on patched kernels if a static binary is=20
used and ASLR shifts the stack over the binary).

=46rom my research, it's not possible to successfully execute a binary=20
such that mmap_min_addr with normal values can be bypassed by the stack=20
shifting trick.  I was able to determine the exact number+sizes of=20
arguments to use for ASLR to have a chance to shift the stack down to 0=20
(any more and we would trigger that BUG_ON()).  Though this was=20
successful, after this point in the ELF loader, additional data is set=20
up on the stack, proportional to the number of arguments passed.  It's=20
impossible for this additional setup to consume less than a page, so it=20
triggers a stack expansion which then gets checked against the normal=20
mmap_min_addr checks.  What actually ends up happening on this=20
second-stage setup is the binary gets killed with SIGKILL by the ELF=20
loader.

The fix to the OOM killer looks correct, but the other problem (causing=20
extreme interactivity hits with almost no effort in userland) needs some=20
more thought, especially since it appears no distro is shipping with=20
hard limits on the stack.

If the  "/ 4" check is to be preserved, it needs to take into account=20
the personality of the target binary: this way, the exec'ing task should=20
always get a proper error back instead of being terminated by the=20
kernel.

There shouldn't be any additional risk from adding the extra rescheds,=20
as copy_*_user can already sleep and be raced against via a number of=20
methods.

-Brad

--wac7ysb48OaltWcw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkx8K+8ACgkQmHm2SUJF1GonOgCfZ8XHgc1fw7zWWDAylVSGNq9J
QUQAn1UwmddRwbBBadaQefEU11NPyp2O
=5ILJ
-----END PGP SIGNATURE-----

--wac7ysb48OaltWcw--
