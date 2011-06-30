Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754002Ab1F3TlA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 15:41:00 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:49851
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752149Ab1F3Tk5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 15:40:57 -0400
Date: Thu, 30 Jun 2011 15:40:55 -0400
From: Christoph Hellwig <hch@infradead.org>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: Re: [PATCH 24/40] Staging: hv: storvsc: On I/O get the correct IDE
 device
Message-ID: <20110630194055.GC22707@infradead.org>
References: <1309358301-8488-1-git-send-email-kys@microsoft.com>
 <1309358377-8537-1-git-send-email-kys@microsoft.com>
 <1309358377-8537-24-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1309358377-8537-24-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 29, 2011 at 07:39:21AM -0700, K. Y. Srinivasan wrote:
> We use the channel number to distinguish an IDE device managed by the
> storvsc driver from scsi devices. Add code to get the correct
> device pointer based on the channel number.
> 
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
> Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
> ---
>  drivers/staging/hv/storvsc_drv.c |   10 ++++++++++
>  1 files changed, 10 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
> index cf659d7..fcc3f5d 100644
> --- a/drivers/staging/hv/storvsc_drv.c
> +++ b/drivers/staging/hv/storvsc_drv.c
> @@ -517,6 +517,16 @@ static int storvsc_queuecommand_lck(struct scsi_cmnd *scmnd,
>  	unsigned int sg_count = 0;
>  	struct vmscsi_request *vm_srb;
>  
> +	if (scmnd->device->channel >= HV_IDE_BASE_CHANNEL) {
> +		int channel = scmnd->device->channel;
> +
> +		/*
> +		 * This is an IDE device; get the right dev.
> +		 */
> +
> +		dev = ide_devices[channel - HV_IDE_BASE_CHANNEL];
> +	}

So instead of playing games about getting the right hv_device here,
why don't you register one scsi host for each IDE device? libata
does the same for real ATA devices.

