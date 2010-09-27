Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933551Ab0I0UHO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 16:07:14 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:47175 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932927Ab0I0UHM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 16:07:12 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Nigel Cunningham <nigel@tuxonice.net>
Subject: Re: [PATCH 02/23] Record & display i/o speed post resume.
Date: Mon, 27 Sep 2010 22:06:19 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc5-rjw+; KDE/4.4.4; x86_64; ; )
Cc: Linux PM <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "TuxOnIce-devel" <tuxonice-devel@tuxonice.net>
References: <1285566238-10966-1-git-send-email-nigel@tuxonice.net> <1285566238-10966-3-git-send-email-nigel@tuxonice.net>
In-Reply-To: <1285566238-10966-3-git-send-email-nigel@tuxonice.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201009272206.20020.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, September 27, 2010, Nigel Cunningham wrote:
> Record the speed at which the image is written and read, and
> display it to the user post-resume.
> 
> Signed-off-by: Nigel Cunningham <nigel@tuxonice.net>
> ---
>  kernel/power/hibernate.c |   11 ++++++++++-
>  kernel/power/power.h     |    3 ++-
>  kernel/power/swap.c      |   14 +++++++++++---
>  3 files changed, 23 insertions(+), 5 deletions(-)
> 
> diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
> index 6c9c9dc..0cd1f05 100644
> --- a/kernel/power/hibernate.c
> +++ b/kernel/power/hibernate.c
> @@ -212,7 +212,7 @@ static void platform_recover(int platform_mode)
>   *	@msg -		introductory message to print
>   */
>  
> -void swsusp_show_speed(struct timeval *start, struct timeval *stop,
> +int swsusp_show_speed(struct timeval *start, struct timeval *stop,
>  			unsigned nr_pages, char *msg)
>  {
>  	s64 elapsed_centisecs64;
> @@ -231,6 +231,7 @@ void swsusp_show_speed(struct timeval *start, struct timeval *stop,
>  			msg, k,
>  			centisecs / 100, centisecs % 100,
>  			kps / 1000, (kps % 1000) / 10);
> +	return kps / 1000;
>  }
>  
>  /**
> @@ -648,6 +649,14 @@ int hibernate(void)
>  			power_down();
>  	} else {
>  		pr_debug("PM: Image restored successfully.\n");
> +		if (write_speed)
> +			pr_debug("PM: Image written at %u MB/s.\n",
> +					(u8) write_speed);
> +		write_speed = 0;
> +		if (read_speed)
> +			pr_debug("PM: Image read at %u MB/s.\n",
> +					(u8) read_speed);
> +		read_speed = 0;
>  	}
>  
>   Thaw:
> diff --git a/kernel/power/power.h b/kernel/power/power.h
> index 03634be..22f8607 100644
> --- a/kernel/power/power.h
> +++ b/kernel/power/power.h
> @@ -53,6 +53,7 @@ extern int hibernation_snapshot(int platform_mode);
>  extern int hibernation_restore(int platform_mode);
>  extern int hibernation_platform_enter(void);
>  
> +extern char __nosavedata write_speed, read_speed;
>  #else /* !CONFIG_HIBERNATION */
>  
>  static inline void hibernate_image_size_init(void) {}
> @@ -161,7 +162,7 @@ extern int hib_wait_on_bio_chain(struct bio **bio_chain);
>  
>  struct timeval;
>  /* kernel/power/swsusp.c */
> -extern void swsusp_show_speed(struct timeval *, struct timeval *,
> +extern int swsusp_show_speed(struct timeval *, struct timeval *,
>  				unsigned int, char *);
>  
>  #ifdef CONFIG_SUSPEND
> diff --git a/kernel/power/swap.c b/kernel/power/swap.c
> index 3c01105..caf4db8 100644
> --- a/kernel/power/swap.c
> +++ b/kernel/power/swap.c
> @@ -45,7 +45,8 @@ struct swap_map_page {
>  };
>  
>  struct swsusp_header {
> -	char reserved[PAGE_SIZE - 20 - sizeof(sector_t) - sizeof(int)];
> +	char reserved[PAGE_SIZE - 21 - sizeof(sector_t) - sizeof(int)];
> +	char write_speed;
>  	sector_t image;
>  	unsigned int flags;	/* Flags to pass to the "boot" kernel */
>  	char	orig_sig[10];
> @@ -161,6 +162,7 @@ int swsusp_swap_in_use(void)
>  
>  static unsigned short root_swap = 0xffff;
>  struct block_device *hib_resume_bdev;
> +char __nosavedata write_speed, read_speed;

I really should have noticed that earlier, but I don't really like __nosavedata
being used here.  In fact, it shouldn't be used at all any more, because it's
meaningless on x86_64.

I'm not sure how to implement that without __nosavedata, but please don't
use it.  Sorry aboiut that.

Rafael
