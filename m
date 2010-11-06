Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752682Ab0KFSXo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Nov 2010 14:23:44 -0400
Received: from kroah.org ([198.145.64.141]:53994 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752042Ab0KFSXj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Nov 2010 14:23:39 -0400
Date: Sat, 6 Nov 2010 11:19:30 -0700
From: Greg KH <greg@kroah.com>
To: Baruch Siach <baruch@tkos.co.il>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Alex Gershgorin <agersh@rambler.ru>
Subject: Re: [PATCH] drivers/misc: Altera Cyclone active serial
	implementation
Message-ID: <20101106181930.GB6927@kroah.com>
References: <879a6320efee16c04f0732a6887b95c1b4c6d10f.1288793522.git.baruch@tkos.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <879a6320efee16c04f0732a6887b95c1b4c6d10f.1288793522.git.baruch@tkos.co.il>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 03, 2010 at 04:21:35PM +0200, Baruch Siach wrote:
> From: Alex Gershgorin <agersh@rambler.ru>
> 
> The active serial protocol can be used to program Altera Cyclone FPGA devices.
> This driver uses the kernel gpio interface to implement the active serial
> protocol.
> 
> Signed-off-by: Alex Gershgorin <agersh@rambler.ru>
> Signed-off-by: Baruch Siach <baruch@tkos.co.il>
> ---
>  drivers/misc/Kconfig       |   10 ++
>  drivers/misc/Makefile      |    1 +
>  drivers/misc/cyclone_as.c  |  326 ++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/cyclone_as.h |   23 +++
>  4 files changed, 360 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/misc/cyclone_as.c
>  create mode 100644 include/linux/cyclone_as.h
> 
> diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
> index b743312..182328e 100644
> --- a/drivers/misc/Kconfig
> +++ b/drivers/misc/Kconfig
> @@ -390,6 +390,16 @@ config BMP085
>  	  To compile this driver as a module, choose M here: the
>  	  module will be called bmp085.
>  
> +config CYCLONE_AS
> +	tristate "Altera Cyclone Active Serial driver"
> +	help
> +	  Provides support for active serial programming of Altera Cyclone
> +	  devices. For the active serial protocol details see the Altera 
> +	  "Serial Configuration Devices" document (C51014).
> +
> +	  To compile this driver as a module, choose M here: the
> +	  module will be called cyclone_as.
> +
>  source "drivers/misc/c2port/Kconfig"
>  source "drivers/misc/eeprom/Kconfig"
>  source "drivers/misc/cb710/Kconfig"
> diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
> index 42eab95..a3e0248 100644
> --- a/drivers/misc/Makefile
> +++ b/drivers/misc/Makefile
> @@ -35,3 +35,4 @@ obj-y				+= eeprom/
>  obj-y				+= cb710/
>  obj-$(CONFIG_VMWARE_BALLOON)	+= vmw_balloon.o
>  obj-$(CONFIG_ARM_CHARLCD)	+= arm-charlcd.o
> +obj-$(CONFIG_CYCLONE_AS)	+= cyclone_as.o
> diff --git a/drivers/misc/cyclone_as.c b/drivers/misc/cyclone_as.c
> new file mode 100644
> index 0000000..bfaa60d
> --- /dev/null
> +++ b/drivers/misc/cyclone_as.c
> @@ -0,0 +1,326 @@
> +/*
> + * Copyright 2010 Alex Gershgorin, Orex Computed Radiography
> + *
> + * The code contained herein is licensed under the GNU General Public
> + * License. You may obtain a copy of the GNU General Public License
> + * Version 2 or later at the following locations:
> + *
> + * http://www.opensource.org/licenses/gpl-license.html
> + * http://www.gnu.org/licenses/old-licenses/gpl-2.0.html
> + */
> +
> +#include <linux/fs.h>
> +#include <linux/err.h>
> +#include <linux/cdev.h>
> +#include <linux/gpio.h>
> +#include <linux/slab.h>
> +#include <linux/mutex.h>
> +#include <linux/delay.h>
> +#include <linux/device.h>
> +#include <linux/uaccess.h>
> +#include <linux/cyclone_as.h>
> +#include <linux/platform_device.h>
> +
> +/* Active Serial Instruction Set */
> +#define AS_WRITE_ENABLE		0x06
> +#define AS_WRITE_DISABLE	0x04
> +#define AS_READ_STATUS		0x05
> +#define AS_WRITE_STATUS		0x01
> +#define AS_READ_BYTES		0x03
> +#define AS_FAST_READ_BYTES	0x0B
> +#define AS_PAGE_PROGRAM		0x02
> +#define AS_ERASE_SECTOR		0xD8
> +#define AS_ERASE_BULK		0xC7
> +#define AS_READ_SILICON_ID	0xAB
> +#define AS_CHECK_SILICON_ID	0x9F
> +
> +#define AS_PAGE_SIZE		256
> +
> +#define AS_MAX_DEVS		16
> +
> +#define ASIO_DATA		0
> +#define ASIO_NCONFIG		1
> +#define ASIO_DCLK		2
> +#define ASIO_NCS		3
> +#define ASIO_NCE		4
> +#define AS_GPIO_NUM		5
> +
> +#define AS_ALIGNED(x)	IS_ALIGNED(x, AS_PAGE_SIZE)
> +
> +static struct class *cyclone_as_class;

Please don't create your own class just for a single driver.  Just use
the misc class interface instead, as all you really want/need here is a
character device node, right?

And as discussed at the Plumbers conference this past week, we don't
want to add any new 'struct class' implementations to the kernel from
now on, as it's the overall wrong thing to do.


> --- /dev/null
> +++ b/include/linux/cyclone_as.h

Why do you need a .h file at all?

thanks,

greg k-h
