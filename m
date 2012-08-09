Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756190Ab2HIIHb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 04:07:31 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:60116 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755366Ab2HIIHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 04:07:18 -0400
Date: Thu, 9 Aug 2012 10:07:13 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Takashi Iwai <tiwai@suse.de>
Cc: Jaroslav Kysela <perex@perex.cz>,
        David Henningsson <david.henningsson@canonical.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ALSA: hda - Defer probe when loading patch firmware
Message-ID: <20120809080713.GC24808@avionic-0098.mockup.avionic-design.de>
References: <1344494723-6827-1-git-send-email-thierry.reding@avionic-design.de>
 <s5hhascft86.wl%tiwai@suse.de>
 <20120809070813.GA6979@avionic-0098.mockup.avionic-design.de>
 <s5hd330frn1.wl%tiwai@suse.de>
 <20120809073642.GA24695@avionic-0098.mockup.avionic-design.de>
 <s5h7gt8fr47.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ALfTUftag+2gvp1h"
Content-Disposition: inline
In-Reply-To: <s5h7gt8fr47.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:WChr0QcPYh4SUmbNZmk/Ob4ugxTtX2kNiRf6+x3VZ5D
 QTHG3JSK5nuWFT07sEo0hlG6EQHgYSO4WEAkdmuCY3ej1ZQhig
 sQ+trf8ZBqZZLnUA/SF83HOlAmXln1t5T0XnMMsDE44jn7r5us
 IeJsTJVG1+r8efGJoDzorpQfLroej4a/e6LlT8+LyVe6YghttJ
 OnrNg6WZac+kAIvR/MvwUwzHmXTi+qWapFdyhcA+KpZL4xZ2aa
 wIqQUyj58eka9Yn82JjrzZeq0IBPaADtxwdZYOsEg3Yub00pqh
 CvDThpODmKwLWIPUIErKv8c0xblNgshf5x4vQL+MC5/ShoOhev
 FH+nFvwgfIhj+poutKMSrZO1sobE4M3ky7w3x+t4F/Y7BDDwFQ
 xt+f/+9ZBHPfoO/mwUHF5Kkk3lgoqPDGcmZfrPJqhuZruWQ3k9
 2aLvF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ALfTUftag+2gvp1h
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 09, 2012 at 09:42:48AM +0200, Takashi Iwai wrote:
> At Thu, 9 Aug 2012 09:36:42 +0200,
> Thierry Reding wrote:
> >=20
> > On Thu, Aug 09, 2012 at 09:31:30AM +0200, Takashi Iwai wrote:
> > > At Thu, 9 Aug 2012 09:08:13 +0200,
> > > Thierry Reding wrote:
> > > >=20
> > > > On Thu, Aug 09, 2012 at 08:57:13AM +0200, Takashi Iwai wrote:
> > > > > At Thu,  9 Aug 2012 08:45:23 +0200,
> > > > > Thierry Reding wrote:
> > > > > >=20
> > > > > > Recent changes to the firmware loading helpers cause drivers to=
 stall
> > > > > > when firmware is loaded during the module_init() call. The snd-=
hda-intel
> > > > > > module requests firmware if the patch=3D parameter is used to l=
oad a patch
> > > > > > file. This patch works around the problem by deferring the prob=
e in such
> > > > > > cases, which will cause the module to load successfully and the=
 driver
> > > > > > binding to the device outside the module_init() call.
> > > > >=20
> > > > > Is the "recent" change meant 3.6 kernel, or in linux-next?
> > > > >=20
> > > > > In anyway, I don't understand why such a change was allowed.  Most
> > > > > drivers do call request_firmware() at the device probing time.
> > > > > If this really has to be resolved in the driver side, it must be =
a bug
> > > > > in the firmware loader core code.
> > > >=20
> > > > A good explanation of the problem and subsequent discussion can be =
found
> > > > here:
> > > >=20
> > > > 	http://article.gmane.org/gmane.linux.drivers.video-input-infrastru=
cture/49975
> > >=20
> > > Yeah, but it doesn't justify this ugly module option.
> > > It's a simple bug.  Papering over it with this option doesn't fix
> > > anything.
> >=20
> > It's not an option, all it does is defer probing if and only if the
> > patch parameter was specified to make sure the firmware load won't
> > stall. I realize that this may not be an optimal solution, but at least
> > it fixes the problem with no fallout.
>=20
> Ah sorry, I misread the patch.
>=20
> Then it shouldn't be checked at that point.  Since 3.5 kernel, the
> probing code was already split for vga_switcheroo support.

Yes, I saw that. But unless you actually use vga_switcheroo, the second
stage, azx_probe_continue(), will still be called from azx_probe() and
therefore ultimately from module_init().

Before coming up with this patch I actually did play around a bit with
using the asynchronous firmware load functions but it turned out to be
rather difficult to do so I opted for the easy way. The biggest problem
I faced was that since patch loading needs to be done very early on, a
lot of the initialization would need to be done after .probe() and many
things could still fail, so cleaning up after errors would become
increasingly difficult.

> The point you added is the second stage.

I don't understand this sentence.

Thierry

--ALfTUftag+2gvp1h
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQI2+xAAoJEN0jrNd/PrOhG0wQAK7trGSUmaPTd5R5TcSi7Vf0
khWVDAFYenheo3ZUqb4mdPZMA8VoaL0o/DZ+tRi7rj8lxYGR3XO53WmXp5RMWx0b
+UHr33K1sJvtJWypfuejt2qqxhWlU9dqEGdcV2ZAhM9ImEkWftEAjG9BK8ooJi0Q
GCGe4ijYFkybaSmI9QJ6ktVVt99f+cMy9j9+lJN3PuixcVpt6HEV1msgKAP4gg78
x6vduw4/D9r68kQxi3VKQY9eMRr2B+x3m/7ZDddT9MmHG1DMjYr0Uv0VGQjAYlJ9
xP+ynkzDyd6LeirQ1lTbCRjuSK7Wqfd6SCqWff2mFDOfS262rbO4ZpLCxyXlYGqn
ZE2bzyyFHQApWkpBJmcw5lhZt1/4GsbGt9WnW4BLot2pmOk61eHv+It2AGLln8iq
SlFXoVK2NrjDiFmgU9atzjz9iAzM1knjCq2RH+uqVyETukgPPrl8i3VgYMRc4DLt
ntPPgPl3W7Mcd1VcvaZDhppnrlKd8Pb1ObKHNlsGK7Qjwk0WeeWlE+ODqf9kX4xT
+bvsffUpX72vhvJeQ36OWTER4YFH3xOzbUcy4wItfJ6/sSaFNxD0f9QfOUdZdBW/
qD5OkQAdZcS8xqqrg/qP/51ULaPn4FB8vTmpAYtCkFt3nxssnlDWyTfpNykxHZzF
gMpVtwzBPI6Bz8SBjObe
=T8J3
-----END PGP SIGNATURE-----

--ALfTUftag+2gvp1h--
