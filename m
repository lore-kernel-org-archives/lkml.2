Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933184Ab2EOP6i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 11:58:38 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:53165 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933149Ab2EOP6g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 11:58:36 -0400
Message-ID: <4FB27D2A.5070309@ti.com>
Date: Tue, 15 May 2012 08:58:34 -0700
From: Russ Dill <Russ.Dill@ti.com>
Organization: Texas Instruments
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120509 Thunderbird/13.0
MIME-Version: 1.0
To: Pantelis Antoniou <panto@antoniou-consulting.com>
CC: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [g_mass_storage] Fix unmount problem with OS-X
References: <1337158489-27142-1-git-send-email-panto@antoniou-consulting.com>
In-Reply-To: <1337158489-27142-1-git-send-email-panto@antoniou-consulting.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/16/2012 01:54 AM, Pantelis Antoniou wrote:
> OS-X uses a sequence on unmounting that makes us close the backing
> file. Apparently there's no way to open it again, which makes it
> impossible to remount without rmmod'ing g_mass_storage.
>
> Fix this by adding a media_ejected flag to each lun, and keeping
> track of it properly.
>
> Any other method (i.e. preventing unmount, and not keeping track
> of the eject status) failed due to OS-X sending start stop commands
> after the unmount and checking again.
> ---
>  drivers/usb/gadget/f_mass_storage.c |   21 ++++++++++++++-------
>  drivers/usb/gadget/storage_common.c |   11 +++++++++++
>  2 files changed, 25 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/usb/gadget/f_mass_storage.c b/drivers/usb/gadget/f_mass_storage.c
> index cb8c162..b865d20 100644
> --- a/drivers/usb/gadget/f_mass_storage.c
> +++ b/drivers/usb/gadget/f_mass_storage.c
> @@ -1445,6 +1445,9 @@ static int do_start_stop(struct fsg_common *common)
>  			curlun->sense_data = SS_MEDIUM_NOT_PRESENT;
>  			return -EINVAL;
>  		}
> +
> +		/* if the host is trying again, the media are mounted */
> +		fsg_lun_set_ejected(curlun, 0);
>  		return 0;
>  	}
>  
> @@ -1468,11 +1471,15 @@ static int do_start_stop(struct fsg_common *common)
>  			return 0;
>  	}
>  
> -	up_read(&common->filesem);
> -	down_write(&common->filesem);
> -	fsg_lun_close(curlun);
> -	up_write(&common->filesem);
> -	down_read(&common->filesem);
> +	/*
> +	 * Do not close the LUNs, just made them invisible.
> +	 * When the next exception comes we make them visible
> +	 * again. This fixes the bug where MacOSX unmounts
> +	 * and then it's impossible to mount again, since
> +	 * fsg_lun_open is never called again.
> +	 */
> +
> +	fsg_lun_set_ejected(curlun, 1);
>  
>  	return common->ops && common->ops->post_eject
>  		? min(0, common->ops->post_eject(common, curlun,
> @@ -1531,7 +1538,6 @@ static int do_mode_select(struct fsg_common *common, struct fsg_buffhd *bh)
>  	return -EINVAL;
>  }
>  
> -
>  /*-------------------------------------------------------------------------*/
>  
>  static int halt_bulk_in_endpoint(struct fsg_dev *fsg)
> @@ -1917,7 +1923,7 @@ static int check_command(struct fsg_common *common, int cmnd_size,
>  
>  	/* If the medium isn't mounted and the command needs to access
>  	 * it, return an error. */
> -	if (curlun && !fsg_lun_is_open(curlun) && needs_medium) {
> +	if (curlun && !fsg_lun_is_open_and_mounted(curlun) && needs_medium) {
>  		curlun->sense_data = SS_MEDIUM_NOT_PRESENT;
>  		return -EINVAL;
>  	}
> @@ -2533,6 +2539,7 @@ static void handle_exception(struct fsg_common *common)
>  			curlun->unit_attention_data = SS_NO_SENSE;
>  			curlun->sense_data_info = 0;
>  			curlun->info_valid = 0;
> +			curlun->media_ejected = 0;
>  		}
>  		common->state = FSG_STATE_IDLE;
>  	}
> diff --git a/drivers/usb/gadget/storage_common.c b/drivers/usb/gadget/storage_common.c
> index 8081ca3..723c6aa 100644
> --- a/drivers/usb/gadget/storage_common.c
> +++ b/drivers/usb/gadget/storage_common.c
> @@ -199,6 +199,7 @@ struct fsg_lun {
>  	unsigned int	registered:1;
>  	unsigned int	info_valid:1;
>  	unsigned int	nofua:1;
> +	unsigned int	media_ejected:1;
>  
>  	u32		sense_data;
>  	u32		sense_data_info;
> @@ -211,6 +212,16 @@ struct fsg_lun {
>  
>  #define fsg_lun_is_open(curlun)	((curlun)->filp != NULL)
>  
> +#define fsg_lun_is_ejected(curlun) ((curlun)->media_ejected)
> +
> +#define fsg_lun_set_ejected(curlun, v) ((curlun)->media_ejected = !!(v))
> +
> +#define fsg_lun_is_open_and_mounted(curlun) \
> +	({ \
> +		const struct fsg_lun *_curlun = (curlun); \
> +		fsg_lun_is_open(_curlun) && !fsg_lun_is_ejected(_curlun); \
> +	 })
> +
>  static struct fsg_lun *fsg_lun_from_dev(struct device *dev)
>  {
>  	return container_of(dev, struct fsg_lun, dev);


Acked-by: Russ.Dill@ti.com


