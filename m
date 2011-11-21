Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756703Ab1KUUIn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 15:08:43 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:45466 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751670Ab1KUUIl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 15:08:41 -0500
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: David Daney <ddaney.cavm@gmail.com>
Subject: Re: [PATCH RFC 1/5] scripts: Add sortextable to sort the kernel's exception table.
Date: Mon, 21 Nov 2011 15:08:37 -0500
User-Agent: KMail/1.13.7 (Linux/3.1.1; KDE/4.6.5; x86_64; ; )
Cc: linux-mips@linux-mips.org, ralf@linux-mips.org,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-embedded@vger.kernel.org, x86@kernel.org,
        David Daney <david.daney@cavium.com>
References: <1321645068-20475-1-git-send-email-ddaney.cavm@gmail.com> <201111211350.58916.vapier@gentoo.org> <4ECAA374.2040102@gmail.com>
In-Reply-To: <4ECAA374.2040102@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1759691.6lAoAVt38i";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201111211508.39398.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1759691.6lAoAVt38i
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Monday 21 November 2011 14:16:04 David Daney wrote:
> On 11/21/2011 10:50 AM, Mike Frysinger wrote:
> > On Monday 21 November 2011 13:25:36 David Daney wrote:
> >> On 11/20/2011 03:22 PM, Mike Frysinger wrote:
> >>> On Friday 18 November 2011 14:37:44 David Daney wrote:
> >>>> +	switch (w2(ehdr->e_machine)) {
> >>>> +	default:
> >>>> +		fprintf(stderr, "unrecognized e_machine %d %s\n",
> >>>> +			w2(ehdr->e_machine), fname);
> >>>> +		fail_file();
> >>>> +		break;
> >>>> +	case EM_386:
> >>>> +	case EM_MIPS:
> >>>> +	case EM_X86_64:
> >>>> +		break;
> >>>> +	}  /* end switch */
> >>>=20
> >>> unlike recordmcount, this file doesn't do anything arch specific.  so
> >>> let's just delete this and be done.
> >>=20
> >> Not really true at this point.  We don't know the size or layout of the
> >> architecture specific exception table entries, likewise for
> >> CONFIG_ARCH_HAS_SORT_EXTABLE, we don't even know how to do the
> >> comparison.
> >=20
> > all of your code that i could see is based on "is it 32bit or is it
> > 64bit". there is no code that says "if it's x86, we need to do XXX".
>=20
> At this point there is no need.  MIPS, i386 and x86_64 all store the key
> in the first word of a two word structure.
>=20
> If there were some architecture that didn't fit this model, we would
> have to create a special sorting function and select it (and perhaps
> other parameters as well) in that switch statement.

that's trivial to check:
	sed -n '/^struct exception_table_entry/,/};/p'\
		arch/*/include/asm/uaccess* include/asm-generic/uaccess.h=20

and indeed, the only arches that don't follow this model are the ones that=
=20
define ARCH_HAS_SORT_EXTABLE.

> > when i look in the kernel, we have common code behind
> > ARCH_HAS_SORT_EXTABLE. so you could easily do the same thing:
> >=20
> > scripts/sortextable.c:
> > 	#ifdef ARCH_HAS_SORT_EXTABLE
> > =09
> > 		switch (w2(ehdr->e_machine)) {
> > 	=09
> > 		default:
> > 			fprintf(stderr, "unrecognized e_machine %d %s\n",
> > 		=09
> > 				w2(ehdr->e_machine), fname);
> > 		=09
> > 			... return a unique exit code like 77 ...
> > 			break;
> > 	=09
> > 		/* add arch sorting info here */
> > 		}  /* end switch */
> > =09
> > 	#endif
> >=20
> > kernel/extable.c:
> > 	#if defined(ARCH_HAS_SORT_EXTABLE)&&  !defined(ARCH_HAS_SORTED_EXTABLE)
> > 	void __init sort_main_extable(void)
> > 	{
> > =09
> > 		sort_extable(__start___ex_table, __stop___ex_table);
> > =09
> > 	}
> > 	#endif
>=20
> Yes, I am familiar with that code.  One thing to keep in mind is that
> the compiler has access to struct exception_table_entry, and can easily
> figure out both how big the structure is *and* where the insn field is
> within the structure.
>=20
> This is not the case for the author of sortextable.  Except for MIPS,
> MIPS64, i386 and x86_64, I know neither the size of struct
> exception_table_entry, nor the offset of its insn field.

a trivial sed/grep gets you the answer: they're all the same

> > this way all the people not doing unique stuff work out of the box.  on=
ly
> > the people who are doing funky stuff need to extend things.
>=20
> I didn't want to include something like this that I cannot test.  An
> unsorted (or improperly sorted) exception table is not necessarily
> something that will be noticeable by simply booting the kernel.  Your
> only indication may be a panic or OOPS under rarely encountered condition=
s.

this is what linux-next is for :)
=2Dmike

--nextPart1759691.6lAoAVt38i
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iQIcBAABAgAGBQJOyq/HAAoJEEFjO5/oN/WBoCYP/0UXHxMgqL2/Y6mYI8SWv9j1
bGpyabcFESLzJ6S0QtiM0LAtDTT8epHa/wBXtN52V7lfTTxhviNeK7WIqhorn4pT
3GTUA1R4JpcOC9Gnt1hpG/CSugDMuKVwquK69DhlKxp1Cfa8wN1P8dtnh545nHjX
XedfFYzeeHzCQx6ZO6P+Cc85U5BimRLhGK9FPeqAMKsgerzT+hKsAVffgh4gNmqo
XsEGOvby34VO9SmOLTtYfxZ91sENewJ1PwiLPjgq0aN5P6fkOpV+Y9668szE+8Pj
mB9sGuraD4aSsHVgDaf+afEEvxb+JOjVcMuOGNjLkYQcJP6o7DaiuyAPD1mLeSaA
YQIvuYX/1WYYsDR2sLHHRu/bKa645xILFzn6+VB4tJBs3a+6u4436aS4i72Q6I22
6h5Nfb/kh2l5WIyj4tsMszyx/XzeKoQ7+7wOkRbHbVvVFExMtuCHlxcCz62w+p18
kz2o6UjrvYBn+ddbme+9HnU9pgzF7PeZjQuoo0w6bjeCMSX4gM6JbBFRouoEWcrV
n6sVeNtt7RzzJg3Z89URkgzx1ireAFzb1dvW9qRt4akH1AUpg5bE7dFs1qJ6mK/b
UJ8zccOnhrhcRT4bvBKva59awy2wG8dstmjVzJqmtDUJWmPkLiVH8Yu45pOUpbw5
TRFYFyh4xbhEk7KlGWjQ
=IRxP
-----END PGP SIGNATURE-----

--nextPart1759691.6lAoAVt38i--
