Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761446Ab2ERIGN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 04:06:13 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51872 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932281Ab2ERIGD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 04:06:03 -0400
Date: Fri, 18 May 2012 18:05:50 +1000
From: NeilBrown <neilb@suse.de>
To: koverstreet@google.com
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, tj@kernel.org,
        axboe@kernel.dk, agk@redhat.com
Subject: Re: [PATCH 12/13] Make generic_make_request handle arbitrarily
 large bios
Message-ID: <20120518180550.0a6cdc34@notabene.brown>
In-Reply-To: <1114e7019b0055fc09a54b59b36398d5c54f5e32.1337308722.git.koverstreet@google.com>
References: <cover.1337308722.git.koverstreet@google.com>
	<1114e7019b0055fc09a54b59b36398d5c54f5e32.1337308722.git.koverstreet@google.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/w5vxMlcq6bve1stJTPTa04p"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/w5vxMlcq6bve1stJTPTa04p
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable


Hi Kent,
 there is lots of good stuff in this series and I certainly hope a lot of it
 can eventually go upstream.

 However there is a part of this patch that I don't think is safe:


> +static void __bio_submit_split(struct closure *cl)
> +{
> +	struct bio_split_hook *s =3D container_of(cl, struct bio_split_hook, cl=
);
> +	struct bio *bio =3D s->bio, *n;
> +
> +	do {
> +		n =3D bio_split(bio, bio_max_sectors(bio),
> +			      GFP_NOIO, s->q->bio_split);
> +		if (!n)
> +			continue_at(cl, __bio_submit_split, bio_split_wq);
> +
> +		closure_get(cl);
> +		generic_make_request(n);
> +	} while (n !=3D bio);
> +
> +	continue_at(cl, bio_submit_split_done, NULL);
> +}

Firstly a small point:  Can bio_split ever return NULL here?  I don't
think it can, so there is no need to test.
But if it can, then calling generic_make_request(NULL) doesn't seem like a
good idea.

More significantly though::
  This is called from generic_make_request which can be called recursively =
and
enforces a tail-recursion semantic.
If that generic_make_request was a recursive call, then the
generic_make_request in __bio_submit_split will not start the request, but
will queue the bio for later handling.  If we then call bio_split again, we
could try to allocation from a mempool while we are holding one entry
allocated from that pool captive.  This can deadlock.

i.e. if the original bio is so large that it needs to be split into 3 piece=
s,
then we will try to allocate the second piece before the first piece has a
chance to be released.  If this happens in enough threads to exhaust the po=
ol
(4 I think), it will deadlock.

I realise this sounds like a very unlikely case, but of course they happen.

One possible approach might be to count how many splits will be required,
then have an interface to mempools so you can allocate them all at once,
or block and wait.

Thanks,
NeilBrown


--Sig_/w5vxMlcq6bve1stJTPTa04p
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT7YC3jnsnt1WYoG5AQKglg//Xze/QbSQ0KVWwYqBQD1GphnYewUp574T
AYyhTO0crZiVeChW9g1Nk/bPCyIokYkGFz5wLFd6kO1hwuVHJpB4GEXS5aPyOqq5
hM7Gy6iAqc4+PxYRClN9QzHYfMqePlF91VN0nPH6htBr2pk2AKLGEzT12cXJEOFr
bInWnijJ0wEA4K6YHNNs99Ibzb6+ul4TjTgOdRj6Hh8kW49zPctaZuUbfU1sg2eB
irNiZr5IBdbP76M74HfMgJcCT6/rCYhKr8jbbR4bUU8ROiW4vh2b8FqLoW5qem6a
N297B1EQp8IVpuWkPybIuOuKWNeb5QH65lk93AvXpA1mBJIb1VGKQ2QVgMUW9rhn
KeNsFk5IWzneRegKbfutBNsFMZ4ruXpNsbr4cRt6pAf1di+QOZW7OFlv3Y9nsndn
vW1+0B1TOzCtaYxYRffN2L0oGVckeTVrAVtDCB9ZG11GVEmiyCEssKo5PpyTM+uY
vQfsrLPhB6682KhS6qyngY3GkdTysLUdT7mP7mX19q7EuVx89s+4N/89Fq9PEStk
ZXGP76LiZzz0MYjXRQHpCgvIXdtBfPWuxnwdDmRO0hR0ohGN+y271DKJXDbPTQay
0q20Uw/VvYYrvJtETG7iLUGi2s5dCx1vlRGCjlr6WUsiTTDKxsnB2Zb1pP7s/rtj
LVAyv+knoKs=
=RBfr
-----END PGP SIGNATURE-----

--Sig_/w5vxMlcq6bve1stJTPTa04p--
