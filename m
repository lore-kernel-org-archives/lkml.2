Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751546Ab2ACDdP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jan 2012 22:33:15 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:36114 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041Ab2ACDdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jan 2012 22:33:14 -0500
Date: Tue, 3 Jan 2012 14:33:04 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: linux-next: manual merge of the input tree with the arm-soc tree
Message-Id: <20120103143304.eeeaf5e11021721fd02dbce8@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__3_Jan_2012_14_33_04_+1100_RiG9aGM2CCM2ouhe"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__3_Jan_2012_14_33_04_+1100_RiG9aGM2CCM2ouhe
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dmitry,

Today's linux-next merge of the input tree got a conflict in
drivers/input/keyboard/samsung-keypad.c between commit b3d6ac3e5f93
("input: samsung-keypad: Add device tree support") from the arm-soc tree
and commit 48c98b1bb85a ("Input: samsung-keypad - implement runtime power
management support") from the input tree.

I fixed it up (see below) and can carry the fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/input/keyboard/samsung-keypad.c
index 8a0060c,b746fce..0000000
--- a/drivers/input/keyboard/samsung-keypad.c
+++ b/drivers/input/keyboard/samsung-keypad.c
@@@ -20,11 -20,11 +20,13 @@@
  #include <linux/io.h>
  #include <linux/module.h>
  #include <linux/platform_device.h>
+ #include <linux/pm.h>
+ #include <linux/pm_runtime.h>
  #include <linux/slab.h>
 +#include <linux/of.h>
 +#include <linux/of_gpio.h>
  #include <linux/sched.h>
- #include <plat/keypad.h>
+ #include <linux/input/samsung-keypad.h>
 =20
  #define SAMSUNG_KEYIFCON			0x00
  #define SAMSUNG_KEYIFSTSCLR			0x04
@@@ -69,8 -70,8 +72,9 @@@ struct samsung_keypad=20
  	void __iomem *base;
  	wait_queue_head_t wait;
  	bool stopped;
+ 	bool wake_enabled;
  	int irq;
 +	enum samsung_keypad_type type;
  	unsigned int row_shift;
  	unsigned int rows;
  	unsigned int cols;
@@@ -421,18 -318,9 +438,19 @@@ static int __devinit samsung_keypad_pro
  	keypad->row_shift =3D row_shift;
  	keypad->rows =3D pdata->rows;
  	keypad->cols =3D pdata->cols;
+ 	keypad->stopped =3D true;
  	init_waitqueue_head(&keypad->wait);
 =20
 +	if (pdev->dev.of_node) {
 +#ifdef CONFIG_OF
 +		samsung_keypad_parse_dt_gpio(&pdev->dev, keypad);
 +		keypad->type =3D of_device_is_compatible(pdev->dev.of_node,
 +					"samsung,s5pv210-keypad");
 +#endif
 +	} else {
 +		keypad->type =3D platform_get_device_id(pdev)->driver_data;
 +	}
 +
  	input_dev->name =3D pdev->name;
  	input_dev->id.bustype =3D BUS_HOST;
  	input_dev->dev.parent =3D &pdev->dev;
@@@ -471,21 -363,15 +493,21 @@@
  	if (error)
  		goto err_free_irq;
 =20
- 	device_init_wakeup(&pdev->dev, pdata->wakeup);
- 	platform_set_drvdata(pdev, keypad);
-=20
 +	if (pdev->dev.of_node) {
 +		devm_kfree(&pdev->dev, (void *)pdata->keymap_data->keymap);
 +		devm_kfree(&pdev->dev, (void *)pdata->keymap_data);
 +		devm_kfree(&pdev->dev, (void *)pdata);
 +	}
  	return 0;
 =20
  err_free_irq:
  	free_irq(keypad->irq, keypad);
+ 	pm_runtime_disable(&pdev->dev);
+ 	device_init_wakeup(&pdev->dev, 0);
+ 	platform_set_drvdata(pdev, NULL);
  err_put_clk:
  	clk_put(keypad->clk);
 +	samsung_keypad_dt_gpio_free(keypad);
  err_unmap_base:
  	iounmap(keypad->base);
  err_free_mem:
@@@ -578,24 -510,14 +647,25 @@@ static int samsung_keypad_resume(struc
 =20
  	return 0;
  }
+ #endif
 =20
  static const struct dev_pm_ops samsung_keypad_pm_ops =3D {
- 	.suspend	=3D samsung_keypad_suspend,
- 	.resume		=3D samsung_keypad_resume,
+ 	SET_SYSTEM_SLEEP_PM_OPS(samsung_keypad_suspend, samsung_keypad_resume)
+ 	SET_RUNTIME_PM_OPS(samsung_keypad_runtime_suspend,
+ 			   samsung_keypad_runtime_resume, NULL)
  };
- #endif
 =20
 +#ifdef CONFIG_OF
 +static const struct of_device_id samsung_keypad_dt_match[] =3D {
 +	{ .compatible =3D "samsung,s3c6410-keypad" },
 +	{ .compatible =3D "samsung,s5pv210-keypad" },
 +	{},
 +};
 +MODULE_DEVICE_TABLE(of, samsung_keypad_dt_match);
 +#else
 +#define samsung_keypad_dt_match NULL
 +#endif
 +
  static struct platform_device_id samsung_keypad_driver_ids[] =3D {
  	{
  		.name		=3D "samsung-keypad",
@@@ -614,10 -536,7 +684,8 @@@ static struct platform_driver samsung_k
  	.driver		=3D {
  		.name	=3D "samsung-keypad",
  		.owner	=3D THIS_MODULE,
 +		.of_match_table =3D samsung_keypad_dt_match,
- #ifdef CONFIG_PM
  		.pm	=3D &samsung_keypad_pm_ops,
- #endif
  	},
  	.id_table	=3D samsung_keypad_driver_ids,
  };

--Signature=_Tue__3_Jan_2012_14_33_04_+1100_RiG9aGM2CCM2ouhe
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPAnbwAAoJEECxmPOUX5FE7BIP/0Qv5qJcnj1RHyKeBhKjAACy
4E7HHo1cwhQfU7hFMbUiOJgnm3+OdarfencknbMI+37oUHNWFAYQnAWRRMFkk0MO
xmSGcMV+q/VFILzt0pLf4i9K7+BZiQgPsfeVOSgMMkRbqlSqOQaWSxoB5e7IucZD
r3cfg+I7ieymF67KqCOe9KryxH2rCSv6E/W4nG+lOrO7Ym1Zge6T8CF7pL86j+az
PPGY/h9LxVisIg8nx6oegh5I/urrfdSo/am92lHvX6ceBc93T6PrkSKqkcYrVFeC
heVCsBu4yxBFJ2yTSNYpBxdhe/MuDl9xuiG1SMJsTnA7HVylNHjbbM1YkfX7hBVO
dzKdNjOGhZowqYmU6x2POyT82yV8oYdODcErjIrERIdTKT2RrHJYhBeXNbAjB6HH
AgFgFZkmMLl4foDB0umJ98ZZNphBsxoz08F++xnGybELAdIVG1JeyzPVwf1Ki0+A
PIS2aEveXdLz9SRDAfI5Vd7zOWxf5YcwQeiwNfQD75pqNnRRzCu6MlRcPvxwjYh8
C6YcXjgUwkpgg0niQim0NXUiQo/QyUyzJQ4N6+yibAiVtpdFTuCr44aSrKQqte+q
rGuXjdg/q1HSsvKeaacjvK6pa2JHOIRXuRtJWsh9VehllqJ+8N5qXB3muxKnKOj0
5OUO9dMgyuYx8EFfXo+R
=+1bC
-----END PGP SIGNATURE-----

--Signature=_Tue__3_Jan_2012_14_33_04_+1100_RiG9aGM2CCM2ouhe--
