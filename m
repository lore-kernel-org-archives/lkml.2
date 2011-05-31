Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757745Ab1EaRNB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 13:13:01 -0400
Received: from smtp108.prem.mail.ac4.yahoo.com ([76.13.13.47]:30586 "HELO
	smtp108.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757662Ab1EaRNA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 13:13:00 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: Gf77Nr0VM1nbA1TTj.hczhvsrDemF39bguBF5UwdWehVZGo
 ZijH2LJbEQWEy4ol7LxLyylhWK4eSdXtJMPzRTArf.79apdChisnuUPUucao
 UqCOofF4fS9d._GdiBa6XkBYZgjKMO0u964GQDYx.u7fq7634_WOnoN2BY5o
 15p9ZuhBKVsLAWfQrx0vqBjR.XRwtYt7pFW9zEi5QI89iIGs8CkYGvtP2pls
 5r0i2DP2iktMcBj4_DuCCWhsrVx6pa.hpYJp5WzDsbNbMryo0UWjrsZ5DOKA
 ZTv_tNCLKybZV2Bks3Ga6imXZJdCuwptJI0vvCMYCKVUYeRq1o23WIG4Nar6
 m_No0dfCT20JaBGclMuKvcne8
X-Yahoo-Newman-Property: ymail-3
Date: Tue, 31 May 2011 12:12:57 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: David Rientjes <rientjes@google.com>
cc: Pekka Enberg <penberg@cs.helsinki.fi>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [slubllv6 12/17] slub: Avoid disabling interrupts in free
 slowpath
In-Reply-To: <alpine.DEB.2.00.1105261354130.26952@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.1105311212120.19928@router.home>
References: <20110526181442.789868308@linux.com> <20110526181508.302886720@linux.com> <alpine.DEB.2.00.1105261354130.26952@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/Mixed; BOUNDARY="531368966-1776596693-1306443338=:26952"
Content-ID: <alpine.DEB.2.00.1105261516032.10790@chino.kir.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--531368966-1776596693-1306443338=:26952
Content-Type: TEXT/PLAIN; CHARSET=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Content-ID: <alpine.DEB.2.00.1105261516033.10790@chino.kir.corp.google.com>

On Thu, 26 May 2011, David Rientjes wrote:

> We know that flags will be initialized at this point in the code, but the
> compiler doesn't and it emits this:
>
> =09mm/slub.c: In function =E2=80=98__slab_free=E2=80=99:
> =09mm/slub.c:2198: warning: =E2=80=98flags=E2=80=99 may be used uninitial=
ized in this function
>
> so it'll need uninitialized_var().



Subject: slub: Disable interrupts in free_debug processing

We will be calling free_debug_processing with interrupts disabled
in some case when the later patches are applied. Some of the
functions called by free_debug_processing expect interrupts to be
off.

Signed-off-by: Christoph Lameter <cl@linux.com>


---
 mm/slub.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

Index: linux-2.6/mm/slub.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.orig/mm/slub.c=092011-05-31 10:20:05.472975031 -0500
+++ linux-2.6/mm/slub.c=092011-05-31 10:20:09.792975006 -0500
@@ -1040,6 +1040,10 @@ bad:
 static noinline int free_debug_processing(struct kmem_cache *s,
 =09=09 struct page *page, void *object, unsigned long addr)
 {
+=09unsigned long flags;
+=09int rc =3D 0;
+
+=09local_irq_save(flags);
 =09slab_lock(page);

 =09if (!check_slab(s, page))
@@ -1056,7 +1060,7 @@ static noinline int free_debug_processin
 =09}

 =09if (!check_object(s, page, object, SLUB_RED_ACTIVE))
-=09=09return 0;
+=09=09goto out;

 =09if (unlikely(s !=3D page->slab)) {
 =09=09if (!PageSlab(page)) {
@@ -1077,13 +1081,15 @@ static noinline int free_debug_processin
 =09=09set_track(s, object, TRACK_FREE, addr);
 =09trace(s, page, object, 0);
 =09init_object(s, object, SLUB_RED_INACTIVE);
+=09rc =3D 1;
+out:
 =09slab_unlock(page);
-=09return 1;
+=09local_irq_restore(flags);
+=09return rc;

 fail:
 =09slab_fix(s, "Object at 0x%p not freed", object);
-=09slab_unlock(page);
-=09return 0;
+=09goto out;
 }


 static int __init setup_slub_debug(char *str)
--531368966-1776596693-1306443338=:26952--
