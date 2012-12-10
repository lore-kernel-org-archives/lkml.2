Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752109Ab2LJTvo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 14:51:44 -0500
Received: from smtprelay-h21.telenor.se ([195.54.99.196]:54575 "EHLO
	smtprelay-h21.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751881Ab2LJTvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 14:51:43 -0500
X-SENDER-IP: [85.230.168.206]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AshSAPQ7xlBV5qjOPGdsb2JhbABFinGzbRcDAQEBATg0gh4BAQQBOhwjBQsIAw4KLhQlChoTiAsKuBIUjCuDYmEDlgWFe41C
X-IronPort-AV: E=Sophos;i="4.84,253,1355094000"; 
   d="scan'208";a="168216715"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Mon, 10 Dec 2012 20:54:14 +0100
To: Guenter Roeck <groeck-dsl@sbcglobal.net>
Cc: "Gabriel L. Somlo" <somlo@cmu.edu>, khali@linux-fr.org, linux@roeck-us.net,
        lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org, agraf@suse.de,
        rene@exactcode.com
Subject: Re: [PATCH] applesmc: add sysfs file to report OSK
Message-ID: <20121210195414.GA642@polaris.bitmath.org>
References: <20121210145134.GA2097@hedwig.ini.cmu.edu>
 <20121210190905.GA24927@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121210190905.GA24927@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guenter,

> On Mon, Dec 10, 2012 at 09:51:35AM -0500, Gabriel L. Somlo wrote:
> > The AppleSMC contains two char[32] keys, OSK0 and OSK1, which are not
> > reported in the key count and index by default. These keys are used by
> > the OS X boot sequence, and normally don't matter when running Linux.
> > 
> > This patch creates a sysfs entry which reports the value of these keys
> > as an ASCII string, to help emulators (such as QEMU) load OS X when
> > running on genuine Apple hardware.
> > 
> > Signed-off-by: Gabriel L. Somlo <somlo@cmu.edu>
> > ---
> > 
> > For extra context: To boot OS X as a guest, QEMU must (among others)
> > emulate the AppleSMC. To boot successfully, OS X insists on querying
> > the (emulated) SMC for the value of OSK0 and OSK1. Currently, these
> > values must be supplied on the QEMU command line as
> > 
> >   -device applesmc,osk="...concatenated values of OSK0 and OSK1..."
> > 
> > With the availability of /sys/devices/platform/applesmc.768/osk, the
> > emulated QEMU AppleSMC could acquire this string directly from the
> > (Apple-manufactured) host machine.
> > 
> Hmm ... this is a non-hwmon attribute which doesn't really belong into hwmon
> in the first place ... like several other attributes in the same driver.
> 
> So I'll leave it up to the maintainer to decide if we should accept it. Henrik ?

Indeed, the reaons against this patch are too many. I was just about
to reply with the below:

Gabriel,

The OSK string seems constant accross machines, which renders the
patch rather pointless, no? And even if the OSK differs between a
couple of machines, the emulator could easily handle it gracefully.

There are also some technical issues with the patch below, to keep in
mind for future submissions.

>  drivers/hwmon/applesmc.c |   18 ++++++++++++++++++
>  1 files changed, 18 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/hwmon/applesmc.c b/drivers/hwmon/applesmc.c
> index b41baff..0c7cc71 100644
> --- a/drivers/hwmon/applesmc.c
> +++ b/drivers/hwmon/applesmc.c
> @@ -1013,6 +1013,23 @@ static ssize_t applesmc_key_at_index_store(struct device *dev,
>  	return count;
>  }
>  
> +static ssize_t applesmc_osk_show(struct device *dev,
> +				struct device_attribute *attr, char *sysfsbuf)
> +{
> +	int fail;

All other functions use 'ret' here...

> +
> +	mutex_lock(&smcreg.mutex);
> +	fail = read_smc(APPLESMC_READ_CMD, "OSK0", sysfsbuf, 32) ||
> +	       read_smc(APPLESMC_READ_CMD, "OSK1", sysfsbuf + 32, 32);

The read function should propagate error messages, i.e., keep the
return values here. And please read to buffers instead.

> +	mutex_unlock(&smcreg.mutex);
> +	if (fail)
> +		return -1;

Return error here.

> +
> +	sysfsbuf[64] = '\n';
> +	sysfsbuf[65] = '\0';
> +	return 65;

A snprintf here, please.

> +}
> +
>  static struct led_classdev applesmc_backlight = {
>  	.name			= "smc::kbd_backlight",
>  	.default_trigger	= "nand-disk",
> @@ -1027,6 +1044,7 @@ static struct applesmc_node_group info_group[] = {
>  	{ "key_at_index_type", applesmc_key_at_index_type_show },
>  	{ "key_at_index_data_length", applesmc_key_at_index_data_length_show },
>  	{ "key_at_index_data", applesmc_key_at_index_read_show },
> +	{ "osk", applesmc_osk_show },

Unfortunately this is not a good place to put random things going
forward.

>  	{ }
>  };
>  
> -- 
> 1.7.7.6
> 

Given the above issues together with the weak rationale for the patch
in the first place, this patch will not be applied.

Thanks.
Henrik
