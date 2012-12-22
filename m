Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751447Ab2LVOcW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2012 09:32:22 -0500
Received: from mail-la0-f45.google.com ([209.85.215.45]:52910 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751144Ab2LVOcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2012 09:32:17 -0500
Message-ID: <50D5C473.2030902@mvista.com>
Date: Sat, 22 Dec 2012 18:32:19 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Derek Basehore <dbasehore@chromium.org>
CC: JBottomley@parallels.com, jgarzik@pobox.com, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] don't wait on disk to start on resume
References: <1356064540-17414-1-git-send-email-dbasehore@chromium.org>
In-Reply-To: <1356064540-17414-1-git-send-email-dbasehore@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 21-12-2012 8:35, Derek Basehore wrote:

> We no longer wait for the disk to spin up in sd_resume. It now enters the
> request to spinup the disk into the elevator and returns.
>
> A function is scheduled under the scsi_sd_probe_domain to wait for the command
> to spinup the disk to complete. This function then checks for errors and cleans
> up after the sd resume function.

> This allows system resume to complete much faster on systems with an HDD since
> spinning up the disk is a significant portion of resume time.

> Signed-off-by: Derek Basehore <dbasehore@chromium.org>
> ---
>   drivers/scsi/sd.c |  106 +++++++++++++++++++++++++++++++++++++++++++++++++---
>   drivers/scsi/sd.h |    9 ++++
>   2 files changed, 108 insertions(+), 7 deletions(-)

> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 7992635..2fe051f 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
[...]
> @@ -3087,20 +3089,110 @@ done:
>   	return ret;
>   }
>
> +/*
> + * Callback function for when the request that starts the disk completes. Passed
> + * into blk_execute_rq_nowait in sd_resume.
> + */
> +static void sd_end_start_rq(struct request *rq, int error)
> +{
> +	struct completion *waiting = rq->end_io_data;
> +
> +	rq->end_io_data = NULL;
> +	/*
> +	 * Set the end_io_data to NULL before calling complete. This (with
> +	 * sd_resume async) ensures that it is set to NULL before we call
> +	 * blk_put_request.
> +	 */

    Shouldn't this comment precede the previous statement?

> +	complete(waiting);
> +}
[...]
>   static int sd_resume(struct device *dev)
>   {
>   	struct scsi_disk *sdkp = scsi_disk_get_from_dev(dev);
> -	int ret = 0;
> +	struct scsi_device *sdp = sdkp->device;
> +	struct resume_async_struct *resume = NULL;
> +	struct request *req;
> +	unsigned char cmd[6] = { START_STOP };	/* START_VALID */
>
> -	if (!sdkp->device->manage_start_stop)
> -		goto done;
> +	if (!sdkp->device->manage_start_stop) {
> +		scsi_disk_put(sdkp);
> +		return 0;
> +	}
>
>   	sd_printk(KERN_NOTICE, sdkp, "Starting disk\n");
> -	ret = sd_start_stop_device(sdkp, 1);
>
> -done:
> -	scsi_disk_put(sdkp);
> -	return ret;
> +	cmd[4] |= 1;	/* START */
> +
> +	if (sdp->start_stop_pwr_cond)
> +		cmd[4] |= 1 << 4;	/* Active */
> +
> +	if (!scsi_device_online(sdp))
> +		return -ENODEV;
> +
> +	resume = kzalloc(sizeof(struct resume_async_struct), GFP_NOIO);
> +	if (!resume)
> +		return DRIVER_ERROR << 24;
> +
> +	req = blk_get_request(sdp->request_queue, 0, __GFP_WAIT);
> +	if (!req)
> +		return DRIVER_ERROR << 24;
> +
> +	resume->req = req;
> +	resume->sdkp = sdkp;
> +	init_completion(&resume->wait);
> +
> +	req->cmd_len = COMMAND_SIZE(cmd[0]);
> +	memcpy(req->cmd, cmd, req->cmd_len);
> +	req->sense = resume->sense;
> +	req->sense_len = 0;

    Not SCSI_SENSE_BUFFERSIZE?

> +	req->retries = SD_MAX_RETRIES;
> +	req->timeout = SD_TIMEOUT;
> +	req->cmd_type = REQ_TYPE_BLOCK_PC;
> +	req->cmd_flags |= REQ_QUIET | REQ_PREEMPT;
> +	req->end_io_data = &resume->wait;
> +
> +	async_schedule_domain(sd_resume_async, resume, &scsi_sd_probe_domain);
> +	/*
> +	 * don't wait here for the disk to spin up, since we can resume faster
> +	 * if we don't. Cleanup and checking for errors is done the the

    s/the the/in the/

WBR, Sergei

