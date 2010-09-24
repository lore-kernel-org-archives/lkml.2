Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753491Ab0IXFDp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 01:03:45 -0400
Received: from ozlabs.org ([203.10.76.45]:51771 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751530Ab0IXFDo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 01:03:44 -0400
Subject: Re: [PATCH] irqbalance, powerpc: add IRQs without settable SMP
 affinity to banned list
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Neil Horman <nhorman@tuxdriver.com>
Cc: Michael Neuling <mikey@neuling.org>, Neil Horman <nhorman@gmail.com>,
        linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
        Arjen Van De Ven <arjanvandeven@gmail.com>, arjan@linux.intel.com
In-Reply-To: <20100923131302.GA6560@shamino.rdu.redhat.com>
References: <12972.1285135457@neuling.org>
	 <1285230159.30617.2.camel@concordia> <1243.1285239440@neuling.org>
	 <20100923131302.GA6560@shamino.rdu.redhat.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-ztpOUwOzJOa/P5pdfilH"
Date: Fri, 24 Sep 2010 15:03:42 +1000
Message-ID: <1285304622.7637.55.camel@concordia>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-ztpOUwOzJOa/P5pdfilH
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2010-09-23 at 09:13 -0400, Neil Horman wrote:
> On Thu, Sep 23, 2010 at 08:57:20PM +1000, Michael Neuling wrote:
> >=20
> > > > +		if (fwrite(line, strlen(line) - 1, 1, file) =3D=3D 0)
> > >=20
> > > if (fputs(line, file) =3D=3D EOF)
> >=20
> > Good point thanks... new patch below
> >=20
> > Mikey
> >=20
> > irqbalance, powerpc: add IRQs without settable SMP affinity to banned l=
ist
> >=20
> > On pseries powerpc, IPIs are registered with an IRQ number so
> > /proc/interrupts looks like this on a 2 core/2 thread machine:
> >=20
> >            CPU0       CPU1       CPU2       CPU3
> >  16:    3164282    3290514    1138794     983121   XICS             Lev=
el        IPI
> >  18:    2605674          0     304994          0   XICS             Lev=
el        lan0
> >  30:     400057          0     169209          0   XICS             Lev=
el        ibmvscsi
> > LOC:     133734      77250     106425      91951   Local timer interrup=
ts
> > SPU:          0          0          0          0   Spurious interrupts
> > CNT:          0          0          0          0   Performance monitori=
ng interrupts
> > MCE:          0          0          0          0   Machine check except=
ions
> >=20
> > Unfortunately this means irqbalance attempts to set the affinity of IPI=
s
> > which is not possible.  So in the above case, when irqbalance is in
> > performance mode due to heavy IPI, lan0 and ibmvscsi activity, it
> > sometimes attempts to put the IPIs on one core (CPU0&1) and lan0 and
> > ibmvscsi on the other core (CPU2&3).  This is suboptimal as we want lan=
0
> > and ibmvscsi to be on separate cores and IPIs to be ignored.
> >=20
> > When irqblance attempts writes to the IPI smp_affinity (ie.
> > /proc/irq/16/smp_affinity in the above example) it fails but irqbalance
> > ignores currently ignores this.
> >=20
> > This patch catches these write fails and in this case adds that IRQ
> > number to the banned IRQ list.  This will catch the above IPI case and
> > any other IRQ where the SMP affinity can't be set.
> >=20
> > Tested on POWER6, POWER7 and x86.
> >=20
> > Signed-off-by: Michael Neuling <mikey@neuling.org>
> >=20
> > Index: irqbalance/irqlist.c
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > --- irqbalance.orig/irqlist.c
> > +++ irqbalance/irqlist.c
> > @@ -67,7 +67,7 @@
> >  	DIR *dir;
> >  	struct dirent *entry;
> >  	char *c, *c2;
> > -	int nr , count =3D 0;
> > +	int nr , count =3D 0, can_set =3D 1;
> >  	char buf[PATH_MAX];
> >  	sprintf(buf, "/proc/irq/%i", number);
> >  	dir =3D opendir(buf);
> > @@ -80,7 +80,7 @@
> >  			size_t size =3D 0;
> >  			FILE *file;
> >  			sprintf(buf, "/proc/irq/%i/smp_affinity", number);
> > -			file =3D fopen(buf, "r");
> > +			file =3D fopen(buf, "r+");
> >  			if (!file)
> >  				continue;
> >  			if (getline(&line, &size, file)=3D=3D0) {
> > @@ -89,7 +89,14 @@
> >  				continue;
> >  			}
> >  			cpumask_parse_user(line, strlen(line), irq->mask);
> > -			fclose(file);
> > +			/*
> > +			 * Check that we can write the affinity, if
> > +			 * not take it out of the list.
> > +			 */
> > +			if (fputs(line, file) =3D=3D EOF)
> > +				can_set =3D 0;

> This is maybe a nit, but writing to the affinity file can fail for a few
> different reasons, some of them permanent, some transient.  For instance,=
 if
> we're in a memory constrained condition temporarily irq_affinity_proc_wri=
te
> might return -ENOMEM. =20

Yeah true, usually followed shortly by your kernel going so far into
swap you never get it back, or OOMing, but I guess it's possible.

> Might it be better to modify this code so that, instead
> of using fputs to merge the various errors into an EOF, we use some other=
 write
> method that lets us better determine the error and selectively ban the in=
terrupt
> only for those errors which we consider permanent?

Yep. It seems fputs() gives you know way to get the actual error from
write(), so it looks we'll need to switch to open/write, but that's
probably not so terrible.

cheers


--=-ztpOUwOzJOa/P5pdfilH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkycMSsACgkQdSjSd0sB4dJCYACgvkE4OQ2GAwqNKiw1A7yZomWv
D1QAn1mWi97tUcjZBPLkROx6SPzVgNSE
=kBif
-----END PGP SIGNATURE-----

--=-ztpOUwOzJOa/P5pdfilH--

