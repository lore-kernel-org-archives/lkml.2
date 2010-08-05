Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933192Ab0HELmo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 07:42:44 -0400
Received: from gate.lvk.cs.msu.su ([158.250.17.1]:57228 "EHLO
	mail.lvk.cs.msu.su" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759080Ab0HELml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 07:42:41 -0400
X-Spam-ASN: 
Date: Thu, 5 Aug 2010 15:42:31 +0400
From: Alexander Gordeev <lasaine@lvk.cs.msu.su>
To: Rodolfo Giometti <giometti@enneenne.com>
Cc: linux-kernel@vger.kernel.org, "Nikita V. Youshchenko" <yoush@cs.msu.su>,
        linuxpps@ml.enneenne.com, john stultz <johnstul@us.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Joonwoo Park <joonwpark81@gmail.com>
Subject: Re: [PATCHv3 05/16] pps: access pps device by direct pointer
Message-ID: <20100805154231.52555130@desktopvm.lvknet>
In-Reply-To: <20100805093236.GI26615@gundam.enneenne.com>
References: <cover.1280952801.git.lasaine@lvk.cs.msu.su>
	<244e91439eeb1c835b6fa82999fcd65a8a282183.1280952801.git.lasaine@lvk.cs.msu.su>
	<20100805093236.GI26615@gundam.enneenne.com>
Organization: LVK
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA256;
 boundary="Sig_/LH1311t+VP3SuBPENOhKzgu"; protocol="application/pgp-signature"
X-AV-Checked: ClamAV using ClamSMTP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/LH1311t+VP3SuBPENOhKzgu
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

=D0=92 Thu, 5 Aug 2010 11:32:36 +0200
Rodolfo Giometti <giometti@enneenne.com> =D0=BF=D0=B8=D1=88=D0=B5=D1=82:

> On Thu, Aug 05, 2010 at 01:06:42AM +0400, Alexander Gordeev wrote:
> > Using device index as a pointer needs some unnecessary work to be done
> > every time the pointer is needed (in irq handler for example).
> > Using a direct pointer is much more easy (and safe as well).
> >=20
> > Signed-off-by: Alexander Gordeev <lasaine@lvk.cs.msu.su>
[snip]
>=20
> If you remove these functions you can't be sure anymore that nobodies
> may call pps_event() over a non existent device...

[snip]

> By dropping pps_get_source you may be here by a call from (i.e.) a
> serial port driver whose doesn't know if your PPS source is gone or
> not...
>=20
> I don't understand how your modifications may resolve this problem.

Well, this can happen only if PPS client module calls pps_event before
calling pps_register_source() or after pps_unregister_source(). This
means that it's broken! If we try to handle/workaround broken clients it
affects performance. So we have to choose what is the priority:
security or performance. My guru told me I shouldn't bother too much
about broken kernel-space code which my code interacts with. If it's
broken it should be fixed. Some assertions enabled by DEBUG define are
enough. For me it makes sense but I don't know what should I check here?

Well I can add something like that to pps_event:

BUG_ON((pps =3D=3D NULL) || (pps_get_source(pps->id) !=3D pps));

where pps_get_source is:

static inline struct pps_device *pps_get_source(int source)
{
	struct pps_device *pps;
	unsigned long flags;

	spin_lock_irqsave(&pps_idr_lock, flags);
	pps =3D idr_find(&pps_idr, source);
	spin_unlock_irqrestore(&pps_idr_lock, flags);

	return pps;
}

BTW, while looking at the code to answer your question I've found a
bug: struct pps_device was not kfree'd on device destruction. The fix
will appear soon. Perhaps with an assertion above if you like it.

--=20
  Alexander

--Sig_/LH1311t+VP3SuBPENOhKzgu
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iQEcBAEBCAAGBQJMWqOnAAoJEElrwznyooJbHs8H/RgVMc14O3G2Zv4uaCEjoKTT
knhmNtOTsTdGjEtza7WY5viGRZIe9iP79T/j8t0e3V7AZnoIxO8WucuRP5MBkROI
74w7UFq1ZbS04vgKfLRwUYAp9OmmufGCXxKbUUUsHptItCFmz4A/WemqvRP4Nz6f
fQ35xutmI2FOXF/a21LHrR15y030OmHeCRlknzDAZpzXwf4JM/TCfTPB9YunO85t
M0ND/M+U+sxQMCalVzgLkFSIfTBCYvz2pygbr0/pXe8BMg+n1E0zzEFnFr3CQfam
b6jj1sBKSBcMRqNpIRIPi8qMqw/AdeLS+lciO6YdS8xzaG+mTFhTrHhNa5LoExI=
=1vfS
-----END PGP SIGNATURE-----

--Sig_/LH1311t+VP3SuBPENOhKzgu--
