Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756572Ab1DLAeT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 20:34:19 -0400
Received: from ozlabs.org ([203.10.76.45]:48688 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756467Ab1DLAeS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 20:34:18 -0400
Subject: Re: [PATCH] mm: Check we have the right vma in __access_remote_vm()
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, hughd@google.com,
        walken@google.com, aarcange@redhat.com, riel@redhat.com,
        linuxppc-dev@ozlabs.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
In-Reply-To: <20110411165035.5a303647.akpm@linux-foundation.org>
References: <10e5cbf67c850b6ae511979bdbad1761236ad9b0.1302247435.git.michael@ellerman.id.au>
	 <20110411165035.5a303647.akpm@linux-foundation.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-wpVZ5b1uUgu0Y5fZV2oA"
Date: Tue, 12 Apr 2011 10:34:17 +1000
Message-ID: <1302568457.4894.38.camel@concordia>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-wpVZ5b1uUgu0Y5fZV2oA
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2011-04-11 at 16:50 -0700, Andrew Morton wrote:
> On Fri,  8 Apr 2011 17:24:01 +1000 (EST)
> Michael Ellerman <michael@ellerman.id.au> wrote:
>=20
> > In __access_remote_vm() we need to check that we have found the right
> > vma, not the following vma, before we try to access it. Otherwise we
> > might call the vma's access routine with an address which does not
> > fall inside the vma.
> >=20
>=20
> hm, mysteries.  Does this patch fix any known problem in any known
> kernel, or was the problem discovered by inspection, or what?

Sorry I meant to add that explanation but forgot.

It was discovered on a current kernel but with an unreleased driver,
from memory it was strace leading to a kernel bad access, but it
obviously depends on what the access implementation does.=20

Looking at other access implementations I only see:

$ git grep -A 5 vm_operations|grep access
arch/powerpc/platforms/cell/spufs/file.c-	.access =3D spufs_mem_mmap_access=
,
arch/x86/pci/i386.c-	.access =3D generic_access_phys,
drivers/char/mem.c-	.access =3D generic_access_phys
fs/sysfs/bin.c-	.access		=3D bin_access,


The spufs one looks like it might behave badly given the wrong vma, it
assumes vma->vm_file->private_data is a spu_context, and looks like it
would probably blow up pretty quickly if it wasn't.

generic_access_phys() only uses the vma to check vm_flags and get the
mm, and then walks page tables using the address. So it should bail on
the vm_flags check, or at worst let you access some other VM_IO mapping.

And bin_access() just proxies to another access implementation.

cheers



--=-wpVZ5b1uUgu0Y5fZV2oA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAk2jngYACgkQdSjSd0sB4dLPTQCfbBHY6mHfeKf2atRQwhTQjAx2
f4QAoKyAkaOWDYFE3xd6fkATHG4m6pOM
=oyZZ
-----END PGP SIGNATURE-----

--=-wpVZ5b1uUgu0Y5fZV2oA--

