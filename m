Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757645Ab2HPPpJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 11:45:09 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:55752 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751920Ab2HPPpG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 11:45:06 -0400
Date: Thu, 16 Aug 2012 10:45:07 -0500
From: Kent Yoder <key@linux.vnet.ibm.com>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-kernel@vger.kernel.org, tpmdd-devel@lists.sourceforge.net,
        Sirrix AG <tpmdd@sirrix.com>, Marcel Selhorst <tpmdd@selhorst.net>,
        Rajiv Andrade <mail@srajiv.net>, Seiji Munetoh <munetoh@jp.ibm.com>,
        Stefan Berger <stefanb@us.ibm.com>,
        Reiner Sailer <sailer@watson.ibm.com>, Kylene Hall <kjhall@us.ibm.com>
Subject: Re: [PATCH] tpm: Do not dereference NULL pointer if
 acpi_os_map_memory() fails.
Message-ID: <20120816154507.GA3850@linux.vnet.ibm.com>
References: <alpine.LNX.2.00.1208072247490.3227@swampdragon.chaosbits.net>
 <20120808180750.GA24016@linux.vnet.ibm.com>
 <20120815201527.GC27618@linux.vnet.ibm.com>
 <alpine.LNX.2.00.1208160001080.7818@swampdragon.chaosbits.net>
 <alpine.LNX.2.00.1208160011160.7818@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1208160011160.7818@swampdragon.chaosbits.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12081615-7182-0000-0000-0000024E8DA7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 16, 2012 at 12:16:33AM +0200, Jesper Juhl wrote:
> In drivers/char/tpm/tpm_acpi.c::read_log() we call
> acpi_os_map_memory(). That call may fail for a number of reasons
> (invalid address, out of memory etc). If the call fails it returns
> NULL and we just pass that to memcpy() unconditionally, which will go
> bad when it tries to dereference the pointer.
> 
> Unfortunately we just get NULL back, so we can't really tell the user
> exactely what went wrong, but we can at least avoid crashing and
> return an error (-EIO seemed more generic and more suitable here than
> -ENOMEM or something else, so I picked that).

  Thanks Jesper, applied here:

git://github.com/shpedoikal/linux.git v3.6-rc1-tpmdd-staging

Kent

> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> ---
>  drivers/char/tpm/tpm_acpi.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
>  note: this patch is against git://github.com/shpedoikal/linux.git v3.6-rc1-tpmdd-staging
> 
> diff --git a/drivers/char/tpm/tpm_acpi.c b/drivers/char/tpm/tpm_acpi.c
> index a1bb5a18..fe3fa94 100644
> --- a/drivers/char/tpm/tpm_acpi.c
> +++ b/drivers/char/tpm/tpm_acpi.c
> @@ -96,6 +96,11 @@ int read_log(struct tpm_bios_log *log)
>  	log->bios_event_log_end = log->bios_event_log + len;
> 
>  	virt = acpi_os_map_memory(start, len);
> +	if (!virt) {
> +		kfree(log->bios_event_log);
> +		printk("%s: ERROR - Unable to map memory\n", __func__);
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

