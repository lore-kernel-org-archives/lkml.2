Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752468Ab2DCBoa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 21:44:30 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40205 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751855Ab2DCBo3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 21:44:29 -0400
Date: Tue, 3 Apr 2012 03:44:28 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: NeilBrown <neilb@suse.de>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: Subject: [PATCH] APM: fix deadlock in APM_IOC_SUSPEND ioctl
In-Reply-To: <20120401201930.01202cd2@notabene.brown>
Message-ID: <alpine.LNX.2.00.1204030342540.16928@pobox.suse.cz>
References: <20120401201930.01202cd2@notabene.brown>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 1 Apr 2012, NeilBrown wrote:

> 
> 
> I found the Xorg server on my ARM device stuck in the 'msleep()' loop
> in apm_ioctl.
> 
> I suspect it had attempted suspend immediately after resuming and lost
> a race.
> During that msleep(10);, a new suspend cycle must have started and
> changed ->suspend_state to SUSPEND_PENDING, so it was never seen to
> be SUSPEND_DONE and the loop could never exited.  It would have moved on
> to SUSPEND_ACKTO but never been able to reach SUSPEND_DONE.
> 
> So change the loop to only run while SUSPEND_ACKED rather than until
> SUSPEND_DONE.  This is much safer.
> 
> Signed-off-by: NeilBrown <neilb@suse.de>
> 
> diff --git a/drivers/char/apm-emulation.c b/drivers/char/apm-emulation.c
> index f4837a8..6005c5c 100644
> --- a/drivers/char/apm-emulation.c
> +++ b/drivers/char/apm-emulation.c
> @@ -302,7 +302,7 @@ apm_ioctl(struct file *filp, u_int cmd, u_long arg)
>  			 * anything critical, chill a bit on each iteration.
>  			 */
>  			while (wait_event_freezable(apm_suspend_waitqueue,
> -					as->suspend_state == SUSPEND_DONE))
> +					as->suspend_state != SUSPEND_ACKED))
>  				msleep(10);
>  			break;
>  		case SUSPEND_ACKTO:

Good catch Neil! I have missed this race when we were moving away from 
freezer_*_count() to wait_event_freezable() here.

Applied, thanks.

-- 
Jiri Kosina
SUSE Labs
