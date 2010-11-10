Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756400Ab0KJOtK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 09:49:10 -0500
Received: from mailbigip.dreamhost.com ([208.97.132.5]:47942 "EHLO
	homiemail-a1.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756363Ab0KJOtE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 09:49:04 -0500
X-Greylist: delayed 96117 seconds by postgrey-1.27 at vger.kernel.org; Wed, 10 Nov 2010 09:49:04 EST
Subject: Re: [PATCH] fix the poll method of bsg file operations in Block
 layer SCSI generic driver
From: Davidlohr Bueso <dave@gnu.org>
Reply-To: dave@gnu.org
To: Hillf Danton <dhillf@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Zou, Yi" <yi.zou@intel.com>, Joe Eykholt <jeykholt@cisco.com>
In-Reply-To: <AANLkTi=butKgG8VktAu0V12aBKTetOJwiGkcTLG_RZWB@mail.gmail.com>
References: <AANLkTi=butKgG8VktAu0V12aBKTetOJwiGkcTLG_RZWB@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 10 Nov 2010 11:48:53 -0300
Message-ID: <1289400533.2208.6.camel@cowboy>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-11-10 at 21:58 +0800, Hillf Danton wrote:
> Though it looks like a typo, the check for POLLOUT is computed incorrectly.
> 
> Signed-off-by: Hillf Danton <dhillf@gmail.com>
> ---
> 
> --- a/block/bsg.c	2010-09-13 07:07:38.000000000 +0800
> +++ b/block/bsg.c	2010-11-10 21:40:30.000000000 +0800
> @@ -874,6 +874,8 @@ static unsigned int bsg_poll(struct file
>  	if (!list_empty(&bd->done_list))
>  		mask |= POLLIN | POLLRDNORM;
>  	if (bd->queued_cmds >= bd->max_queue)
> +		;
> +	else
>  		mask |= POLLOUT;
>  	spin_unlock_irq(&bd->lock);

How about something more like this:

diff --git a/block/bsg.c b/block/bsg.c
index f20d6a7..2663db3 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -870,7 +870,7 @@ static unsigned int bsg_poll(struct file *file,
poll_table *wait)
        spin_lock_irq(&bd->lock);
        if (!list_empty(&bd->done_list))
                mask |= POLLIN | POLLRDNORM;
-       if (bd->queued_cmds >= bd->max_queue)
+       if (bd->queued_cmds < bd->max_queue)
                mask |= POLLOUT;
        spin_unlock_irq(&bd->lock);


Thanks,
Davidlohr



> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


