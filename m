Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758227Ab2EDNls (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 09:41:48 -0400
Received: from mga03.intel.com ([143.182.124.21]:29346 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756792Ab2EDNlr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 09:41:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="asc'?scan'208";a="138894224"
Date: Fri, 4 May 2012 16:42:40 +0300
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>, Durgadoss R <durgadoss.r@intel.com>,
        Andi Kleen <ak@linux.intel.com>, Jean Delvare <khali@linux-fr.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH, v2] hwmon: coretemp: use list instead of fixed size
 array for temp data
Message-ID: <20120504134240.GA1914@otc-wbsnb-06>
References: <1335971436-13903-1-git-send-email-kirill.shutemov@linux.intel.com>
 <1336043936-11105-1-git-send-email-kirill.shutemov@linux.intel.com>
 <20120504054122.GA19334@ericsson.com>
 <20120504064606.GA11744@otc-wbsnb-06>
 <20120504133419.GA20602@ericsson.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="W/nzBZO5zC0uMSeA"
Content-Disposition: inline
In-Reply-To: <20120504133419.GA20602@ericsson.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--W/nzBZO5zC0uMSeA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 04, 2012 at 06:34:19AM -0700, Guenter Roeck wrote:
> On Fri, May 04, 2012 at 02:46:06AM -0400, Kirill A. Shutemov wrote:
> > On Thu, May 03, 2012 at 10:41:22PM -0700, Guenter Roeck wrote:
> > > On Thu, May 03, 2012 at 07:18:56AM -0400, Kirill A. Shutemov wrote:
> > > > From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
> > > >=20
> > > > Let's rework code to allow arbitrary number of cores on a CPU, not
> > > > limited by hardcoded array size.
> > > >=20
> > > > Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> > > > ---
> > > >  v2:
> > > >    - fix NULL pointer dereference. Thanks to R, Durgadoss;
> > > >    - use mutex instead of spinlock for list locking.
> > > > ---
> > > >  drivers/hwmon/coretemp.c |  178 +++++++++++++++++++++++++++++++++-=
------------
> > > >  1 files changed, 129 insertions(+), 49 deletions(-)
> > > >=20
> > > > diff --git a/drivers/hwmon/coretemp.c b/drivers/hwmon/coretemp.c
> > > > index 54a70fe..1c66131 100644
> > > > --- a/drivers/hwmon/coretemp.c
> > > > +++ b/drivers/hwmon/coretemp.c
> > > > @@ -36,6 +36,8 @@
> > > >  #include <linux/cpu.h>
> > > >  #include <linux/pci.h>
> > > >  #include <linux/smp.h>
> > > > +#include <linux/list.h>
> > > > +#include <linux/kref.h>
> > > >  #include <linux/moduleparam.h>
> > > >  #include <asm/msr.h>
> > > >  #include <asm/processor.h>
> > > > @@ -52,11 +54,9 @@ module_param_named(tjmax, force_tjmax, int, 0444=
);
> > > >  MODULE_PARM_DESC(tjmax, "TjMax value in degrees Celsius");
> > > >=20
> > > >  #define BASE_SYSFS_ATTR_NO     2       /* Sysfs Base attr no for c=
oretemp */
> > > > -#define NUM_REAL_CORES         16      /* Number of Real cores per=
 cpu */
> > > >  #define CORETEMP_NAME_LENGTH   17      /* String Length of attrs */
> > > >  #define MAX_CORE_ATTRS         4       /* Maximum no of basic attr=
s */
> > > >  #define TOTAL_ATTRS            (MAX_CORE_ATTRS + 1)
> > > > -#define MAX_CORE_DATA          (NUM_REAL_CORES + BASE_SYSFS_ATTR_N=
O)
> > > >=20
> > > >  #define TO_PHYS_ID(cpu)                (cpu_data(cpu).phys_proc_id)
> > > >  #define TO_CORE_ID(cpu)                (cpu_data(cpu).cpu_core_id)
> > > > @@ -82,6 +82,9 @@ MODULE_PARM_DESC(tjmax, "TjMax value in degrees C=
elsius");
> > > >   * @valid: If this is 1, the current temperature is valid.
> > > >   */
> > > >  struct temp_data {
> > > > +       struct list_head list;
> > > > +       struct kref refcount;
> > >=20
> > > Hi,
> > >=20
> > > the kref is not needed. The attribute access functions don't
> > > need to be protected since the attributes for a core are deleted
> > > before the core data itself is deleted. So it is not neccessary=20
> > > to hold a lock while accessing/using temp_data in the attribute
> > > access functions. All you need is to hold a mutex while you are
> > > manipulating or walking the list.
> >=20
> > Without kref, what prevents following situation:
> >=20
> > 		CPU-A				CPU-B
> > 	tdata =3D get_temp_data();
> > 					coretemp_remove_core() {
> > 					    device_remove_file();
> > 					    kfree(tdata);
> > 					}
> > 	<tdata dereference>
> >=20
> The remove function requires a semaphore which is held by the access func=
tion,
> so device_remove_file() will only proceed after CPU-A is done with the sy=
sfs access.

Understood. I'll update the patch.

--=20
 Kirill A. Shutemov

--W/nzBZO5zC0uMSeA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPo9zQAAoJEAd+omnVudOMKhgQAMnKBOg5oEKyOpdHwGkmJXqQ
tOPkagIOKPxLeEUQjd5MXa81TXiuuLqW0aGGdP9VCxVOFIlQ9mbGIh0HjlD3lvmL
IoqlwP8IwuJfU6NEiU27PEd9rQjgNn8Poz0KjQqNcoavleaOaoNljB2OVVT+1cWF
Pjm0MvEU6/swBCGAu9EmUg0ly81GtpeL9kCkWrlXl/au9PzhM6RQp3agGQ4tgZfb
ahI0I2ZJ7tDGvjBJaL2LzGnyADJG/ZnZnrvHlFH3NI4PK0N2jR5JFepeGGfQckzK
Xx8d34SQXSULjt8iE3AcGG6AbkapYYmfmkXX9H4PdiwBwJsgwE6nwPIUfxFrutCf
DrFbFg1cKV3da4vphmcBtMdCNzJBVhmdyk62zjOsq7Nz+qbQ4HKJOQH6sOMwzSPY
ZFeG2vcIxEGywpY3NmKBBf8tPeqlWBwt7Yu236ruOKwVHxEhY0B/41G0iI2+sh4w
fSQJED0cxbUGS5WiWokT0pahid1CMFLerQrYFRd6RrSq5ORcoqYJjq8sCxNmGOqR
sDeDJYld4h3XpyvBWbTqHiKGeEUUBvpTvImla639C0mSYMBd2VdZWqsAfm4H7022
igrhfUvtRHVV0TpULN5Yy1JZvnum0RiTWQlA7dtRMwXbyu5Jz5KYUKs2HlZa1QkP
n+F3rzDMktM2yzJsYI9a
=qZkz
-----END PGP SIGNATURE-----

--W/nzBZO5zC0uMSeA--
