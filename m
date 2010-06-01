Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756415Ab0FAOH7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 10:07:59 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:43874 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756029Ab0FAOH6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 10:07:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ZWnuqo4GgS4ZytCm8h92xbx393JmHhgnVfajS2nu+qaiYVGtxVLw2MlIJm+Za96zIk
         L29ZHFK+UhFe1JVj9nqkOY9PPEc47I5xDx/NQcTm2mDgHSRKiZXaYydva/OVDBbfE/eS
         k3oGWrnwGlWF27VyGi6muInCWSaFo2TJlPuao=
Date: Tue, 1 Jun 2010 07:08:12 -0700
From: mark gross <640e9920@gmail.com>
To: florian@mickler.org
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, 640e9920@gmail.com,
       markgross@thegnar.org, Arve Hj?nnev?g <arve@android.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Peter Zijlstra <peterz@infradead.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Brian Swetland <swetland@google.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] pm_qos: remove unnecessary list-traversal
Message-ID: <20100601140811.GD1281@gvim.org>
Reply-To: markgross@thegnar.org
References: <20100601090737.4bc243d9@schatten.dmk.lab>
 <1275382014-10178-1-git-send-email-florian@mickler.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1275382014-10178-1-git-send-email-florian@mickler.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 01, 2010 at 10:46:54AM +0200, florian@mickler.org wrote:
> The new extreme value is only depending on the old extreme value and
> the changed value.
> 
> Signed-off-by: Florian Mickler <florian@mickler.org>
> ---
>  kernel/pm_qos_params.c |   19 +++++++++++++++++--
>  1 files changed, 17 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/pm_qos_params.c b/kernel/pm_qos_params.c
> index f42d3f7..5d71c12 100644
> --- a/kernel/pm_qos_params.c
> +++ b/kernel/pm_qos_params.c
> @@ -136,6 +136,16 @@ static s32 min_compare(s32 v1, s32 v2)
>  }
>  
>  
> +static void update_target_val(int pm_qos_class, s32 val)
> +{
> +	s32 extreme_value;
> +	s32 new_value;
> +	extreme_value = atomic_read(&pm_qos_array[pm_qos_class]->target_value);
> +	new_value = pm_qos_array[pm_qos_class]->comparitor(val,extreme_value);
> +	if (extreme_value != new_value)
> +		atomic_set(&pm_qos_array[pm_qos_class]->target_value,new_value);
> +}
> +

only works right when the new val is a more stringent constraint
(request) than what is already there.  When removing or reducing a
constraint (request) the list still needs to be walked to get the new
aggregate request.

But its a really good optimization for 1/2 of the calls to pm_qos I
should have seen and included a long time ago!  Thanks!

--mgross


>  static void update_target(int pm_qos_class)
>  {
>  	s32 extreme_value;
> @@ -253,19 +263,24 @@ void pm_qos_update_request(struct pm_qos_request_list *pm_qos_req,
>  	s32 temp;
>  
>  	if (pm_qos_req) { /*guard against callers passing in null */
> +		int target = pm_qos_req->pm_qos_class;
>  		spin_lock_irqsave(&pm_qos_lock, flags);
>  		if (new_value == PM_QOS_DEFAULT_VALUE)
> -			temp = pm_qos_array[pm_qos_req->pm_qos_class]->default_value;
> +			temp = pm_qos_array[target]->default_value;
>  		else
>  			temp = new_value;
>  
>  		if (temp != pm_qos_req->value) {
>  			pending_update = 1;
>  			pm_qos_req->value = temp;
> +			update_target_val(target,temp);
>  		}
>  		spin_unlock_irqrestore(&pm_qos_lock, flags);
> +
>  		if (pending_update)
> -			update_target(pm_qos_req->pm_qos_class);
> +			blocking_notifier_call_chain(
> +				pm_qos_array[pm_qos_class]->notifiers,
> +					(unsigned long) temp, NULL);
>  	}
>  }
>  EXPORT_SYMBOL_GPL(pm_qos_update_request);
> -- 
> 1.7.1
> 
