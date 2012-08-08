Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757969Ab2HHSNS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 14:13:18 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:51131 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754543Ab2HHSNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 14:13:17 -0400
Date: Wed, 8 Aug 2012 13:07:51 -0500
From: Kent Yoder <key@linux.vnet.ibm.com>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-kernel@vger.kernel.org, tpmdd-devel@lists.sourceforge.net,
        Sirrix AG <tpmdd@sirrix.com>, Marcel Selhorst <tpmdd@selhorst.net>,
        Rajiv Andrade <mail@srajiv.net>, Seiji Munetoh <munetoh@jp.ibm.com>,
        Stefan Berger <stefanb@us.ibm.com>,
        Reiner Sailer <sailer@watson.ibm.com>, Kylene Hall <kjhall@us.ibm.com>
Subject: Re: [PATCH] tpm: Do not dereference NULL pointer if
 acpi_os_map_memory() fails.
Message-ID: <20120808180750.GA24016@linux.vnet.ibm.com>
References: <alpine.LNX.2.00.1208072247490.3227@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1208072247490.3227@swampdragon.chaosbits.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12080818-1780-0000-0000-000008295C41
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000290; HX=3.00000194; KW=3.00000007;
 PH=3.00000001; SC=3.00000006; SDB=6.00163619; UDB=6.00037017; UTC=2012-08-08
 18:13:15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 07, 2012 at 10:50:56PM +0200, Jesper Juhl wrote:
> In drivers/char/tpm/tpm_bios.c::read_log() we call
> acpi_os_map_memory(). That call may fail for a number of reasons
> (invallid address, out of memory etc). If the call fails it returns
> NULL and we just pass that to memcpy() unconditionally, which will go
> bad when it tries to dereference the pointer.
> 
> Unfortunately we just get NULL back, so we can't really tell the user
> exactely what went wrong, but we can at least avoid crashing and
> return an error (-EIO seemed more generic and more suitable here than
> -ENOMEM or something else, so I picked that).

Thanks Jesper. I'd made some updates to tpm_bios.c recently but this
should still apply. I'll let you know if not.

Kent

> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> ---
>  drivers/char/tpm/tpm_bios.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
>   Compile tested only.
> 
> diff --git a/drivers/char/tpm/tpm_bios.c b/drivers/char/tpm/tpm_bios.c
> index 0636520..0c5c274 100644
> --- a/drivers/char/tpm/tpm_bios.c
> +++ b/drivers/char/tpm/tpm_bios.c
> @@ -410,6 +410,11 @@ static int read_log(struct tpm_bios_log *log)
>  	log->bios_event_log_end = log->bios_event_log + len;
> 
>  	virt = acpi_os_map_memory(start, len);
> +	if (!virt) {
> +		printk("%s: ERROR - Unable to map memory\n",
> +			__func__);
> +		return -EIO;
> +	}
> 
>  	memcpy(log->bios_event_log, virt, len);
> 
> -- 
> 1.7.11.4
> 
> 
> -- 
> Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
> Don't top-post http://www.catb.org/jargon/html/T/top-post.html
> Plain text mails only, please.
> 

