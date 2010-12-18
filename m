Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756710Ab0LRAvK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 19:51:10 -0500
Received: from gate.lvk.cs.msu.su ([158.250.17.1]:32779 "EHLO
	mail.lvk.cs.msu.su" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756221Ab0LRAvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 19:51:07 -0500
X-Spam-ASN: 
Date: Sat, 18 Dec 2010 03:50:54 +0300
From: Alexander Gordeev <lasaine@lvk.cs.msu.su>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "Nikita V\. Youshchenko" <yoush@cs.msu.su>,
        linuxpps@ml.enneenne.com, Rodolfo Giometti <giometti@enneenne.com>
Subject: Re: [PATCHv6 15/16] pps: add parallel port PPS client
Message-ID: <20101218035054.2aaac64b@apollo.gnet>
In-Reply-To: <20101217161756.664b8d8b.akpm@linux-foundation.org>
References: <cover.1292604060.git.lasaine@lvk.cs.msu.su>
	<5aad62a4e5290f8baa5994b227e7fe6edaa7841a.1292604060.git.lasaine@lvk.cs.msu.su>
	<20101217161756.664b8d8b.akpm@linux-foundation.org>
Organization: LVK
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA256;
 boundary="Sig_/6nRZzEoBSTcbYJmRySLiGtu"; protocol="application/pgp-signature"
X-AV-Checked: ClamAV using ClamSMTP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/6nRZzEoBSTcbYJmRySLiGtu
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

=D0=92 Fri, 17 Dec 2010 16:17:56 -0800
Andrew Morton <akpm@linux-foundation.org> =D0=BF=D0=B8=D1=88=D0=B5=D1=82:

> On Fri, 17 Dec 2010 22:54:39 +0300
> Alexander Gordeev <lasaine@lvk.cs.msu.su> wrote:
>=20
> > Add parallel port PPS client. It uses a standard method for capturing
> > timestamps for assert edge transitions: getting a timestamp soon after
> > an interrupt has happened. This is not a very precise source of time
> > information due to interrupt handling delays. However, timestamps for
> > clear edge transitions are much more precise because the interrupt
> > handler continuously polls hardware port until the transition is done.
> > Hardware port operations require only about 1us so the maximum error
> > should not exceed this value. This was my primary goal when developing
> > this client.
> > Clear edge capture could be disabled using clear_wait parameter.
> >=20
> > ...
> >
> > +/* parport interrupt handler */
> > +static void parport_irq(void *handle)
> > +{
> > +	struct pps_event_time ts_assert, ts_clear;
> > +	struct pps_client_pp *dev =3D handle;
> > +	struct parport *port =3D dev->pardev->port;
> > +	unsigned int i;
> > +	unsigned long flags;
> > +
> > +	/* first of all we get the time stamp... */
> > +	pps_get_ts(&ts_assert);
> > +
> > +	if (dev->cw =3D=3D 0)
> > +		/* clear edge capture disabled */
> > +		goto out_assert;
> > +
> > +	/* try capture the clear edge */
> > +	local_irq_save(flags);
> > +	/* check the signal (no signal means the pulse is lost this time) */
> > +	if (!signal_is_set(port)) {
> > +		local_irq_restore(flags);
> > +		dev_err(dev->pps->dev, "lost the signal\n");
> > +		goto out_assert;
> > +	}
> > +
> > +	/* poll the port until the signal is unset */
> > +	for (i =3D dev->cw; i; i--)
> > +		if (!signal_is_set(port)) {
> > +			pps_get_ts(&ts_clear);
> > +			local_irq_restore(flags);
> > +			dev->cw_err =3D 0;
> > +			goto out_both;
> > +		}
> > +	local_irq_restore(flags);
>=20
> Why is this function paying around with local_irq_save()?  It's unusual
> and looks buggy because local_irq_save() doesn't stop other CPUs from
> taking an interrupt and coming in and playing with the "protected" data.

The idea is to prevent other interrupts on the same processor to
introduce uncontrolled time lags here. Reading from IO port is known to
take approximately 1us while other interrupt handlers can probably take
much more. So I poll the port with locally disabled interrupts to
ensure that the maximum lag here is 1us. All my experiments show that
it is in fact very precise this way given that input signal is precise.

> I have a feeling I asked this before, but you didn't add a comment
> explaining it, so I went and asked it again!  Cause, effect.

No, you didn't ask this before, I think.

> > +static void parport_attach(struct parport *port)
> > +{
> > +	struct pps_client_pp *device;
> > +	struct pps_source_info info =3D {
> > +		.name		=3D KBUILD_MODNAME,
> > +		.path		=3D "",
> > +		.mode		=3D PPS_CAPTUREBOTH | \
> > +				  PPS_OFFSETASSERT | PPS_OFFSETCLEAR | \
> > +				  PPS_ECHOASSERT | PPS_ECHOCLEAR | \
> > +				  PPS_CANWAIT | PPS_TSFMT_TSPEC,
> > +		.echo		=3D pps_echo,
> > +		.owner		=3D THIS_MODULE,
> > +		.dev		=3D NULL
> > +	};
> > +
> > +	device =3D kzalloc(sizeof(struct pps_client_pp), GFP_KERNEL);
> > +	if (!device) {
> > +		pr_err("memory allocation failed, not attaching\n");
> > +		return;
>=20
> And the void-returning parport_driver.attach() still sucks.

Hmm. Do you want me to rewrite the parport subsystem? There are lots of
problems in it now:
 * not part of LDM
 * controlled through /proc
 * detach is called for every port, not only the on being attached to
 * ...

Sure, I think it should be rewritten quite a bit but I cannot do that
right now, sorry.

> > +	}
> > +
> > +	device->pardev =3D parport_register_device(port, KBUILD_MODNAME,
> > +			NULL, NULL, parport_irq, 0, device);
> > +	if (!device->pardev) {
> > +		pr_err("couldn't register with %s\n", port->name);
> > +		goto err_free;
> > +	}
> > +
> > +	if (parport_claim_or_block(device->pardev) < 0) {
> > +		pr_err("couldn't claim %s\n", port->name);
> > +		goto err_unregister_dev;
> > +	}
> > +
> > +	device->pps =3D pps_register_source(&info,
> > +			PPS_CAPTUREBOTH | PPS_OFFSETASSERT | PPS_OFFSETCLEAR);
> > +	if (device->pps =3D=3D NULL) {
> > +		pr_err("couldn't register PPS source\n");
> > +		goto err_release_dev;
> > +	}
> > +
> > +	device->cw =3D clear_wait;
> > +
> > +	port->ops->enable_irq(port);
> > +
> > +	pr_info("attached to %s\n", port->name);
> > +
> > +	return;
> > +
> > +err_release_dev:
> > +	parport_release(device->pardev);
> > +err_unregister_dev:
> > +	parport_unregister_device(device->pardev);
> > +err_free:
> > +	kfree(device);
> > +}
> > +
>=20


--=20
  Alexander

--Sig_/6nRZzEoBSTcbYJmRySLiGtu
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBCAAGBQJNDAVuAAoJEElrwznyooJbF7MH/jR9vDT03ZATjH9zWpIIu3VU
t3IBMgxInMxNxpqw6KXey2BJGqrmlzSm56TA4werQ0hHBN7NQ5LoXaTPQ756BcWr
ojSB8I937l46AGMthhd+ZDE8WArx7G/uNPFGw0RGjJdqLUwU7JqmoJrujY/MI+1t
LZnEhhg6rElcYHDWLRBX6T2MZcOhflVIYaRFvlsY9T2EBITRY76yQTfk/iPXKYQb
aWXzOrq30HQDVxvhAAwimTL9fm4SaaqqkUwcTcD83Rl5r15mmUugiwwuHb9HCgzz
m00FzAd/1n3OGru6UuMjwk0MUuIRMgCm6kRn2Oh6dqSlqmYyOCMHyIQkmunfZHU=
=lM2b
-----END PGP SIGNATURE-----

--Sig_/6nRZzEoBSTcbYJmRySLiGtu--
