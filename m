Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754244Ab2ETDwo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2012 23:52:44 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60146 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752151Ab2ETDwm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2012 23:52:42 -0400
Message-ID: <1337485947.4107.295.camel@deadeye>
Subject: Re: [WARNING] lockdep and kmemcheck_alloc_shadow
From: Ben Hutchings <ben@decadent.org.uk>
To: Steven Rostedt <rostedt@goodmis.org>, Christoph Lameter <cl@linux.com>
Cc: LKML <linux-kernel@vger.kernel.org>, stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peter Zijlstra <peterz@infradead.org>
Date: Sun, 20 May 2012 04:52:27 +0100
In-Reply-To: <1337449661.32434.4.camel@gandalf.stny.rr.com>
References: <1337449661.32434.4.camel@gandalf.stny.rr.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-mTWdG1Q4Ikzjr4ALVgFc"
X-Mailer: Evolution 3.2.2-1+b1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-mTWdG1Q4Ikzjr4ALVgFc
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2012-05-19 at 13:47 -0400, Steven Rostedt wrote:
> Testing 3.2.18-rc1 I hit the following:
>=20
> WARNING: at /work/autotest/nobackup/linux-test.git/kernel/lockdep.c:2739 =
lockdep_trace_alloc+0xee/0xf0()

Which is:

	/*
	 * Oi! Can't be having __GFP_FS allocations with IRQs disabled.
	 */
	if (DEBUG_LOCKS_WARN_ON(irqs_disabled_flags(flags)))
		return;

> Hardware name:        =20
> Pid: 0, comm: swapper/0 Not tainted 3.2.18-rc1-test+ #1
> Call Trace:^M
>  [<ffffffff81066175>] warn_slowpath_common+0x75/0xb0
>  [<ffffffff81066285>] warn_slowpath_null+0x15/0x20
>  [<ffffffff81098aee>] lockdep_trace_alloc+0xee/0xf0
>  [<ffffffff810d8adc>] __alloc_pages_nodemask+0x8c/0x7e0
>  [<ffffffff81098537>] ? trace_hardirqs_off_caller+0xb7/0x120
>  [<ffffffff8143467d>] ? trace_hardirqs_off_thunk+0x3a/0x3c
>  [<ffffffff81098537>] ? trace_hardirqs_off_caller+0xb7/0x120
>  [<ffffffff8143467d>] ? trace_hardirqs_off_thunk+0x3a/0x3c
>  [<ffffffff81098537>] ? trace_hardirqs_off_caller+0xb7/0x120
>  [<ffffffff8143467d>] ? trace_hardirqs_off_thunk+0x3a/0x3c
>  [<ffffffff81c8d567>] ? retint_restore_args+0x6/0x13
>  [<ffffffff81113c9b>] kmemcheck_alloc_shadow+0x4b/0xf0
>  [<ffffffff8111016f>] new_slab+0x26f/0x370
>  [<ffffffff81c70677>] __slab_alloc+0x2ee/0x421
>  [<ffffffff8143467d>] ? trace_hardirqs_off_thunk+0x3a/0x3c
>  [<ffffffff8110997e>] ? do_set_mempolicy+0x4e/0x210^M
>  [<ffffffff81c8d567>] ? retint_restore_args+0x6/0x13
>  [<ffffffff8110997e>] ? do_set_mempolicy+0x4e/0x210
>  [<ffffffff8111122d>] kmem_cache_alloc+0x12d/0x140
>  [<ffffffff8110997e>] do_set_mempolicy+0x4e/0x210
>  [<ffffffff822e945e>] numa_policy_init+0x11f/0x13f
>  [<ffffffff822c7aae>] start_kernel+0x2d0/0x36e
[...]

Seems to be a bug in SLUB:

> static struct page *allocate_slab(struct kmem_cache *s, gfp_t flags, int =
node)
> {
[...]
> 	if (flags & __GFP_WAIT)
> 		local_irq_disable();
>=20
> 	if (!page)
> 		return NULL;
>=20
> 	if (kmemcheck_enabled
> 		&& !(s->flags & (SLAB_NOTRACK | DEBUG_DEFAULT_FLAGS))) {
> 		int pages =3D 1 << oo_order(oo);
>=20
> 		kmemcheck_alloc_shadow(page, oo_order(oo), flags, node);
[...]

So kmemcheck_alloc_shadow() runs with IRQs off, but uses the same flags
as the original allocation.

Looks like this was introduced by:

commit 7e0528dadc9f8b04e4de0dba48a075100c2afe75
Author: Christoph Lameter <cl@linux.com>
Date:   Wed Jun 1 12:25:44 2011 -0500

    slub: Push irq disable into allocate_slab()

which went into 3.1.

Ben.

--=20
Ben Hutchings
Experience is directly proportional to the value of equipment destroyed.
                                                         - Carolyn Scheppne=
r

--=-mTWdG1Q4Ikzjr4ALVgFc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAT7hqe+e/yOyVhhEJAQomkg//eE3KjcRWNjWCSPeqvxcvSre0AyOzP8dk
KDdbIkNM4/D9d/GF6wf2Ek2/CWhZQ2cIuP/Nrrp4EsoMcy0sZJLc/4WSlO0ucoR5
Ij9BCoG13m+zrSQ4+otLhwL+/21oltVZ8DfmIDv6AFE8zM5praFpw3Tx2DnLa0B5
+q5HZeZlu8WtcTG5wQrrl3CU/ceUEko1cm1lFTy+uc4lXj5Fe3eNd+8KPCiDZNJ7
ntTrarcaNIeKsxly7bt6nq7wGb1XmspEd7qSZvumMJ61egWN5DmZQ2sGwFbRhdLg
I3V2pb3ev+vwfaRKJEw8nPFaUpCueOtG9nRluS0wjeyq9CH+360fiHJTkGRlFJjJ
mSp31agVMqmaVUwTUBD27jQMQT63arlUzNJ0tOES6JUNGGzGe/dkAf2kx0RCP46/
pJMc8RT/G6t2hh/OsHNybLZzp4una5YL6zzBKazUwMmqVqNIlFA3BvR+HCz0DU89
6MAY3J0+yx/Dy4no3zmECeSxIxIDxsPefyyEBPMojfY2tsW/LA/0qbpVnF+6YetS
Q7ioublVom8bMXZnbX/1wElHTLeMQSkbtZrjqyIepty8OPzVX9OpYMEI7a8BEFsU
KMOPdjU8avi+ulyNanWWxwWwAg7n9BLA/rOKWGsncSexRGhUsZA9VEohY/hVDRKO
V5aFeoVss6M=
=dyWh
-----END PGP SIGNATURE-----

--=-mTWdG1Q4Ikzjr4ALVgFc--
