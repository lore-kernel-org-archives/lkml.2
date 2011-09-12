Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756266Ab1ILQ6q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 12:58:46 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:59649 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756241Ab1ILQ6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 12:58:43 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Jarod Wilson <jarod@redhat.com>
Cc: Sandy Harris <sandyinchina@gmail.com>, Steve Grubb <sgrubb@redhat.com>,
        Neil Horman <nhorman@redhat.com>, Tomas Mraz <tmraz@redhat.com>,
        Sasha Levin <levinsasha928@gmail.com>, "Ted Ts'o" <tytso@mit.edu>,
        linux-crypto@vger.kernel.org, Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert.xu@redhat.com>,
        Stephan Mueller <stephan.mueller@atsec.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] random: add blocking facility to urandom
In-Reply-To: Your message of "Mon, 12 Sep 2011 09:55:15 EDT."
             <4E6E0F43.6070307@redhat.com>
From: Valdis.Kletnieks@vt.edu
References: <1314974248-1511-1-git-send-email-jarod@redhat.com> <1315464117.11199.51.camel@vespa.frost.loc> <20110908125234.GD13657@hmsreliant.think-freely.org> <201109080911.12921.sgrubb@redhat.com> <CACXcFmnnMLHq2VE35i4QK4wNePXHJc6T73VQNTmJo7WEz34DaQ@mail.gmail.com> <118704.1315706746@turing-police.cc.vt.edu>
            <4E6E0F43.6070307@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1315846699_2747P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 12 Sep 2011 12:58:19 -0400
Message-ID: <11721.1315846699@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=dagger.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020205.4E6E3A33.0140,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1315846699_2747P
Content-Type: text/plain; charset=us-ascii

On Mon, 12 Sep 2011 09:55:15 EDT, Jarod Wilson said:

> Well, previously, we were looking at simply improving random entropy 
> contributions, but quoting Matt Mackall from here:
> 
> http://www.mail-archive.com/linux-crypto@vger.kernel.org/msg05799.html
> 
> 'I recommend you do some Google searches for "ssl timing attack" and 
> "aes timing attack" to get a feel for the kind of seemingly impossible 
> things that can be done and thereby recalibrate your scale of the 
> impossible.'

If you're referring to Dan Bernstein's 2005 paper on AES timing attacks
(http://cr.yp.to/antiforgery/cachetiming-20050414.pdf), note that it took
him on the order of 2*25 packets per byte of AES key - targeting a
dummy server intentionally designed to minimize noise.  Although he
correctly notes: 

     Of course, I wrote this server to minimize the amount of noise in the timings
  available to the client. However, adding noise does not stop the attack: the client
  simply averages over a larger number of samples, as in [7]. In particular, reducing
  the precision of the server's timestamps, or eliminating them from the server's
  responses, does not stop the attack: the client simply uses round-trip timings
  based on its local clock, and compensates for the increased noise by averaging
  over a larger number of samples.

one has to remember that he's measuring average differences in processing
time on the order of single-digits of cycles - if any *real* processing was happening
it would only take a few cache line misses or an 'if' statement branching the
other way to almost totally drown out the AES computation.  (Personally,
I'm amazed that FreeBSD 4.8's kernel is predictable enough to do these
measurements - probably helps a *lot* that the server was otherwise idle -
if somebody else was getting a timeslice in between it would totally swamp
the numbers).

Dan's reference [7] mentions specifically that RSA blinding (first implemented
by default all the way back in OpenSSL 0.9.7b) defeats that paper's timing
attack.

If anything, those attacks are the best proof possible that the suggested
"fix" for /dev/urandom is a fool's errand - why would anybody bother trying to
figure out what the "next" data out of /dev/urandom is, when they can simply
wait for a few milliseconds and extract it out of whatever program read it? :)

--==_Exmh_1315846699_2747P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFObjorcC3lWbTT17ARAh+mAKC2so3DGa++bW/l4KQEttzwqnqDpwCgyErS
ACm3OD4YQBar3G0rRQGM+Kw=
=hi+7
-----END PGP SIGNATURE-----

--==_Exmh_1315846699_2747P--

