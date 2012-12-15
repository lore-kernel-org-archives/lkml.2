Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755854Ab2LOKys (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2012 05:54:48 -0500
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:38437 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755074Ab2LOKyr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2012 05:54:47 -0500
Message-ID: <50CC56F3.1020907@kernel.org>
Date: Sat, 15 Dec 2012 10:54:43 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Alexander Holler <holler@ahsoftware.de>
CC: linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        Jonathan Cameron <jic23@cam.ac.uk>,
        Lars-Peter Clausen <lars@metafoo.de>, rtc-linux@googlegroups.com,
        Alessandro Zummo <a.zummo@towertech.it>,
        srinivas pandruvada <srinivas.pandruvada@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/4 v2] iio: hid-sensors: respect CONFIG_IIO_TRIGGER
References: <50C73AFC.1050904@jic23.retrosnub.co.uk> <1355250106-3114-1-git-send-email-holler@ahsoftware.de>
In-Reply-To: <1355250106-3114-1-git-send-email-holler@ahsoftware.de>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/11/2012 06:21 PM, Alexander Holler wrote:
> Not much to say, without that change, hid-sensor-trigger will be
> always compiled if HID_SENSOR_IIO_COMMON is selected which fails if
> CONFIG_IIO_TRIGGER is not set because CONFIG_IIO_CONSUMERS_PER_TRIGGER
> will not be defined.
> 
> Signed-off-by: Alexander Holler <holler@ahsoftware.de>

Not sure what tree this was against as it is needs some fixing up for
staging-next and currently mainline.  Ah well fixed up and added to togreg
branch of

git://git.kernel.org/pub/scm/linux/kernel/git/jic23/iio.git

Please check I haven't messed it up.
> ---
>  drivers/iio/accel/Kconfig               |    1 +
>  drivers/iio/common/hid-sensors/Kconfig  |   13 ++++++++++++-
>  drivers/iio/common/hid-sensors/Makefile |    3 ++-
>  drivers/iio/gyro/Kconfig                |    1 +
>  drivers/iio/light/Kconfig               |    1 +
>  drivers/iio/magnetometer/Kconfig        |    1 +
>  6 files changed, 18 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/iio/accel/Kconfig b/drivers/iio/accel/Kconfig
> index b2510c4..b84b806 100644
> --- a/drivers/iio/accel/Kconfig
> +++ b/drivers/iio/accel/Kconfig
> @@ -8,6 +8,7 @@ config HID_SENSOR_ACCEL_3D
>  	select IIO_BUFFER
>  	select IIO_TRIGGERED_BUFFER
>  	select HID_SENSOR_IIO_COMMON
> +	select HID_SENSOR_IIO_TRIGGER
>  	tristate "HID Acelerometers 3D"
>  	help
>  	  Say yes here to build support for the HID SENSOR
> diff --git a/drivers/iio/common/hid-sensors/Kconfig b/drivers/iio/common/hid-sensors/Kconfig
> index 8e63d81..e294f31 100644
> --- a/drivers/iio/common/hid-sensors/Kconfig
> +++ b/drivers/iio/common/hid-sensors/Kconfig
> @@ -6,7 +6,7 @@ menu "Hid Sensor IIO Common"
>  config HID_SENSOR_IIO_COMMON
>  	tristate "Common modules for all HID Sensor IIO drivers"
>  	depends on HID_SENSOR_HUB
> -	select IIO_TRIGGER if IIO_BUFFER
> +	select HID_SENSOR_IIO_TRIGGER if IIO_BUFFER
>  	help
>  	  Say yes here to build support for HID sensor to use
>  	  HID sensor common processing for attributes and IIO triggers.
> @@ -14,6 +14,17 @@ config HID_SENSOR_IIO_COMMON
>  	  HID sensor drivers, this module contains processing for those
>  	  attributes.
>  
> +config HID_SENSOR_IIO_TRIGGER
> +	tristate "Common module (trigger) for all HID Sensor IIO drivers"
> +	depends on HID_SENSOR_HUB && HID_SENSOR_IIO_COMMON
> +	select IIO_TRIGGER
> +	help
> +	  Say yes here to build trigger support for HID sensors.
> +	  Triggers will be send if all requested attributes were read.
> +
> +	  If this driver is compiled as a module, it will be named
> +	  hid-sensor-trigger.
> +
>  config HID_SENSOR_ENUM_BASE_QUIRKS
>  	tristate "ENUM base quirks for HID Sensor IIO drivers"
>  	depends on HID_SENSOR_IIO_COMMON
> diff --git a/drivers/iio/common/hid-sensors/Makefile b/drivers/iio/common/hid-sensors/Makefile
> index 1f463e0..22e7c5a 100644
> --- a/drivers/iio/common/hid-sensors/Makefile
> +++ b/drivers/iio/common/hid-sensors/Makefile
> @@ -3,4 +3,5 @@
>  #
>  
>  obj-$(CONFIG_HID_SENSOR_IIO_COMMON) += hid-sensor-iio-common.o
> -hid-sensor-iio-common-y := hid-sensor-attributes.o hid-sensor-trigger.o
> +obj-$(CONFIG_HID_SENSOR_IIO_TRIGGER) += hid-sensor-trigger.o
> +hid-sensor-iio-common-y := hid-sensor-attributes.o
> diff --git a/drivers/iio/gyro/Kconfig b/drivers/iio/gyro/Kconfig
> index 21e27e2..bc9daff 100644
> --- a/drivers/iio/gyro/Kconfig
> +++ b/drivers/iio/gyro/Kconfig
> @@ -8,6 +8,7 @@ config HID_SENSOR_GYRO_3D
>  	select IIO_BUFFER
>  	select IIO_TRIGGERED_BUFFER
>  	select HID_SENSOR_IIO_COMMON
> +	select HID_SENSOR_IIO_TRIGGER
>  	tristate "HID Gyroscope 3D"
>  	help
>  	  Say yes here to build support for the HID SENSOR
> diff --git a/drivers/iio/light/Kconfig b/drivers/iio/light/Kconfig
> index 1763c9b..dbf80ab 100644
> --- a/drivers/iio/light/Kconfig
> +++ b/drivers/iio/light/Kconfig
> @@ -47,6 +47,7 @@ config HID_SENSOR_ALS
>  	select IIO_BUFFER
>  	select IIO_TRIGGERED_BUFFER
>  	select HID_SENSOR_IIO_COMMON
> +	select HID_SENSOR_IIO_TRIGGER
>  	tristate "HID ALS"
>  	help
>  	  Say yes here to build support for the HID SENSOR
> diff --git a/drivers/iio/magnetometer/Kconfig b/drivers/iio/magnetometer/Kconfig
> index c1f0cdd..ff11d68 100644
> --- a/drivers/iio/magnetometer/Kconfig
> +++ b/drivers/iio/magnetometer/Kconfig
> @@ -8,6 +8,7 @@ config HID_SENSOR_MAGNETOMETER_3D
>  	select IIO_BUFFER
>  	select IIO_TRIGGERED_BUFFER
>  	select HID_SENSOR_IIO_COMMON
> +	select HID_SENSOR_IIO_TRIGGER
>  	tristate "HID Magenetometer 3D"
>  	help
>  	  Say yes here to build support for the HID SENSOR
> 
