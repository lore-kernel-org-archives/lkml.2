Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932444Ab1BCS6y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 13:58:54 -0500
Received: from smtp.infotech.no ([82.134.31.41]:38063 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756316Ab1BCS6x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 13:58:53 -0500
X-Greylist: delayed 343 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 Feb 2011 13:58:53 EST
Message-ID: <4D4AF98D.9020000@interlog.com>
Date: Thu, 03 Feb 2011 13:53:01 -0500
From: Douglas Gilbert <dgilbert@interlog.com>
Reply-To: dgilbert@interlog.com
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: djwong@us.ibm.com
CC: James Bottomley <James.Bottomley@HansenPartnership.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] scsi_debug: Fix 32-bit overflow in do_device_access
References: <20110201024754.GS27190@tux1.beaverton.ibm.com>
In-Reply-To: <20110201024754.GS27190@tux1.beaverton.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11-01-31 09:47 PM, Darrick J. Wong wrote:
> If I create a scsi_debug device that is larger than 4GB, the multiplication of
> (block * scsi_debug_sector_size) can produce a 64-bit value.  Unfortunately,
> the compiler sees two 32-bit quantities and performs a 32-bit multiplication,
> thus truncating the bits above 2^32.  This causes the wrong memory location to
> be read or written.  Change block and rest to be unsigned long long.

Not sure why 'rest' also needs to be 64 bit.
The third argument of this call:
    ret = func(scmd, fake_storep, rest * scsi_debug_sector_size);
later in do_device_access() is declared int.

> Signed-off-by: Darrick J. Wong<djwong@us.ibm.com>
Acked-by: Douglas Gilbert <dgilbert@interlog.com>

> ---
>
>   drivers/scsi/scsi_debug.c |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index 7b31093..a6b2d72 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -1671,7 +1671,7 @@ static int do_device_access(struct scsi_cmnd *scmd,
>   			    unsigned long long lba, unsigned int num, int write)
>   {
>   	int ret;
> -	unsigned int block, rest = 0;
> +	unsigned long long block, rest = 0;
>   	int (*func)(struct scsi_cmnd *, unsigned char *, int);
>
>   	func = write ? fetch_to_dev_buffer : fill_from_dev_buffer;
>

