Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753527Ab2KTDOD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 22:14:03 -0500
Received: from cantor2.suse.de ([195.135.220.15]:55114 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753418Ab2KTDOB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 22:14:01 -0500
Date: Tue, 20 Nov 2012 14:13:43 +1100
From: NeilBrown <neilb@suse.de>
To: Dan Williams <djbw@fb.com>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
        Vinod Koul <vinod.koul@intel.com>, "Tomasz Figa" <t.figa@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH] raid5: panic() on dma_wait_for_async_tx() error
Message-ID: <20121120141343.25d84c71@notabene.brown>
In-Reply-To: <1353378237.26735.11.camel@localhost.localdomain>
References: <20121119120632.1c97e306@notabene.brown>
	<84A937D219C2B44EB8EA44831ACA1E49166C741F@SC-MBX02-3.TheFacebook.com>
	<20121120091824.58ed4565@notabene.brown>
	<1353378237.26735.11.camel@localhost.localdomain>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/rXxlZqsWNV_cmKZw6uY4cra"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/rXxlZqsWNV_cmKZw6uY4cra
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 19 Nov 2012 18:23:57 -0800 Dan Williams <djbw@fb.com> wrote:

> On Tue, 2012-11-20 at 09:18 +1100, NeilBrown wrote:
> > On Mon, 19 Nov 2012 05:22:25 +0000 Dan Williams <djbw@fb.com> wrote:
> >=20
> > >=20
> > >=20
> > > On 11/18/12 5:06 PM, "NeilBrown" <neilb@suse.de> wrote:
> > >=20
> > > >
> > > >Hi Dan,
> > > > could you comment on this please?  Would it make sense to arrange f=
or
> > > >errors
> > > > to propagate up?  Or should we arrange to do a software-fallback in=
 the
> > > >dma
> > > > engine is a problem?  What sort of things can cause error here anyw=
ay?
> > >=20
> > > Propagating up is missing reliable "dma abort" operation.
> > >=20
> > > In these cases the engine failed to complete due to hardware hang / d=
river
> > > bug, or has hit a memory error (uncorrectable even with software
> > > fallback).  This originally should have been using async_tx_quiesce()
> > > which also does the panic.
> > >=20
> > > The engines that I have worked with have either lacked support for
> > > aborting, or were otherwise unable to recover from a hardware hang.
> > > However, for engines that do support error recovery they should be ab=
le to
> > > hide the failure from the upper layers.
> > >
> >=20
> > So maybe I could:
> >=20
> > diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> > index ac09fa4..ffbf0ca 100644
> > --- a/drivers/md/raid5.c
> > +++ b/drivers/md/raid5.c
> > @@ -3268,7 +3268,7 @@ static void handle_stripe_expansion(struct r5conf=
 *conf, struct stripe_head *sh)
> >  	/* done submitting copies, wait for them to complete */
> >  	if (tx) {
> >  		async_tx_ack(tx);
> > -		dma_wait_for_async_tx(tx);
> > +		async_tx_quiesce(&tx);
> >  	}
> >  }
> > =20
> >=20
> >=20
> > and then the panic would be somebody else's problem?
> >=20
> > I note that handle_stripe_expansion has:
> >=20
> >  		async_tx_ack(tx);
> > 		dma_wait_for_async_tx(tx);
> >=20
> > while async_tx_quiesce() has:
> >=20
> > 		if (dma_wait_for_async_tx(*tx) =3D=3D DMA_ERROR)
> > 			panic("DMA_ERROR waiting for transaction\n");
> > 		async_tx_ack(*tx);
> >=20
> >=20
> > i.e. the same two functions called in the reverse order.  Is the order
> > important?  Is handle_stripe_expansion wrong?   Should the patch I apply
> > actually be:
> >=20
> >=20
> > diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> > index ac09fa4..e51d903 100644
> > --- a/drivers/md/raid5.c
> > +++ b/drivers/md/raid5.c
> > @@ -3266,10 +3266,7 @@ static void handle_stripe_expansion(struct r5con=
f *conf, struct stripe_head *sh)
> > =20
> >  		}
> >  	/* done submitting copies, wait for them to complete */
> > -	if (tx) {
> > -		async_tx_ack(tx);
> > -		dma_wait_for_async_tx(tx);
> > -	}
> > +	async_tx_quiesce(&tx);
> >  }
> > =20
>=20
> Yes, this one, handles it like the other cases of needing to do a
> synchronous wait and does not care if tx is NULL.

Thanks.  Following is now in my for-next branch.

NeilBrown

=46rom e25a8de38d6584ffd042dbef3a5a8eb518b8813b Mon Sep 17 00:00:00 2001
From: NeilBrown <neilb@suse.de>
Date: Tue, 20 Nov 2012 14:11:15 +1100
Subject: [PATCH] md/raid5: use async_tx_quiesce() instead of open-coding it.

handle_stripe_expansion contains:

        if (tx) {
                async_tx_ack(tx);
                dma_wait_for_async_tx(tx);
        }

which is very similar to the body of async_tx_quiesce(),
except that the later handles an error from dma_wait_for_async_tx()
(admittedly by panicing, but that decision belongs in the dma
code, not the md code).

So just us async_tx_quiesce().

Acked-by: Dan Williams <djbw@fb.com>
Reported-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index ac09fa4..e51d903 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3266,10 +3266,7 @@ static void handle_stripe_expansion(struct r5conf *c=
onf, struct stripe_head *sh)
=20
 		}
 	/* done submitting copies, wait for them to complete */
-	if (tx) {
-		async_tx_ack(tx);
-		dma_wait_for_async_tx(tx);
-	}
+	async_tx_quiesce(&tx);
 }
=20
 /*

--Sig_/rXxlZqsWNV_cmKZw6uY4cra
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUKr1Zznsnt1WYoG5AQJ1JBAAkv6R4RJCuBeN9Z7LFDWmRkVmAskiMgVO
VK7AEuV/wdUUSwjHM4uoQ3fdZIlnb8RD/rJ4bKhWhZGrj2sXjNwi3AI6LNaM0VML
pV61UDPMDCjoP8lWKJEFVGrLyCimde5VjsztMSWmllZ5msulEh0Tb2dX5Vr6quUF
mMD5OOFpK3xBgeETpgltp3Obtd3cBWJHI8fwvD+fc3O4fm/Wm1BXAzRbJK0YNFq6
o8zGQ6u+pUySPAnPrYj6R2P9tZTPTYR838zv4WS4/Wk1jc0Tke+199xuHdHeiSO/
uyYFoUhWZU2ArCLGm9KZRM9K9nZfP0WgY1JDRbTGXsaeyd6LKmHvT/ri4HL/gjgt
htUlHisREtqgWNJco87OHuszSQ7Sen359XrtpV81tqml7hCCd91rs005IV4meyow
wmeRAeGuo9GZvIxnW67t89WNt/IxLY8aLz1IMvQkYhGLrySxvIe9fnuJggFXyhTf
RmF2O7IbH8FvTk5XyrQWhTlngtQg6fZbVLHDkGIE/iN7vybY6RcRq8Dxbe5gT/f1
7O2bHCfipphMJ551Jde/C8HM32JPUtPoIlCnItxvgahQ66HJB7W6MnALxwh8rbkf
Xx0pl1fVFulZ5tjNDxhVnavO2P85FleZ57GJ8mwKKgRAdSLlJTB3XmDG1gRxEDLt
hSOkkfE25b4=
=a17B
-----END PGP SIGNATURE-----

--Sig_/rXxlZqsWNV_cmKZw6uY4cra--
