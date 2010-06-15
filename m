Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758136Ab0FORYU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 13:24:20 -0400
Received: from ist.d-labs.de ([213.239.218.44]:39613 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753832Ab0FORYS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 13:24:18 -0400
Date: Tue, 15 Jun 2010 19:23:47 +0200
From: Florian Mickler <florian@mickler.org>
To: James Bottomley <James.Bottomley@suse.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Jonathan Corbet <corbet@lwn.net>,
       markgross@thegnar.org, linville@tuxdriver.com,
       linux-kernel@vger.kernel.org,
       pm list <linux-pm@lists.linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 3/3] pm_qos: only schedule work when in interrupt
 context
Message-ID: <20100615192347.761f427a@schatten.dmk.lab>
In-Reply-To: <1276526800-12362-3-git-send-email-florian@mickler.org>
References: <1276266352.2862.70.camel@mulgrave.site>
	<1276526800-12362-3-git-send-email-florian@mickler.org>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi James!

On Mon, 14 Jun 2010 16:46:40 +0200
florian@mickler.org wrote:

> With this patch we only schedule the work when in interrupt context.
> 
> Before update_request was callable from interrupt-context there was a
> 1:1 relation between a change in the request-value and a notification.
> This patch restores that behaviour for all constraints that have update_request
> never called from interrupt context.
> 
> The notifier mutex serializes calls to blocking_notifier_call_chain, so
> that we are serialized against any pending or currently executing notification.
> 
> Signed-off-by: Florian Mickler <florian@mickler.org>
> ---
>  kernel/pm_qos_params.c |   10 +++++++---
>  1 files changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/pm_qos_params.c b/kernel/pm_qos_params.c
> index 9346906..c06cae9 100644
> --- a/kernel/pm_qos_params.c
> +++ b/kernel/pm_qos_params.c
> @@ -152,11 +152,15 @@ static s32 min_compare(s32 v1, s32 v2)
>  static void pm_qos_call_notifiers(struct pm_qos_object *o,
>  				  unsigned long curr_value)
>  {
> -	schedule_work(&o->notify);
> -
>  	if (o->atomic_notifiers)
>  		atomic_notifier_call_chain(o->atomic_notifiers,
> -					   curr_value, NULL);
> +				(unsigned long) curr_value, NULL);
> +
> +	if (in_interrupt()) 
> +		schedule_work(&o->notify);
> +	else 
> +		blocking_notifier_call_chain(o->blocking_notifiers, 
> +				(unsigned long) curr_value, NULL);
>  }
>  
>  static void update_notify(struct work_struct *work)

What about this? Is this ok? I don't know if it is benign to use
in_interrupt() here. I took this idea from the
execute_in_process_context() implementation. 


If this is ok, should I rebase them on your two pm_qos patches (plists
and the kzalloc removal)? 

Did you already thought about some debugging stuff that would suffice
the android needs? I kind of thought about either registerieng some
notifier callback or using the perf/tracing infrastructure. 
But I have not looked into it yet.

Cheers,
Flo
