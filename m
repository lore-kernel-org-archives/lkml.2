Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760294Ab2EVTpN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 15:45:13 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35525 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758356Ab2EVTpL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 15:45:11 -0400
Message-ID: <4FBBECC2.10503@gmail.com>
Date: Tue, 22 May 2012 12:45:06 -0700
From: David Daney <ddaney.cavm@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: David Daney <ddaney.cavm@gmail.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Rob Herring <rob.herring@calxeda.com>,
        "spi-devel-general@lists.sourceforge.net" 
	<spi-devel-general@lists.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Liam Girdwood <lrg@ti.com>, Tabi Timur-B04825 <B04825@freescale.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [PATCH 1/3] of: Add prefix parameter to of_modalias_node().
References: <1336773923-17866-1-git-send-email-ddaney.cavm@gmail.com> <1336773923-17866-2-git-send-email-ddaney.cavm@gmail.com> <20120520055436.13AF03E03B8@localhost> <20120520060802.03CE73E03B8@localhost>
In-Reply-To: <20120520060802.03CE73E03B8@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/19/2012 11:08 PM, Grant Likely wrote:
> On Sat, 19 May 2012 23:54:36 -0600, Grant Likely<grant.likely@secretlab.ca>  wrote:
>> On Fri, 11 May 2012 15:05:21 -0700, David Daney<ddaney.cavm@gmail.com>  wrote:
>>> From: David Daney<david.daney@cavium.com>
>>>
>>> When generating MODALIASes, it is convenient to add things like "spi:"
>>> or "i2c:" to the front of the strings.  This allows the standard
>>> modprobe to find the right driver when automatically populating bus
>>> children from the device tree structure.
>>>
>>> Add a prefix parameter, and adjust callers.  For
>>> of_register_spi_devices() use the "spi:" prefix.
>>>
>>> Signed-off-by: David Daney<david.daney@cavium.com>
>>
>> Applied, thanks.  Some notes below...
>
> Wait... why is this necessary?

Because in of_register_spi_devices() in of_spi.c, you do:

	request_module(spi->modalias);

The string passed to request_module() must have the "spi:" prefix.


> The module type prefix isn't stored in
> the modalias value for any other bus type as far as I can see,

It is only useful with the prefix, so I though I would add it to the 
stored value.

> and
> with this series it appears that the "spi:" prefix may or may not be
> present in the modalias.  That doesn't look right.

Perhaps, but the with the combination of patches 1/3 and 2/3 I tried to 
ensure that the prefix would always be present for SPI devices.

>
> Why isn't prefixing spi: at uevent time sufficient?

Because udev may not be loading the driver.

> IIUC, modprobe
> depends on either UEVENT or the modalias attribute to know which
> driver to probe.  It does look like the attribute is missing the spi:
> prefix though.  Does the following change work instead of these two
> patches?
>

No.

> diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
> index 3d8f662..da8aac7 100644
> --- a/drivers/spi/spi.c
> +++ b/drivers/spi/spi.c
> @@ -51,7 +51,7 @@ modalias_show(struct device *dev, struct device_attribute *a, char *buf)
>   {
>          const struct spi_device *spi = to_spi_device(dev);
>
> -       return sprintf(buf, "%s\n", spi->modalias);
> +       return sprintf(buf, "%s%s\n", SPI_MODULE_PREFIX, spi->modalias);
>   }
>
> So, I've dropped this patch from my tree.  If the change above works
> for you then I'll push it out.
>
> g.
>

