Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752789Ab1FTTum (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 15:50:42 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:49623 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751352Ab1FTTul (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 15:50:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=X2/HGPftExhIEs+jOjEaake1TiWSG5LbNotmCEezZqQRXCOFtOPumq6sVYXzDs8jLH
         uW8PJv46URGdFnNFOcL2NlxHvSA7t5sB4M55V/GCa56VnRk24mSJ8SX9HspmkV6UCDNJ
         zm4HB/re8hkcVjO/JqI1yRk0iukra3J/HXjM8=
Date: Mon, 20 Jun 2011 22:50:38 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Peter Huewe <peterhuewe@gmx.de>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Ian Lartey <ian@opensource.wolfsonmicro.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 1/2 v2] mfd/ab3550: Convert to kstrtou8_from_user
Message-ID: <20110620195037.GA2534@p183.telecom.by>
References: <BANLkTikKRVP4PW48YtR+mMMNsaxTDxoGtw@mail.gmail.com>
 <1308599189-28555-1-git-send-email-peterhuewe@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1308599189-28555-1-git-send-email-peterhuewe@gmx.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 20, 2011 at 09:46:28PM +0200, Peter Huewe wrote:
> @@ -923,27 +916,16 @@ static ssize_t ab3550_address_write(struct file *file,
>  	size_t count, loff_t *ppos)
>  {
>  	struct ab3550 *ab = ((struct seq_file *)(file->private_data))->private;
> -	char buf[32];
> -	int buf_size;
> -	unsigned long user_address;
> +	u8 user_address;
>  	int err;
>  
> -	/* Get userspace string and assure termination */
> -	buf_size = min(count, (sizeof(buf) - 1));
> -	if (copy_from_user(buf, user_buf, buf_size))
> -		return -EFAULT;
> -	buf[buf_size] = 0;
> -
> -	err = strict_strtoul(buf, 0, &user_address);
> +	/* Get userspace string and convert to number */
> +	err = kstrtou8_from_user(user_buf, count, 0, &user_address);
>  	if (err)
> -		return -EINVAL;
> -	if (user_address > 0xff) {
> -		dev_err(&ab->i2c_client[0]->dev,
> -			"debugfs error input > 0xff\n");
> -		return -EINVAL;
> -	}
> +		return err;
> +
>  	ab->debug_address = user_address;
> -	return buf_size;
> +	return count;

You don't need temporary variable and should write straight to final location,
because kstrto* functions will never write to result unless it was converted
successfully.
