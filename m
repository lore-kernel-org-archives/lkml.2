Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752380Ab0IFISM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 04:18:12 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:41144 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751669Ab0IFISK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 04:18:10 -0400
From: "Datta, Shubhrajyoti" <shubhrajyoti@ti.com>
To: "achew@nvidia.com" <achew@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>
CC: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "khali@linux-fr.org" <khali@linux-fr.org>,
        "ldewangan@nvidia.com" <ldewangan@nvidia.com>
Date: Mon, 6 Sep 2010 13:47:18 +0530
Subject: RE: [PATCH 1/1] iio: ak8975: Add Ak8975 magnetometer sensor
Thread-Topic: [PATCH 1/1] iio: ak8975: Add Ak8975 magnetometer sensor
Thread-Index: ActK/I9N9is6KwSRSO+mVM+JyVFhbAClNv1A
Message-ID: <0680EC522D0CC943BC586913CF3768C003C2018464@dbde02.ent.ti.com>
References: <1283470837-18210-1-git-send-email-achew@nvidia.com>
In-Reply-To: <1283470837-18210-1-git-send-email-achew@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: linux-iio-owner@vger.kernel.org [mailto:linux-iio-
> owner@vger.kernel.org] On Behalf Of achew@nvidia.com
> Sent: Friday, September 03, 2010 5:11 AM
> To: linux-kernel@vger.kernel.org; linux-iio@vger.kernel.org; linux-
> i2c@vger.kernel.org
> Cc: akpm@linux-foundation.org; khali@linux-fr.org; ldewangan@nvidia.com;
> Andrew Chew
> Subject: [PATCH 1/1] iio: ak8975: Add Ak8975 magnetometer sensor
> 
> From: Andrew Chew <achew@nvidia.com>
> 
> This is for the Asahi Kasei AK8975 3-axis magnetometer.  It resides within
> the magnetometer section of the IIO subsystem, and implements the raw
> magn_x,y,z attributes, as well as x,y,z factory calibration attributes.
> 
Could you help me with the datasheet details.
> Signed-off-by: Andrew Chew <achew@nvidia.com>
> ---
>  drivers/staging/iio/magnetometer/Kconfig  |   11 +
>  drivers/staging/iio/magnetometer/Makefile |    1 +
>  drivers/staging/iio/magnetometer/ak8975.c |  521
> +++++++++++++++++++++++++++++
>  3 files changed, 533 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/staging/iio/magnetometer/ak8975.c
> 
> diff --git a/drivers/staging/iio/magnetometer/Kconfig
> b/drivers/staging/iio/magnetometer/Kconfig
> index d014450..00e1204 100644
> --- a/drivers/staging/iio/magnetometer/Kconfig
> +++ b/drivers/staging/iio/magnetometer/Kconfig
> @@ -3,6 +3,17 @@
>  #
>  comment "Magnetometer sensors"
> 
> +config SENSORS_AK8975
> +	tristate "Asahi Kasei AK8975 3-Axis Magnetometer"
> +	default n
Default is anyways n however does no harm.
> +	depends on I2C
> +	help
> +	  Say yes here to build support for Asahi Kasei AK8975 3-Axis
> +	  Magnetometer.
> +
> +	  To compile this driver as a module, choose M here: the module
> +	  will be called ak8975.
> +
>  config SENSORS_HMC5843
>  	tristate "Honeywell HMC5843 3-Axis Magnetometer"
>  	depends on I2C
> diff --git a/drivers/staging/iio/magnetometer/Makefile
> b/drivers/staging/iio/magnetometer/Makefile
> index f9bfb2e..e3dbaa4 100644
> --- a/drivers/staging/iio/magnetometer/Makefile
> +++ b/drivers/staging/iio/magnetometer/Makefile
> @@ -2,4 +2,5 @@
>  # Makefile for industrial I/O Magnetometer sensors
>  #
> 
> +obj-$(CONFIG_SENSORS_AK8975)	:= ak8975.o

Was the : intentional

>  obj-$(CONFIG_SENSORS_HMC5843)	+= hmc5843.o
> diff --git a/drivers/staging/iio/magnetometer/ak8975.c
> b/drivers/staging/iio/magnetometer/ak8975.c
> new file mode 100644
> index 0000000..ca39840
> --- /dev/null
> +++ b/drivers/staging/iio/magnetometer/ak8975.c
> @@ -0,0 +1,521 @@
> +/*
> + * A sensor driver for the magnetometer AK8975.
