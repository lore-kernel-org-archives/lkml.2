Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756651Ab2LMUIZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 15:08:25 -0500
Received: from mga11.intel.com ([192.55.52.93]:58537 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756343Ab2LMUIV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 15:08:21 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,275,1355126400"; 
   d="asc'?scan'208";a="261824786"
Date: Thu, 13 Dec 2012 22:08:57 +0200
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Miles J Penner <miles.j.penner@intel.com>,
        John Ronciak <john.ronciak@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Tushar N Dave <tushar.n.dave@intel.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Amos Kong <kongjianjun@gmail.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] PCI Hotplug: workaround for Thunderbolt on Intel
 DZ77RE-75K motherboard
Message-ID: <20121213200857.GA24939@otc-wbsnb-06>
References: <1355412708-20046-1-git-send-email-kirill.shutemov@linux.intel.com>
 <1355412708-20046-4-git-send-email-kirill.shutemov@linux.intel.com>
 <20121213184820.GC12105@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="x+6KMIRAuhnl3hBn"
Content-Disposition: inline
In-Reply-To: <20121213184820.GC12105@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--x+6KMIRAuhnl3hBn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 13, 2012 at 10:48:20AM -0800, Greg KH wrote:
> On Thu, Dec 13, 2012 at 05:31:48PM +0200, Kirill A. Shutemov wrote:
> > From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
> >=20
> > BIOS on Intel DZ77RE-75K motherboard notifies OS about Thunderbolt
> > hotplug before devices behind Thunderbolt are ready to be enumerated.
> >=20
> > Let's delay enumeration by 2 seconds.
> >=20
> > Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> > ---
> >  drivers/pci/hotplug/acpiphp_glue.c |   16 +++++++++++++++-
> >  1 file changed, 15 insertions(+), 1 deletion(-)
> >=20
> > diff --git a/drivers/pci/hotplug/acpiphp_glue.c b/drivers/pci/hotplug/a=
cpiphp_glue.c
> > index 1a2b3ca..165987a 100644
> > --- a/drivers/pci/hotplug/acpiphp_glue.c
> > +++ b/drivers/pci/hotplug/acpiphp_glue.c
> > @@ -49,6 +49,7 @@
> >  #include <linux/mutex.h>
> >  #include <linux/slab.h>
> >  #include <linux/acpi.h>
> > +#include <linux/dmi.h>
> > =20
> >  #include "../pci.h"
> >  #include "acpiphp.h"
> > @@ -1327,6 +1328,19 @@ out:
> >  static void handle_hotplug_event_bridge(acpi_handle handle, u32 type,
> >  					void *context)
> >  {
> > +	unsigned long delay =3D 0;
> > +	const char *board_name;
> > +
> > +	board_name =3D dmi_get_system_info(DMI_BOARD_NAME);
> > +	/*
> > +	 * BIOS on Intel DZ77RE-75K motherboard notifies OS about Thunderbolt
> > +	 * hotplug before devices behind Thunderbolt are ready to be
> > +	 * enumerated.
> > +	 * Let's delay enumeration by 2 seconds.
> > +	 */
> > +	if (board_name && !strcmp(board_name, "DZ77RE-75K"))
> > +		delay =3D 2 * HZ;
>=20
> Again, no objection to this patch as-is, but should we make it a bit
> more "general" and provide a quirk table to make this type of fix easier
> for other motherboards?  Shouldn't we also match on a manufacturer field
> as well as the board_name?  The kernel provides a very easy to match on
> any arbritary set of DMI fields for this kind of problem that we could
> use here.

Something like this (untested):

diff --git a/drivers/pci/hotplug/acpiphp_glue.c b/drivers/pci/hotplug/acpip=
hp_glue.c
index 1a2b3ca..c4db634 100644
--- a/drivers/pci/hotplug/acpiphp_glue.c
+++ b/drivers/pci/hotplug/acpiphp_glue.c
@@ -49,6 +49,7 @@
 #include <linux/mutex.h>
 #include <linux/slab.h>
 #include <linux/acpi.h>
+#include <linux/dmi.h>
=20
 #include "../pci.h"
 #include "acpiphp.h"
@@ -1327,6 +1328,31 @@ out:
 static void handle_hotplug_event_bridge(acpi_handle handle, u32 type,
 					void *context)
 {
+	unsigned long delay =3D 0;
+	const struct dmi_system_id *match;
+	static const struct dmi_system_id sysids[] =3D {
+		/*
+		 * BIOS on Intel DZ77RE-75K motherboard notifies OS about
+		 * Thunderbolt hotplug before devices behind Thunderbolt are
+		 * ready to be enumerated.
+		 * Let's delay enumeration by 2 seconds.
+		 */
+		{
+			.ident =3D "DZ77RE-75K",
+			.matches =3D {
+				DMI_MATCH(DMI_BOARD_VENDOR,
+						"Intel Corporation"),
+				DMI_MATCH(DMI_BOARD_NAME,
+						"DZ77RE-75K"),
+			},
+			.driver_data =3D (void *) (2 * HZ), /* delay */
+		},
+	};
+
+	match =3D dmi_first_match(sysids);
+	if (match)
+		delay =3D (unsigned long) match->driver_data;
+
 	/*
 	 * Currently the code adds all hotplug events to the kacpid_wq
 	 * queue when it should add hotplug events to the kacpi_hotplug_wq.
@@ -1336,7 +1362,7 @@ static void handle_hotplug_event_bridge(acpi_handle h=
andle, u32 type,
 	 * don't deadlock on hotplug actions.
 	 */
 	alloc_acpiphp_hp_work(handle, type, context,
-			      _handle_hotplug_event_bridge, 0);
+			      _handle_hotplug_event_bridge, delay);
 }
