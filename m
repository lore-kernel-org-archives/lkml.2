Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752178Ab0H0Gl7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 02:41:59 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:36032 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068Ab0H0Gl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 02:41:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:reply-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=Sg/vByP5M49RJRByoKAFTAokrU3parw1OQdGDfXYUbm2rI+fbvhrdRJExlD/1y9kMK
         d/4Xgm78VL51B03a30r9fb4h4g5H9sg111k7zom60OwBhDCu9e1R6+LVGqLiZRic9of2
         YmidbEWKbK5GtaDa7gqMigh5xhmMy0yFTH6kQ=
Date: Thu, 26 Aug 2010 23:41:54 -0700
From: mark gross <markgross@thegnar.org>
To: Saravana Kannan <skannan@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        James Bottomley <James.Bottomley@suse.de>,
        mark gross <markgross@thegnar.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>, khilman@deeprootsystems.com
Subject: Re: [PATCH] pm_qos: Add system bus performance parameter
Message-ID: <20100827064153.GB3414@gvim.org>
Reply-To: markgross@thegnar.org
References: <1282882403-29824-1-git-send-email-skannan@codeaurora.org>
 <1282882403-29824-2-git-send-email-skannan@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1282882403-29824-2-git-send-email-skannan@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 26, 2010 at 09:13:23PM -0700, Saravana Kannan wrote:
> Some drivers/devices might need some minimum system bus performance to
> provide acceptable service. Provide a PM QoS parameter to send these requests
> to.
> 
> The new parameter is named "system bus performance" since it is generic enough
> for the unit of the request to be frequency, bandwidth or something else that
> might be appropriate. It's up to each implementation of the QoS provider to
> define what the unit of the request would be.
> 
> Signed-off-by: Saravana Kannan <skannan@codeaurora.org>
> ---
>  kernel/pm_qos_params.c |    9 +++++++++
>  1 files changed, 9 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/pm_qos_params.c b/kernel/pm_qos_params.c
> index 996a4de..1a44a67 100644
> --- a/kernel/pm_qos_params.c
> +++ b/kernel/pm_qos_params.c
> @@ -93,12 +93,21 @@ static struct pm_qos_object network_throughput_pm_qos = {
>  	.type = PM_QOS_MAX,
>  };
>  
> +static BLOCKING_NOTIFIER_HEAD(system_bus_performance_notifier);
> +static struct pm_qos_object system_bus_performance_pm_qos = {
> +	.requests = PLIST_HEAD_INIT(system_bus_performance_pm_qos.requests, pm_qos_lock),
> +	.notifiers = &system_bus_performance_notifier,
> +	.name = "system_bus_performance",
> +	.default_value = 0,
> +	.type = PM_QOS_MAX,
> +};
>  
>  static struct pm_qos_object *pm_qos_array[] = {
>  	&null_pm_qos,
>  	&cpu_dma_pm_qos,
>  	&network_lat_pm_qos,
>  	&network_throughput_pm_qos
> +	&system_bus_performance_pm_qos
>  };
>  
>  static ssize_t pm_qos_power_write(struct file *filp, const char __user *buf,
> -- 
> 1.7.1.1
> ---

nack.

Change the name to system_bus_throughput_pm_qos assuming KBS units and
I'll ok it.  It needs to be portable and without units I think drivers
will start using magic numbers that will break when you go from a
devices with 16 to 32 bus with the same clock.

We had an email thread about this last year 
http://lkml.org/lkml/2009/12/31/143
I don't recall solution ever coming out of it.   I think you guys didn't
like the idea of using units.  Further I did post a patch adding
something like using units. Although I looks like I botch the post the
linux-pm as I can't seem to find it in the linux-pm archives :(
http://lkml.org/lkml/2010/4/22/213

Would you be ok with using throughput instead of a unit less performance
magic number?


--mark


