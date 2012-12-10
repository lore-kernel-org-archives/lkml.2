Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751580Ab2LJQnJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 11:43:09 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34023 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750823Ab2LJQnI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 11:43:08 -0500
References: <20121210145134.GA2097@hedwig.ini.cmu.edu>
In-Reply-To: <20121210145134.GA2097@hedwig.ini.cmu.edu>
Mime-Version: 1.0 (1.0)
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain;
	charset=us-ascii
Message-Id: <34BBB83D-9531-4C44-99C8-02E04DF55D18@suse.de>
Cc: "rydberg@euromail.se" <rydberg@euromail.se>,
        "khali@linux-fr.org" <khali@linux-fr.org>,
        "linux@roeck-us.net" <linux@roeck-us.net>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rene@exactcode.com" <rene@exactcode.com>
X-Mailer: iPhone Mail (9B206)
From: Alexander Graf <agraf@suse.de>
Subject: Re: [PATCH] applesmc: add sysfs file to report OSK
Date: Mon, 10 Dec 2012 17:44:20 +0100
To: "Gabriel L. Somlo" <somlo@cmu.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 10.12.2012, at 15:51, "Gabriel L. Somlo" <somlo@cmu.edu> wrote:

> The AppleSMC contains two char[32] keys, OSK0 and OSK1, which are not
> reported in the key count and index by default. These keys are used by
> the OS X boot sequence, and normally don't matter when running Linux.
> 
> This patch creates a sysfs entry which reports the value of these keys
> as an ASCII string, to help emulators (such as QEMU) load OS X when
> running on genuine Apple hardware.
> 
> Signed-off-by: Gabriel L. Somlo <somlo@cmu.edu>

Acked-by: Alexander Graf <agraf@suse.de>

Alex

> ---
> 
> For extra context: To boot OS X as a guest, QEMU must (among others)
> emulate the AppleSMC. To boot successfully, OS X insists on querying
> the (emulated) SMC for the value of OSK0 and OSK1. Currently, these
> values must be supplied on the QEMU command line as
> 
>  -device applesmc,osk="...concatenated values of OSK0 and OSK1..."
> 
> With the availability of /sys/devices/platform/applesmc.768/osk, the
> emulated QEMU AppleSMC could acquire this string directly from the
> (Apple-manufactured) host machine.
> 
> Thanks,
>  Gabriel
> 
> drivers/hwmon/applesmc.c |   18 ++++++++++++++++++
> 1 files changed, 18 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/hwmon/applesmc.c b/drivers/hwmon/applesmc.c
> index b41baff..0c7cc71 100644
> --- a/drivers/hwmon/applesmc.c
> +++ b/drivers/hwmon/applesmc.c
> @@ -1013,6 +1013,23 @@ static ssize_t applesmc_key_at_index_store(struct device *dev,
>    return count;
> }
> 
> +static ssize_t applesmc_osk_show(struct device *dev,
> +                struct device_attribute *attr, char *sysfsbuf)
> +{
> +    int fail;
> +
> +    mutex_lock(&smcreg.mutex);
> +    fail = read_smc(APPLESMC_READ_CMD, "OSK0", sysfsbuf, 32) ||
> +           read_smc(APPLESMC_READ_CMD, "OSK1", sysfsbuf + 32, 32);
> +    mutex_unlock(&smcreg.mutex);
> +    if (fail)
> +        return -1;
> +
> +    sysfsbuf[64] = '\n';
> +    sysfsbuf[65] = '\0';
> +    return 65;
> +}
> +
> static struct led_classdev applesmc_backlight = {
>    .name            = "smc::kbd_backlight",
>    .default_trigger    = "nand-disk",
> @@ -1027,6 +1044,7 @@ static struct applesmc_node_group info_group[] = {
>    { "key_at_index_type", applesmc_key_at_index_type_show },
>    { "key_at_index_data_length", applesmc_key_at_index_data_length_show },
>    { "key_at_index_data", applesmc_key_at_index_read_show },
> +    { "osk", applesmc_osk_show },
>    { }
> };
> 
> -- 
> 1.7.7.6
> 