=20
 static void _handle_hotplug_event_func(struct work_struct *work)

--=20
 Kirill A. Shutemov

--x+6KMIRAuhnl3hBn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQyjXZAAoJEAd+omnVudOMXrQP/jUE6v1K2XcX3oo75OtQob+O
YOgwL+bS12hXbbF7jwRnC96BRxL5DgL84jyVCmVLhr+Oq/pSY64C9qIm4sjBZtiu
JLHO7GYfwrnYUYdgH1aJ6q+tj49oqLQA/rIz3OyI/oTifGSRSxp5THyvsuNhZTl4
uITpx63KMCENcB3afe2z+07aMtiHa4yoBl569VulQ+337oeUt/di3cd7njUeJ/wT
LsClXnwqZbu18B6Qwqz/sTgWdkVwTHdWzSyAgvLXeqRx+npK65TxmPCRn8IFrf9/
G13JrU7tZjLP7n86oH2HzO/vrcCVjEEfSXiQltueMeEvdW7FHWbVIqUwowTaBtV1
Ui6Bl8MHMFs3PJ5hsfmSWPAe5zPj7IWlKZG2Tadc1AdGZXVVH+m+yqmWvphSjuSV
JDsb+Pk0L5eqFWq3MnIprFt9uGO+DjF8ayLx2qnK+h0OGLH5tR4+lRpwVFHHYPPf
C8kskwSb07Nn5iJh55krty/8qq8aaQnXLtdDd/E1f3l9BTZm+RIBoyKgbgaBy5gY
1Qb3GwqBwbou70dh7vN6Eluvg6iZwRLxGR3QslrIXzfNXGrNzJcE9UkkdVm6bYyn
ehjmdPBrk6Mui/+wb8t6WBo0qMTaZDt3ufmNDB1ZjzaslNAKYdPP81pNO7AaHyai
7yPdvaDzSM4XIyg0r2oC
=Bkfr
-----END PGP SIGNATURE-----

--x+6KMIRAuhnl3hBn--
