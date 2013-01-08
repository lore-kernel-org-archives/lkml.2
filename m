Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753568Ab3AHHPo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 02:15:44 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:59491 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038Ab3AHHPn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 02:15:43 -0500
Date: Tue, 8 Jan 2013 08:10:23 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Boris BREZILLON <linux-arm@overkiz.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Andrew Victor <linux@maxim.org.za>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>
Subject: Re: [PATCH v4 RESEND] pwm: atmel: add Timer Counter Block PWM driver
Message-ID: <20130108071023.GA2171@avionic-0098.adnet.avionic-design.de>
References: <1355994776-4764-1-git-send-email-linux-arm@overkiz.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qDbXVdCdHGoSgWSk"
Content-Disposition: inline
In-Reply-To: <1355994776-4764-1-git-send-email-linux-arm@overkiz.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:CUCqul9QjM2FPwxybO9zePDnstpnbfXGzxnmGDyM9uE
 ciQWG9eLcHHssEKHrEUMqFAxN2DSZYVTgtGERr42csvpTw35bt
 GTXoLA4h+N92c6MN8vqpmzS7Ir4D0bfQzpTFMhmXD6sO2zq04F
 foAtPXpLmn5WTUOJgyLCUxSYVq9R1K9Qr8hXf8dkQlglVhM4DW
 9UvBS2xVpPaEhjDvnFOJbvR33A85hOuaBwT3Bn2t5RH9sYVPIl
 VBtsB4OgUaautDzM3Pempbl5+boS66qK61sS2KXht+nwCGd1Zb
 FI9OZt40kSXDQ4W++BpbCQUYswdRmDvs0wQMWE1DGOsVoMGNtm
 9CkrNEkSK87hsiYWjUPT3G6fk8RF3faLVWJNrOuDimmxTs95J8
 TxwxsGOsK8TIK6H2uGvoUPi8ws6RnbiGwY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qDbXVdCdHGoSgWSk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 20, 2012 at 10:12:56AM +0100, Boris BREZILLON wrote:
> Hi,
>=20
> Sorry for resend. The previous version still has alignment issues on=20
> atmel_tcb_pwm_set_polarity, atmel_tcb_pwm_request and
> atmel_tcb_pwm_config function parameters.
>=20
> This patch adds a PWM driver based on Atmel Timer Counter Block.
> Timer Counter Block is used in Waveform generator mode.
>=20
> A Timer Counter Block provides up to 6 PWM devices grouped by 2:
> * group 0 =3D PWM 0 and 1
> * group 1 =3D PWM 1 and 2
> * group 2 =3D PMW 3 and 4

Should this be "PWM 2 and 3" and "PWM 4 and 5"? Or is PWM 1 shared
between groups 0 and 1?

> +static int atmel_tcb_pwm_request(struct pwm_chip *chip,
> +				 struct pwm_device *pwm)
> +{
[...]
> +	clk_enable(tc->clk[group]);

You need to check the return value of clk_enable(). There's always a
small possibility that it may fail.

> +static void atmel_tcb_pwm_disable(struct pwm_chip *chip, struct pwm_devi=
ce *pwm)
> +{
[...]
> +	/* If duty is 0 reverse polarity */
> +	if (tcbpwm->duty =3D=3D 0)
> +		polarity =3D !polarity;

Rather than commenting on what the code does, this should say why it
does so.

> +static int atmel_tcb_pwm_enable(struct pwm_chip *chip, struct pwm_device=
 *pwm)
> +{
[...]
> +	/* If duty is 0 reverse polarity */
> +	if (tcbpwm->duty =3D=3D 0)
> +		polarity =3D !polarity;

Same here.

> +static int atmel_tcb_pwm_probe(struct platform_device *pdev)
> +{
[...]
> +	struct atmel_tcb_pwm_chip *tcbpwm;
> +	struct device_node *np =3D pdev->dev.of_node;
> +	struct atmel_tc *tc;
> +	int err;
> +	int tcblock;
> +
> +	err =3D of_property_read_u32(np, "tc-block", &tcblock);
> +	if (err < 0) {
> +		dev_err(&pdev->dev,
> +			"failed to get tc block number from device tree (error: %d)\n",

Maybe: "failed to get Timer Counter Block number..." to make it
consistent with the error message below:

> +	tc =3D atmel_tc_alloc(tcblock, "tcb-pwm");
> +	if (tc =3D=3D NULL) {
> +		dev_err(&pdev->dev, "failed to allocate Timer Counter Block\n");
> +		return -ENOMEM;
> +	}
[...]
> +static const struct of_device_id atmel_tcb_pwm_dt_ids[] =3D {
> +	{ .compatible =3D "atmel,tcb-pwm", },
> +	{ /* sentinel */ }
> +};
> +MODULE_DEVICE_TABLE(of, mxs_pwm_dt_ids);

This is still wrong.

> +static struct platform_driver atmel_tcb_pwm_driver =3D {
> +	.driver =3D {
> +		.name =3D "atmel-tcb-pwm",
> +		.of_match_table =3D atmel_tcb_pwm_dt_ids,
> +	},
> +	.probe =3D atmel_tcb_pwm_probe,
> +	.remove =3D atmel_tcb_pwm_remove,
> +};
> +module_platform_driver(atmel_tcb_pwm_driver);
> +
> +MODULE_AUTHOR("Boris BREZILLON <b.brezillon@overkiz.com>");
> +MODULE_DESCRIPTION("Atmel Timer Counter Pulse Width Modulation Driver");
> +MODULE_ALIAS("platform:atmel-tcb-pwm");

I don't think you needMODULE_ALIAS() if the alias is the same as the
driver name.

Thierry

--qDbXVdCdHGoSgWSk
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQ68ZfAAoJEN0jrNd/PrOhArkQALf0m1p2mjiOeYMJUeXR6itC
Xo3owVg5QuZY4f7rWT31p7BJ2SFU6xVauhxK4CDgH+f2KnJ4qKeMsuC+mlo/JUTa
GTRWxytID2/mZCZuHnDXBDuESPDQlWZJ2V8Ul943Hs1ahcEQT9PzqFd7L0RsipBc
C0jsoxo3gHmTGBZodhDCCWJdMNRrzYWzjtwCBRGCmmdCxd8gEBubW51fViPCs3tr
xbPJWGrmFedzGzTdCkjNLIn8OArnjLl2IISYQMvcsbHve3B4+Z2PJcveYz6hpUlE
EBYzW0zoZqm6E77Gu2PE4Q3QdmsUHZI5P6XAAyl+8fcGqqdjpjEziWLY526nw/bC
R8Iobvdon4vZNBn9UpY6Py9x2fGZNwFpT1ohZbi5tpBqQyekumVF91V2e+R2g5JC
aAWAZZ4NSophKOxXVO05LvYc3AB5lTLfaAsT4zaORO0+cBirTRCFq44oyjauoh4C
ltH3CVIp/OavpnPaL5WHAi6iyUKja8X6NQRRwYut8U4803lsiigOQSHSB0xPNJB0
MSsfZwUFhuW15JFYJdj7pS+NdyWokB2WVWVHt3G5q4K0HvodQShUuyOz7nJB/L96
o4RzutpdrArvB9q/iJosxzaZF7JdojuJUwYjexIcTLBDQHzEq3oZN8D892PQMbs3
lzdgM7RJBQj8KhWMM9jG
=vyev
-----END PGP SIGNATURE-----

--qDbXVdCdHGoSgWSk--
