Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760022Ab2J2Q0n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 12:26:43 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:46014 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759698Ab2J2Q0k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 12:26:40 -0400
Date: Mon, 29 Oct 2012 18:20:45 +0200
From: Felipe Balbi <balbi@ti.com>
To: Sourav Poddar <sourav.poddar@ti.com>
CC: <dmitry.torokhov@gmail.com>, <linux-input@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <b-cousson@ti.com>, <balbi@ti.com>,
        <santosh.shilimkar@ti.com>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv5] Input: keypad: Add smsc ece1099 keypad driver
Message-ID: <20121029162045.GK27566@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1351507129-10229-1-git-send-email-sourav.poddar@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1hKfHPzOXWu1rh0v"
Content-Disposition: inline
In-Reply-To: <1351507129-10229-1-git-send-email-sourav.poddar@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--1hKfHPzOXWu1rh0v
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Oct 29, 2012 at 04:08:49PM +0530, Sourav Poddar wrote:
> +static int __devinit
> +smsc_probe(struct platform_device *pdev)
> +{
> +	struct device *dev =3D &pdev->dev;
> +	struct input_dev *input;
> +	struct smsc_keypad *kp;
> +	int ret =3D 0;
> +	int i, max_keys, row_shift;
> +	int irq;
> +	int addr;
> +
> +	kp =3D devm_kzalloc(dev, sizeof(*kp), GFP_KERNEL);
> +
> +	input =3D devm_input_allocate_device(dev);
> +	if (!kp || !input)
> +		ret =3D -ENOMEM;
> +
> +	ret =3D smsc_keypad_parse_dt(dev, kp);
> +	if (ret)
> +		return ret;
> +
> +	/* Get the debug Device */
> +	kp->input =3D input;
> +	kp->irq =3D platform_get_irq(pdev, 0);
> +	kp->dev =3D dev;
> +
> +	/* setup input device */
> +	 __set_bit(EV_KEY, input->evbit);
> +
> +	/* Enable auto repeat feature of Linux input subsystem */
> +	if (!kp->no_autorepeat)
> +		__set_bit(EV_REP, input->evbit);
> +
> +	input_set_capability(input, EV_MSC, MSC_SCAN);
> +	input->name             =3D "SMSC Keypad";
> +	input->phys             =3D "smsc_keypad/input0";
> +	input->dev.parent       =3D &pdev->dev;
> +	input->id.bustype       =3D BUS_HOST;
> +	input->id.vendor        =3D 0x0001;
> +	input->id.product       =3D 0x0001;
> +	input->id.version       =3D 0x0003;
> +
> +	input->open =3D smsc_keypad_open;
> +	input->close =3D smsc_keypad_close;
> +	input_set_drvdata(input, kp);
> +
> +	/* Mask all GPIO interrupts (0x37-0x3B) */
> +	for (addr =3D SMSC_GPIO_INT_MASK_START;
> +			addr < SMSC_GPIO_INT_MASK_START + 4; addr++)
> +		smsc_write(dev, addr, 0);
> +
> +	/* Set all outputs high (0x05-0x09) */
> +	for (addr =3D SMSC_GPIO_DATA_OUT_START;
> +			addr < SMSC_GPIO_DATA_OUT_START + 4; addr++)
> +		smsc_write(dev, addr, 0xff);
> +
> +	/* Clear all GPIO interrupts (0x32-0x36) */
> +	for (addr =3D SMSC_GPIO_INT_STAT_START;
> +			addr < SMSC_GPIO_INT_STAT_START + 4; addr++)
> +		smsc_write(dev, addr, 0xff);
> +
> +	/* Configure the smsc pins as Keyboard scan Input */
> +	for (i =3D 0; i < kp->rows; i++) {
> +		addr =3D 0x12 + i;
> +		smsc_write(dev, addr, SMSC_KP_KSI);
> +	}
> +
> +	/* Configure the smsc pins as Keyboard scan output */
> +	for (i =3D 0; i < kp->cols; i++) {
> +		addr =3D 0x1a + i;
> +		smsc_write(dev, addr, SMSC_KP_KSO);
> +	}
> +
> +	smsc_write(dev, SMSC_KP_INT_STAT, SMSC_KP_SET_HIGH);
> +	smsc_write(dev, SMSC_WKUP_CTRL, SMSC_KP_SET_LOW_PWR);
> +	smsc_write(dev, SMSC_KP_OUT, SMSC_KSO_ALL_LOW);
> +
> +	row_shift =3D get_count_order(kp->cols);
> +	max_keys =3D kp->rows << row_shift;
> +
> +	kp->row_shift =3D row_shift;
> +	kp->keymap =3D devm_kzalloc(dev, max_keys * sizeof(kp->keymap[0]),
> +					GFP_KERNEL);
> +	if (!kp->keymap) {
> +		dev_err(dev, "Not enough memory for keymap\n");
> +		return -ENOMEM;
> +	}
> +
> +	ret =3D matrix_keypad_build_keymap(NULL, NULL, kp->rows,
> +			kp->cols, kp->keymap, input);
> +	if (ret) {
> +		dev_err(dev, "failed to build keymap\n");
> +		return ret;
> +	}
> +
> +	/*
> +	* This ISR will always execute in kernel thread context because of
> +	* the need to access the SMSC over the I2C bus.
> +	*/
> +	ret =3D devm_request_threaded_irq(dev, kp->irq, NULL, do_kp_irq,
> +			IRQF_TRIGGER_FALLING | IRQF_ONESHOT, pdev->name, kp);
> +	if (ret) {
> +		dev_dbg(dev, "request_irq failed for irq no=3D%d\n",
> +			irq);
> +		return ret;
> +	}
> +
> +	ret =3D input_register_device(input);
> +	if (ret) {
> +		dev_err(kp->dev,
> +			"Unable to register twl4030 keypad device\n");
> +		return ret;
> +	}
> +
> +	return 0;
> +}
> +
> +static int __devexit smsc_remove(struct platform_device *pdev)
> +{

shouldn't you unregister the input device here ??

--=20
balbi

--1hKfHPzOXWu1rh0v
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQjqzdAAoJEIaOsuA1yqRErGcP/0q2Be35qwuyTMvyDFUo62L9
Y+oVo5+5Jmec9HRiaZsZ2s/hkX82F66gw9hFYQTyzS+I10rC2K3AKx2VjSXojC5m
9hQ+f0NpAOOHZKrKTLvM11KGM5RHAOBOO5kyUqAqk4qLYeAr0svYzPCDmlUtYGd8
NJuO/cDAs+VEbPfT62JiQt8maVS74jVNyev2sOuoR/Ywyky8dlFhWCY0IgatGZjc
wgibr7ciE3GfiTe1vtFqXpv53jRn1lSA8Jt672LWxUGiTG5TMUs2/vL+t9rTKGL8
KE5n4MlgvMtWoX5cN7NgJwho1yHntHG49EuTQ7bGDl2GlWuEKIkyZaFrYbSaGbVV
/6SfbjR0Zzc8H1tA1M+Q3E7xJfEpITfOoN9t2AiAPY6YsbuLLGtZa4ucEGgZ4JQf
+01utCkQWzKb7QH+3m0doBS/ZUsbPyEoBkIEMPZmIIWt71fYFLu2gOBmnbObd6HZ
QEUHhT/kALZjC9Z4b4UgA5fNZRrbXojVzz4J+1SfRzdgC007hXOp+k3DfSf2o4pc
I/G07uQAgpxKSvEShztj4wiRbi/x/yE6bnw8divEFjPeCw35H7mZUMUM8AJIAwk3
pvcEVemIOAvsQH5KPPsiP6FcH8MnZiFny8GUExpEc7Lf7VeMCmjGXr2IDuARdr04
dTyP3PKih9V9Gwd63RFf
=vSrn
-----END PGP SIGNATURE-----

--1hKfHPzOXWu1rh0v--
