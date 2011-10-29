Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933519Ab1J2RA2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Oct 2011 13:00:28 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53661 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932930Ab1J2RA1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Oct 2011 13:00:27 -0400
Date: Sat, 29 Oct 2011 19:00:24 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Julia Lawall <julia@diku.dk>
Cc: David Herrmann <dh.herrmann@googlemail.com>,
        Arend van Spriel <arend@broadcom.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/5 v2] drivers/hid/hid-roccat.c: eliminate a null pointer
 dereference
In-Reply-To: <Pine.LNX.4.64.1110291411150.17700@ask.diku.dk>
Message-ID: <alpine.LNX.2.00.1110291857310.3541@pobox.suse.cz>
References: <1319846297-2985-3-git-send-email-julia@diku.dk> <20111029062412.GG14881@longonot.mountain> <4EABC937.60600@broadcom.com> <CANq1E4QJoM+NYub9hfs3KnL1w212FK0MHo8ez2p1nyGmNVb-=A@mail.gmail.com> <Pine.LNX.4.64.1110291411150.17700@ask.diku.dk>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 29 Oct 2011, Julia Lawall wrote:

> From: Julia Lawall <julia@diku.dk>
> 
> It is not possible to take the lock in device if device is NULL.
> The mutex_lock is thus moved after the NULL test, and the relevant part of
> the shared error handling code is moved up.
> 
> The semantic match that finds this problem is as follows:
> (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @r@
> expression E, E1;
> identifier f;
> statement S1,S2,S3;
> @@
> 
> if (E == NULL)
> {
>   ... when != if (E == NULL || ...) S1 else S2
>       when != E = E1
> *E->f
>   ... when any
>   return ...;
> }
> else S3
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>
> 
> ---
> mutex_lock changed to mutex_unlock in error handling code
> 
>  drivers/hid/hid-roccat.c |    9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/hid/hid-roccat.c b/drivers/hid/hid-roccat.c
> index 2596321..36a28b8 100644
> --- a/drivers/hid/hid-roccat.c
> +++ b/drivers/hid/hid-roccat.c
> @@ -163,14 +163,15 @@ static int roccat_open(struct inode *inode, struct file *file)
>  
>  	device = devices[minor];
>  
> -	mutex_lock(&device->readers_lock);
> -
>  	if (!device) {
>  		pr_emerg("roccat device with minor %d doesn't exist\n", minor);
> -		error = -ENODEV;
> -		goto exit_err;
> +		kfree(reader);
> +		mutex_unlock(&devices_lock);
> +		return -ENODEV;
>  	}
>  
> +	mutex_lock(&device->readers_lock);
> +
>  	if (!device->open++) {
>  		/* power on device on adding first reader */
>  		error = hid_hw_power(device->hid, PM_HINT_FULLON);

Julia,

thanks a lot for fixing this.

Could you please redo the patch in a way that it adds second 
'exit_unlock1' label (and renames 'exit_unlock' to 'exit_unlock2') (or 
any appropriate variation of the names) and preserve error path using goto 
instead of mixture of returns and gotos that this patch would introduce?

Thanks,

-- 
Jiri Kosina
SUSE Labs
