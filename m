Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753928Ab2EIFij (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 01:38:39 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:64273 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751644Ab2EIFih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 01:38:37 -0400
Message-ID: <4FAA02DA.3000201@gmail.com>
Date: Tue, 08 May 2012 23:38:34 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Zheng Liu <gnehzuil.liu@gmail.com>
CC: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-scsi@vger.kernel.org, Jeff Garzik <jeff@garzik.org>,
        Zheng Liu <wenqing.lz@taobao.com>
Subject: Re: [RFC][PATCH] libata: enable SATA disk fua detection on default
References: <1336447443-4685-1-git-send-email-wenqing.lz@taobao.com>
In-Reply-To: <1336447443-4685-1-git-send-email-wenqing.lz@taobao.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/07/2012 09:24 PM, Zheng Liu wrote:
> From: Zheng Liu<wenqing.lz@taobao.com>
>
> Currently, SATA disk fua detection is disabled on default because most of
> devices don't support this feature at that time.  With the development of
> technology, more and more SATA disks support this feature.  So now we can enable
> this detection on default.
>
> Although fua detection is defined as a kernel module parameter, it is too hard
> to set its value because it must be loaded and set before system starts up.
> That needs to modify initrd file.  So it is inconvenient for administrator who
> needs to manage a huge number of servers.
>
> CC: Jeff Garzik<jeff@garzik.org>
> Signed-off-by: Zheng Liu<wenqing.lz@taobao.com>
> ---
>   drivers/ata/libata-core.c |    4 ++--
>   1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
> index 23763a1..3627251 100644
> --- a/drivers/ata/libata-core.c
> +++ b/drivers/ata/libata-core.c
> @@ -133,9 +133,9 @@ int atapi_passthru16 = 1;
>   module_param(atapi_passthru16, int, 0444);
>   MODULE_PARM_DESC(atapi_passthru16, "Enable ATA_16 passthru for ATAPI devices (0=off, 1=on [default])");
>
> -int libata_fua = 0;
> +int libata_fua = 1;
>   module_param_named(fua, libata_fua, int, 0444);
> -MODULE_PARM_DESC(fua, "FUA support (0=off [default], 1=on)");
> +MODULE_PARM_DESC(fua, "FUA support (0=off, 1=on [default])");
>
>   static int ata_ignore_hpa;
>   module_param_named(ignore_hpa, ata_ignore_hpa, int, 0644);

I don't see that this is very likely to cause issues, but the FUA 
implementation also seems a bit incomplete. FUA will only get enabled if 
the drive claims support for the FUA-specific commands like 
WRITE_DMA_FUA_EXT. But theoretically any drive that supports NCQ should 
be able to do FUA since there's a FUA bit provided in those commands. Of 
course this makes things a bit more complicated (for example, if NCQ 
gets disabled by user request or due to too many errors, and the drive 
doesn't support the separate FUA commands, then FUA needs to be disabled 
too.)
