Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755525Ab1KIIFX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 03:05:23 -0500
Received: from ozlabs.org ([203.10.76.45]:51512 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755371Ab1KIIFR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 03:05:17 -0500
Subject: Re: [PATCH v3 3/3] Use separate struct console structure for each
 hvc_console.
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Miche Baker-Harvey <miche@google.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Stephen Rothwell <sfr@canb.auug.org.au>, xen-devel@lists.xensource.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Anton Blanchard <anton@samba.org>, Amit Shah <amit.shah@redhat.com>,
        Mike Waychison <mikew@google.com>,
        ppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Eric Northrup <digitaleric@google.com>
In-Reply-To: <20111108214509.28884.98169.stgit@miche.sea.corp.google.com>
References: <20111108214452.28884.14840.stgit@miche.sea.corp.google.com>
	 <20111108214509.28884.98169.stgit@miche.sea.corp.google.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-d4UMUQr8j6a6R6ANBKiZ"
Date: Wed, 09 Nov 2011 19:05:12 +1100
Message-ID: <1320825912.9376.72.camel@concordia>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-d4UMUQr8j6a6R6ANBKiZ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2011-11-08 at 13:45 -0800, Miche Baker-Harvey wrote:
> It is possible to make any virtio_console port be a console
> by sending VIRITO_CONSOLE_CONSOLE_PORT.  But hvc_alloc was
> using a single struct console hvc_console, which contains
> both an index and flags which are per-port.
>=20
> This adds a separate struct console for each virtio_console
> that is CONSOLE_PORT.

Hi Miche,

I'm testing this on powerpc and unfortunately it's working a little _too
well_. I end up with two struct consoles registered and so I get every
line of output twice :)

The problem is that we're registering two struct consoles. The first
obviously is hvc_console, either in hvc_console_init(), or in my case
from hvc_instantiate().

Then we register the allocated one in hvc_alloc(). But because they both
point back to the same hardware you get duplicate output.

We _do_ want to register a console early, in either/both
hvc_console_init() and hvc_instantiate(), because we want to have
console during boot prior to when hvc_alloc() gets called.

I think maybe we should be checking in hvc_alloc() whether we already
have hvc_console associated with the vtermno and if so we use
hvc_console instead of allocating a new one.

Patch below to do that, and works for me, but it's a bit of a hack,
there must be a better solution.

Finally I'm not sure how your patch affects the code in hvc_poll() which
checks hvc_console.index to do the SYSRQ hack.

cheers

diff --git a/drivers/tty/hvc/hvc_console.c b/drivers/tty/hvc/hvc_console.c
index fff35da..b249195 100644
--- a/drivers/tty/hvc/hvc_console.c
+++ b/drivers/tty/hvc/hvc_console.c
@@ -815,13 +815,15 @@ struct hvc_struct *hvc_alloc(uint32_t vtermno, int da=
ta,
        kref_init(&hp->kref);
=20
        INIT_WORK(&hp->tty_resize, hvc_set_winsz);
-       /*
-        * Make each console its own struct console.
-        */
-       cp =3D kmemdup(&hvc_console, sizeof(*cp), GFP_KERNEL);
-       if (!cp) {
-               kfree(hp);
-               return ERR_PTR(-ENOMEM);
+
+       if (hvc_console.index >=3D 0 && vtermnos[hvc_console.index] =3D=3D =
hp->vtermno)
+               cp =3D &hvc_console;
+       else {
+               cp =3D kmemdup(&hvc_console, sizeof(*cp), GFP_KERNEL);
+               if (!cp) {
+                       kfree(hp);
+                       return ERR_PTR(-ENOMEM);
+               }
        }
=20
        hp->hvc_console =3D cp;
@@ -850,7 +852,9 @@ struct hvc_struct *hvc_alloc(uint32_t vtermno, int data=
,
=20
        list_add_tail(&(hp->next), &hvc_structs);
        spin_unlock(&hvc_structs_lock);
-       register_console(cp);
+
+       if (cp !=3D &hvc_console)
+               register_console(cp);
=20
        return hp;
 }


--=-d4UMUQr8j6a6R6ANBKiZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAk66NDgACgkQdSjSd0sB4dJg5ACgjHqUujtNJ9SiPUAhWVHc6sv7
Y5AAnRuekB5kaSUrzXaxayeTwFqR49UT
=Ticb
-----END PGP SIGNATURE-----

--=-d4UMUQr8j6a6R6ANBKiZ--

