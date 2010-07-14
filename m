Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757413Ab0GNTAT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 15:00:19 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:41361 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754090Ab0GNTAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 15:00:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=Nr7M2krvhPm6LFkLPB4TU56EoOKIsXs8pxgg7FpjhEwxg449h37TRwvC+7C9BpXRbt
         l9ANEJfeitvGXMV+O1rMo7SSeBCnBigM9kBqcirE1hJYZlW06IOTjLl+TgoKfmBneZ78
         Oivxfx9J5VU1DhRnH8glX9WrLG8YI8q7Xf75w=
Date: Wed, 14 Jul 2010 20:58:31 +0200
From: Dan Carpenter <error27@gmail.com>
To: Kulikov Vasiliy <segooon@gmail.com>
Cc: kernel-janitors@vger.kernel.org,
        Adaptec OEM Raid Solutions <aacraid@adaptec.com>,
        "James E.J. Bottomley" <James.Bottomley@suse.de>,
        Julia Lawall <julia@diku.dk>, Frederic Weisbecker <fweisbec@gmail.com>,
        John Kacur <jkacur@redhat.com>,
        OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: dpt_i2o: fix memory leak
Message-ID: <20100714185831.GA5164@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Kulikov Vasiliy <segooon@gmail.com>,
	kernel-janitors@vger.kernel.org,
	Adaptec OEM Raid Solutions <aacraid@adaptec.com>,
	"James E.J. Bottomley" <James.Bottomley@suse.de>,
	Julia Lawall <julia@diku.dk>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	John Kacur <jkacur@redhat.com>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1279130008-9934-1-git-send-email-segooon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1279130008-9934-1-git-send-email-segooon@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 14, 2010 at 09:53:27PM +0400, Kulikov Vasiliy wrote:
> Free allocated memory if adpt_ioctl_to_context() failed.
> 
> Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
> ---
>  drivers/scsi/dpt_i2o.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/scsi/dpt_i2o.c b/drivers/scsi/dpt_i2o.c
> index f2d4df1..dd9a43b 100644
> --- a/drivers/scsi/dpt_i2o.c
> +++ b/drivers/scsi/dpt_i2o.c
> @@ -1839,8 +1839,10 @@ static int adpt_i2o_passthru(adpt_hba* pHba, u32 __user *arg)
>  	sg_offset = (msg[0]>>4)&0xf;
>  	msg[2] = 0x40000000; // IOCTL context
>  	msg[3] = adpt_ioctl_to_context(pHba, reply);

This patch is wrong I'm afraid.  adpt_ioctl_to_context() frees "reply" if
there is an error.

regards,
dan carpenter

> -	if (msg[3] == (u32)-1)
> +	if (msg[3] == (u32)-1) {
> +		kfree(reply);
>  		return -EBUSY;
> +	}
>  
>  	memset(sg_list,0, sizeof(sg_list[0])*pHba->sg_tablesize);
>  	if(sg_offset) {
> -- 

