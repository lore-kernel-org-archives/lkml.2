Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757408Ab1GAVFj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 17:05:39 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:63341 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751929Ab1GAVFi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 17:05:38 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Nathan Royer <nroyer@invensense.com>
Subject: Re: [PATCH 01/11] misc: inv_mpu primary header file and README file.
Date: Fri, 1 Jul 2011 23:04:18 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc1nosema+; KDE/4.6.3; x86_64; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Greg Kroah-Hartman" <gregkh@suse.de>,
        Jonathan Cameron <jic23@cam.ac.uk>, Jiri Kosina <jkosina@suse.cz>,
        Alan Cox <alan@linux.intel.com>, Jean Delvare <khali@linux-fr.org>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
References: <1309486707-1658-1-git-send-email-nroyer@invensense.com>
In-Reply-To: <1309486707-1658-1-git-send-email-nroyer@invensense.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201107012304.19073.arnd@arndb.de>
X-Provags-ID: V02:K0:hn2jVqv5OzIyBbsLKuI1/iBT2zRzh7s25zTpdg73PDi
 fM8WR6wpV2UkuATjsbTWKK4UYQgLzBtVWLWghMt811wPb9boxh
 5VXs8ZkmZnCAMmib1VBKlWqAJ82oFuAp7qKjyHxwmXr9X9ratY
 9v4Kf8agzYBpw9In59fhx43h2ZJLQKeC2S93SHCVEK4cc4zMIn
 aGMY4w7Di1B/BYMHwOV5Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 01 July 2011 04:18:17 Nathan Royer wrote:
> +/* Structure for the following IOCTS's
> + * MPU_CONFIG_GYRO
> + * MPU_CONFIG_ACCEL
> + * MPU_CONFIG_COMPASS
> + * MPU_CONFIG_PRESSURE
> + * MPU_GET_CONFIG_GYRO
> + * MPU_GET_CONFIG_ACCEL
> + * MPU_GET_CONFIG_COMPASS
> + * MPU_GET_CONFIG_PRESSURE
> + *
> + * @key one of enum ext_slave_config_key
> + * @len length of data pointed to by data
> + * @apply zero if communication with the chip is not necessary, false otherwise
> + *        This flag can be used to select cached data or to refresh cashed data
> + *        cache data to be pushed later or push immediately.  If true and the
> + *        slave is on the secondary bus the MPU will first enger bypass mode
> + *        before calling the slaves .config or .get_config funcion
> + * @data pointer to the data to confgure or get
> + */
> +struct ext_slave_config {
> +       __u8 key;
> +       __u16 len;
> +       __u8 apply;
> +       void *data;
> +};

I'm a bit worried about the ioctl interface, it seems overloaded and has
problems with 32/64 bit compatibility. In general, having void pointers
in an structure that is used as an ioctl argument is a sign that the
interface is too complex. In fact, there are a number of reasons why you
should try to avoid pointers in there completely.

You should also try to avoid padding in structures. The definition you
have could be any of 64/96/128 bytes long depending on the architecture,
and leak kernel stack data.

Having separate commands on a single device file in order to do the
same operation on distinct pieces of hardware sounds like a wrong
abstraction of your devices. Instead, it would seem more appropriate
to represent each hardware endpoint (gyro/accel/compass/...) as one
character device, and let each of them export the same minimum set of
commands. However, the suggestion to use an existing subsystem (iio,
input, hwmon, ...) for each of the endpoints as appropriate would fit
better into the existing use cases.

I haven't been able to figure out if all those endpoints are just
I2C devices and could be handled by i2c drivers for those subsystems,
or if you have another hardware interface that groups of them. In the
latter case, would an MFD driver work for this? The idea of that is
essentially to prove a new bus_type without having to do all the
abstraction work when you already know all the devices behind it.


	Arnd
