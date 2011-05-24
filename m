Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754997Ab1EXMeg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 08:34:36 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:64347 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753572Ab1EXMef (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 08:34:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=L6AhEczzWMfD7YM2nR04bSMGjWYRORyKhI2MAv8GooXF/KolmdqECQbfgERduAtTJU
         E8YrjDh/Ldx4x8zDmCbkhRqE/ch4uEGpYop1bArivBpDTps7z5VTXin4L3VhJ/71y94X
         Ml8UDT6sWzuf1uYfkPi6FviI+rYfXUO8laalM=
Date: Tue, 24 May 2011 14:34:32 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: Nicolas Kaiser <nikai@nikai.net>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Richard Cochran <richard.cochran@omicron.at>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] posix clocks: correct error value in posix_clock_poll()
Message-ID: <20110524123432.GB2929@riccoc20.at.omicron.at>
References: <20110524125147.0eb112b5@absol.kitzblitz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110524125147.0eb112b5@absol.kitzblitz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 24, 2011 at 12:51:47PM +0200, Nicolas Kaiser wrote:
> Signed-off-by: Nicolas Kaiser <nikai@nikai.net>
> ---
> It looks to me like -ENODEV might not be a good return value
> in poll(). Would POLLERR be the correct one in this case?
> 
>  kernel/time/posix-clock.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/time/posix-clock.c b/kernel/time/posix-clock.c
> index c340ca6..2424d3f 100644
> --- a/kernel/time/posix-clock.c
> +++ b/kernel/time/posix-clock.c
> @@ -71,7 +71,7 @@ static unsigned int posix_clock_poll(struct file *fp, poll_table *wait)
>  	int result = 0;
>  
>  	if (!clk)
> -		return -ENODEV;
> +		return POLLERR;

The condition (!clk) is only satisfied when 'zombie' is set,
indicating that the dynamic clock has disappeared. That is why the
file operations uniformly return ENODEV. So, I think it makes sense
the way that it is.

In addition, man 2 poll says,

   POLLERR
          Error condition (output only).

so using that error code would be misleading, IMHO.

Thanks,
Richard
