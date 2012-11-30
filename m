Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932139Ab2K3JIH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 04:08:07 -0500
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:41228 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750856Ab2K3JIB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 04:08:01 -0500
Message-ID: <1354266477.2259.5.camel@dabdike.int.hansenpartnership.com>
Subject: Re: [PATCH] scsi: prevent stack buffer overflow in host_reset
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 30 Nov 2012 09:07:57 +0000
In-Reply-To: <1353012706-28182-1-git-send-email-sasha.levin@oracle.com>
References: <1353012706-28182-1-git-send-email-sasha.levin@oracle.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-11-15 at 15:51 -0500, Sasha Levin wrote:
> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> index ce5224c..77ba946 100644
> --- a/drivers/scsi/scsi_sysfs.c
> +++ b/drivers/scsi/scsi_sysfs.c
> @@ -249,9 +249,9 @@ static DEVICE_ATTR(active_mode, S_IRUGO | S_IWUSR, show_shost_active_mode, NULL)
>  
>  static int check_reset_type(char *str)
>  {
> -	if (strncmp(str, "adapter", 10) == 0)
> +	if (sysfs_streq(str, "adapter"))
>  		return SCSI_ADAPTER_RESET;
> -	else if (strncmp(str, "firmware", 10) == 0)
> +	else if (sysfs_streq(str, "firmware"))
>  		return SCSI_FIRMWARE_RESET;
>  	else
>  		return 0;
> @@ -264,12 +264,9 @@ store_host_reset(struct device *dev, struct device_attribute *attr,
>  	struct Scsi_Host *shost = class_to_shost(dev);
>  	struct scsi_host_template *sht = shost->hostt;
>  	int ret = -EINVAL;
> -	char str[10];
>  	int type;
>  
> -	sscanf(buf, "%s", str);
> -	type = check_reset_type(str);
> -
> +	type = check_reset_type(buf);
>  	if (!type)
>  		goto exit_store_host_reset;

You didn't compile test this:

  CC [M]  drivers/scsi/scsi_sysfs.o
drivers/scsi/scsi_sysfs.c: In function ‘store_host_reset’:
drivers/scsi/scsi_sysfs.c:269:2: warning: passing argument 1 of ‘check_reset_type’ discards ‘const’ qualifier from pointer target type [enabled by default]
drivers/scsi/scsi_sysfs.c:250:12: note: expected ‘char *’ but argument is of type ‘const char *’

It needs a const in check_reset_type().

I've added it.

James



