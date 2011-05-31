Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932871Ab1EaWmc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 18:42:32 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:51442 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758422Ab1EaWmb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 18:42:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=nMLRHUaGF9AtfkGdNDIjMvp4suQ5E9f69MoVlZ6/bn4uAehQYuBxXqNyiJOXhMYLOG
         fK2KUJBxt9leYBCwtz6/1vVie8AHSSuJeCFS5UvaLGlS1LdviS0dbTvCZncoiGU/3RUH
         6U2ZXN5qD50I70hBgnyax2saGgPvtnRTgqjHw=
Date: Wed, 1 Jun 2011 01:42:12 +0300
From: Dan Carpenter <error27@gmail.com>
To: Andre Bartke <andre.bartke@googlemail.com>
Cc: gregkh@suse.de, devel@driverdev.osuosl.org,
        Andre Bartke <andre.bartke@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: intel_sst: Fix memory leak
Message-ID: <20110531224212.GC3661@shale.localdomain>
References: <1306868636-23367-1-git-send-email-andre.bartke@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306868636-23367-1-git-send-email-andre.bartke@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 31, 2011 at 09:03:56PM +0200, Andre Bartke wrote:
> In case of an error stream_bufs is not freed here.
> 
> Signed-off-by: Andre Bartke <andre.bartke@gmail.com>
> ---
>  .../staging/intel_sst/intel_sst_app_interface.c    |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/staging/intel_sst/intel_sst_app_interface.c b/drivers/staging/intel_sst/intel_sst_app_interface.c
> index b8c7ddb..93b41a2 100644
> --- a/drivers/staging/intel_sst/intel_sst_app_interface.c
> +++ b/drivers/staging/intel_sst/intel_sst_app_interface.c
> @@ -430,8 +430,10 @@ static int snd_sst_fill_kernel_list(struct stream_info *stream,
>  				return -ENOMEM;
>  			if (copy_from_user((void *) &rar_handle,
>  					iovec[index].iov_base,
> -					sizeof(__u32)))
> +					sizeof(__u32))) {
> +				kfree(stream_bufs);
>  				return -EFAULT;
> +			}
>  			stream_bufs->addr = (char *)rar_handle;


Btw, the original code looks seems pretty awful.  "rar_handle" is
a kernel pointer that we get from user space.  It is a u32 type so
this won't work under a 64 bit OS.

These allocations get added to a list.  Maybe we should free them
all?  It's hard to say.  There is only one place that calls this
function, and it ignores the return value.

regards,
dan carpenter
