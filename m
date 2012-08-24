Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757842Ab2HXKe2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 06:34:28 -0400
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:60515 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753871Ab2HXKeZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 06:34:25 -0400
Message-ID: <1345804456.9287.54.camel@lappyti>
Subject: Re: [PATCH v4 1/3] Runtime Interpreted Power Sequences
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
To: Alex Courbot <acourbot@nvidia.com>
Cc: Thierry Reding <thierry.reding@avionic-design.de>,
        Stephen Warren <swarren@nvidia.com>, Simon Glass <sjg@chromium.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Leela Krishna Amudala <leelakrishna.a@gmail.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Date: Fri, 24 Aug 2012 13:34:16 +0300
In-Reply-To: <6044581.2jEzZBWCu1@percival>
References: <1345097337-24170-1-git-send-email-acourbot@nvidia.com>
	 <20120821091306.GA4819@avionic-0098.mockup.avionic-design.de>
	 <1345542860.4085.40.camel@deskari> <6044581.2jEzZBWCu1@percival>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-4E5jpmn3JkyQUAiDm8Zk"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-4E5jpmn3JkyQUAiDm8Zk
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2012-08-24 at 18:24 +0900, Alex Courbot wrote:
> On Tuesday 21 August 2012 17:54:20 Tomi Valkeinen wrote:

> > And as I said, I don't have any problems with some kind of generic powe=
r
> > sequences. So the code in the board file could be moved and converted t=
o
> > use the power sequences, if that is better than just plain c code.
>=20
> My concern now is, provided that all drivers to their job and handle how =
their=20
> devices are switched on and off, when (if at all) are encoded power seque=
nces=20
> better than their equivalent C code? There is the matching database size =
issue=20
> that you mentionned, is it a sufficient concern to justify a new kernel f=
eature?

Good question.

I think obviously the worst solution is to have separate .c driver files
for each panel, where the drivers do 99% the same thing.

So the question is how to represent the 1% difference the panels have.

I think it depends on the panels. If it looks like all the panel have,
say, max 2 regulators and one reset/enable gpio, and they are always
enabled in the same order (regulators first, then the gpio), it should
be easy to handle it in the driver without any power sequence framework.

If the panels require more complex setups, then the code in the panel
driver would probably start to form into a power sequence framework, and
it would make sense to have it as a separate framework.

Then again, if the panel setup is complex, it makes me wonder if it'd be
just easier to handle it with c code in a separate driver.

Also, the database size issue is a bit separate issue. There's the db
size problem with or without the framework, if we do not pass the data
from DT.

So as clarification, I see 4 different options:
- Power sequences in DT (as proposed in this series)
- Custom panel data in DT, that the driver uses to power up properly
- Power sequences in a panel database in kernel
- Custom panel data in a panel db in kernel

> On the other hand some devices like panels are typically not used in many=
=20
> different appliances, so maybe it is not worth to separate them from thei=
r=20

Yep, this is the reason for my concern with the database size. The DB
could contain 10k panels, of which a board uses one. The rest just waste
memory. But then again, 10k panels is probably not a realistic amount.
It's difficult to guess the amount of memory used by such a database,
though. If it uses, say, 8kB, I'm not sure if it's a reason to panic.

And, as I mentioned, it could be optimized so that the driver throws
away the unneeded panels at __init. Of course here the problem is that
the panel needs to know what panels are needed.

> board definition. As Mark mentionned, having .dtsi files for the DT (and =
their=20
> equivalent .h for kernels that use platform data) might be a good middle=
=20
> ground.

I guess it's the perfectionist in me that leans toward handling it fully
in the kernel, as I think that's architecturally correct thing to do.
The DT data should contain parameters that can be configured per board,
or nodes (like regulators) that are needed by other parts of the DT
data.

If the only reason why to do it via DT is to avoid the possible size
problem with the panel database, perhaps what we should solve is the
optimization of the database. If that seems unsolvable, then DT approach
could be used as a workaround.

And I have to say I'm not too familiar with DT, so if I'm wrong about
what DT should contain, I'm all ears =3D).

 Tomi


--=-4E5jpmn3JkyQUAiDm8Zk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJQN1ioAAoJEPo9qoy8lh71EncP/RHUcx4gu5R9TA6l4zGNkNuB
saZ+3/v5yyTn752DpXO5FVJbNdGcEeq5hea1XDAECMTyI99dbUtQxcGNtmDW3t1R
BdCw7ZE/bCkOEnu05r4C/JFhavqMoKkpqYR9nVQIlJV8RUqLe5Ye9yT2UKNDUa+2
ljqlD1DJ216IT5ZPE6O6ukRwFpx6PWtbGKvgH5R3VsXE9cv69vSX6iAZGurgQLnk
rj8K+nQGWw3pJoAnNj3NJ8DZhq07jOeiLgQ+8lld/7uxVMP2f4Eo8rm1mtcH4Htr
5Qr1kvtYcIWC2UypMyCLAqXE3Am6mNxEvrugxERd9Pm3Viw8Yp30BYwaPqO5DTuM
PZmmrawIarfkxMs66MPeIs3eA5qmbeFvXo19lz4RN97c1As+xz78Nlmm2cAcJmxJ
5IjmBM0jKF6gNRsbOFlYbCuc4KwjmIdCifr03eY6/L5YATke7rHaWWCHVAQdGYSO
o5P+YTWV/HhzYrcxGFwabH/pWY0xiC95g5QYBYuLDjJc2eDliLYHXLq2Ob2AC4XT
vkdr4DFM8S1ekkVfRdPvATeuWOjHjvEt6TUfHIjK2XeFlU+F7pDeueFhJUX3hAO/
7AI//6dRKJBMeXCGvuDIHCtuoJdvSUeWLfuX1tHnpLUtzYSeT2TiEWEJASvai54d
9c//so8lHtE3LS6VgCy6
=zarw
-----END PGP SIGNATURE-----

--=-4E5jpmn3JkyQUAiDm8Zk--

