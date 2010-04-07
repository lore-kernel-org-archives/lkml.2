Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754717Ab0DGSNR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 14:13:17 -0400
Received: from ppsw-7.csi.cam.ac.uk ([131.111.8.137]:45906 "EHLO
	ppsw-7.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375Ab0DGSNQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 14:13:16 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4BBCCBDC.8080609@cam.ac.uk>
Date: Wed, 07 Apr 2010 19:15:56 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20100109 Thunderbird/3.0
MIME-Version: 1.0
To: yauhen.kharuzhy@promwad.com
CC: linux-kernel@vger.kernel.org, Jeff Mahoney <jeffm@suse.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] IIO: Fix adding more than one iio device eventset
References: <1270652625-30640-1-git-send-email-yauhen.kharuzhy@promwad.com>
In-Reply-To: <1270652625-30640-1-git-send-email-yauhen.kharuzhy@promwad.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

NACK

Thanks for the patch.  The first bug was fixed by a patch from Sonic Zhang.
Andrew Morton picked it up so it is in the mm tree.  Thanks for the report
of this particularly horrible bug though as had been there quite a while before
Sonic pointed it out!

http://userweb.kernel.org/~akpm/mmotm/broken-out/iio-iio_get_new_idr_val-return-negative-value-on-failure-fix.patch

I don't think the second is actually a bug.  I agree it would make more sense if the numbering
of event_line_sources matched that of the character device through which the events
are read, but technically it doesn't have to do so.  So your fix for this one is
reasonable but not vital.  It is actually a typo either, more or an evolutionary
disconnect in naming!   The relevant code is removed entirely by the abi change
patch set.  On that iirc the equivalent sysfs files are in

/sys/bus/iio/devices/device[n]:event[m]
which can also be acessed via
/sys/bus/iio/devices/device[n]/device[n]:event[m]

For reference, the relevant patches are:

http://marc.info/?l=linux-iio&m=126980876128689&w=2
and
http://marc.info/?l=linux-iio&m=126980876328704&w=2

These will probably have a v2 before I send these to lkml - if nothing else some
of the early patches in the series have pending changes and as it turns out
a few minor reworks of the abi spec are still needed to avoid ambiguous event
parameter naming.

Thanks again,

Jonathan

> iio_get_new_idr_val() returns new id, but this value was checked as
> usual error code.
> 
> Also fix typo in sysfs attribute name generation, seems that this name
> should be unique.
> 
> Signed-off-by: Yauhen Kharuzhy <yauhen.kharuzhy@promwad.com>
> ---
>  drivers/staging/iio/industrialio-core.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/iio/industrialio-core.c b/drivers/staging/iio/industrialio-core.c
> index b456dfc..8d33584 100644
> --- a/drivers/staging/iio/industrialio-core.c
> +++ b/drivers/staging/iio/industrialio-core.c
> @@ -659,7 +659,7 @@ static int iio_device_register_eventset(struct iio_dev *dev_info)
>  	for (i = 0; i < dev_info->num_interrupt_lines; i++) {
>  		dev_info->event_interfaces[i].owner = dev_info->driver_module;
>  		ret = iio_get_new_idr_val(&iio_event_idr);
> -		if (ret)
> +		if (ret < 0)
>  			goto error_free_setup_ev_ints;
>  		else
>  			dev_info->event_interfaces[i].id = ret;
> @@ -685,7 +685,7 @@ static int iio_device_register_eventset(struct iio_dev *dev_info)
>  
>  	for (i = 0; i < dev_info->num_interrupt_lines; i++) {
>  		snprintf(dev_info->event_interfaces[i]._attrname, 20,
> -			"event_line%d_sources", i);
> +			"event_line%d_sources", dev_info->event_interfaces[i].id);
>  		dev_info->event_attrs[i].name
>  			= (const char *)
>  			(dev_info->event_interfaces[i]._attrname);

