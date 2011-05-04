Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754150Ab1EDQ3T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 12:29:19 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:50953 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751018Ab1EDQ3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 12:29:17 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
Subject: Re: [RFC 2/5] gpio: add support for Technologic Systems TS-5500 GPIOs
Date: Wed, 4 May 2011 18:29:12 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org,
        Jerome Oufella <jerome.oufella@savoirfairelinux.com>,
        platform-driver-x86@vger.kernel.org, linux-serial@vger.kernel.org,
        lm-sensors@lm-sensors.org
References: <1304115712-5299-1-git-send-email-vivien.didelot@savoirfairelinux.com> <1304115712-5299-3-git-send-email-vivien.didelot@savoirfairelinux.com>
In-Reply-To: <1304115712-5299-3-git-send-email-vivien.didelot@savoirfairelinux.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201105041829.12801.arnd@arndb.de>
X-Provags-ID: V02:K0:YEcZgQQq1cTYPIecCBse2q8XBZwDTv0px48jTX0mPEj
 BQwrscAo8uNtDqba5JDjXRom8glXENxGywt/9fclsT/qbkyghi
 Gb6ECq5VGyUWUBY1cEQAm/y/DRS8obauQK3QGzOe/NGAR3OYs2
 QN+BjjZFPGOKGNIzRd0hTlYpqwK7izT7KhmQa7QY8KEmMdOPju
 sC6cohuSTuFXCuY3ZkzGw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 30 April 2011, Vivien Didelot wrote:
> +       ts5xxx_sbcinfo_set(&sbcinfo);
> +       if (5500 != sbcinfo.board_id) {
> +               printk(MODULE_NAME ": Incompatible TS Board.\n");
> +               return -ENODEV;
> +       }

The above should not be necessary:

> +static int __init ts5500_gpio_init(void)
> +{
> +       int ret;
> +
> +       ret = platform_driver_register(&ts5500_gpio_driver);
> +       if (ret)
> +               return ret;
> +
> +       ret = platform_device_register(&gpio_device);
> +       if (ret) {
> +               printk(MODULE_NAME ": Failed to register platform device\n");
> +               platform_driver_unregister(&ts5500_gpio_driver);
> +               return ret;
> +       }
> +
> +       printk(MODULE_NAME ": GPIO/DIO driver loaded.\n");
> +       return 0;
> +}
> +module_init(ts5500_gpio_init);

Doing it this way requires you know that you have to load the driver,
which is not good if you want to have the same kernel running on 
different machines.

Better move the device registration into your platform code, in the
place where you know what device you have. The add a MODULE_DEVICE_TABLE()
entry to the module so the driver gets automatically loaded (if it's
a module), and match the platform device to the driver you register
from the module_init function.

Same for the other devices where you follow the same pattern.

Another way to do the same in a more modern fashion would be
to provide a flattened device tree that describes all your devices
and pass that into the kernel. Take a look at the CE4100 and OLPC
platforms to see how that is done.

	Arnd
