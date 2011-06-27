Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754902Ab1F0W1V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 18:27:21 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:42124 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755041Ab1F0W0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 18:26:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=godv7VFLnvYtGgyWplBR/s/6bgbDHRC8PF38bO4+TZVsFW0E8o+XdG1GWAtyhtdEms
         fvl4Zxv9FPxXifTWojzTcHwZrhzKoRF8KS64ye2/5jp//jziOVG0K/s6MzwCJNYHc4D9
         THgMrKsoEwj24KiysCFyDed84zfTZGgVIGbS4=
Date: Tue, 28 Jun 2011 01:25:26 +0300
From: Dan Carpenter <error27@gmail.com>
To: Jesper Juhl <jj@chaosbits.net>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        James Bottomley <jbottomley@parallels.com>,
        Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH][Resend] SCSI, target, loopback: Fix memory leak in
 tcm_loop_make_scsi_hba()
Message-ID: <20110627222526.GA14591@shale.localdomain>
References: <alpine.LNX.2.00.1106272351520.30245@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1106272351520.30245@swampdragon.chaosbits.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 27, 2011 at 11:54:48PM +0200, Jesper Juhl wrote:
> --- a/drivers/target/loopback/tcm_loop.c
> +++ b/drivers/target/loopback/tcm_loop.c
> @@ -1321,7 +1321,8 @@ struct se_wwn *tcm_loop_make_scsi_hba(
>  
>  	printk(KERN_ERR "Unable to locate prefix for emulated Target Port:"
>  			" %s\n", name);
> -	return ERR_PTR(-EINVAL);
> +	ret = -EINVAL;
> +	goto out;

You've added a weird bunny hop goto here.  It might be better to
change the if (ptr) check to if (!ptr) so we could fall through
here in the normal case.

>  
>  check_len:
>  	if (strlen(name) >= TL_WWN_ADDR_LEN) {

If this check fails then it calls kfree() and returns.  It would be
cleaner to "goto out" here as well.

regards,
dan carpenter
