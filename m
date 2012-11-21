Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753968Ab2KUNmR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 08:42:17 -0500
Received: from 50-56-35-84.static.cloud-ips.com ([50.56.35.84]:38268 "EHLO
	mail.hallyn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751640Ab2KUNmP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 08:42:15 -0500
Date: Wed, 21 Nov 2012 13:46:21 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: linux-pm@vger.kernel.org, rjw@sisk.pl, keescook@chromium.org,
        serge.hallyn@canonical.com, linux-kernel@vger.kernel.org,
        myungjoo.ham@gmail.com
Subject: Re: [PATCH] PM / devfreq: missing rcu_read_lock() added for
 find_device_opp()
Message-ID: <20121121134621.GA30575@mail.hallyn.com>
References: <CAGXu5j+g8inUZV43GFQzs9KpRvjPGPTJsXinb4Y=wOuOf2jnVQ@mail.gmail.com>
 <1353492634-10730-1-git-send-email-myungjoo.ham@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1353492634-10730-1-git-send-email-myungjoo.ham@samsung.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting MyungJoo Ham (myungjoo.ham@samsung.com):
> opp_get_notifier() uses find_device_opp(), which requires to
> held rcu_read_lock. In order to keep the notifier-header
> valid, we have added rcu_read_lock().
> 
> Reported-by: Kees Cook <keescook@chromium.org>
> Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
> ---
>  drivers/devfreq/devfreq.c |   26 ++++++++++++++++++++------
>  1 files changed, 20 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/devfreq/devfreq.c b/drivers/devfreq/devfreq.c
> index 45e053e..e91cb22 100644
> --- a/drivers/devfreq/devfreq.c
> +++ b/drivers/devfreq/devfreq.c
> @@ -1023,11 +1023,18 @@ struct opp *devfreq_recommended_opp(struct device *dev, unsigned long *freq,
>   */
>  int devfreq_register_opp_notifier(struct device *dev, struct devfreq *devfreq)
>  {
> -	struct srcu_notifier_head *nh = opp_get_notifier(dev);
> +	struct srcu_notifier_head *nh;
> +	int ret = 0;
>  
> +	rcu_read_lock();
> +	nh = opp_get_notifier(dev);
>  	if (IS_ERR(nh))
> -		return PTR_ERR(nh);
> -	return srcu_notifier_chain_register(nh, &devfreq->nb);
> +		ret = PTR_ERR(nh);
> +	if (!ret)
> +		ret = srcu_notifier_chain_register(nh, &devfreq->nb);

Hm, but if I'm seeing right, srcu_notifier_chain_register calls
mutex_lock(), which sleeps, so you can't do that under rcu_read_lock().

-serge
