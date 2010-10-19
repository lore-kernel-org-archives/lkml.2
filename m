Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753072Ab0JSO7I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 10:59:08 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:41298 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753002Ab0JSO7G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 10:59:06 -0400
Date: Wed, 20 Oct 2010 01:58:54 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        stefano.stabellini@eu.citrix.com, jeremy@goop.org
Subject: Re: swiotlb-xen tree + xen + linux-next
Message-Id: <20101020015854.3e8b78f1.sfr@canb.auug.org.au>
In-Reply-To: <20101019142539.GA5726@dumpdata.com>
References: <20101019142539.GA5726@dumpdata.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__20_Oct_2010_01_58_54_+1100_nEIM=STin97sJ.bG"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__20_Oct_2010_01_58_54_+1100_nEIM=STin97sJ.bG
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Konrad,

On Tue, 19 Oct 2010 10:25:39 -0400 Konrad Rzeszutek Wilk <konrad.wilk@oracl=
e.com> wrote:
>
> Jeremy and I fixed the mega failures you saw and last night Jeremy's
> got pulled in while mine was silent. I am enabling my tree today, and whi=
le
> the previous failure is gone when I do a merge of my tree against linux-n=
ext,
> I keep on getting one that I am having trouble solving.

Thanks for fixing this all up.

> The issues is that my patchset touches drivers/pci/Makefile which
> had been changed a bit by a): 350a55e9ff6005032407d3234af800f413b03af5
> (PCI: use new ccflags variable in Makefile) which does this:
> @@ -65,6 +65,4 @@ obj-$(CONFIG_PCI_SYSCALL) +=3D syscall.o
> =20
>  obj-$(CONFIG_PCI_STUB) +=3D pci-stub.o
> =20
> -ifeq ($(CONFIG_PCI_DEBUG),y)
> -EXTRA_CFLAGS +=3D -DDEBUG
> -endif
> +ccflags-$(CONFIG_PCI_DEBUG) :=3D -DDEBUG
>=20
> And then b) my patch (git commit 956a9202cd1220397933a07beda9f96b3df1fa24
> xen-pcifront: Xen PCI frontend driver.) goes in and tries to add:
>=20
> @@ -65,6 +65,8 @@ obj-$(CONFIG_PCI_SYSCALL) +=3D syscall.o
> =20
>  obj-$(CONFIG_PCI_STUB) +=3D pci-stub.o
> =20
> +obj-$(CONFIG_XEN_PCIDEV_FRONTEND) +=3D xen-pcifront.o
> +
>  ifeq ($(CONFIG_PCI_DEBUG),y)
>  EXTRA_CFLAGS +=3D -DDEBUG
>  endif
>=20
> I've tried to put a) patch in the branch and rebase my tree on top of that
> and this way, the "ifeq ($(CONFIG_PCI_DEBUG_...)" is gone, but merge still
> complains! The error is:
>=20
> diff --cc drivers/pci/Makefile
> index dcd7ace,39c7327..0000000
> --- a/drivers/pci/Makefile
> +++ b/drivers/pci/Makefile
> @@@ -65,4 -65,7 +65,10 @@@ obj-$(CONFIG_PCI_SYSCALL) +=3D syscall.
>  =20
>   obj-$(CONFIG_PCI_STUB) +=3D pci-stub.o
>  =20
> ++<<<<<<< HEAD
> ++=3D=3D=3D=3D=3D=3D=3D
> + # Xen PCI frontend driver
> + obj-$(CONFIG_XEN_PCIDEV_FRONTEND) +=3D xen-pcifront.o
> +=20
> ++>>>>>>> stable/xen-pcifront-0.8.3
>   ccflags-$(CONFIG_PCI_DEBUG) :=3D -DDEBUG
>=20
> [That branch with the a) patch is stable/xen-pcifront-0.8.3, which differs
> from #linux-next (which is linked to stable/xen-pcifront-0.8.2) by just
> having the patch a) in it. I am not going to use that for #linux-next as
> it does not seem to make merging automatic].
>=20
> Any ideas why it is doing this?

I think that if git sees this as the "ccflags" change on one side of the
merge and "ccflags" change plus your change on the other and decides that
it conflicts.  It considers the two "ccflags" changes to be different
because they are not the same commit (even if they have the same patch).

> In the internim and so that the merge tonight won't be broken, I've
> attached a merge conflict patch instead:
>=20
> diff --git a/drivers/pci/Makefile b/drivers/pci/Makefile
> index dcd7ace..f01e344 100644
> --- a/drivers/pci/Makefile
> +++ b/drivers/pci/Makefile
> @@ -65,4 +65,6 @@ obj-$(CONFIG_PCI_SYSCALL) +=3D syscall.o
> =20
>  obj-$(CONFIG_PCI_STUB) +=3D pci-stub.o
> =20
> +obj-$(CONFIG_XEN_PCIDEV_FRONTEND) +=3D xen-pcifront.o
> +
>  ccflags-$(CONFIG_PCI_DEBUG) :=3D -DDEBUG
>=20

Thanks.  You don't need to worry about simple conflicts like this, Linus
and I are both quite happy with fixing them up - though I will still
report them, just so people know what is going on.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__20_Oct_2010_01_58_54_+1100_nEIM=STin97sJ.bG
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMvbIuAAoJEDMEi1NhKgbsLTUIAJeWimuAIjPzSuJxqijKsfnf
GvZ/6MYxZ4qm+AOZNqF0xjMbG1uH/tO9BxIRZ5ax22EqVSulB8kgVr/zPpB2NVkL
fCNECd/JRRVZJCIydsuRSCL6dmULyWtMViv/juRqcI7KpNeG88jbuNp7SsuU6yjz
pfRecDQk1HlOoscgu7/8tKQpsGvOlkDKuAGV6yg73jktdj1JewKaP2gC+1anHRUw
BAlL3UADRg5yeb+q/TTy8VGO6Nip/uFPoQ/v7jg3qBH8fkFTskdim58atWlJR4KA
GTHfw5YFHA/MqH2EKH88P1pkGGD2cJp6EmL6uknrJ2xd+zR/c6pncakVQ5Npt/c=
=m3TS
-----END PGP SIGNATURE-----

--Signature=_Wed__20_Oct_2010_01_58_54_+1100_nEIM=STin97sJ.bG--
