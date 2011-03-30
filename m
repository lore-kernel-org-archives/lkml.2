Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965143Ab1C3VNT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:13:19 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:57470 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933632Ab1C3VNQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:13:16 -0400
Message-ID: <4D939CE5.1090405@linux.vnet.ibm.com>
Date: Wed, 30 Mar 2011 17:13:09 -0400
From: Stefan Berger <stefanb@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: ak@linux.intel.com, guichaz@gmail.com, srajiv@linux.vnet.ibm.com,
        gregkh@suse.de, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com
Subject: Re: [PATCH] [73/275] tpm_tis: Use timeouts returned from TPM
References: <20110330203.501921634@firstfloor.org> <20110330210510.8AF143E1A05@tassilo.jf.intel.com>
In-Reply-To: <20110330210510.8AF143E1A05@tassilo.jf.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/30/2011 05:05 PM, Andi Kleen wrote:

Please drop it. It has been rejected previously. A revised patch has 
been sent.

    Stefab

> 2.6.35-longterm review patch.  If anyone has any objections, please let me know.
>
> ------------------
> From: Stefan Berger<stefanb@linux.vnet.ibm.com>
>
> commit 9b29050f8f75916f974a2d231ae5d3cd59792296 upstream.
>
> The current TPM TIS driver in git discards the timeout values returned
> from the TPM. The check of the response packet needs to consider that
> the return_code field is 0 on success and the size of the expected
> packet is equivalent to the header size + u32 length indicator for the
> TPM_GetCapability() result + 3 timeout indicators of type u32.
>
> I am also adding a sysfs entry 'timeouts' showing the timeouts that are
> being used.
>
> Signed-off-by: Stefan Berger<stefanb@linux.vnet.ibm.com>
> Signed-off-by: Andi Kleen<ak@linux.intel.com>
> Tested-by: Guillaume Chazarain<guichaz@gmail.com>
> Signed-off-by: Rajiv Andrade<srajiv@linux.vnet.ibm.com>
> Signed-off-by: Greg Kroah-Hartman<gregkh@suse.de>
>
> ---
>   drivers/char/tpm/tpm.c     |   18 ++++++++++++++++--
>   drivers/char/tpm/tpm.h     |    2 ++
>   drivers/char/tpm/tpm_tis.c |    4 +++-
>   3 files changed, 21 insertions(+), 3 deletions(-)
>
> Index: linux-2.6.35.y/drivers/char/tpm/tpm.c
> ===================================================================
> --- linux-2.6.35.y.orig/drivers/char/tpm/tpm.c	2011-03-29 23:02:59.667308683 -0700
> +++ linux-2.6.35.y/drivers/char/tpm/tpm.c	2011-03-29 23:02:59.685308223 -0700
> @@ -567,9 +567,11 @@
>   	if (rc)
>   		return;
>
> -	if (be32_to_cpu(tpm_cmd.header.out.return_code)
> -	    != 3 * sizeof(u32))
> +	if (be32_to_cpu(tpm_cmd.header.out.return_code) != 0 ||
> +	    be32_to_cpu(tpm_cmd.header.out.length)
> +	    != sizeof(tpm_cmd.header.out) + sizeof(u32) + 3 * sizeof(u32))
>   		return;
> +
>   	duration_cap =&tpm_cmd.params.getcap_out.cap.duration;
>   	chip->vendor.duration[TPM_SHORT] =
>   	    usecs_to_jiffies(be32_to_cpu(duration_cap->tpm_short));
> @@ -913,6 +915,18 @@
>   }
>   EXPORT_SYMBOL_GPL(tpm_show_caps_1_2);
>
> +ssize_t tpm_show_timeouts(struct device *dev, struct device_attribute *attr,
> +			  char *buf)
> +{
> +	struct tpm_chip *chip = dev_get_drvdata(dev);
> +
> +	return sprintf(buf, "%d %d %d\n",
> +	               jiffies_to_usecs(chip->vendor.duration[TPM_SHORT]),
> +	               jiffies_to_usecs(chip->vendor.duration[TPM_MEDIUM]),
> +	               jiffies_to_usecs(chip->vendor.duration[TPM_LONG]));
> +}
> +EXPORT_SYMBOL_GPL(tpm_show_timeouts);
> +
>   ssize_t tpm_store_cancel(struct device *dev, struct device_attribute *attr,
>   			const char *buf, size_t count)
>   {
> Index: linux-2.6.35.y/drivers/char/tpm/tpm.h
> ===================================================================
> --- linux-2.6.35.y.orig/drivers/char/tpm/tpm.h	2011-03-29 22:51:40.876677237 -0700
> +++ linux-2.6.35.y/drivers/char/tpm/tpm.h	2011-03-29 23:02:59.685308223 -0700
> @@ -56,6 +56,8 @@
>   				char *);
>   extern ssize_t tpm_show_temp_deactivated(struct device *,
>   					 struct device_attribute *attr, char *);
> +extern ssize_t tpm_show_timeouts(struct device *,
> +				 struct device_attribute *attr, char *);
>
>   struct tpm_chip;
>
> Index: linux-2.6.35.y/drivers/char/tpm/tpm_tis.c
> ===================================================================
> --- linux-2.6.35.y.orig/drivers/char/tpm/tpm_tis.c	2011-03-29 22:51:40.877677211 -0700
> +++ linux-2.6.35.y/drivers/char/tpm/tpm_tis.c	2011-03-29 23:02:59.686308198 -0700
> @@ -355,6 +355,7 @@
>   		   NULL);
>   static DEVICE_ATTR(caps, S_IRUGO, tpm_show_caps_1_2, NULL);
>   static DEVICE_ATTR(cancel, S_IWUSR | S_IWGRP, NULL, tpm_store_cancel);
> +static DEVICE_ATTR(timeouts, S_IRUGO, tpm_show_timeouts, NULL);
>
>   static struct attribute *tis_attrs[] = {
>   	&dev_attr_pubek.attr,
> @@ -364,7 +365,8 @@
>   	&dev_attr_owned.attr,
>   	&dev_attr_temp_deactivated.attr,
>   	&dev_attr_caps.attr,
> -	&dev_attr_cancel.attr, NULL,
> +	&dev_attr_cancel.attr,
> +	&dev_attr_timeouts.attr, NULL,
>   };
>
>   static struct attribute_group tis_attr_grp = {

