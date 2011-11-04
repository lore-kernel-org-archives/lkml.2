Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752220Ab1KDFx5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 01:53:57 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:36141 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751937Ab1KDFxz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 01:53:55 -0400
From: "Mohammed, Afzal" <afzal@ti.com>
To: Kyle Manna <kyle.manna@fuel7.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
CC: Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "Girdwood, Liam" <lrg@ti.com>, Samuel Ortiz <sameo@linux.intel.com>
Subject: RE: [PATCH v3 1/6] mfd: TPS65910: Handle non-existent devices
Thread-Topic: [PATCH v3 1/6] mfd: TPS65910: Handle non-existent devices
Thread-Index: AQHMmku2flu69KmPy0qp1VN6s74Vf5WcKVoA
Date: Fri, 4 Nov 2011 05:53:01 +0000
Message-ID: <C8443D0743D26F4388EA172BF4E2A7A9018E59@DBDE01.ent.ti.com>
References: <1320340086-15371-1-git-send-email-kyle.manna@fuel7.com>
 <1320340086-15371-2-git-send-email-kyle.manna@fuel7.com>
In-Reply-To: <1320340086-15371-2-git-send-email-kyle.manna@fuel7.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kyla,

On Thu, Nov 03, 2011 at 22:38:01, Kyle Manna wrote:
> The JTAGREVNUM register contains a silicon revision number in the lower
> four bits and the upper four bits are to always read 0.
> 
> To detect the presence of the device, attempt to read JTAGREVNUM
> register and check that it returns a valid value.  If the I2C device
> fails to respond or returns an invalid value, return -ENODEV.
> 
:
:
> +	/* Check that the device is there */
> +	ret = tps65910_i2c_read(tps65910, TPS65910_JTAGVERNUM, 1, &reg);
> +	if (ret < 0 || (reg & ~JTAGVERNUM_VERNUM_MASK)) {
> +		dev_err(tps65910->dev, "unknown version: JTAGREVNUM = 0x%x\n",
> +				       reg);
> +		ret = -ENODEV;
>  		goto err;
> +	}

If i2c read fails, "0" would get printed as version.

Perhaps it would be better to print version irrespective of whether it
is unknown or not, and return error for unknown value, something like,

        unsigned char buff;

        /* Check that the device is actually there */
        ret = tps65910_i2c_read(tps65910, 0x0, 1, &buff);
        if (ret < 0) {
                dev_err(tps65910->dev, "could not be detected\n");
                ret = -ENODEV;
                goto err;
        }

        dev_info(tps65910->dev, "JTAGREVNUM 0x%x\n", buff);

        if (buff & ~JTAGVERNUM_VERNUM_MASK) {
                dev_err(tps65910->dev, "unknown version\n");
                ret = -ENODEV;
                goto err;
        }



Regards
Afzal
