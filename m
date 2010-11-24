Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751739Ab0KXFQo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 00:16:44 -0500
Received: from cantor.suse.de ([195.135.220.2]:50271 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751451Ab0KXFQn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 00:16:43 -0500
Date: Wed, 24 Nov 2010 16:16:32 +1100
From: Neil Brown <neilb@suse.de>
To: Joe Perches <joe@perches.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] md: Fix single printks with multiple KERN_<level>s
Message-ID: <20101124161632.27a05405@notabene.brown>
In-Reply-To: <1290560260.11971.5.camel@Joe-Laptop>
References: <20101011152516.GF27153@n2100.arm.linux.org.uk>
	<1290505382-16110-1-git-send-email-u.kleine-koenig@pengutronix.de>
	<20101123101210.GA18170@n2100.arm.linux.org.uk>
	<20101123103940.GN4693@pengutronix.de>
	<20101123105830.GO4693@pengutronix.de>
	<AANLkTinmky17XZZPh7QvcY_r=66f_PwzRYFPUSvhiJGK@mail.gmail.com>
	<20101123223344.GE26510@n2100.arm.linux.org.uk>
	<1290560260.11971.5.camel@Joe-Laptop>
X-Mailer: Claws Mail 3.7.7 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Nov 2010 16:57:40 -0800
Joe Perches <joe@perches.com> wrote:

> Noticed-by: Russell King <linux@arm.linux.org.uk>
> Signed-off-by: Joe Perches <joe@perches.com>

Applied by: NeilBrown

Thanks a lot!

NeilBrown


> ---
> > Note that KERN_foo in the middle of strings, even after a newline are
> > preserved in the output.  So:
> > 
> >                 printk(KERN_WARNING "BUG: Your driver calls ioremap() on system memory.  This leads\n"
> >                        KERN_WARNING "to architecturally unpredictable behaviour on ARMv6+, and ioremap()\n"
> >                        KERN_WARNING "will fail in the next kernel release.  Please fix your driver.\n");
> > 
> > results in <4>'s appearing on the console.  I've always written code
> > over the last 15 years assuming that after any newline in printk output,
> > the log level gets reset and so needs a new log level specifier.
> > 
> > Sounds like this is something which needs auditing as a result of your
> > change, and sounds like its something that kernelnewbies people could
> > do.  My own greps haven't revealed any cases though.
> 
>  drivers/md/raid1.c  |    5 +++--
>  drivers/md/raid10.c |    5 +++--
>  drivers/md/raid5.c  |    1 -
>  3 files changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 45f8324..e05381b 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -1027,8 +1027,9 @@ static void error(mddev_t *mddev, mdk_rdev_t *rdev)
>  	} else
>  		set_bit(Faulty, &rdev->flags);
>  	set_bit(MD_CHANGE_DEVS, &mddev->flags);
> -	printk(KERN_ALERT "md/raid1:%s: Disk failure on %s, disabling device.\n"
> -	       KERN_ALERT "md/raid1:%s: Operation continuing on %d devices.\n",
> +	printk(KERN_ALERT
> +	       "md/raid1:%s: Disk failure on %s, disabling device.\n"
> +	       "md/raid1:%s: Operation continuing on %d devices.\n",
>  	       mdname(mddev), bdevname(rdev->bdev, b),
>  	       mdname(mddev), conf->raid_disks - mddev->degraded);
>  }
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index c67aa54..686543d 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -1051,8 +1051,9 @@ static void error(mddev_t *mddev, mdk_rdev_t *rdev)
>  	}
>  	set_bit(Faulty, &rdev->flags);
>  	set_bit(MD_CHANGE_DEVS, &mddev->flags);
> -	printk(KERN_ALERT "md/raid10:%s: Disk failure on %s, disabling device.\n"
> -	       KERN_ALERT "md/raid10:%s: Operation continuing on %d devices.\n",
> +	printk(KERN_ALERT
> +	       "md/raid10:%s: Disk failure on %s, disabling device.\n"
> +	       "md/raid10:%s: Operation continuing on %d devices.\n",
>  	       mdname(mddev), bdevname(rdev->bdev, b),
>  	       mdname(mddev), conf->raid_disks - mddev->degraded);
>  }
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index dc574f3..316fbe7 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -1721,7 +1721,6 @@ static void error(mddev_t *mddev, mdk_rdev_t *rdev)
>  		set_bit(Faulty, &rdev->flags);
>  		printk(KERN_ALERT
>  		       "md/raid:%s: Disk failure on %s, disabling device.\n"
> -		       KERN_ALERT
>  		       "md/raid:%s: Operation continuing on %d devices.\n",
>  		       mdname(mddev),
>  		       bdevname(rdev->bdev, b),
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

