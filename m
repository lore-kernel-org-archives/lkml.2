Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755142Ab0C2RiI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 13:38:08 -0400
Received: from vps.mortis.eu ([79.99.135.181]:37080 "EHLO vps.mortis.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754163Ab0C2RiG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 13:38:06 -0400
Date: Mon, 29 Mar 2010 19:38:00 +0200
From: Giel van Schijndel <me@mortis.eu>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Hans de Goede <hdegoede@redhat.com>,
       Jean Delvare <khali@linux-fr.org>, Jonathan Cameron <jic23@cam.ac.uk>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Dominik Brodowski <linux@dominikbrodowski.net>,
       Laurens Leemans <laurens@signips.com>, lm-sensors@lm-sensors.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] resource: shared I/O region support
Message-ID: <20100329173800.GA3583@salidar.me.mortis.eu>
References: <20100325125005.6d58cfaf@lxorguk.ukuu.org.uk>
 <1269523063-30346-1-git-send-email-me@mortis.eu>
 <20100325155705.1ec79dbc@lxorguk.ukuu.org.uk>
 <20100325180347.GA2761@salidar.me.mortis.eu>
 <20100325181633.0313b8a5@lxorguk.ukuu.org.uk>
 <20100329081834.GB27956@salidar.me.mortis.eu>
 <20100329090713.1317942b@jbarnes-piketon>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KsGdsel6WgEHnImy"
Content-Disposition: inline
In-Reply-To: <20100329090713.1317942b@jbarnes-piketon>
OpenPGP: id=CEE5E742; url=http://gpg.mortis.eu/me.asc
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--KsGdsel6WgEHnImy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 29, 2010 at 09:07:13AM -0700, Jesse Barnes wrote:
> On Mon, 29 Mar 2010 10:18:34 +0200> Giel van Schijndel wrote:
>> On Thu, Mar 25, 2010 at 06:16:33PM +0000, Alan Cox wrote:
>>>> +			if (res->flags & IORESOURCE_MUXED)
>>>> +				wake_up(&muxed_resource_wait);
>>>>  			kfree(res);
>>>>  			return;
>>>=20
>>> And you'll want a
>>>=20
>>> Signed-off-by: Alan Cox <alan@linux.intel.com>
>>=20
>> Yes, thanks.
>>=20
>> Anyone specific I should mail to get this patch applied? I don't see any
>> entry in MAINTAINERS for kernel/resource.c or include/linux/resource.h.
>=20
> I can take it; sometimes Linus applies resource stuff directly though.
>=20
> Can you resend with the appropriate s-o-bs etc?

Sure.

(I copied Alan's signed-off-by from his reply to the patch)

Patch after this line:
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
resource: shared I/O region support

SuperIO devices share regions and use lock/unlock operations to chip
select.  We therefore need to be able to request a resource and wait for
it to be freed by whichever other SuperIO device currently hogs it.
Right now you have to poll which is horrible.

Add a MUXED field to IO port resources. If the MUXED field is set on the
resource and on the request (via request_muxed_region) then we block
until the previous owner of the muxed resource releases their region.

This allows us to implement proper resource sharing and locking for
superio chips using code of the form

enable_my_superio_dev() {
	request_muxed_region(0x44, 0x02, "superio:watchdog");
	outb() ..sequence to enable chip
}

disable_my_superio_dev() {
	outb() .. sequence of disable chip
	release_region(0x44, 0x02);
}

Signed-off-by: Giel van Schijndel <me@mortis.eu>
Signed-off-by: Alan Cox <alan@linux.intel.com>
---
 include/linux/ioport.h |    4 +++-
 kernel/resource.c      |   16 +++++++++++++++-
 2 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/include/linux/ioport.h b/include/linux/ioport.h
index 71ab79d..604fd29 100644
--- a/include/linux/ioport.h
+++ b/include/linux/ioport.h
@@ -52,6 +52,7 @@ struct resource_list {
=20
 #define IORESOURCE_MEM_64	0x00100000
 #define IORESOURCE_WINDOW	0x00200000	/* forwarded by bridge */
+#define IORESOURCE_MUXED	0x00400000	/* Resource is software muxed */
=20
 #define IORESOURCE_EXCLUSIVE	0x08000000	/* Userland may not map this resou=
rce */
 #define IORESOURCE_DISABLED	0x10000000
@@ -141,7 +142,8 @@ static inline unsigned long resource_type(const struct =
resource *res)
 }
=20
 /* Convenience shorthand with allocation */
-#define request_region(start,n,name)	__request_region(&ioport_resource, (s=
tart), (n), (name), 0)
+#define request_region(start,n,name)		__request_region(&ioport_resource, (=
start), (n), (name), 0)
+#define request_muxed_region(start,n,name)	__request_region(&ioport_resour=
ce, (start), (n), (name), IORESOURCE_MUXED)
 #define __request_mem_region(start,n,name, excl) __request_region(&iomem_r=
esource, (start), (n), (name), excl)
 #define request_mem_region(start,n,name) __request_region(&iomem_resource,=
 (start), (n), (name), 0)
 #define request_mem_region_exclusive(start,n,name) \
diff --git a/kernel/resource.c b/kernel/resource.c
index 2d5be5d..ab44c7f 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -15,6 +15,7 @@
 #include <linux/spinlock.h>
 #include <linux/fs.h>
 #include <linux/proc_fs.h>
+#include <linux/sched.h>
 #include <linux/seq_file.h>
 #include <linux/device.h>
 #include <linux/pfn.h>
@@ -651,6 +652,8 @@ resource_size_t resource_alignment(struct resource *res)
  * release_region releases a matching busy region.
  */
=20
+static DECLARE_WAIT_QUEUE_HEAD(muxed_resource_wait);
+
 /**
  * __request_region - create a new busy resource region
  * @parent: parent resource descriptor
@@ -663,6 +666,7 @@ struct resource * __request_region(struct resource *par=
ent,
 				   resource_size_t start, resource_size_t n,
 				   const char *name, int flags)
 {
+	DECLARE_WAITQUEUE(wait, current);
 	struct resource *res =3D kzalloc(sizeof(*res), GFP_KERNEL);
=20
 	if (!res)
@@ -687,7 +691,15 @@ struct resource * __request_region(struct resource *pa=
rent,
 			if (!(conflict->flags & IORESOURCE_BUSY))
 				continue;
 		}
-
+		if (conflict->flags & flags & IORESOURCE_MUXED) {
+			add_wait_queue(&muxed_resource_wait, &wait);
+			write_unlock(&resource_lock);
+			set_current_state(TASK_UNINTERRUPTIBLE);
+			schedule();
+			remove_wait_queue(&muxed_resource_wait, &wait);
+			write_lock(&resource_lock);
+			continue;
+		}
 		/* Uhhuh, that didn't work out.. */
 		kfree(res);
 		res =3D NULL;
@@ -761,6 +773,8 @@ void __release_region(struct resource *parent, resource=
_size_t start,
 				break;
 			*p =3D res->sibling;
 			write_unlock(&resource_lock);
+			if (res->flags & IORESOURCE_MUXED)
+				wake_up(&muxed_resource_wait);
 			kfree(res);
 			return;
 		}
--=20
1.6.4.4

--=20
Met vriendelijke groet,
With kind regards,
Giel van Schijndel

--KsGdsel6WgEHnImy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkuw5XYACgkQZBYm/87l50IKKwCgn9m1I1bHCDDGP8AY1dt1FHNs
d7YAoME6Ahp1Pe+1FkuQpt1CCDBmkS1V
=u74c
-----END PGP SIGNATURE-----

--KsGdsel6WgEHnImy--
