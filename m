Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753314Ab1JJKFS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 06:05:18 -0400
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:38898 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753097Ab1JJKFP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 06:05:15 -0400
Date: Mon, 10 Oct 2011 13:05:09 +0300
From: Felipe Balbi <balbi@ti.com>
To: Felipe Balbi <balbi@ti.com>
Cc: "Munegowda, Keshava" <keshava_mgowda@ti.com>,
        Paul Walmsley <paul@pwsan.com>, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        khilman@ti.com, b-cousson@ti.com, gadiyar@ti.com,
        sameo@linux.intel.com, parthab@india.ti.com, tony@atomide.com,
        johnstul@us.ibm.com, vishwanath.bs@ti.com, Greg KH <greg@kroah.com>
Subject: Re: [PATCH 1/5 v13] arm: omap: usb: ehci and ohci hwmod structures
 for omap4
Message-ID: <20111010100507.GG6685@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1317901099-2519-1-git-send-email-keshava_mgowda@ti.com>
 <alpine.DEB.2.00.1110070305040.4611@utopia.booyaka.com>
 <CAP05o4J39MotDTOv-O2ahvWfxL-7jC-L3FGsNXbmDy8HNg=W3g@mail.gmail.com>
 <alpine.DEB.2.00.1110070330220.4611@utopia.booyaka.com>
 <CAP05o4KLAnNHcvNbNWqJFN710JMNAy2emYzCt2xHF+m-Kvwveg@mail.gmail.com>
 <CAP05o4+ybhZwRaXZPgS-ZdTL_0gjz1VLf6LuUtMgm_txNPwrnw@mail.gmail.com>
 <20111010090330.GE6685@legolas.emea.dhcp.ti.com>
 <CAP05o4Kqrsr3Kzm=NDpEB7wHACzXkp2mQLuWdUAsZ8pVPdJafA@mail.gmail.com>
 <20111010092613.GF6685@legolas.emea.dhcp.ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gvF4niNJ+uBMJnEh"
Content-Disposition: inline
In-Reply-To: <20111010092613.GF6685@legolas.emea.dhcp.ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gvF4niNJ+uBMJnEh
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 10, 2011 at 12:26:15PM +0300, Felipe Balbi wrote:
> On Mon, Oct 10, 2011 at 02:47:42PM +0530, Munegowda, Keshava wrote:
> > On Mon, Oct 10, 2011 at 2:33 PM, Felipe Balbi <balbi@ti.com> wrote:
> > > Hi,
> > >
> > > On Mon, Oct 10, 2011 at 02:22:23PM +0530, Munegowda, Keshava wrote:
> > >> Hi paul and Felipe
> > >>
> > >> Here is the highlights of the change in the design of =A0USB Host wh=
ich
> > >> we can do after kernel 3.2 release;
> > >>
> > >> 1. separate the TLL changes =A0from UHH
> > >> 2. The TLL is be a new platform driver in ./drivers/mfd
> > >> 3. the TLL platform driver will export apis =A0for enable/disable cl=
ocks
> > >> and settings.
> > >
> > > TLL should control its clocks through pm_runtime APIs like anything
> > > else. If you really must export APIs to be used by UHH, you need to h=
ave
> > > an API so that you can claim/release a TLL channel and get/put for
> > > increasing/decreasing PM counters.
> > >
> > > I still think though, you should try to avoid exporting OMAP-specific
> > > APIs all over the place. Ideally, we would be able to have some way of
> > > saying that UHH and TLL are closely related... something like having =
the
> > > ability to say e.g. two devices are sibblings of each other, so that =
we
> > > could ask for a sibbling to wakeup/sleep depending if we need it or n=
ot.
> >=20
> > do we have sibling structures today? I dont think so.
>=20
> no we don't.

Ok, here's a first shot at it:

=46rom 600ae62f4b4a832d90a83d43227deb6f84b9def1 Mon Sep 17 00:00:00 2001
=46rom: Felipe Balbi <balbi@ti.com>
Date: Mon, 10 Oct 2011 12:56:34 +0300
Subject: [RFC/NOT-FOR-MERGING/PATCH] base: add the idea of sibling devices
Organization: Texas Instruments\n

It's possible that some devices, which share a
common parent, need to talk to each due to a
very close relationship between them.

Generally, one device will provide some sort of
resources to the other (e.g. clocks) while still
both sharing another common parent.

In such cases, it seems necessary to define those
two devices as siblings, rather than a virtual
parent relationship, and have means for one device
to ask the sibling device to e.g. turn on its clocks.

Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 drivers/base/core.c    |   41 +++++++++++++++++++++++++++++++++++++++++
 include/linux/device.h |    7 +++++++
 2 files changed, 48 insertions(+), 0 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index bc8729d..3b7f2e5 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -589,6 +589,7 @@ void device_initialize(struct device *dev)
 	dev->kobj.kset =3D devices_kset;
 	kobject_init(&dev->kobj, &device_ktype);
 	INIT_LIST_HEAD(&dev->dma_pools);
+	INIT_LIST_HEAD(&dev->siblings);
 	mutex_init(&dev->mutex);
 	lockdep_set_novalidate_class(&dev->mutex);
 	spin_lock_init(&dev->devres_lock);
