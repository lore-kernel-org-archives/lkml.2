Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932976Ab2GENKF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 09:10:05 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:54338 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932339Ab2GENKB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 09:10:01 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH] driver core: Move deferred devices to the end of dpm_list before probing
Date: Thu, 5 Jul 2012 15:15:33 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0-rc5+; KDE/4.6.0; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
References: <1341493484-9074-1-git-send-email-broonie@opensource.wolfsonmicro.com>
In-Reply-To: <1341493484-9074-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201207051515.34019.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, July 05, 2012, Mark Brown wrote:
> When deferred probe was originally added the idea was that devices which
> defer their probes would move themselves to the end of dpm_list in order
> to try to keep the assumptions that we're making about the list being in
> roughly the order things should be suspended correct. However this hasn't
> been what's been happening and doing it requires a lot of duplicated code
> to do the moves.
> 
> Instead take a simple, brute force solution and have the deferred probe
> code push devices to the end of dpm_list before it retries the probe. This
> does mean we lock the dpm_list a bit more often but it's very simple and
> the code shouldn't be a fast path. We do the move with the deferred mutex
> dropped since doing things with fewer locks held simultaneously seems like
> a good idea.
> 
> This approach was most recently suggested by Grant Likely.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Looks good.

Acked-by: Rafael J. Wysocki <rjw@sisk.pl>

> ---
>  drivers/base/dd.c |   12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/drivers/base/dd.c b/drivers/base/dd.c
> index 6cd2c6c..9b0aca4 100644
> --- a/drivers/base/dd.c
> +++ b/drivers/base/dd.c
> @@ -85,8 +85,20 @@ static void deferred_probe_work_func(struct work_struct *work)
>  		 * manipulate the deferred list
>  		 */
>  		mutex_unlock(&deferred_probe_mutex);
> +
> +		/*
> +		 * Force the device to the end of the dpm_list since
> +		 * the PM code assumes that the order we add things to
> +		 * the list is a good order for suspend but deferred
> +		 * probe makes that very unsafe.
> +		 */
> +		device_pm_lock();
> +		device_pm_move_last(dev);
> +		device_pm_unlock();
> +
>  		dev_dbg(dev, "Retrying from deferred list\n");
>  		bus_probe_device(dev);
> +
>  		mutex_lock(&deferred_probe_mutex);
>  
>  		put_device(dev);
> 

