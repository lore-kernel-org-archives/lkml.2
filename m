Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760260Ab2FUUiJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 16:38:09 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:34163 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760160Ab2FUUiG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 16:38:06 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: mandeep.baines@gmail.com
Subject: Re: [PATCH] PM: Prevent waiting forever on asynchronous suspend after abort
Date: Thu, 21 Jun 2012 22:43:28 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0-rc3+; KDE/4.6.0; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Mandeep Singh Baines <msb@chromium.org>,
        linux-pm@vger.kernel.org, stable@kernel.org,
        Pavel Machek <pavel@ucw.cz>, Len Brown <len.brown@intel.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Kevin Hilman <khilman@ti.com>, Alan Stern <stern@rowland.harvard.edu>,
        Colin Cross <ccross@android.com>, Sameer Nanda <snanda@chromium.org>,
        Olof Johansson <olofj@chromium.org>
References: <1340158627-7586-1-git-send-email-msb@chromium.org> <1340208795-8049-1-git-send-email-msb@chromium.org>
In-Reply-To: <1340208795-8049-1-git-send-email-msb@chromium.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201206212243.28984.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, June 20, 2012, mandeep.baines@gmail.com wrote:
> From: Mandeep Singh Baines <msb@chromium.org>
> 
> __device_suspend() must always send a completion. Otherwise, parent
> devices will wait forever.
> 
> Commit 1e2ef05b, "PM: Limit race conditions between runtime PM and
> system sleep (v2)", introduced a regression by short-circuiting the
> complete_all() for certain error cases.
> 
> This patch fixes the bug by always signalling a completion.
> 
> Addresses http://crosbug.com/31972
> 
> Tested by injecting an abort.
> 
> Signed-off-by: Mandeep Singh Baines <msb@chromium.org>
> Cc: Rafael J. Wysocki <rjw@sisk.pl>
> Cc: linux-pm@vger.kernel.org
> Cc: stable@kernel.org
> Cc: Pavel Machek <pavel@ucw.cz>
> Cc: Len Brown <len.brown@intel.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Kevin Hilman <khilman@ti.com>
> Cc: Alan Stern <stern@rowland.harvard.edu>
> Cc: Colin Cross <ccross@android.com>
> Cc: Sameer Nanda <snanda@chromium.org>
> Cc: Olof Johansson <olofj@chromium.org>

Applied to linux-pm/linux-next, will be pushed to Linus in a couple of days.

Thanks,
Rafael


> ---
>  drivers/base/power/main.c |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
> index e0fb5b0..9cb845e 100644
> --- a/drivers/base/power/main.c
> +++ b/drivers/base/power/main.c
> @@ -1031,7 +1031,7 @@ static int __device_suspend(struct device *dev, pm_message_t state, bool async)
>  	dpm_wait_for_children(dev, async);
>  
>  	if (async_error)
> -		return 0;
> +		goto Complete;
>  
>  	pm_runtime_get_noresume(dev);
>  	if (pm_runtime_barrier(dev) && device_may_wakeup(dev))
> @@ -1040,7 +1040,7 @@ static int __device_suspend(struct device *dev, pm_message_t state, bool async)
>  	if (pm_wakeup_pending()) {
>  		pm_runtime_put_sync(dev);
>  		async_error = -EBUSY;
> -		return 0;
> +		goto Complete;
>  	}
>  
>  	device_lock(dev);
> @@ -1097,6 +1097,8 @@ static int __device_suspend(struct device *dev, pm_message_t state, bool async)
>  	}
>  
>  	device_unlock(dev);
> +
> + Complete:
>  	complete_all(&dev->power.completion);
>  
>  	if (error) {
> 

