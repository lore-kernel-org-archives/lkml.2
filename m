Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932425Ab2GBHKM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 03:10:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41746 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751871Ab2GBHKJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 03:10:09 -0400
Message-ID: <4FF14957.3040007@redhat.com>
Date: Mon, 02 Jul 2012 09:10:15 +0200
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Ben Hutchings <ben@decadent.org.uk>
CC: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Alan Stern <stern@rowland.harvard.edu>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        Matthew Dharm <mdharm-usb@one-eyed-alien.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [ 38/48] SCSI & usb-storage: add try_rc_10_first flag
References: <20120701172012.078559139@decadent.org.uk>
In-Reply-To: <20120701172012.078559139@decadent.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch is a better fix for the issue first fixed by:
"usb-storage: Add 090c:1000 to unusal-devs", so the same applies to
this patch, let me quote my reply to the stable-review for that patch:

"I'm not sure if this is needed with 3.2, it is needed with 3.4 because
recently the usb-storage driver was changed to report the supported
scsi level as reported by the device, rather then always report a
scsi level of 2. This change causes sd.c to try READ_CAPACITY(16)
first, which foobars up not only this one device, but as it turns
out a lot of others too, so we're working on another fix
(and I believe that 3.2 is unaffected)."

So since 3.2 already tries READ_CAPACITY(10) first, this patch is
not needed. It does not harm either, and if the scsi level reporting
change ever finds its way into 3.2 stable (which it should not
IMHO), then this patch will be needed.

Regards,

Hans


On 07/01/2012 07:20 PM, Ben Hutchings wrote:
> 3.2-stable review patch.  If anyone has any objections, please let me know.
>
> ------------------
>
> From: Alan Stern <stern@rowland.harvard.edu>
>
> commit 6a0bdffa0073857870a4ed1b4489762146359eb4 upstream.
>
> Several bug reports have been received recently for USB mass-storage
> devices that don't handle READ CAPACITY(16) commands properly.  They
> report bogus sizes, in some cases becoming unusable as a result.
>
> The bugs were triggered by commit
> 09b6b51b0b6c1b9bb61815baf205e4d74c89ff04 (SCSI & usb-storage: add
> flags for VPD pages and REPORT LUNS), which caused usb-storage to stop
> overriding the SCSI level reported by devices.  By default, the sd
> driver will try READ CAPACITY(16) first for any device whose level is
> above SCSI_SPC_2.
>
> It seems likely that any device large enough to require the use of
> READ CAPACITY(16) (i.e., 2 TB or more) would be able to handle READ
> CAPACITY(10) commands properly.  Indeed, I don't know of any devices
> that don't handle READ CAPACITY(10) properly.
>
> Therefore this patch (as1559) adds a new flag telling the sd driver
> to try READ CAPACITY(10) before READ CAPACITY(16), and sets this flag
> for every USB mass-storage device.  If a device really is larger than
> 2 TB, sd will fall back to READ CAPACITY(16) just as it used to.
>
> This fixes Bugzilla #43391.
>
> Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
> Acked-by: Hans de Goede <hdegoede@redhat.com>
> CC: "James E.J. Bottomley" <JBottomley@parallels.com>
> CC: Matthew Dharm <mdharm-usb@one-eyed-alien.net>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> ---
>   drivers/scsi/sd.c              |    2 ++
>   drivers/usb/storage/scsiglue.c |    6 ++++++
>   include/scsi/scsi_device.h     |    1 +
>   3 files changed, 9 insertions(+)
>
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 6f0a4c6..6f72b80 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -1899,6 +1899,8 @@ static int sd_try_rc16_first(struct scsi_device *sdp)
>   {
>   	if (sdp->host->max_cmd_len < 16)
>   		return 0;
> +	if (sdp->try_rc_10_first)
> +		return 0;
>   	if (sdp->scsi_level > SCSI_SPC_2)
>   		return 1;
>   	if (scsi_device_protection(sdp))
> diff --git a/drivers/usb/storage/scsiglue.c b/drivers/usb/storage/scsiglue.c
> index a324a5d..11418da 100644
> --- a/drivers/usb/storage/scsiglue.c
> +++ b/drivers/usb/storage/scsiglue.c
> @@ -202,6 +202,12 @@ static int slave_configure(struct scsi_device *sdev)
>   		if (us->fflags & US_FL_NO_READ_CAPACITY_16)
>   			sdev->no_read_capacity_16 = 1;
>
> +		/*
> +		 * Many devices do not respond properly to READ_CAPACITY_16.
> +		 * Tell the SCSI layer to try READ_CAPACITY_10 first.
> +		 */
> +		sdev->try_rc_10_first = 1;
> +
>   		/* assume SPC3 or latter devices support sense size > 18 */
>   		if (sdev->scsi_level > SCSI_SPC_2)
>   			us->fflags |= US_FL_SANE_SENSE;
> diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
> index 6efb2e1..ba96988 100644
> --- a/include/scsi/scsi_device.h
> +++ b/include/scsi/scsi_device.h
> @@ -151,6 +151,7 @@ struct scsi_device {
>   					   SD_LAST_BUGGY_SECTORS */
>   	unsigned no_read_disc_info:1;	/* Avoid READ_DISC_INFO cmds */
>   	unsigned no_read_capacity_16:1; /* Avoid READ_CAPACITY_16 cmds */
> +	unsigned try_rc_10_first:1;	/* Try READ_CAPACACITY_10 first */
>   	unsigned is_visible:1;	/* is the device visible in sysfs */
>
>   	DECLARE_BITMAP(supported_events, SDEV_EVT_MAXBITS); /* supported events */
>
>

