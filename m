Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756136Ab2EBG0g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 02:26:36 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55553 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751614Ab2EBG0e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 02:26:34 -0400
Date: Wed, 2 May 2012 16:26:27 +1000
From: NeilBrown <neilb@suse.de>
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] w1: Introduce a slave mutex for serializing IO.
Message-ID: <20120502162627.50544c8b@notabene.brown>
In-Reply-To: <20120501213958.GA15560@ioremap.net>
References: <20120425124914.3187a794@notabene.brown>
	<20120501213958.GA15560@ioremap.net>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/I61CQDpV3LR+PK3zAoToZ+Y"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/I61CQDpV3LR+PK3zAoToZ+Y
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 2 May 2012 01:39:58 +0400 Evgeniy Polyakov <zbr@ioremap.net> wrote:

> On Wed, Apr 25, 2012 at 12:49:14PM +1000, NeilBrown (neilb@suse.de) wrote:
> > w1 devices need a mutex to serial IO.
> > Most use master->mutex.
> >=20
> > However that is used for other purposes and they can conflict.
> >=20
> > In particular master->mutex is held while w1_attach_slave_device is
> > called.
> >=20
> > For bq27000, this registers a 'powersupply' device which tries to
> > read the current status.  The attempt to read will cause a deadlock on
> > master->mutex.
> >=20
> > So create a new per-slave mutex and use that for serializing IO for
> > bq27000.
>=20
> How will this protect against master doing search for example?
> It performs a number of read/write operations which are not allowed to
> be interrupted by outside read.
>=20

Yes, you are right.  That was broken, I see it now.

Take takes me back to the deadlock.
To be precise:
  while scanning the w1 bus - with master->mutex held - w1_attach_slave_dev=
ice
  eventually calls into bq27000_battery_probe  which calls
    power_supply_register -> device_add -> kobject_uevent_env

  and the to get all the data for the uevent, power_supply_uevent calls
  the get_property callback which tries to read from the w1 bus and so
  needs the master->mutex.  Which is held.  Deadlock.

So options seems to be:
 - drop the lock while attaching slave devices
 - create a list of slave devices, then attach them after the bus scan has
   finished.
 - have device_add run the kobject_uevent in a separate task (work_queue)
 - or maybe the following which feels ugly but is easy.  Mark the bq27000 as
   not ready until after the power_supply_register, and if get_property is=
=20
   called before the device is ready, return ENODATA.
   Simple and works.  Maybe horrible.
   power_supply_register will have scheduled a power_supply_changed() which
   will poll

Thoughts?

Thanks,
NeilBrown


diff --git a/drivers/power/bq27x00_battery.c b/drivers/power/bq27x00_batter=
y.c
index 298de4b..bd89494 100644
--- a/drivers/power/bq27x00_battery.c
+++ b/drivers/power/bq27x00_battery.c
@@ -107,6 +107,7 @@ struct bq27x00_device_info {
=20
 	struct bq27x00_access_methods bus;
=20
+	int ready;
 	struct mutex lock;
 };
=20
@@ -500,6 +501,8 @@ static int bq27x00_battery_get_property(struct power_su=
pply *psy,
 	int ret =3D 0;
 	struct bq27x00_device_info *di =3D to_bq27x00_device_info(psy);
=20
+	if (!di->ready)
+		return -ENODATA;
 	mutex_lock(&di->lock);
 	if (time_is_before_jiffies(di->last_update + 5 * HZ)) {
 		cancel_delayed_work_sync(&di->work);
@@ -583,6 +586,7 @@ static int bq27x00_powersupply_init(struct bq27x00_devi=
ce_info *di)
 	di->bat.num_properties =3D ARRAY_SIZE(bq27x00_battery_props);
 	di->bat.get_property =3D bq27x00_battery_get_property;
 	di->bat.external_power_changed =3D bq27x00_external_power_changed;
+	di->ready =3D 0;
=20
 	INIT_DELAYED_WORK(&di->work, bq27x00_battery_poll);
 	mutex_init(&di->lock);
@@ -592,10 +596,12 @@ static int bq27x00_powersupply_init(struct bq27x00_de=
vice_info *di)
 		dev_err(di->dev, "failed to register battery: %d\n", ret);
 		return ret;
 	}
+	di->ready =3D 1;
=20
 	dev_info(di->dev, "support ver. %s enabled\n", DRIVER_VERSION);
=20
-	bq27x00_update(di);
+	di->last_update =3D jiffies - 10*HZ;
+	schedule_delayed_work(&di->work, 1);
=20
 	return 0;
 }

--Sig_/I61CQDpV3LR+PK3zAoToZ+Y
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT6DTkznsnt1WYoG5AQK3og//bCjoxr1ieGs2W1MUIXKLLA0xEuqC1JQ+
7319c6GIRN3dn0IhKs5YJYP1q44sI17ZxZOutQuafKtqJ/6glZibCtgdUfjXgbci
PN6qv6i+W0upGs6ax48ecOz/JU0xIKGEp2CysK0rJ/kWuKyhCQ1nEIt2YeCatNyE
NxeQvUAh5aszKL4KtV//ksUBezAFW9xIPwre0EefleBtxpcjVu18htbGDDOgEd0l
o9MVPZx/pVwsNKpFVAEG1GE8REPL9lXAKI93rsBlNRRRD3Y3rK3+7Ubrw+vKh4uh
84eP5NXtMWR12Ce4Y+ox2CW/hZd0oGCdcywi76Kl9NYeWqYsvbGY1F0B0aHgo99W
033pXdO8PeJOkMay3bo+IM37c6/xk/2oPJEc23y1WSIqd2xFLfSuiV5e1SaI952h
gq39NMB5AIlwngyikl316jELShgUjOXKEzvK+VGqhlLGvQCHKCoNjBHBsjnAM0lu
hLUlXe45OWnEGlDqdQVkRNjwKPrRhOL4ynoAZYk68ysqc/BQpe8HZw31AcU/o6Zi
z1vum0ZwSFoTFpQcLClWmmc324EUPjItKlhYsFxSICi6+WDHHb5KB+5gwjoWQUYj
d+TI/lVEYLaV1p7yi3tJqlYWlmmwZWfG0m29ipMRP1EVHJXzMDUDfe5erjVbl0QG
KsKcmOYfZ28=
=Iolu
-----END PGP SIGNATURE-----

--Sig_/I61CQDpV3LR+PK3zAoToZ+Y--
