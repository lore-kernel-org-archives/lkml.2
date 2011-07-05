Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755487Ab1GEQIh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 12:08:37 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:60402 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755403Ab1GEQIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 12:08:36 -0400
X-Sasl-enc: 5p6DZjEGFJZhTXQI+l1UYsAIxEUqS01bh9VzzqXCE+Ex 1309882115
Date: Tue, 5 Jul 2011 09:04:08 -0700
From: Greg KH <greg@kroah.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, Haiyang Zhang <haiyangz@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: Re: [PATCH 09/77] Staging: hv: blkvsc: Use the newly introduced
 vmbus ID in the blockvsc driver
Message-ID: <20110705160408.GB7214@kroah.com>
References: <1308255393-3785-1-git-send-email-kys@microsoft.com>
 <1308255470-3826-1-git-send-email-kys@microsoft.com>
 <1308255470-3826-9-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1308255470-3826-9-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 16, 2011 at 01:16:42PM -0700, K. Y. Srinivasan wrote:
> Setup the newly introduced id_table for the blkvsc driver.:
> 
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
> ---
>  drivers/staging/hv/blkvsc_drv.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/staging/hv/blkvsc_drv.c b/drivers/staging/hv/blkvsc_drv.c
> index 3612574..5842db8 100644
> --- a/drivers/staging/hv/blkvsc_drv.c
> +++ b/drivers/staging/hv/blkvsc_drv.c
> @@ -802,10 +802,15 @@ static void blkvsc_request(struct request_queue *queue)
>  	}
>  }
>  
> +static const struct hv_vmbus_device_id id_table[] = {
> +	{ "hv_block" },
> +	{ "" }
> +};

Ick.  Yeah, I was afraid of this :(

You are trying to use a "human" name here, which you could just use the
macro for the module name.

But, we don't care about the module name, we just care about what GUID
this driver says it supports.  So put that in the driver, then use the
module alias for that GUID and have modprobe figure out what module to
load based on when the GUID is seen by the vmbus and exposed to
userspace through the hotplug event.

Think of the GUID as a PCI vendor/device/class signature, that's all it
is.  None of this wierd "names" that you have to keep track of in the
core, and in the driver, and hope to keep them all in sync all the time.

So no, this isn't the way to do this sorry, please redo it like
PCI/USB/the entire rest of the kernel does it.

thanks,

greg k-h
