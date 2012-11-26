Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754662Ab2KZKBJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 05:01:09 -0500
Received: from mo-p05-ob.rzone.de ([81.169.146.182]:41512 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753371Ab2KZKBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 05:01:07 -0500
X-Greylist: delayed 363 seconds by postgrey-1.27 at vger.kernel.org; Mon, 26 Nov 2012 05:01:07 EST
X-RZG-AUTH: :IW0NeWC7b/q2i6W/qstXb1SBUuFnrGoheedClaTaNdBkW0QOb9J0FJuBIKwwprdJ0g==
X-RZG-CLASS-ID: mo05
Message-ID: <50B33C6C.4070503@gmail.com>
Date: Mon, 26 Nov 2012 10:54:52 +0100
From: Stefan Roese <stefan.roese@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Ming Lei <ming.lei@canonical.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] firmware: Add Lattice ECP3 FPGA configuration via SPI
References: <1353657505-23003-1-git-send-email-sr@denx.de> <CACVXFVPy-x-kp3a5UnqYuhAeB+h05PZA7xFn9FK_Vd4MsbYV8A@mail.gmail.com>
In-Reply-To: <CACVXFVPy-x-kp3a5UnqYuhAeB+h05PZA7xFn9FK_Vd4MsbYV8A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26/2012 02:35 AM, Ming Lei wrote:
> On Fri, Nov 23, 2012 at 3:58 PM, Stefan Roese <sr@denx.de> wrote:
>> This patch adds support for bitstream configuration (programming /
>> loading) of the Lattice ECP3 FPGA's via the SPI bus.
>>
>> Here an example on my custom MPC5200 based board:
>>
>> $ echo 1 > /sys/class/firmware/lattice-ecp3.0/loading
>> $ cat fpga_a4m2k.bit > /sys/class/firmware/lattice-ecp3.0/data
>> $ echo 0 > /sys/class/firmware/lattice-ecp3.0/loading
>>
>> leads to these messages:
>>
>> lattice-ecp3 spi32766.0: FPGA Lattice ECP3-35 detected
>> lattice-ecp3 spi32766.0: Configuring the FPGA...
>> lattice-ecp3 spi32766.0: FPGA succesfully configured!
>>
>> Signed-off-by: Stefan Roese <sr@denx.de>
>> Cc: Ming Lei <ming.lei@canonical.com>
>> ---
>>  arch/powerpc/Kconfig                   |   2 +
>>  drivers/firmware/Kconfig               |  11 ++
>>  drivers/firmware/Makefile              |   1 +
>>  drivers/firmware/lattice-ecp3-config.c | 254 +++++++++++++++++++++++++++++++++
> 
> The driver is just a firmware loader, so looks 'drivers/firmware/' is not
> a good place for it. And it is better to make the driver as part  the
> of the FPGA driver, such as other drivers which need downloading firmware,
> or you can put it under 'drivers/spi' if there is no such fpga driver.

This FPGA loading via the firmware infrastructure is completely
independent from the FPGA device driver. Its common for all Lattice ECP3
FPGA's. So I would like to place this loading driver into a generic
directory. If firmware is wrong then I'll move this driver for the next
version to drivers/spi.

> BTW, you'd better to CC maintainers of this directory.

Will do.

<snip>

>> +static struct platform_device pseudo_dev = {
>> +       .name = DRIVER_NAME,
>> +       .id   = 0,
>> +       .num_resources = 0,
>> +       .dev  = {
>> +               .release = dev_release,
>> +       }
>> +};
> 
> Why do you introduce one such device? If you just make it
> as the parent of firmware device, it is not correct and unnecessary,
> see below.

Good point. Will fix in next version.

>> +
>> +static struct device *ecp3_device = &pseudo_dev.dev;
>> +
>> +static void firmware_load(const struct firmware *fw, void *context)
>> +{
>> +       struct spi_device *spi = (struct spi_device *)context;
>> +       static u8 *buffer;
> 
> Defining the buffer as static is dangerous and will make the buffer shared by
> more than one such FPGA device, so buffer data may become broken and
> cause downloading a mistaken firmware.

Fixed.

<snip>

>> +static int __devinit lattice_ecp3_probe(struct spi_device *spi)
>> +{
>> +       int err;
>> +
>> +       if (platform_device_register(&pseudo_dev))
>> +               return -ENODEV;
>> +
>> +       err = request_firmware_nowait(THIS_MODULE, FW_ACTION_NOHOTPLUG,
>> +                                     FIRMWARE_NAME, ecp3_device,
> 
> The &spi->dev should be passed to request_firmware_nowait() instead of
> the pseudo-device, which is wrong. It is a device lifetime thing. When you
> download firmware via spi device, you should make sure the spi device
> is live during firmware downloading, so the spi device should be passed to
> request_firmware_nowait() to make it as the parent of the firmware device.

Fixed.

Thanks for the review,
Stefan

