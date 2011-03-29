Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752493Ab1C2Oer (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 10:34:47 -0400
Received: from e24smtp01.br.ibm.com ([32.104.18.85]:50517 "EHLO
	e24smtp01.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751348Ab1C2Oeq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 10:34:46 -0400
Message-ID: <4D91EE00.1000801@linux.vnet.ibm.com>
Date: Tue, 29 Mar 2011 11:34:40 -0300
From: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Lightning/1.0b2 Thunderbird/3.1.8
MIME-Version: 1.0
To: Stefan Berger <stefanb@linux.vnet.ibm.com>
CC: debora@linux.vnet.ibm.com, tpmdd-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, jirislaby@gmail.com, preining@logic.at
Subject: Re: [patch 1/8] tpm_tis: Use timeouts returned from TPM
References: <20110315111307.895085413@linux.vnet.ibm.com> <20110315111425.620707275@linux.vnet.ibm.com>
In-Reply-To: <20110315111425.620707275@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 11032914-6842-0000-0000-0000013F026B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stefan,

Some comments:

On 03/15/2011 08:13 AM, Stefan Berger wrote:
> v3:
> - sysfs entry now called 'durations' to resemble TPM-speak (previously
>   was called 'timeouts')
> 
> v2:
> - adjusting all timeouts for TPM devices reporting timeouts in msec rather
>   than usec

This is a bugfix that's different than the one you originally sent, can you
submit this as a separated patch? This is mainly for easier debug in the
future, so each feature/bugfix/commit can be tested separately.

> - also displaying in sysfs whether the timeouts are 'original' or 'adjusted'
> 

Minor comment, it's easier to read the log when the changelog comes after the main 
patch description.

> The current TPM TIS driver in git discards the timeout values returned
> from the TPM. The check of the response packet needs to consider that
> the return_code field is 0 on success and the size of the expected
> packet is equivalent to the header size + u32 length indicator for the
> TPM_GetCapability() result + 3 timeout indicators of type u32.
> 
> Since some TPMs seem to return timeouts in msec rather than usec,
> I am now adjusting all the timeouts rather than just the one for short
> durations.
> 
> I am also adding a sysfs entry 'durations' showing the timeouts that are
> being used.
> 
> Signed-off-by: Stefan Berger <stefanb@linux.vnet.ibm.com> 
> 
> ---
>  drivers/char/tpm/tpm.c     |   38 ++++++++++++++++++++++++++++++--------
>  drivers/char/tpm/tpm.h     |    3 +++
>  drivers/char/tpm/tpm_tis.c |    4 +++-
>  3 files changed, 36 insertions(+), 9 deletions(-)
> 
> Index: linux-2.6/drivers/char/tpm/tpm.c
> ===================================================================
> --- linux-2.6.orig/drivers/char/tpm/tpm.c
> +++ linux-2.6/drivers/char/tpm/tpm.c
> @@ -575,23 +575,31 @@ duration:
>  	if (rc)
>  		return;
> 
> -	if (be32_to_cpu(tpm_cmd.header.out.return_code)
> -	    != 3 * sizeof(u32))
> +	if (be32_to_cpu(tpm_cmd.header.out.return_code) != 0 ||
> +	    be32_to_cpu(tpm_cmd.header.out.length)
> +	    != sizeof(tpm_cmd.header.out) + sizeof(u32) + 3 * sizeof(u32))
>  		return;
> +
>  	duration_cap = &tpm_cmd.params.getcap_out.cap.duration;
>  	chip->vendor.duration[TPM_SHORT] =
>  	    usecs_to_jiffies(be32_to_cpu(duration_cap->tpm_short));
> +	chip->vendor.duration[TPM_MEDIUM] =
> +	    usecs_to_jiffies(be32_to_cpu(duration_cap->tpm_medium));
> +	chip->vendor.duration[TPM_LONG] =
> +	    usecs_to_jiffies(be32_to_cpu(duration_cap->tpm_long));
> +
>  	/* The Broadcom BCM0102 chipset in a Dell Latitude D820 gets the above
>  	 * value wrong and apparently reports msecs rather than usecs. So we
>  	 * fix up the resulting too-small TPM_SHORT value to make things work.
> +	 * We also scale the TPM_MEDIUM and -_LONG values by 1000.
>  	 */
> -	if (chip->vendor.duration[TPM_SHORT] < (HZ/100))
> +	if (chip->vendor.duration[TPM_SHORT] < (HZ / 100)) {
>  		chip->vendor.duration[TPM_SHORT] = HZ;
> -
> -	chip->vendor.duration[TPM_MEDIUM] =
> -	    usecs_to_jiffies(be32_to_cpu(duration_cap->tpm_medium));
> -	chip->vendor.duration[TPM_LONG] =
> -	    usecs_to_jiffies(be32_to_cpu(duration_cap->tpm_long));
> +		chip->vendor.duration[TPM_MEDIUM] *= 1000;
> +		chip->vendor.duration[TPM_LONG] *= 1000;
> +		chip->vendor.duration_adjusted = true;
> +		dev_info(chip->dev, "Adjusting TPM timeout parameters.");
> +	}
>  }
>  EXPORT_SYMBOL_GPL(tpm_get_timeouts);
> 
> @@ -937,6 +945,20 @@ ssize_t tpm_show_caps_1_2(struct device 
>  }
>  EXPORT_SYMBOL_GPL(tpm_show_caps_1_2);
> 
> +ssize_t tpm_show_durations(struct device *dev, struct device_attribute *attr,
> +			  char *buf)
> +{
> +	struct tpm_chip *chip = dev_get_drvdata(dev);
> +
> +	return sprintf(buf, "%d %d %d [%s]\n",
> +		       jiffies_to_usecs(chip->vendor.duration[TPM_SHORT]),
> +		       jiffies_to_usecs(chip->vendor.duration[TPM_MEDIUM]),
> +		       jiffies_to_usecs(chip->vendor.duration[TPM_LONG]),
> +		       chip->vendor.duration_adjusted
> +		       ? "adjusted" : "original");
> +}
> +EXPORT_SYMBOL_GPL(tpm_show_durations);
> +
>  ssize_t tpm_store_cancel(struct device *dev, struct device_attribute *attr,
>  			const char *buf, size_t count)
>  {
> Index: linux-2.6/drivers/char/tpm/tpm.h
> ===================================================================
> --- linux-2.6.orig/drivers/char/tpm/tpm.h
> +++ linux-2.6/drivers/char/tpm/tpm.h
> @@ -56,6 +56,8 @@ extern ssize_t tpm_show_owned(struct dev
>  				char *);
>  extern ssize_t tpm_show_temp_deactivated(struct device *,
>  					 struct device_attribute *attr, char *);
> +extern ssize_t tpm_show_durations(struct device *,
> +				  struct device_attribute *attr, char *);
> 
>  struct tpm_chip;
> 
> @@ -82,6 +84,7 @@ struct tpm_vendor_specific {
>  	int locality;
>  	unsigned long timeout_a, timeout_b, timeout_c, timeout_d; /* jiffies */
>  	unsigned long duration[3]; /* jiffies */
> +	bool duration_adjusted;
> 
>  	wait_queue_head_t read_queue;
>  	wait_queue_head_t int_queue;
> Index: linux-2.6/drivers/char/tpm/tpm_tis.c
> ===================================================================
> --- linux-2.6.orig/drivers/char/tpm/tpm_tis.c
> +++ linux-2.6/drivers/char/tpm/tpm_tis.c
> @@ -376,6 +376,7 @@ static DEVICE_ATTR(temp_deactivated, S_I
>  		   NULL);
>  static DEVICE_ATTR(caps, S_IRUGO, tpm_show_caps_1_2, NULL);
>  static DEVICE_ATTR(cancel, S_IWUSR | S_IWGRP, NULL, tpm_store_cancel);
> +static DEVICE_ATTR(durations, S_IRUGO, tpm_show_durations, NULL);
> 
>  static struct attribute *tis_attrs[] = {
>  	&dev_attr_pubek.attr,
> @@ -385,7 +386,8 @@ static struct attribute *tis_attrs[] = {
>  	&dev_attr_owned.attr,
>  	&dev_attr_temp_deactivated.attr,
>  	&dev_attr_caps.attr,
> -	&dev_attr_cancel.attr, NULL,
> +	&dev_attr_cancel.attr,
> +	&dev_attr_durations.attr, NULL,
>  };
> 
>  static struct attribute_group tis_attr_grp = {
> 

