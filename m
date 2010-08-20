Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751993Ab0HTRnM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 13:43:12 -0400
Received: from mtaout02-winn.ispmail.ntl.com ([81.103.221.48]:26476 "EHLO
	mtaout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751784Ab0HTRnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 13:43:09 -0400
From: Ian Campbell <ijc@hellion.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Greg KH <gregkh@suse.de>
In-Reply-To: <AANLkTinqUa6qwFKCjG0ww7Rq4ath0LtNH5yuMNOai=Z7@mail.gmail.com>
References: <20100818203143.735033743@clark.site>
	 <1282308887.3170.5439.camel@zakaz.uk.xensource.com>
	 <AANLkTin7L=v1GR2=U-mvESyrP2vySYLRa4U-fh9-L38F@mail.gmail.com>
	 <AANLkTim1ABgiwscmaTZxeO9FxB4FacUNe0ahzUctQkn6@mail.gmail.com>
	 <AANLkTinqUa6qwFKCjG0ww7Rq4ath0LtNH5yuMNOai=Z7@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-Zqv9107XNwJ+d66bWp0Y"
Date: Fri, 20 Aug 2010 18:43:02 +0100
Message-ID: <1282326182.29609.789.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
X-SA-Exim-Connect-IP: 192.168.1.7
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: Re: [2/3] mm: fix up some user-visible effects of the stack guard
 page
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
X-Cloudmark-Analysis: v=1.1 cv=4QByPj+6Iq2k/6L54d+eVKTdgQxdscpRskJJReCfdXo= c=1 sm=0 a=isDwiucj6PoA:10 a=Z4Rwk6OoAAAA:8 a=3kiAjA4kGuRBMZo4KM8A:9 a=A_Oq5kbJnAtRwE8BVynfoFipVmgA:4 a=wPNLvfGTeEIA:10 a=jbrJJM5MRmoA:10 a=8qN4eHysdWosld3ynxMA:9 a=f-qCW-El6TKJBEtXFsUKrbhQKNUA:4 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Zqv9107XNwJ+d66bWp0Y
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: quoted-printable

On Fri, 2010-08-20 at 09:24 -0700, Linus Torvalds wrote:
> On Fri, Aug 20, 2010 at 9:07 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > That said, it does strike me as rather odd to do VM ops on partial
> > stacks. What are you doing, exactly, to hit this?
>=20
> The reason I ask is that the _sane_ thing to do - if we really care
> about this - is to change the 'vm_next' singly-linked list into using
> 'list.h'. It would clean up a fair amount of stuff, like removing the
> need for that disgusting 'find_vma_prev()' thing. There are actually
> several users of vma's that want to look at the previous vma, but
> because it's hard to get at, they do something non-intuitive or odd.

I wasn't sure at first what you were getting at here, so let me see if I
figured it out...

If we could easily get at the previous VMA (instead of just the next
one) then we could easily check if we were mlocking a VM_GROWSDOWN
region which had another VM_GROWSDOWN region immediately below it and
therefore avoid introducing a guard page at the boundary. Doing this
check is currently too expensive because of the need to use
find_vma_prev. Is that right?

> At the same time, we've had that vm_next pointer since pretty much day
> one, and I also get a strong feeling that it's not really worth the
> churn.

It does look like a big task, but if it seems like the only sane option
I'll take a look at it and see if can be broken down into manageable
stages.

You mentioned making this a tunable in your original commit message,
that would at least help in the short term so I may look into that too.
(prctl would be the right interface?)

I wonder if there's any way to auto tune, for example automatically
disabling the guard page for a process which mlocks only part of its
stack VMA. That would obviously target the specific issue I'm seeing
pretty directly and would only reopen the hole for applications which
were already doing odd things (c.f. your earlier comment about the guard
page not being magic or helping with wilfully crazy userspace).

Ian.

--=20
Ian Campbell

Let he who takes the plunge remember to return it by Tuesday.

--=-Zqv9107XNwJ+d66bWp0Y
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkxuvqYACgkQM0+0qS9rzVnxzgCfXTU71KttJRYV3IjqJ+NcIPn7
aY4An0IbU4YYj+Utht8EQ3cepiKHz32i
=WZOn
-----END PGP SIGNATURE-----

--=-Zqv9107XNwJ+d66bWp0Y--

