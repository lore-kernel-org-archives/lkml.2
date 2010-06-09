Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757138Ab0FIP1h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 11:27:37 -0400
Received: from ist.d-labs.de ([213.239.218.44]:46271 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757053Ab0FIP1f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 11:27:35 -0400
Date: Wed, 9 Jun 2010 17:27:14 +0200
From: Florian Mickler <florian@mickler.org>
To: James Bottomley <James.Bottomley@suse.de>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       pm list <linux-pm@lists.linux-foundation.org>, markgross@thegnar.org,
       mgross@linux.intel.com, Frederic Weisbecker <fweisbec@gmail.com>,
       Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] pm_qos: make update_request callable from interrupt
 context
Message-ID: <20100609172714.7438db1f@schatten.dmk.lab>
In-Reply-To: <1276087119.4343.52.camel@mulgrave.site>
References: <1276074915-26879-1-git-send-email-florian@mickler.org>
	<1276074915-26879-2-git-send-email-florian@mickler.org>
	<alpine.LFD.2.00.1006091146010.2933@localhost.localdomain>
	<1276087119.4343.52.camel@mulgrave.site>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 09 Jun 2010 08:38:39 -0400
James Bottomley <James.Bottomley@suse.de> wrote:

> On Wed, 2010-06-09 at 11:46 +0200, Thomas Gleixner wrote:
> > On Wed, 9 Jun 2010, florian@mickler.org wrote:
> > 
> > > The pm_qos framework has to guarantee atomic notifications so that
> > > drivers can request and release constraints at all times while no races
> > > occur.
> > > 
> > > In order to avoid implementing a secondary notification chain in which
> > > listeners might sleep, we demand that every listener implements it's
> > > notification so that it can run in interrupt context. The listener is in
> > > a better position to know if races are harmful or not.
> > 
> > That breaks existing notifiers.
> 
> Right ... and we don't want to do that.  Which is why I think we just
> use blocking notifiers as they are but allow for creating atomic ones
> which may use atomic update sites.
> 
> This is the solution I have in my tree ... it preserves existing
> semantics because all the update and add sites are in user context, but
> it allows for notifiers with purely atomic semantics and will do a
> runtime warn if anyone tries to use them in a blocking fashion (or if
> anyone adds an atomic update to an existing blocking notifier).
> 
> James


> 
> @@ -302,8 +330,12 @@ int pm_qos_add_notifier(int pm_qos_class, struct notifier_block *notifier)
>  {
>  	int retval;
>  
> +	/* someone tried to register a blocking notifier to a
> +	 * qos object that only supports atomic ones */
> +	BUG_ON(!pm_qos_array[pm_qos_class]->blocking_notifiers);
> +
>  	retval = blocking_notifier_chain_register(
> -			pm_qos_array[pm_qos_class]->notifiers, notifier);
> +			pm_qos_array[pm_qos_class]->blocking_notifiers, notifier);
>  
>  	return retval;
>  }

Why not:

	retval = 1;
	if(pm_qos_array[pm_qos_class]->blocking_notifiers) 
		retval = blocking_notifier_chain_register(..
	else 
		WARN();
	return retval;

That way, the offending programmer could eventually fix it, without
having to reboot? 

> @@ -319,15 +351,41 @@ EXPORT_SYMBOL_GPL(pm_qos_add_notifier);


The rest looks good to me. I posted another variant using
schedule_work(). 

As currently no atomic notifications are needed and critical operations
probably have to check pm_qos_get_request manually anyway to be shure
this would be an alternative. Whatever. 

Cheers,
Flo
