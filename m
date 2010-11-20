Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754936Ab0KTVdj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Nov 2010 16:33:39 -0500
Received: from gate.lvk.cs.msu.su ([158.250.17.1]:59371 "EHLO
	mail.lvk.cs.msu.su" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753009Ab0KTVdi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Nov 2010 16:33:38 -0500
X-Spam-ASN: 
Date: Sun, 21 Nov 2010 00:33:23 +0300
From: Alexander Gordeev <lasaine@lvk.cs.msu.su>
To: Rodolfo Giometti <giometti@enneenne.com>
Cc: linux-kernel@vger.kernel.org, "Nikita V. Youshchenko" <yoush@cs.msu.su>,
        linuxpps@ml.enneenne.com, Andrew Morton <akpm@linux-foundation.org>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [PATCHv4 06/17] pps: convert printk/pr_* to dev_*
Message-ID: <20101121003323.4bbf0199@apollo.gnet>
In-Reply-To: <20101120154940.GY13356@enneenne.com>
References: <cover.1290087473.git.lasaine@lvk.cs.msu.su>
	<ce13c55a2acb39be7ef5667467c765595df19835.1290087479.git.lasaine@lvk.cs.msu.su>
	<20101120154940.GY13356@enneenne.com>
Organization: LVK
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA256;
 boundary="Sig_/WZBE2=ta2+fa2rrSxXhN9MX"; protocol="application/pgp-signature"
X-AV-Checked: ClamAV using ClamSMTP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/WZBE2=ta2+fa2rrSxXhN9MX
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

=D0=92 Sat, 20 Nov 2010 16:49:40 +0100
Rodolfo Giometti <giometti@enneenne.com> =D0=BF=D0=B8=D1=88=D0=B5=D1=82:

> On Thu, Nov 18, 2010 at 07:00:59PM +0300, Alexander Gordeev wrote:
> > Since we now have direct pointers to struct pps_device everywhere it's
> > easy to use dev_* functions to print messages instead of plain printks.
> > Where dev_* cannot be used printks are converted to pr_*.
> >=20
> > Signed-off-by: Alexander Gordeev <lasaine@lvk.cs.msu.su>
> > ---
> >  drivers/pps/clients/pps-ktimer.c |    5 +++--
> >  drivers/pps/clients/pps-ldisc.c  |    2 ++
> >  drivers/pps/kapi.c               |   15 ++++++++-------
> >  drivers/pps/pps.c                |   25 +++++++++++++------------
> >  4 files changed, 26 insertions(+), 21 deletions(-)
> >=20
> > diff --git a/drivers/pps/clients/pps-ktimer.c b/drivers/pps/clients/pps=
-ktimer.c
> > index 966ead1..2728469 100644
> > --- a/drivers/pps/clients/pps-ktimer.c
> > +++ b/drivers/pps/clients/pps-ktimer.c
> > @@ -19,6 +19,7 @@
> >   *   Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
> >   */
> > =20
> > +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
>=20
> Instead of redefining pr_fmt() in each file you may do it once into
> include file pps_kernel.h...

Yes, but then every .c file will have to include linux/pps_kernel.h
before including linux/kernel.h (where pr_* are defined) and only you
and me will know the reason for that. Of course, we can add a comment to
every .c file to discourage others from moving includes but IMHO the
way how it is done in the patch is better. I dislike hidden
dependencies between header files very much.

> >  #include <linux/kernel.h>
> >  #include <linux/module.h>
> > @@ -45,7 +46,7 @@ static void pps_ktimer_event(unsigned long ptr)
> >  	/* First of all we get the time stamp... */
> >  	pps_get_ts(&ts);
> > =20
> > -	pr_info("PPS event at %lu\n", jiffies);
> > +	dev_info(pps->dev, "PPS event at %lu\n", jiffies);
> > =20
> >  	pps_event(pps, &ts, PPS_CAPTUREASSERT, NULL);
> > =20
> > @@ -94,7 +95,7 @@ static int __init pps_ktimer_init(void)
> >  	pps =3D pps_register_source(&pps_ktimer_info,
> >  				PPS_CAPTUREASSERT | PPS_OFFSETASSERT);
> >  	if (pps =3D=3D NULL) {
> > -		printk(KERN_ERR "cannot register ktimer source\n");
> > +		pr_err("cannot register PPS source\n");
> >  		return -ENOMEM;
> >  	}
> > =20
> > diff --git a/drivers/pps/clients/pps-ldisc.c b/drivers/pps/clients/pps-=
ldisc.c
> > index 1950b15..30789fa 100644
> > --- a/drivers/pps/clients/pps-ldisc.c
> > +++ b/drivers/pps/clients/pps-ldisc.c
> > @@ -19,6 +19,8 @@
> >   *   Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
> >   */
> > =20
> > +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> > +
> >  #include <linux/module.h>
> >  #include <linux/serial_core.h>
> >  #include <linux/tty.h>
> > diff --git a/drivers/pps/kapi.c b/drivers/pps/kapi.c
> > index 98d4012..fbb89c6 100644
> > --- a/drivers/pps/kapi.c
> > +++ b/drivers/pps/kapi.c
> > @@ -19,6 +19,7 @@
> >   *   Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
> >   */
> > =20
> > +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> > =20
> >  #include <linux/kernel.h>
> >  #include <linux/module.h>
> > @@ -80,20 +81,20 @@ struct pps_device *pps_register_source(struct pps_s=
ource_info *info,
> > =20
> >  	/* Sanity checks */
> >  	if ((info->mode & default_params) !=3D default_params) {
> > -		printk(KERN_ERR "pps: %s: unsupported default parameters\n",
> > +		pr_err("pps: %s: unsupported default parameters\n",
> >  					info->name);
> >  		err =3D -EINVAL;
> >  		goto pps_register_source_exit;
> >  	}
> >  	if ((info->mode & (PPS_ECHOASSERT | PPS_ECHOCLEAR)) !=3D 0 &&
> >  			info->echo =3D=3D NULL) {
> > -		printk(KERN_ERR "pps: %s: echo function is not defined\n",
> > +		pr_err("pps: %s: echo function is not defined\n",
> >  					info->name);
> >  		err =3D -EINVAL;
> >  		goto pps_register_source_exit;
> >  	}
> >  	if ((info->mode & (PPS_TSFMT_TSPEC | PPS_TSFMT_NTPFP)) =3D=3D 0) {
> > -		printk(KERN_ERR "pps: %s: unspecified time format\n",
> > +		pr_err("pps: %s: unspecified time format\n",
> >  					info->name);
> >  		err =3D -EINVAL;
> >  		goto pps_register_source_exit;
> > @@ -138,7 +139,7 @@ struct pps_device *pps_register_source(struct pps_s=
ource_info *info,
> >  	if (id >=3D PPS_MAX_SOURCES) {
> >  		spin_unlock_irq(&pps_idr_lock);
> > =20
> > -		printk(KERN_ERR "pps: %s: too many PPS sources in the system\n",
> > +		pr_err("pps: %s: too many PPS sources in the system\n",
> >  					info->name);
> >  		err =3D -EBUSY;
> >  		goto free_idr;
> > @@ -150,12 +151,12 @@ struct pps_device *pps_register_source(struct pps=
_source_info *info,
> >  	/* Create the char device */
> >  	err =3D pps_register_cdev(pps);
> >  	if (err < 0) {
> > -		printk(KERN_ERR "pps: %s: unable to create char device\n",
> > +		pr_err("%s: unable to create char device\n",
> >  					info->name);
> >  		goto free_idr;
> >  	}
> > =20
> > -	pr_info("new PPS source %s at ID %d\n", info->name, id);
> > +	dev_info(pps->dev, "new PPS source %s\n", info->name);
> > =20
> >  	return pps;
> > =20
> > @@ -168,7 +169,7 @@ kfree_pps:
> >  	kfree(pps);
> > =20
> >  pps_register_source_exit:
> > -	printk(KERN_ERR "pps: %s: unable to register source\n", info->name);
> > +	pr_err("%s: unable to register source\n", info->name);
> > =20
> >  	return NULL;
> >  }
> > diff --git a/drivers/pps/pps.c b/drivers/pps/pps.c
> > index 1922f27..9f7c2e8 100644
> > --- a/drivers/pps/pps.c
> > +++ b/drivers/pps/pps.c
> > @@ -19,6 +19,7 @@
> >   *   Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
> >   */
> > =20
> > +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> > =20
> >  #include <linux/kernel.h>
> >  #include <linux/module.h>
> > @@ -67,7 +68,7 @@ static long pps_cdev_ioctl(struct file *file,
> > =20
> >  	switch (cmd) {
> >  	case PPS_GETPARAMS:
> > -		pr_debug("PPS_GETPARAMS: source %d\n", pps->id);
> > +		dev_dbg(pps->dev, "PPS_GETPARAMS\n");
> > =20
> >  		spin_lock_irq(&pps->lock);
> > =20
> > @@ -83,7 +84,7 @@ static long pps_cdev_ioctl(struct file *file,
> >  		break;
> > =20
> >  	case PPS_SETPARAMS:
> > -		pr_debug("PPS_SETPARAMS: source %d\n", pps->id);
> > +		dev_dbg(pps->dev, "PPS_SETPARAMS\n");
> > =20
> >  		/* Check the capabilities */
> >  		if (!capable(CAP_SYS_TIME))
> > @@ -93,14 +94,14 @@ static long pps_cdev_ioctl(struct file *file,
> >  		if (err)
> >  			return -EFAULT;
> >  		if (!(params.mode & (PPS_CAPTUREASSERT | PPS_CAPTURECLEAR))) {
> > -			pr_debug("capture mode unspecified (%x)\n",
> > +			dev_dbg(pps->dev, "capture mode unspecified (%x)\n",
> >  								params.mode);
> >  			return -EINVAL;
> >  		}
> > =20
> >  		/* Check for supported capabilities */
> >  		if ((params.mode & ~pps->info.mode) !=3D 0) {
> > -			pr_debug("unsupported capabilities (%x)\n",
> > +			dev_dbg(pps->dev, "unsupported capabilities (%x)\n",
> >  								params.mode);
> >  			return -EINVAL;
> >  		}
> > @@ -113,7 +114,7 @@ static long pps_cdev_ioctl(struct file *file,
> >  		/* Restore the read only parameters */
> >  		if ((params.mode & (PPS_TSFMT_TSPEC | PPS_TSFMT_NTPFP)) =3D=3D 0) {
> >  			/* section 3.3 of RFC 2783 interpreted */
> > -			pr_debug("time format unspecified (%x)\n",
> > +			dev_dbg(pps->dev, "time format unspecified (%x)\n",
> >  								params.mode);
> >  			pps->params.mode |=3D PPS_TSFMT_TSPEC;
> >  		}
> > @@ -126,7 +127,7 @@ static long pps_cdev_ioctl(struct file *file,
> >  		break;
> > =20
> >  	case PPS_GETCAP:
> > -		pr_debug("PPS_GETCAP: source %d\n", pps->id);
> > +		dev_dbg(pps->dev, "PPS_GETCAP\n");
> > =20
> >  		err =3D put_user(pps->info.mode, iuarg);
> >  		if (err)
> > @@ -138,7 +139,7 @@ static long pps_cdev_ioctl(struct file *file,
> >  		struct pps_fdata fdata;
> >  		unsigned int ev;
> > =20
> > -		pr_debug("PPS_FETCH: source %d\n", pps->id);
> > +		dev_dbg(pps->dev, "PPS_FETCH\n");
> > =20
> >  		err =3D copy_from_user(&fdata, uarg, sizeof(struct pps_fdata));
> >  		if (err)
> > @@ -153,7 +154,7 @@ static long pps_cdev_ioctl(struct file *file,
> >  		else {
> >  			unsigned long ticks;
> > =20
> > -			pr_debug("timeout %lld.%09d\n",
> > +			dev_dbg(pps->dev, "timeout %lld.%09d\n",
> >  					(long long) fdata.timeout.sec,
> >  					fdata.timeout.nsec);
> >  			ticks =3D fdata.timeout.sec * HZ;
> > @@ -171,7 +172,7 @@ static long pps_cdev_ioctl(struct file *file,
> > =20
> >  		/* Check for pending signals */
> >  		if (err =3D=3D -ERESTARTSYS) {
> > -			pr_debug("pending signal caught\n");
> > +			dev_dbg(pps->dev, "pending signal caught\n");
> >  			return -EINTR;
> >  		}
> > =20
> > @@ -240,7 +241,7 @@ int pps_register_cdev(struct pps_device *pps)
> > =20
> >  	err =3D cdev_add(&pps->cdev, devt, 1);
> >  	if (err) {
> > -		printk(KERN_ERR "pps: %s: failed to add char device %d:%d\n",
> > +		pr_err("%s: failed to add char device %d:%d\n",
> >  				pps->info.name, MAJOR(pps_devt), pps->id);
> >  		return err;
> >  	}
> > @@ -282,14 +283,14 @@ static int __init pps_init(void)
> > =20
> >  	pps_class =3D class_create(THIS_MODULE, "pps");
> >  	if (!pps_class) {
> > -		printk(KERN_ERR "pps: failed to allocate class\n");
> > +		pr_err("failed to allocate class\n");
> >  		return -ENOMEM;
> >  	}
> >  	pps_class->dev_attrs =3D pps_attrs;
> > =20
> >  	err =3D alloc_chrdev_region(&pps_devt, 0, PPS_MAX_SOURCES, "pps");
> >  	if (err < 0) {
> > -		printk(KERN_ERR "pps: failed to allocate char device region\n");
> > +		pr_err("failed to allocate char device region\n");
> >  		goto remove_class;
> >  	}
> > =20
> > --=20
> > 1.7.2.3
> >=20
>=20
> Acked-by: Rodolfo Giometti <giometti@linux.it>
>=20


--=20
  Alexander

--Sig_/WZBE2=ta2+fa2rrSxXhN9MX
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBCAAGBQJM6D6jAAoJEElrwznyooJbNqoH/AzUPr5YWN9ApC9AvuTNwwxt
X/N5XWjUo+VOl35Qf88tshjLqVkWs7hffcYwEuJ/Cr9BfF6MjmwseL/jpi7ocLJs
veFvSRR4CRg2IIABlnAKeI1pIQlfLpBDDTv/m/gs/Bu91HPQZ87RzUhgeTmpfbl/
UYK8Gd+B9hf1KJyQvoUidBP0NxR1YDhjhT5fvhec0GPogJwraz09DCV01fjtnOMn
3HPJzhmo/wEYduujFtq7nP/sjyGO2nR8e+I8NFaYoZ0I+QmUYmB+HweWCMjwfBfb
kn7n9nSGBdmN9RMxy3uPhQMtlgtL0tf5srVDHSeqggi4Elnn5m0gc15A+OubkOk=
=xkqm
-----END PGP SIGNATURE-----

--Sig_/WZBE2=ta2+fa2rrSxXhN9MX--
