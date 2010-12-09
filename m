Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756809Ab0LIBxI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 20:53:08 -0500
Received: from void.printf.net ([89.145.121.20]:34883 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756452Ab0LIBxG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 20:53:06 -0500
Date: Thu, 9 Dec 2010 01:53:03 +0000
From: Chris Ball <cjb@laptop.org>
To: Takashi Iwai <tiwai@suse.de>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>, Oliver Neukum <oneukum@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mmc: Fix re-probing after hibernation
Message-ID: <20101209015303.GB19741@void.printf.net>
References: <1291821839-15088-1-git-send-email-tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291821839-15088-1-git-send-email-tiwai@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Takashi,

On Wed, Dec 08, 2010 at 04:23:59PM +0100, Takashi Iwai wrote:
> The commit 4c2ef25fe0b847d2ae818f74758ddb0be1c27d8e
>   mmc: fix all hangs related to mmc/sd card insert/removal during
>   suspend/resume
> introduced a bug where the device probing no longer works after
> hibernation.  This was because the pm notifier expects
> PM_POST_HIBERNATION call while the system sends PM_POST_RESTORE
> instead, thus disable_rescan is kept as 1.
> 
> Cc: <stable@kernel.org>
> Signed-off-by: Takashi Iwai <tiwai@suse.de>
> ---
>  drivers/mmc/core/core.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
> index 31ae07a..30094f6 100644
> --- a/drivers/mmc/core/core.c
> +++ b/drivers/mmc/core/core.c
> @@ -1772,7 +1772,7 @@ int mmc_pm_notify(struct notifier_block *notify_block,
>  		break;
>  
>  	case PM_POST_SUSPEND:
> -	case PM_POST_HIBERNATION:
> +	case PM_POST_RESTORE:
>  
>  		spin_lock_irqsave(&host->lock, flags);
>  		host->rescan_disable = 0;

Thanks very much for tracking this down!  The code suggests that
POST_RESTORE is only emitted on a *failed* hibernation restore --
from include/linux/notifier.h:

/* Hibernation and suspend events */
#define PM_POST_HIBERNATION     0x0002 /* Hibernation finished */
#define PM_POST_SUSPEND         0x0004 /* Suspend finished */
#define PM_POST_RESTORE         0x0006 /* Restore failed */

So, this all suggests that we want to add the POST_RESTORE case but
also want to keep the POST_HIBERNATION case.  Do you agree?  Was the 
case you saw of failed probe after hibernation a failed restore from
hibernation image?

By the way, it looks like there are some other drivers which also
test for POST_HIBERNATION but not POST_RESTORE:

  drivers/media/video/tlg2300/pd-main.c
  drivers/s390/char/vmwatchdog.c
  drivers/s390/cio/css.c
  drivers/staging/brcm80211/brcmfmac/dhd_linux.c

Thanks,

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
