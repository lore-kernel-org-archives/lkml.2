Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934671Ab2JXJsD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 05:48:03 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:52020 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933581Ab2JXJr7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 05:47:59 -0400
Date: Wed, 24 Oct 2012 20:47:46 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: akpm@linux-foundation.org, a.p.zijlstra@chello.nl, xemul@parallels.com,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: + procfs-add-vmflags-field-in-smaps-output-v3-fix-2.patch added
 to -mm tree
Message-Id: <20121024204746.8a8c0fa14b6495b5d5013db4@canb.auug.org.au>
In-Reply-To: <20121024084515.GB30983@moon>
References: <20121023220300.1185C200057@hpza10.eem.corp.google.com>
	<20121024084515.GB30983@moon>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__24_Oct_2012_20_47_46_+1100_oB_utr0uCmFqsvrW"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__24_Oct_2012_20_47_46_+1100_oB_utr0uCmFqsvrW
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Cyrill,

On Wed, 24 Oct 2012 12:45:15 +0400 Cyrill Gorcunov <gorcunov@openvz.org> wr=
ote:
>
>  static void show_smap_vma_flags(struct seq_file *m, struct vm_area_struc=
t *vma)
>  {
> +#define __VM_FLAG(_f, _s)	[ilog2(_f)] =3D {(const char [2]){_s}}

I really don't think you need the cast (and it may hide bad usages) or
the second set of braces.  Thus:

#define __VM_FLAG(_f, _s)	[ilog2(_f)] =3D {_s}

> +
>  	/*
>  	 * Don't forget to update Documentation/ on changes.
>  	 */
> @@ -491,46 +493,49 @@ static void show_smap_vma_flags(struct s
>  		/*
>  		 * In case if we meet a flag we don't know about.
>  		 */
> -		[0 ... (BITS_PER_LONG-1)] =3D { {'?', '?'} },
> +		[0 ... (BITS_PER_LONG-1)] =3D { (const char [2]){"??"} },

And here.

Further is there any reason for the struct?

#define __VM_FLAG(_f, _s)	[ilog2(_f)] =3D _s

static const char mnemonics[BITS_PER_LONG][2] =3D {
...
};

>  	seq_puts(m, "VmFlags: ");
>  	for (i =3D 0; i < BITS_PER_LONG; i++) {
> -		if (vma->vm_flags & (1 << i))
> +		if (vma->vm_flags & (1ul << i)) {
>  			seq_printf(m, "%c%c ",
>  				   mnemonics[i].l[0],
>  				   mnemonics[i].l[1]);

				   mnemonics[i][0], mnemonics[i][1]

/me looks for another bike shed :-)
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__24_Oct_2012_20_47_46_+1100_oB_utr0uCmFqsvrW
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQh7lCAAoJEECxmPOUX5FEWlAP/j++DACL1paQJjRkNImLADA3
HrH2TFKZPymgzDr40oqISF3JzuL6dVo8ZpBM692Sc+w9VYXd0+EPzHBk9/KdubHk
WNLotzDYP9Wdor/tKBwAgpKNeBJ/kMNI9qEi8bg8kzMoyZvLOH0pniVjWXx2Qid1
0fJCCrdHR4V5Q5d5NZatHfjeeiN3GAmzuVPQkSwFZV0SVvX0CyyIVMcaevu87L+0
lUVNrlPxJrezkiGHIu2q4+s40EOJL8RX7kQzunbVN/1CGO3gc7/Kzm/7YqQ5J77S
TRioNmEMOkMCoElPr6ibiILLFcdx7az281vvpYcVvs516kTTR5z2DBTa+InnbKHG
iqtPtoGNhRTyq1Jk4HFOp9bEEUnPiTv+mPORVR1uxJKX81ltwsCb3omtn9kfEla4
hNC14HYs9MRIUsfx0R1LJOWi++JFx3xSB8Ia0rDHO4ybU6njeo0a8YKCW1HNwtb0
Yl4lVJX6gXM5OySGdntV7ULVuM8uAu+N3F893MfJDfm04+Yc5iVv6Nt0Mk9Ohz6y
WnQ7KN9sS4jwPu3vG9hYO4G2KgSmSh5LAv2MMYiTYjNiosGiZ5pvXFbplymnJt8E
3Z47JJ3O/Ea2eiprYU4JxXegUHYbSZ7xlX1yvhn9jgpvkfOURT/1kxN6MARhh23H
bLTt1wZI57qFoUrxxhrM
=kNmG
-----END PGP SIGNATURE-----

--Signature=_Wed__24_Oct_2012_20_47_46_+1100_oB_utr0uCmFqsvrW--
