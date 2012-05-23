Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933580Ab2EWOSR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 10:18:17 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56512 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964867Ab2EWOSL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 10:18:11 -0400
MIME-Version: 1.0
In-Reply-To: <20120523084945.GA4085@opensource.wolfsonmicro.com>
References: <CAOMZO5A-05jTYpEEPfnJvWpby1YJ1M7=KPn=zahbQrQOgbjR4g@mail.gmail.com>
	<201205221053.21792.marc@cpdesign.com.au>
	<CAOMZO5BCcFOktp9mqDCpnrVhbK6pwO1R3ZdiKPfawb=KLjzzWw@mail.gmail.com>
	<CAOMZO5DKsrXJoSSacwYFoHUw6pPWLWQnC3gS=6=3k6nvf6tggw@mail.gmail.com>
	<20120523084945.GA4085@opensource.wolfsonmicro.com>
Date: Wed, 23 May 2012 11:18:10 -0300
Message-ID: <CAOMZO5DKLO5B7vbMKmXLfmR0zgVX5bVcxK22khTt=X71bL5tOQ@mail.gmail.com>
Subject: Re: mc13xxx-core: kernel hangs after 'regmap_read'
From: Fabio Estevam <festevam@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: marc@cpdesign.com.au, Samuel Ortiz <sameo@linux.intel.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        =?UTF-8?Q?Philippe_R=C3=A9tornaz?= <philippe.retornaz@epfl.ch>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark,

On Wed, May 23, 2012 at 5:49 AM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:

> You shouldn't be setting bits_per_word at all, that'll corrupt the data
> that regmap has formatted.  Does removing that alone resolve the issue?

Removing only the line that sets bits_per_word:

--- a/drivers/mfd/mc13xxx-spi.c
+++ b/drivers/mfd/mc13xxx-spi.c
@@ -73,7 +73,6 @@ static int mc13xxx_spi_probe(struct spi_device *spi)

        dev_set_drvdata(&spi->dev, mc13xxx);
        spi->mode = SPI_MODE_0 | SPI_CS_HIGH;
-       spi->bits_per_word = 32;

        mc13xxx->dev = &spi->dev;
        mutex_init(&mc13xxx->lock);


, does allow the kernel to boot, but the mx13xxx driver is not probed anymore:

spi_imx imx31-cspi.1: master is unqueued, this is deprecated
spi_imx imx31-cspi.1: probed
spi_imx imx31-cspi.0: master is unqueued, this is deprecated
l4f00242t03 spi0.0: l4f00242t03_probe: Unable to get the IO regulator
spi spi0.0: Driver l4f00242t03 requests probe deferral
spi_imx imx31-cspi.0: probed

Also, on the previous raw spi access version we had:

#define MC13XXX_REGOFFSET_SHIFT 25
int mc13xxx_reg_read(struct mc13xxx *mc13xxx, unsigned int offset, u32 *val)
{
	struct spi_transfer t;
	struct spi_message m;
	int ret;

	BUG_ON(!mutex_is_locked(&mc13xxx->lock));

	if (offset > MC13XXX_NUMREGS)
		return -EINVAL;

	*val = offset << MC13XXX_REGOFFSET_SHIFT;
....

,would the spi regmap access take into account this
MC13XXX_REGOFFSET_SHIFT operation?

I haven't been able to see it in the regmap spi access.
