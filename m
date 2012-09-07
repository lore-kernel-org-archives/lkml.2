Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760629Ab2IGMu6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 08:50:58 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:51750 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755621Ab2IGMuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 08:50:55 -0400
Date: Fri, 7 Sep 2012 14:50:35 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: guanxuetao@mprc.pku.edu.cn
Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>, Mike Turquette <mturquette@linaro.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] unicore32: pwm: Properly remap memory-mapped
 registers
Message-ID: <20120907125035.GA29340@avionic-0098.mockup.avionic-design.de>
References: <1346581273-7041-1-git-send-email-thierry.reding@avionic-design.de>
 <1346581273-7041-2-git-send-email-thierry.reding@avionic-design.de>
 <63235.162.105.203.8.1346920695.squirrel@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Kj7319i9nmIyA2yE"
Content-Disposition: inline
In-Reply-To: <63235.162.105.203.8.1346920695.squirrel@mprc.pku.edu.cn>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:3tKtdt0rN4hMRjiycangcKccJSic/PsWJfpLLhh2yj9
 0pUob+2x6Gqj5Srm8TcGLRh1dONzr3cxwcl2YIBPHWSEoq7LZx
 pxU0KfH/xGSYiDkbhglAm4aFHhb6kHnUa1djR41tli5emTkE9S
 /tsjxZCukFL6y7nCGlWRw3Ry4T0elU6u9/Lxihu1/L14SmX1BT
 BYTT+dA3wmBj6RDqj0X3Gm26fMik8ugq2y4+Rurwlg0Cn0ZUFO
 RhujNSU9HsGMvKh5FZ3yRQbgkL3+S2ued5xlBcGdTMCjxXrTbj
 4Qe5dpjWFPhXRtjGgF6dnGOITJ1KJj8SqWNTSv0iJlmC6m4PGX
 1kXWhNDbQhUesAqZoDDXQsiG7+ku15pssu4Vdxvf6eKNjXvhEu
 WYByIoXRRvzbiCemm96xiGyO4RQp7fhoDmBVRgKiHOt1ELqtwe
 WlxeT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Kj7319i9nmIyA2yE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 06, 2012 at 04:38:15PM +0800, guanxuetao@mprc.pku.edu.cn wrote:
> > Instead of writing to the timer controller registers by dereferencing a
> > pointer to the memory location, properly remap the memory region with a
> > call to ioremap_nocache() and access the registers using writel().
> >
> > Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
> > ---
> >  arch/unicore32/kernel/pwm.c | 25 ++++++++++++++++++++++---
> >  1 file changed, 22 insertions(+), 3 deletions(-)
> >
> > diff --git a/arch/unicore32/kernel/pwm.c b/arch/unicore32/kernel/pwm.c
> > index 4615d51..410b786 100644
> > --- a/arch/unicore32/kernel/pwm.c
> > +++ b/arch/unicore32/kernel/pwm.c
> > @@ -23,10 +23,16 @@
> >  #include <asm/div64.h>
> >  #include <mach/hardware.h>
> >
> > +#define PWCR 0x00
> > +#define DCCR 0x04
> > +#define PCR  0x08
> I think old register names could be used here by some small modifications.
> Please see arch/unicore32/include/mach/regs-ost.h
> We can avoid ioremap and use writel/readl directly on these registers.
>=20
> Guan

The whole point of this patch was to make the PWM driver behave more
like other drivers. If the registers are addressed directly, there is no
way that the driver will work for a second instance of the PWM
controller. I know that there probably is no second instance right now,
but given that pretty much every regular driver accesses its register
through the ioremap()'ed addresses and this patch doesn't go through
hoops to achieve this, I think this is a perfectly valid cleanup.

Thierry

