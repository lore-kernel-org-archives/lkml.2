Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932450Ab1FGVfm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 17:35:42 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:48923 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932408Ab1FGVfJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 17:35:09 -0400
X-Sasl-enc: dfDG69PYrA06qa/kdxOZvdu7NmuvpCzsajJYntXsHoYj 1307482508
Date: Tue, 7 Jun 2011 14:34:18 -0700
From: Greg KH <greg@kroah.com>
To: =?iso-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Matt Mooney <mfm@muteddisk.com>,
        Kulikov Vasiliy <segooon@gmail.com>, Endre Kollar <taxy443@gmail.com>,
        Arjan Mels <arjan.mels@gmx.net>, Ilia Mirkin <imirkin@alum.mit.edu>,
        David Chang <dchang@novell.com>,
        Himanshu Chauhan <hschauhan@nulltrace.org>,
        Max Vozeler <max@vozeler.com>, Arnd Bergmann <arnd@arndb.de>,
        usbip-devel@lists.sourceforge.net, devel@driverdev.osuosl.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usbip: handle length at sysfs show() functions
Message-ID: <20110607213418.GB11102@kroah.com>
References: <4DE5CA9F.6010303@freemail.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4DE5CA9F.6010303@freemail.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 01, 2011 at 07:14:07AM +0200, Németh Márton wrote:
> From: Márton Németh <nm127@freemail.hu>
> 
> The sysfs show() functions shall return the actual content length of
> the result buffer. According to Documentation/filesystems/sysfs.txt:215
> the scnprintf() function is preferred.
> 
> See also the article titled "snprintf() confusion" at
> http://lwn.net/Articles/69419/ .
> 
> Signed-off-by: Márton Németh <nm127@freemail.hu>
> ---
> diff --git a/drivers/staging/usbip/stub_dev.c b/drivers/staging/usbip/stub_dev.c
> index 6e99ec8..af5f107 100644
> --- a/drivers/staging/usbip/stub_dev.c
> +++ b/drivers/staging/usbip/stub_dev.c
> @@ -80,7 +80,7 @@ static ssize_t show_status(struct device *dev, struct device_attribute *attr,
>  	status = sdev->ud.status;
>  	spin_unlock(&sdev->ud.lock);
> 
> -	return snprintf(buf, PAGE_SIZE, "%d\n", status);
> +	return scnprintf(buf, PAGE_SIZE, "%d\n", status);

Actually, this can be changed to just be:
	return sprintf(buf, "%d\n", status);
as obviously an integer will never be bigger than the sysfs buffer.

Good rule of thumb, if you care about the size of the sysfs buffer, you
are doing something wrong.

Case in point:

> --- a/drivers/staging/usbip/stub_main.c
> +++ b/drivers/staging/usbip/stub_main.c
> @@ -79,18 +79,22 @@ static ssize_t show_match_busid(struct device_driver *drv, char *buf)
>  {
>  	int i;
>  	char *out = buf;
> +	int count = 0;
> 
>  	spin_lock(&busid_table_lock);
> 
>  	for (i = 0; i < MAX_BUSID; i++)
> -		if (busid_table[i].name[0])
> -			out += sprintf(out, "%s ", busid_table[i].name);
> +		if (busid_table[i].name[0]) {
> +			count += scnprintf(out, PAGE_SIZE - count,
> +					"%s ", busid_table[i].name);
> +			out = buf + count;
> +		}

Here we are doing lots of work to try to put more than one value in the
sysfs file, and return the proper data to the kernel about how big the
buffer we used.

That's wrong, and violates the "one value per file" sysfs rule, so that
should be fixed instead of trying to change the sprintf() call.

Same goes for other places in this patch.

Care to redo that instead?

thanks,

greg k-h
