Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756581Ab0FAOFH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 10:05:07 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:61528 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756029Ab0FAOFF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 10:05:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=n1mSdQTRJaeL/wt54iReA3LLVMxuVcATsDC+VPx61MQN0GmWiv8Btqnubl6J6L80GX
         N720t/IVN77T+0ZGSIrw3i8T4KjObrGys/OX06vNvVm+4U4EOcfwP02u/yXV9HrJ8QXs
         4mCMQ72Zy2PH4nMyM69bzQWFnExnWgNJKdufE=
Date: Tue, 1 Jun 2010 07:05:19 -0700
From: mark gross <640e9920@gmail.com>
To: Florian Mickler <florian@mickler.org>
Cc: markgross@thegnar.org, 640e9920@gmail.com,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Peter Zijlstra <peterz@infradead.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Brian Swetland <swetland@google.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
Message-ID: <20100601140519.GC1281@gvim.org>
Reply-To: markgross@thegnar.org
References: <AANLkTik_4ezDAQoAQjkpEgwD9SLKeOjDzy2H7T2v6uCP@mail.gmail.com>
 <Pine.LNX.4.44L0.1005292026080.6300-100000@netrider.rowland.org>
 <AANLkTikxws5kmFhnBO1MLzE65ETka3Jy0R5ayAKTS1Lc@mail.gmail.com>
 <201005312338.55109.rjw@sisk.pl>
 <20100531232617.GF31155@gvim.org>
 <20100601090737.4bc243d9@schatten.dmk.lab>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100601090737.4bc243d9@schatten.dmk.lab>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 01, 2010 at 09:07:37AM +0200, Florian Mickler wrote:
> On Mon, 31 May 2010 16:26:17 -0700
> mark gross <640e9920@gmail.com> wrote:
> 
> > On Mon, May 31, 2010 at 11:38:55PM +0200, Rafael J. Wysocki wrote:
> > > On Monday 31 May 2010, Arve Hjønnevåg wrote:
> > > > 2010/5/29 Alan Stern <stern@rowland.harvard.edu>:
> > > > > On Sat, 29 May 2010, Arve Hjønnevåg wrote:
> > > > >
> > > > >> > In place of in-kernel suspend blockers, there will be a new type of QoS
> > > > >> > constraint -- call it QOS_EVENTUALLY.  It's a very weak constraint,
> > > > >> > compatible with all cpuidle modes in which runnable threads are allowed
> > > > >> > to run (which is all of them), but not compatible with suspend.
> > > > >> >
> > > > >> This sound just like another API rename. It will work, but given that
> > > > >> suspend blockers was the name least objectionable last time around,
> > > > >> I'm not sure what this would solve.
> > > > >
> > > > > It's not just a rename.  By changing this into a QoS constraint, we
> > > > > make it more generally useful.  Instead of standing on its own, it
> > > > > becomes part of the PM-QOS framework.
> > > > >
> > > > 
> > > > We cannot use the existing pm-qos framework. It is not safe to call
> > > > from atomic context.
> > > 
> > > We've just merged a patch that fixed that if I'm not mistaken.  Mark, did your
> > > PM QoS update fix that?
> > >
> > 
> > I'm pretty sure it can be called in atomic context, and if its not I'm
> > sure we can fix that.  It can be called in atomic context.  I don't
> > think it was ever a problem to call it in atomic context.  The problem it
> > had was that crappy list of string compares.  Thats been fixed.
> > 
> > --mgross
> >  
> 
> Well, the register call uses kzalloc. Apart from that I
> think we're good. 
> 
> The outstanding list traversals can be fixed also. (see below)
> 
> Cheers,
> Flo
> 
> From 66fdd76f8cc4be722dba3859ddadfe07e7a4b755 Mon Sep 17 00:00:00 2001
> From: Florian Mickler <florian@mickler.org>
> Date: Tue, 1 Jun 2010 09:04:26 +0200
> Subject: [PATCH] pm_qos: remove unnecessary list-traversal
> 
> The new extreme_value is only depending on the old extreme_value and
> the changing value.
> 
> Signed-off-by: Florian Mickler <florian@mickler.org>
> ---
>  kernel/pm_qos_params.c |   20 ++++++++++++++------
>  1 files changed, 14 insertions(+), 6 deletions(-)
> 
> diff --git a/kernel/pm_qos_params.c b/kernel/pm_qos_params.c
> index f42d3f7..6618e2c 100644
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

Only works 1/2 the time, but I like the idea!  
It fails to get the righ answer when constraints are reduced.  But, this
idea is a good improvement i'll roll into the next pm_qos update!

thanks!

--mgross

>  static void update_target(int pm_qos_class)
>  {
>  	s32 extreme_value;
> @@ -227,8 +237,8 @@ struct pm_qos_request_list *pm_qos_add_request(int pm_qos_class, s32 value)
>  		spin_lock_irqsave(&pm_qos_lock, flags);
>  		list_add(&dep->list,
>  			&pm_qos_array[pm_qos_class]->requests.list);
> +		update_target_val(pm_qos_class,dep->value);
>  		spin_unlock_irqrestore(&pm_qos_lock, flags);
> -		update_target(pm_qos_class);
>  	}
>  
>  	return dep;
> @@ -249,23 +259,21 @@ void pm_qos_update_request(struct pm_qos_request_list *pm_qos_req,
>  		s32 new_value)
>  {
>  	unsigned long flags;
> -	int pending_update = 0;
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
> -			pending_update = 1;
>  			pm_qos_req->value = temp;
> +			update_target_val(target,temp);
>  		}
>  		spin_unlock_irqrestore(&pm_qos_lock, flags);
> -		if (pending_update)
> -			update_target(pm_qos_req->pm_qos_class);
>  	}
>  }
>  EXPORT_SYMBOL_GPL(pm_qos_update_request);
> -- 
> 1.7.1
> 
