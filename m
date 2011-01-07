Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753881Ab1AGPTw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 10:19:52 -0500
Received: from hedwig.cmf.nrl.navy.mil ([134.207.12.162]:33731 "EHLO
	hedwig.cmf.nrl.navy.mil" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753050Ab1AGPTu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 10:19:50 -0500
X-Greylist: delayed 981 seconds by postgrey-1.27 at vger.kernel.org; Fri, 07 Jan 2011 10:19:50 EST
Date: Fri, 7 Jan 2011 10:02:39 -0500
From: chas williams - CONTRACTOR <chas@cmf.nrl.navy.mil>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Madge Ambassador ATM Adapter driver: Always
 release_firmware() in ucode_init() and don't leak memory.
Message-ID: <20110107100239.28032e5d@thirdoffive.cmf.nrl.navy.mil>
In-Reply-To: <alpine.LNX.2.00.1101062203160.13988@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1101062203160.13988@swampdragon.chaosbits.net>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-NRLCMF-Spam-Score: () hits=-0.011
X-NRLCMF-Virus-Scanned: No virus found
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

instead of duplicating the same section again and again, could you
write something like:

	errmsg = "no start record";
	goto fail;

	...

	errmsg = "record to long"
	goto fail;

	.... whatever ...

	return 0;

fail:
	release_firmware(fw)
	PRINTK(KERN_ERR, "Bad microcode data (%s)\n", errmsg);
	return -EINVAL;
}

On Thu, 6 Jan 2011 22:06:37 +0100 (CET)
Jesper Juhl <jj@chaosbits.net> wrote:

> 
> Failure to call release_firmware() will result in memory leak in 
> drivers/atm/ambassador.c::ucode_init().
> This patch makes sure we always call release_firmware() when needed, thus 
> removing the leak(s).
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> ---
>  ambassador.c |    5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
>   Compile tested only since I have no way to actually test this.
> 
> diff --git a/drivers/atm/ambassador.c b/drivers/atm/ambassador.c
> index ffe9b65..ab56539 100644
> --- a/drivers/atm/ambassador.c
> +++ b/drivers/atm/ambassador.c
> @@ -1927,7 +1927,7 @@ static int __devinit ucode_init (loader_block * lb, amb_dev * dev) {
>    unsigned long start_address;no start record
>    const struct ihex_binrec *rec;
>    int res;
> -  
> +
>    res = request_ihex_firmware(&fw, "atmsar11.fw", &dev->pci_dev->dev);
>    if (res) {
>      PRINTK (KERN_ERR, "Cannot load microcode data");
> @@ -1937,6 +1937,7 @@ static int __devinit ucode_init (loader_block * lb, amb_dev * dev) {
>    /* First record contains just the start address */
>    rec = (const struct ihex_binrec *)fw->data;
>    if (be16_to_cpu(rec->len) != sizeof(__be32) || be32_to_cpu(rec->addr)) {
> +    release_firmware(fw);
>      PRINTK (KERN_ERR, "Bad microcode data (no start record)");
>      return -EINVAL;
>    }
> @@ -1950,10 +1951,12 @@ static int __devinit ucode_init (loader_block * lb, amb_dev * dev) {
>      PRINTD (DBG_LOAD, "starting region (%x, %u)", be32_to_cpu(rec->addr),
>  	    be16_to_cpu(rec->len));
>      if (be16_to_cpu(rec->len) > 4 * MAX_TRANSFER_DATA) {
> +	    release_firmware(fw);
>  	    PRINTK (KERN_ERR, "Bad microcode data (record too long)");
>  	    return -EINVAL;
>      }
>      if (be16_to_cpu(rec->len) & 3) {
> +	    release_firmware(fw);
>  	    PRINTK (KERN_ERR, "Bad microcode data (odd number of bytes)");
>  	    return -EINVAL;
>      }
> 
> 
> 

