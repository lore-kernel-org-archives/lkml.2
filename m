Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752893Ab1CKSEN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 13:04:13 -0500
Received: from piggy.rz.tu-ilmenau.de ([141.24.4.8]:34779 "EHLO
	piggy.rz.tu-ilmenau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752719Ab1CKSEM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 13:04:12 -0500
Date: Fri, 11 Mar 2011 19:03:35 +0100
From: "Mario 'BitKoenig' Holbe" <Mario.Holbe@TU-Ilmenau.DE>
To: Andi Kleen <ak@linux.intel.com>
Cc: dm-crypt@saout.de, linux-kernel@vger.kernel.org,
        Milan Broz <mbroz@redhat.com>, Alasdair G Kergon <agk@redhat.com>
Subject: Re: dm-crypt: Performance Regression 2.6.37 -> 2.6.38-rc8
Message-ID: <20110311180334.GA11382@darkside.kls.lan>
Mail-Followup-To: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>,
	Andi Kleen <ak@linux.intel.com>, dm-crypt@saout.de,
	linux-kernel@vger.kernel.org, Milan Broz <mbroz@redhat.com>,
	Alasdair G Kergon <agk@redhat.com>
References: <20110308164508.GA8729@darkside.kls.lan>
 <20110310165730.GC20504@alboin.amr.corp.intel.com>
 <20110310175411.GB25027@darkside.kls.lan>
 <20110311011842.GA5698@alboin.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OgqxwSJOaUobr8KG"
Content-Disposition: inline
In-Reply-To: <20110311011842.GA5698@alboin.amr.corp.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--OgqxwSJOaUobr8KG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I was long pondering whether to reply to this or not, but sorry, I
couldn't resist.

On Thu, Mar 10, 2011 at 05:18:42PM -0800, Andi Kleen <ak@linux.intel.com> w=
rote:
> You probably need to find some way
> to make pcrypt (parallel crypt layer) work for dmcrypt. That may
> actually give you more speedup too than your old hack because
> it can balance over more cores.=20

"my" old "hack" balances well as long as the number of stripes is equal
or greater than the number of cores.
And for my specific case... it's hard to balance over more than 4 cores
on a Core2Quad :)

> Or get a system with AES-NI -- that usually solves it too.

Honi soit qui mal y pense.
Of course I understand that Intel's primary goal is to sell new
hardware and hence I understand that you are required to tell this to
me. However, based on the AES-NI benchmarks from the linux-crypto ML,
even with AES-NI it would be hard to impossible to re-gain my
(non-AES-NI!) pre-.38 performance with the .38 dm-crypt parallelization
approach.

> Frankly I don't think it's a very interesting case, the majority
> of workloads are not like that.

Well, I'm not sure if we understand each other.
Probably my use case is a little bit special, but that's not the point.

The main point is that the .38 dm-crypt parallelization approach does
kill performance on *each* RAID0-over-dm-crypt setup. A setup which, I
believe, is not that uncommon as you may believe because it was the only
way to spread disk-encryption over multiple CPUs until .38.

Up to .37 due to the CPU-inaffinity accessing (reading or writing) one
stripe in the RAID0 did always spread over min(#core, #kcryptd) cores.
Now with .38 the same access will always only utilize one single core
because all the chunks of the stripe are (obviously) accessed on the
same core and hence either the multiple underlying kcryptds block each
other now with the old approach or with dm-crypt-over-RAID0 there is
only one kcryptd involved in serving one request on one core. Hence, for
single requests the new approach always decreases throughput and
increases latency. The latency-increase holds even for multi-process
workloads.

For your approach to at least match up the old one it requires
min(#core, #kcryptd) parallel requests all the time assuming latency
doesn't matter and disk seek time to be zero (now you tell me to get
X25s, right? :)).


Mario
--=20
There are two major products that come from Berkeley: LSD and UNIX.
We don't believe this to be a coincidence.    -- Jeremy S. Anderson

--OgqxwSJOaUobr8KG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEVAwUBTXpj9hS+e2HeSPbpAQLGZggAlynlJsCUsPJA3ITqAtQEGTBivg46ayzS
/cy35NwlXGQLAiCzUdHbm0Aun9kP+5IMX2sxqIaSzmPZhDtxFVDY21PVqV//cFrq
/bynlZeyV2kgDGShlOhG0vPY8+Ot46en5lY+DrWsSES87t/lfzQGRt8MASKbjLBo
aEF4acoQLZWem2BOf6gwOSH9SAL9WmRwN4YjR3Vndj60vm+WsU4xmmHIHhSMueBi
YcODz/rudFlq1e/QnVvkY/thfanzih7FQjTdzkqevZyb29HZGg7s1LTk3efiPhPQ
NpJOevvRv2MgHZlPI/1Wpk9C+CjRMl+PIPQ0ZmtRROZC6+11xD0RkQ==
=cVX+
-----END PGP SIGNATURE-----

--OgqxwSJOaUobr8KG--
