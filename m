Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756665Ab2HUKtu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 06:49:50 -0400
Received: from na3sys009aog118.obsmtp.com ([74.125.149.244]:39125 "EHLO
	na3sys009aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756539Ab2HUKtt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 06:49:49 -0400
Date: Tue, 21 Aug 2012 13:45:49 +0300
From: Felipe Balbi <balbi@ti.com>
To: Sourav Poddar <sourav.poddar@ti.com>
Cc: devicetree-discuss@lists.ozlabs.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: Re: [PATCH 2/4] Input: keypad: Add smsc ece1099 keypad driver
Message-ID: <20120821104549.GT10347@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <1345545940-2232-1-git-send-email-sourav.poddar@ti.com>
 <1345545940-2232-3-git-send-email-sourav.poddar@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zpd1bWBxfrI+71+6"
Content-Disposition: inline
In-Reply-To: <1345545940-2232-3-git-send-email-sourav.poddar@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zpd1bWBxfrI+71+6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 21, 2012 at 04:15:38PM +0530, Sourav Poddar wrote:
> From: G, Manjunath Kondaiah <manjugk@ti.com>
>=20
> SMSC ECE1099 is a keyboard scan or GPIO expansion device.The device
> supports a keypad scan matrix of 23*8.This driver uses this
> device as a keypad driver.
>=20
> Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> Cc: Benoit Cousson <b-cousson@ti.com>
> Cc: Felipe Balbi <balbi@ti.com>
> Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
> Signed-off-by: G, Manjunath Kondaiah <manjugk@ti.com>
> Signed-off-by: Sourav Poddar <sourav.poddar@ti.com>

looks good. If you just fix my comment on free_irq() below, you can add:

Acked-by: Felipe Balbi <balbi@ti.com>

> +static int __devinit
> +smsc_probe(struct platform_device *pdev)
> +{
> +	struct device *dev =3D &pdev->dev;
> +	struct smsc *smsc =3D dev_get_drvdata(pdev->dev.parent);
> +	struct input_dev *input;
> +	struct smsc_keypad *kp;
> +	int ret =3D 0, error;
> +	int col, i, max_keys, row_shift;
> +	int irq;
> +	int addr_start, addr;
> +
> +	kp =3D devm_kzalloc(dev, sizeof(*kp), GFP_KERNEL);
> +
> +	input =3D input_allocate_device();
> +	if (!kp || !input) {
> +		error =3D -ENOMEM;
> +		goto err1;
> +	}
> +
> +	error =3D smsc_keypad_parse_dt(&pdev->dev, kp);
> +	if (error)
> +		return error;
> +
> +	/* Get the debug Device */
> +	kp->input =3D input;
> +	kp->smsc =3D smsc;
> +	kp->irq =3D platform_get_irq(pdev, 0);
> +	kp->dev =3D dev;
> +
> +	for (col =3D 0; col < 16; col++) {
> +		kp->last_key_state[col] =3D 0;
> +		kp->last_key_ms[col] =3D 0;
> +	}
> +
> +	/* setup input device */
> +	 __set_bit(EV_KEY, input->evbit);
> +
> +	/* Enable auto repeat feature of Linux input subsystem */
> +	if (!(kp->no_autorepeat))
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
> +	error =3D input_register_device(input);
> +	if (error) {
> +		dev_err(kp->dev,
> +			"Unable to register twl4030 keypad device\n");
> +		goto err1;
> +	}
> +
> +	/* Mask all GPIO interrupts (0x37-0x3B) */
> +	for (addr =3D 0x37; addr < 0x3B; addr++)
> +		smsc_write(dev, addr, 0);
> +
> +	/* Set all outputs high (0x05-0x09) */
> +	for (addr =3D 0x05; addr < 0x09; addr++)
> +		smsc_write(dev, addr, 0xff);
> +
> +	/* Clear all GPIO interrupts (0x32-0x36) */
> +	for (addr =3D 0x32; addr < 0x36; addr++)
> +		smsc_write(dev, addr, 0xff);
> +
> +	addr_start =3D 0x12;
> +	for (i =3D 0; i <=3D kp->rows; i++) {
> +		addr =3D 0x12 + i;
> +		smsc_write(dev, addr, SMSC_KP_KSI);
> +	}
> +
> +	addr_start =3D  0x1A;
> +	for (i =3D 0; i <=3D kp->cols; i++) {
> +		addr =3D 0x1A + i;
> +		smsc_write(dev, addr, SMSC_KP_KSO);
> +	}
> +
> +	addr =3D SMSC_KP_INT_STAT;
> +	smsc_write(dev, addr, SMSC_KP_SET_HIGH);
> +
> +	addr =3D SMSC_WKUP_CTRL;
> +	smsc_write(dev, addr, SMSC_KP_SET_LOW_PWR);
> +
> +	addr =3D SMSC_KP_OUT;
> +	smsc_write(dev, addr, SMSC_KSO_ALL_LOW);
> +
> +	row_shift =3D get_count_order(kp->cols);
> +	max_keys =3D kp->rows << row_shift;
> +
> +	kp->row_shift =3D row_shift;
> +	kp->keymap =3D kzalloc(max_keys * sizeof(kp->keymap[0]),
> +					GFP_KERNEL);
> +	if (!kp->keymap) {
> +		dev_err(&pdev->dev, "Not enough memory for keymap\n");
> +		error =3D -ENOMEM;
> +	}
> +
> +	matrix_keypad_build_keymap(NULL, NULL, kp->rows,
> +			kp->cols, kp->keymap, input);
> +
> +	/*
> +	* This ISR will always execute in kernel thread context because of
> +	* the need to access the SMSC over the I2C bus.
> +	*/
> +	ret =3D devm_request_threaded_irq(dev, kp->irq, NULL, do_kp_irq,
> +			IRQF_TRIGGER_FALLING | IRQF_ONESHOT, pdev->name, kp);
> +	if (ret) {
> +		dev_dbg(&pdev->dev, "request_irq failed for irq no=3D%d\n",
> +			irq);
> +		goto err2;
> +	}
> +
> +	/* Enable smsc keypad interrupts */
> +	ret =3D smsc_write(dev, SMSC_KP_INT_MASK, 0xff);
> +	if (ret < 0)
> +		goto err2;
> +
> +	return 0;
> +
> +err2:
> +	input_unregister_device(input);
> +	free_irq(kp->irq, NULL);

you're using devm_request_threaded_irq, this is unnecessary

> +err1:
> +	input_free_device(input);
> +	return ret;
> +}
> +
> +static int smsc_remove(struct platform_device *pdev)
> +{
> +	struct smsc_keypad *kp =3D platform_get_drvdata(pdev);
> +	free_irq(kp->irq, kp);

ditto.


--=20
balbi

--zpd1bWBxfrI+71+6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQM2bdAAoJEIaOsuA1yqREJeQP/A2punS/wXhdUtGToTI1bI6k
gb35BA8HWCEiUpC9ln73fTq4HFxKqUDLehgSbli8nJFkPTTtd7oWECT1+w2d1Drb
3rJ2RsRqr50HNjVjYkm6NIchheMP8X4VsVQR27hHXPOArFQ9TfBockuU+QtWz2Up
AKigg6hf7zQ+PGof3A0uqV38aGh/NcSR0deZVST8goHmAtBKg+3TYI+kyDkQjZRQ
gBrbxFE4zYo2HFD9bHCIk9rguh0ln3LvGREiz0i3qY8cF40QS1MqnJqG3CbSrcLx
U8Qo8GZ0yeauEJxcLStP8ZPuzFIvs490hAOjbcwml29nS1cwgIPm5kvm8QaHL/Hz
Rg1XM5+BQfGkyjjTPR9aGE1wYY3FFrZNKuWp3833hpqHj4RXYVeaU5T26/IA5yxo
W6+7jw1NKFDYakbwKtHl2/1aVVioZNZtPBWqEdAFT4130YtjqCzAWa2ziliFWfmm
bycIYGr74pB4fwgO0ESl0f6hVS+3w/RNJevNBI802dH+o0BgTV3Z8J7Q37uBz8Z2
NnKfVEHVeoO+5UPEGNPb1PmOZd3MlKr/C0cenKMGdsR11iBASGTEIE5tTQGRN7q5
mrEpNpJTWE98Yt12fPB/cmYhUL7OU7DSBaGReTAVNJHxV8Riwb/qS8kJYPCvuLK5
saN/SFwEHJSl6i27tHH+
=VYEi
-----END PGP SIGNATURE-----

--zpd1bWBxfrI+71+6--
