Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753147Ab0KXR4A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 12:56:00 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:53262 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409Ab0KXRz6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 12:55:58 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: wharms@bfs.de
Cc: =?UTF-8?B?QW3DqXJpY28gV2FuZw==?= <xiyou.wangcong@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        kernel-janitors@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jakub Jelinek <jakub@redhat.com>
Subject: Re: [PATCH v2] fs: select: fix information leak to userspace
In-Reply-To: Your message of "Tue, 23 Nov 2010 15:45:18 +0100."
             <4CEBD37E.5060107@bfs.de>
From: Valdis.Kletnieks@vt.edu
References: <1289421483-23907-1-git-send-email-segooon@gmail.com> <20101112120834.33062900.akpm@linux-foundation.org> <8D90F8B2-EA29-4EB9-9807-294CE0D5523B@dilger.ca> <20101114092533.GB5323@albatros> <20101114180643.593d19ac.akpm@linux-foundation.org> <1289848341.2607.125.camel@edumazet-laptop> <20101123140111.GA3816@hack>
            <4CEBD37E.5060107@bfs.de>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1290621274_4785P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 24 Nov 2010 12:54:34 -0500
Message-ID: <15896.1290621274@localhost>
X-Mirapoint-Received-SPF: 128.173.14.107 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=vivi.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020201.4CED515B.01F4,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1290621274_4785P
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

On Tue, 23 Nov 2010 15:45:18 +0100, walter harms said:

> hi all,
> as we see this is not a question of c99.
> Maybe we can convince the gcc people to make 0 padding default. That wi=
ll not solve the
> problems for other compilers but when they claim =22works like gcc=22 w=
e can press then to
> support this also. I can imagine that this will close some other subtle=
 leaks also.

Note that zero padding by default has a price - the code has to include z=
eroing
instructions for each structure that needs it.  In the case of a function=
 that
gets inlined, the zeroing instructions could easily cost almost as much a=
s the
actual function.  So your code ends up bigger and slower. Let's look at t=
hat example
again:

>>>>  	if (timeval) =7B
>>>> -		rtv.tv_sec =3D rts.tv_sec;
>>>> -		rtv.tv_usec =3D rts.tv_nsec / NSEC_PER_USEC;
>>>> +		struct timeval rtv =3D =7B
>>>> +			.tv_sec =3D rts.tv_sec,
>>>> +			.tv_usec =3D rts.tv_nsec / NSEC_PER_USEC
>>>> +		=7D;
>>>> =20
>>>>  		if (=21copy_to_user(p, &rtv, sizeof(rtv)))
>>>>  			return ret;

Quick - is the optimizer able to eliminate the zero padding?  If so, how =
does
it know that?  And if the optimizer *can't* eliminate the zero padding, w=
hat
does that to do the overall generated code quality (especially on CPUs li=
ke the
x86 in 32-bit mode, where there's significant register pressure)?

You might be able to get them to add an *option* to force zero-padding, b=
ut
there's no way that's going to become the default.


--==_Exmh_1290621274_4785P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFM7VFacC3lWbTT17ARAvJoAKDd9Lim94oTCDUZ+jgjWsDQyK0/YwCg98lp
sYUraqTqUkHDmKxaxh9ENQc=
=vNHG
-----END PGP SIGNATURE-----

--==_Exmh_1290621274_4785P--

