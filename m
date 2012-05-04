Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752722Ab2EDGpO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 02:45:14 -0400
Received: from mga01.intel.com ([192.55.52.88]:6086 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752026Ab2EDGpM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 02:45:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="asc'?scan'208";a="149221826"
Date: Fri, 4 May 2012 09:46:06 +0300
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>, Durgadoss R <durgadoss.r@intel.com>,
        Andi Kleen <ak@linux.intel.com>, Jean Delvare <khali@linux-fr.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH, v2] hwmon: coretemp: use list instead of fixed size
 array for temp data
Message-ID: <20120504064606.GA11744@otc-wbsnb-06>
References: <1335971436-13903-1-git-send-email-kirill.shutemov@linux.intel.com>
 <1336043936-11105-1-git-send-email-kirill.shutemov@linux.intel.com>
 <20120504054122.GA19334@ericsson.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mYCpIKhGyMATD0i+"
Content-Disposition: inline
In-Reply-To: <20120504054122.GA19334@ericsson.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mYCpIKhGyMATD0i+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 03, 2012 at 10:41:22PM -0700, Guenter Roeck wrote:
> On Thu, May 03, 2012 at 07:18:56AM -0400, Kirill A. Shutemov wrote:
> > From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
> >=20
> > Let's rework code to allow arbitrary number of cores on a CPU, not
> > limited by hardcoded array size.
> >=20
> > Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> > ---
> >  v2:
> >    - fix NULL pointer dereference. Thanks to R, Durgadoss;
> >    - use mutex instead of spinlock for list locking.
> > ---
> >  drivers/hwmon/coretemp.c |  178 +++++++++++++++++++++++++++++++++-----=
--------
> >  1 files changed, 129 insertions(+), 49 deletions(-)
> >=20
> > diff --git a/drivers/hwmon/coretemp.c b/drivers/hwmon/coretemp.c
> > index 54a70fe..1c66131 100644
> > --- a/drivers/hwmon/coretemp.c
> > +++ b/drivers/hwmon/coretemp.c
> > @@ -36,6 +36,8 @@
> >  #include <linux/cpu.h>
> >  #include <linux/pci.h>
> >  #include <linux/smp.h>
> > +#include <linux/list.h>
> > +#include <linux/kref.h>
> >  #include <linux/moduleparam.h>
> >  #include <asm/msr.h>
> >  #include <asm/processor.h>
> > @@ -52,11 +54,9 @@ module_param_named(tjmax, force_tjmax, int, 0444);
> >  MODULE_PARM_DESC(tjmax, "TjMax value in degrees Celsius");
> >=20
> >  #define BASE_SYSFS_ATTR_NO     2       /* Sysfs Base attr no for coret=
emp */
> > -#define NUM_REAL_CORES         16      /* Number of Real cores per cpu=
 */
> >  #define CORETEMP_NAME_LENGTH   17      /* String Length of attrs */
> >  #define MAX_CORE_ATTRS         4       /* Maximum no of basic attrs */
> >  #define TOTAL_ATTRS            (MAX_CORE_ATTRS + 1)
> > -#define MAX_CORE_DATA          (NUM_REAL_CORES + BASE_SYSFS_ATTR_NO)
> >=20
> >  #define TO_PHYS_ID(cpu)                (cpu_data(cpu).phys_proc_id)
> >  #define TO_CORE_ID(cpu)                (cpu_data(cpu).cpu_core_id)
> > @@ -82,6 +82,9 @@ MODULE_PARM_DESC(tjmax, "TjMax value in degrees Celsi=
us");
> >   * @valid: If this is 1, the current temperature is valid.
> >   */
> >  struct temp_data {
> > +       struct list_head list;
> > +       struct kref refcount;
>=20
> Hi,
>=20
> the kref is not needed. The attribute access functions don't
> need to be protected since the attributes for a core are deleted
> before the core data itself is deleted. So it is not neccessary=20
> to hold a lock while accessing/using temp_data in the attribute
> access functions. All you need is to hold a mutex while you are
> manipulating or walking the list.

Without kref, what prevents following situation:

		CPU-A				CPU-B
	tdata =3D get_temp_data();
					coretemp_remove_core() {
					    device_remove_file();
					    kfree(tdata);
					}
	<tdata dereference>

?

--=20
 Kirill A. Shutemov

--mYCpIKhGyMATD0i+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPo3stAAoJEAd+omnVudOMx6YQAI0UQCIS0DvOXDISIpCszwtM
pWgBICEIBG4SW/EWpbqIQZJZf4MdRSewiUMt3Mui+9YHXXK4nzUzmX8U+J4T+Dkr
jwZ8XI4Bv1UyH2B2ZCCeXxLdpU5roSlRGrquftwFufyFc/0siL62pUUxHTaIYA81
9RZ65NGAbswWfYUGrACfvxdKn96DtiTyY5GTx9URBIo+xs3opjX5MqFUmTyJf7NS
KFDOaHquoIaPlej/QyhFub3eVK84eKZs5SrzVyOQKrpbxEx6KoUbUnxGMUX0GYbS
+/HKrGEZ58iGzSZWFH7JRurYxVHtYeeAI1W5L2ceHPOAUZlY/3Q/MUpjNgeqWz09
9+QZRTWjw26YeZL/hOA2RZhMWjbknFpz0bGalYLjBhs/jL4DWbmQKMTkH+xEi300
ms3UNnCvPhAc6hxy4ZhaaM+EHLX1QY5T47esHur9KsWTGc1yijAkO+Db+kQH7Pxj
P+/B3i5Duu740K36FijjBrnyqbJbkh9n9tnpn0gjaZsaEO2hHCjYlpj1ThjrXT3Z
rDDJ04gvWJY4iiEUhHpt43L+JTM62sxaC99wpQsxQvsm23JYGcf0Z9EmxKHuvnMa
RMR63x3pXHoLfol5hIAWMjnJ2/IMlp1P9+2ucaUNckZC865r2rNsrRnJD8fEJrmG
6aI8TCHVQF9AxuHHciHr
=tpUh
-----END PGP SIGNATURE-----

--mYCpIKhGyMATD0i+--