@@ -889,6 +890,7 @@ int device_private_init(struct device *dev)
  */
 int device_add(struct device *dev)
 {
+	struct device *sibling, *n;
 	struct device *parent =3D NULL;
 	struct class_interface *class_intf;
 	int error =3D -EINVAL;
@@ -923,6 +925,10 @@ int device_add(struct device *dev)
 	parent =3D get_device(dev->parent);
 	setup_parent(dev, parent);
=20
+	/* setup siblings */
+	list_for_each_entry_safe(sibling, n, &dev->siblings, sibling_node)
+		get_device(sibling);
+
 	/* use parent numa_node */
 	if (parent)
 		set_dev_node(dev, dev_to_node(parent));
@@ -1071,6 +1077,31 @@ void put_device(struct device *dev)
 }
=20
 /**
+ * get_sibling_device_byname - finds a sibling device by its name
+ * @dev: device.
+ * @name: name for the sibling to find.
+ *
+ * This is here to help drivers which need to ask their siblings
+ * for something in particular (like ask sibling to turn clocks on)
+ * achieve that by first finding the correct device pointer for
+ * that sibling.
+ */
+struct device *get_sibling_device_byname(struct device *dev, const char *n=
ame)
+{
+	struct device	*sibling, *n;
+	struct device	*found =3D NULL;
+
+	list_for_each_entry_safe(sibling, n, &dev->siblings, sibling_node) {
+		if (!strcmp(dev_name(sibling), name))
+			found =3D sibling;
+			goto found;
+	}
+
+found:
+	return found;
+}
+
+/**
  * device_del - delete device from system.
  * @dev: device.
  *
@@ -1085,6 +1116,7 @@ void put_device(struct device *dev)
  */
 void device_del(struct device *dev)
 {
+	struct device *sibling, *n;
 	struct device *parent =3D dev->parent;
 	struct class_interface *class_intf;
=20
@@ -1120,6 +1152,15 @@ void device_del(struct device *dev)
 	device_remove_attrs(dev);
 	bus_remove_device(dev);
=20
+	/* teardown siblings */
+	list_for_each_entry_safe(sibling, n, &dev->siblings, sibling_node) {
+		/* siblings must have  the same parent */
+		WARN(sibling->parent !=3D parent,
+				"siblings must have a common parent\n");
+
+		get_device(sibling);
+	}
+
 	/*
 	 * Some platform devices are driven without driver attached
 	 * and managed resources may have been acquired.  Make sure
diff --git a/include/linux/device.h b/include/linux/device.h
index c20dfbf..ae9cec9 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -551,6 +551,9 @@ struct device_dma_parameters {
 struct device {
 	struct device		*parent;
=20
+	struct list_head	sibling_node;
+	struct list_head	siblings;
+
 	struct device_private	*p;
=20
 	struct kobject kobj;
@@ -764,6 +767,10 @@ extern int (*platform_notify_remove)(struct device *de=
v);
 extern struct device *get_device(struct device *dev);
 extern void put_device(struct device *dev);
=20
+/* finds a sibling struct device pointer */
+extern struct device *get_sibling_device_byname(struct device *dev,
+		const char *name);
+
 extern void wait_for_device_probe(void);
=20
 #ifdef CONFIG_DEVTMPFS
--=20
1.7.6.396.ge0613

one way to use this would be to mark both hwmods has having the same
parent and pointing to each other as siblings. Then, from UHH you could:

if (port->mode =3D=3D TLL) {
	tll =3D get_sibling_device_by_name(dev, "usbtll");
	if (!tll)
		error();

	pm_runtime_get_sync(tll);
}

or something similar. As of now, I'm not so sure this is a very good
idea, but decided to gather some comments anyway.

Does anybody see any change of this getting used in more cases ? Greg,
I'm adding you to this thread, if you have any comments to this, I'd
like to hear them.

--=20
balbi

--gvF4niNJ+uBMJnEh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJOksNTAAoJEIaOsuA1yqREnT8P/3p22Ce0NqIyL/Zcx5J4dX6Y
3rtgm4gbaLtAqje2N93l9VtsvKAb9BcEtmaMXDgX1fsv0Oi764GQz33dsmrdoCO4
pI1VMo6WAtlum7iMlj3Ual0y6uvBb6mfKrBrxsS53eXJOD0FIewNLYrTa9Q5+q93
KWWEb+jWAV8eSpZxsNSHZdnHWTlm4eGp8y8MCNXT/Jv3FGawueXyXeLlOs3GU/E3
3lIkZQDR3pEzV5+GKoBF1Jl9C6D3aAKP2rWmw19gaD0GkxxzeVGiikqSrEgGPdqF
mKzfTVHxPqviHIQiWRH2m+VX+of0mSy1vSv2oSDdBu60xrnwZWg1bRSDd3ensg10
prJ8p8/Qf+HYy94hCGxz8qqGQ13ewpeYBetWtUdW2PL+Qs0S1l1Q4WNtUOZgf5zb
VdoOkqvkRBIh5pFTXqlAL4leu5gyHQfnPHogtgjk1aMobDrek8KszH2/TvdURxS2
h5om6cN5189OfJ0OD8OYagsXy/Y87ZszXDLMbageLnWl9BpvsZasS6fO+pyDe7gy
IwEEbNVud7tIb7ojaiahHaWVEb3+YfX4U1SAc9UwiViBVB7PH6ruaM0T8u1kU6uH
0HhEzY25vx1d3AfXjQNlFhOaYslbVd0FYL5aMahlOv7fozpbQ+lfz+Sy+jiWAszd
WErJxUDjWxN6BIj0otjr
=dZRQ
-----END PGP SIGNATURE-----

--gvF4niNJ+uBMJnEh--