> > +
> >  struct pwm_device {
> >  	struct list_head	node;
> >  	struct platform_device *pdev;
> >
> > +	void __iomem	*base;
> > +
> >  	const char	*label;
> >  	struct clk	*clk;
> >  	int		clk_enabled;
> > @@ -69,9 +75,11 @@ int pwm_config(struct pwm_device *pwm, int duty_ns, =
int
> > period_ns)
> >  	 * before writing to the registers
> >  	 */
> >  	clk_enable(pwm->clk);
> > -	OST_PWMPWCR =3D prescale;
> > -	OST_PWMDCCR =3D pv - dc;
> > -	OST_PWMPCR  =3D pv;
> > +
> > +	writel(prescale, pwm->base + PWCR);
> > +	writel(pv - dc, pwm->base + DCCR);
> > +	writel(pv, pwm->base + PCR);
> > +
> >  	clk_disable(pwm->clk);
> >
> >  	return 0;
> > @@ -190,10 +198,19 @@ static struct pwm_device *pwm_probe(struct
> > platform_device *pdev,
> >  		goto err_free_clk;
> >  	}
> >
> > +	pwm->base =3D ioremap_nocache(r->start, resource_size(r));
> > +	if (pwm->base =3D=3D NULL) {
> > +		dev_err(&pdev->dev, "failed to remap memory resource\n");
> > +		ret =3D -EADDRNOTAVAIL;
> > +		goto err_release_mem;
> > +	}
> > +
> >  	__add_pwm(pwm);
> >  	platform_set_drvdata(pdev, pwm);
> >  	return pwm;
> >
> > +err_release_mem:
> > +	release_mem_region(r->start, resource_size(r));
> >  err_free_clk:
> >  	clk_put(pwm->clk);
> >  err_free:
> > @@ -224,6 +241,8 @@ static int __devexit pwm_remove(struct platform_dev=
ice
> > *pdev)
> >  	list_del(&pwm->node);
> >  	mutex_unlock(&pwm_lock);
> >
> > +	iounmap(pwm->base);
> > +
> >  	r =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
> >  	release_mem_region(r->start, resource_size(r));
> >
> > --
> > 1.7.12
> >
>=20
>=20
>=20

--Kj7319i9nmIyA2yE
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQSe2bAAoJEN0jrNd/PrOh7pQQAJqGVzdnsGr5JN5+c/T+eR7N
LeNr3HXw+Q+5YHoVfSrBagp0nVwwGdEL2MksktK+6se5VHWXsy/n0d8VBRMzIDoO
9qCecfht/neX6ZvpwWjFLW50vkoZscoBLtD2o3A9M3gs0n7ZuSa90JGO0Yl/PiKr
HTjqqb3ZqXHTfB373PvVSzEDCTmjcsPpTD3F1HGVO5rV049rYpn2Gf1lJh4bxRsf
oZKBtM7LFWF8Yviogssnhug/pWJlGrM7I7CD2sSLzO6Mvv/xflF32shLXMGZyj+N
9W655PURNsUrirYgKHS92XA5BnwTCha0iQLKC6XL7g0l3x6Eqx4u7G+lcqB/DjIC
VSd227Gdl+Cqye8P6CIkGpgmIw6FtQk53jqm7IzXq8TOn5BWpCk0SOiD7mLCadCo
cGilvSBBl1eC/Rpev+GAfXI0nXXcrKCu7BqOY/tlLA1aRkG4CIuS8uaWYTgxPm8M
Tzas12b6fq1yWC01p3+2p7hbxoAXuiax+xthg+iuaclDqAnhRJw37YUJj+SS631E
gqdiQbMebcqCZNGgy+QDBFb/qu0O/vcsK/2dX4ySDNjvGjVHf31SLyvDppeBGONO
iATIqxejOwNMdZ79XpxTn0e+/EiAiD6gCAwCAJ0h3zko3PvnZ+Zc4tMMjlwZcj9+
1kYdi/DSk6+qkLJn0AgN
=abUr
-----END PGP SIGNATURE-----

--Kj7319i9nmIyA2yE--
