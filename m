Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755478Ab2LLXDM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 18:03:12 -0500
Received: from SMTP.ANDREW.CMU.EDU ([128.2.11.61]:39511 "EHLO
	smtp.andrew.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754013Ab2LLXDL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 18:03:11 -0500
Date: Wed, 12 Dec 2012 18:01:28 -0500
From: "Gabriel L. Somlo" <somlo@cmu.edu>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Guenter Roeck <groeck-dsl@sbcglobal.net>, khali@linux-fr.org,
        linux@roeck-us.net, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org, agraf@suse.de, rene@exactcode.com
Subject: Re: [PATCH v2] applesmc: add sysfs file to report OSK
Message-ID: <20121212230128.GE16373@lobsang.ini.cmu.edu>
References: <20121210195414.GA642@polaris.bitmath.org>
 <20121210222313.GF2097@hedwig.ini.cmu.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121210222313.GF2097@hedwig.ini.cmu.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-PMX-Version: 5.5.9.388399, Antispam-Engine: 2.7.2.376379, Antispam-Data: 2011.3.18.170322
X-SMTP-Spam-Clean: 8% (
 BODY_SIZE_3000_3999 0, BODY_SIZE_5000_LESS 0, BODY_SIZE_7000_LESS 0, FROM_EDU_TLD 0, RDNS_GENERIC_POOLED 0, RDNS_POOLED 0, RDNS_SUSP 0, RDNS_SUSP_GENERIC 0, RDNS_SUSP_SPECIFIC 0, __BOUNCE_CHALLENGE_SUBJ 0, __BOUNCE_NDR_SUBJ_EXEMPT 0, __CD 0, __CT 0, __CT_TEXT_PLAIN 0, __HAS_MSGID 0, __MIME_TEXT_ONLY 0, __MIME_VERSION 0, __PHISH_SPEAR_STRUCTURE_1 0, __RDNS_POOLED_9 0, __SANE_MSGID 0, __TO_MALFORMED_2 0, __USER_AGENT 0)
X-SMTP-Spam-Score: 8%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Henrik, I agree with you that it's silly to poke the hardware for a
string we KNOW will NEVER change :)

That being said, I too would love to live in a world where technical
common sense prevailed over bullshit lawyerly tactics, "corporate
strategies", and the ensuing FUD.

The way things stand today, in order to boot Mac OS X on QEMU/KVM/Linux
(running on Mac hardware of course, in compliance with Apple's license)
requires the end user supplying the OSK on the QEMU command line via the
-osk="..." argument.

I would like to make it easy for people who run Linux natively on Apple
hardware (of which I am one) to run OS X from QEMU "out of the box".

I could try to hardcode the OSK inside QEMU, or I could try to include
it as a default config file entry, but I'm quite certain the QEMU project
would be uncomfortable "distributing" a string on which Apple claims
copyright. Even if that happened, distros might then balk at shipping
QEMU as part of their package repositories, for the exact same reason.

Currently, we're all beating around the bush about the OSK, with vague
hints and hoops to jump through for end users to acquire the OSK and
pass it to QEMU on the command line. This process will have the
unfortunate side effect of filtering out "normal" users :(

The only viable (from a legal CYA standpoint) thing I can think of is
to make it easy to acquire the OSK automatically, on demand, directly
from the hardware. Right now, the logical place for that is applesmc.ko.
It already controls access to the SMC, and already reports values for
various keys.

Yes it may feel silly to "go through the motions" when you KNOW it's
always going to be the same value that gets returned. But this patch
is mostly about reassuring people that lawyers will continue not to
have a reason to get involved...

Thanks for reading, and hope I'm being sufficiently persuasive :)
--Gabriel

>  drivers/hwmon/applesmc.c |   19 +++++++++++++++++++
>  1 files changed, 19 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/hwmon/applesmc.c b/drivers/hwmon/applesmc.c
> index b41baff..b37b271 100644
> --- a/drivers/hwmon/applesmc.c
> +++ b/drivers/hwmon/applesmc.c
> @@ -1013,6 +1013,24 @@ static ssize_t applesmc_key_at_index_store(struct device *dev,
>  	return count;
>  }
>  
> +static ssize_t applesmc_osk_show(struct device *dev,
> +				struct device_attribute *attr, char *sysfsbuf)
> +{
> +	int ret;
> +	char buf[65];
> +
> +	mutex_lock(&smcreg.mutex);
> +	ret = read_smc(APPLESMC_READ_CMD, "OSK0", buf, 32);
> +	if (!ret)
> +		ret = read_smc(APPLESMC_READ_CMD, "OSK1", buf + 32, 32);
> +	mutex_unlock(&smcreg.mutex);
> +	if (ret)
> +		return ret;
> +
> +	buf[64] = '\0';
> +	return snprintf(sysfsbuf, PAGE_SIZE, "%s\n", buf);
> +}
> +
>  static struct led_classdev applesmc_backlight = {
>  	.name			= "smc::kbd_backlight",
>  	.default_trigger	= "nand-disk",
> @@ -1027,6 +1045,7 @@ static struct applesmc_node_group info_group[] = {
>  	{ "key_at_index_type", applesmc_key_at_index_type_show },
>  	{ "key_at_index_data_length", applesmc_key_at_index_data_length_show },
>  	{ "key_at_index_data", applesmc_key_at_index_read_show },
> +	{ "osk", applesmc_osk_show },
>  	{ }
>  };
>  
> -- 
> 1.7.7.6
