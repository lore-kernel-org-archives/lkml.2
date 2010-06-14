Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932077Ab0FNXBT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 19:01:19 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52005 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752094Ab0FNXBR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 19:01:17 -0400
Date: Mon, 14 Jun 2010 16:01:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: linux-mmc <linux-mmc@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Philip Langdale <philipl@overt.org>
Subject: Re: [PATCH v2] MMC: fix all hangs related to mmc/sd card
 insert/removal during suspend/resume.
Message-Id: <20100614160106.bcd92997.akpm@linux-foundation.org>
In-Reply-To: <1276283995-10812-1-git-send-email-maximlevitsky@gmail.com>
References: <1276283791.8557.29.camel@maxim-laptop>
	<1276283995-10812-1-git-send-email-maximlevitsky@gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Jun 2010 22:19:55 +0300
Maxim Levitsky <maximlevitsky@gmail.com> wrote:

> If you don't use CONFIG_MMC_UNSAFE_RESUME, card will now be removed
> in pm notified while userspace is still running.
> Thus it will be possible to sync it propely.
> 
> Card detect workqueue is now freezeable, therefore a card insert/removal event will
> wait till userspace is unfrozen.
> 
> Tested with and without CONFIG_MMC_UNSAFE_RESUME with suspend and hibernate.
> 
>
> ...
>
> @@ -158,6 +162,8 @@ void mmc_remove_host(struct mmc_host *host)
>  	device_del(&host->class_dev);
>  
>  	led_trigger_unregister_simple(host->led);
> +
> +	unregister_pm_notifier(&host->pm_notify);
>  }

This looks a little risky.  There's a window where the pm notifier
remains registered after we've done the device_del() and the
led_trigger_unregister_simple().

I don't know if the code's really buggy, nor if it might become buggy
in the future as things evolve.  But as register_pm_notifier() is the
last thing we do before mmc_start_host(), I'd have though that
unregister_pm_notifier() should be the first thing we do after
mmc_stop_host()?

>
> ...
>
> --- a/include/linux/mmc/host.h
> +++ b/include/linux/mmc/host.h
> @@ -124,6 +124,7 @@ struct mmc_host {
>  	unsigned int		f_min;
>  	unsigned int		f_max;
>  	u32			ocr_avail;
> +	struct notifier_block	pm_notify;
>  
>  #define MMC_VDD_165_195		0x00000080	/* VDD voltage 1.65 - 1.95 */
>  #define MMC_VDD_20_21		0x00000100	/* VDD voltage 2.0 ~ 2.1 */
> @@ -257,6 +258,8 @@ int mmc_card_can_sleep(struct mmc_host *host);
>  int mmc_host_enable(struct mmc_host *host);
>  int mmc_host_disable(struct mmc_host *host);
>  int mmc_host_lazy_disable(struct mmc_host *host);
> +int mmc_pm_notify(struct notifier_block *notify_block, unsigned long, void *);

It's unusual to provide names for some of the arguments and to leave
them out for others.

