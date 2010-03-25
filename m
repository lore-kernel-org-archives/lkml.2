Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753622Ab0CYSDx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 14:03:53 -0400
Received: from vps.mortis.eu ([79.99.135.181]:46236 "EHLO vps.mortis.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753339Ab0CYSDv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 14:03:51 -0400
Date: Thu, 25 Mar 2010 19:03:47 +0100
From: Giel van Schijndel <me@mortis.eu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Hans de Goede <hdegoede@redhat.com>, Jean Delvare <khali@linux-fr.org>,
       Jonathan Cameron <jic23@cam.ac.uk>,
       Laurens Leemans <laurens@signips.com>, lm-sensors@lm-sensors.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] resource: shared I/O region support
Message-ID: <20100325180347.GA2761@salidar.me.mortis.eu>
References: <20100325125005.6d58cfaf@lxorguk.ukuu.org.uk>
 <1269523063-30346-1-git-send-email-me@mortis.eu>
 <20100325155705.1ec79dbc@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jRHKVT23PllUwdXP"
Content-Disposition: inline
In-Reply-To: <20100325155705.1ec79dbc@lxorguk.ukuu.org.uk>
X-Face: 46T+Jilkx"/*x5]:HK*F2!;z\N`8XNfv!<F:e82Epd1k:*!abp@'tamh`KBQo[HA$d,r:c2%Xy&&"<pm7we=N=a#pZ-;h[/mlbeOPx6itqPc-g>4[O?U\!:LQNU@:T+?S*$G`=5sMJjet}Sv,fwQ)LtO{(F0/+..H3c<|GWm*pAS[PdKmQdFTvysgrU%~'m\K0<aI?JU)k6mT8'uJ
OpenPGP: id=CEE5E742; url=http://gpg.mortis.eu/me.asc
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jRHKVT23PllUwdXP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 25, 2010 at 03:57:05PM +0000, Alan Cox wrote:
> On Thu, 25 Mar 2010 14:17:41 +0100 Giel van Schijndel wrote:
>> From: Alan Cox <alan@lxorguk.ukuu.org.uk>
>>=20
>> This patch was originally written by Alan Cox [1]. I only updated it to
>> apply correctly to Linus' current tree and changed IORESOURCE_MUXED's
>> value from 0x00200000 to 0x00400000 because the former has already been
>> taken in use since.
>>=20
>> [1] https://patchwork.kernel.org/patch/32397/
>>=20
>> Patch after this line:
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> ... snip ...
>> @@ -687,7 +690,14 @@ struct resource * __request_region(struct resource =
*parent,
>>  			if (!(conflict->flags & IORESOURCE_BUSY))
>>  				continue;
>>  		}
>> -
>> +		if (conflict->flags & flags & IORESOURCE_MUXED) {
>> +			add_wait_queue(&muxed_resource_wait, &wait);
>> +			write_unlock(&resource_lock);
>=20
> needs a set_current_state(TASK_UNINTERRUPTIBLE); here
>=20
> (error from my original test patch that I noticed re-reviewing it)

Always fun reviewing your own code ;-)

New patch attached.

One question though. I did some reading in
Documentation/memory-barriers.txt and think it is correct *not* to call
set_current_state(TASK_INTERRUPTIBLE) after schedule() finishes. Could
you confirm or deny that?

Patch after this line:
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

--jRHKVT23PllUwdXP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkurpYEACgkQZBYm/87l50K3wQCgwJYIC6JjyAE3MJXLVfhvv+S8
ZkEAoMUSk17qMtk1jKyRIGM50Tb0/ZpR
=F2wv
-----END PGP SIGNATURE-----

--jRHKVT23PllUwdXP--
