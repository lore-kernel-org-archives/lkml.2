Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757998Ab0FIQtM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 12:49:12 -0400
Received: from ist.d-labs.de ([213.239.218.44]:34656 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757885Ab0FIQtK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 12:49:10 -0400
Date: Wed, 9 Jun 2010 18:48:50 +0200
From: Florian Mickler <florian@mickler.org>
To: James Bottomley <James.Bottomley@suse.de>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       pm list <linux-pm@lists.linux-foundation.org>, markgross@thegnar.org,
       mgross@linux.intel.com, Frederic Weisbecker <fweisbec@gmail.com>,
       Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] pm_qos: make update_request callable from interrupt
 context
Message-ID: <20100609184850.2779b784@schatten.dmk.lab>
In-Reply-To: <1276097546.4343.219.camel@mulgrave.site>
References: <1276074915-26879-1-git-send-email-florian@mickler.org>
	<1276074915-26879-2-git-send-email-florian@mickler.org>
	<alpine.LFD.2.00.1006091146010.2933@localhost.localdomain>
	<1276087119.4343.52.camel@mulgrave.site>
	<20100609172714.7438db1f@schatten.dmk.lab>
	<1276097546.4343.219.camel@mulgrave.site>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 09 Jun 2010 11:32:26 -0400
James Bottomley <James.Bottomley@suse.de> wrote:
 
> > > @@ -302,8 +330,12 @@ int pm_qos_add_notifier(int pm_qos_class, struct notifier_block *notifier)
> > >  {
> > >  	int retval;
> > >  
> > > +	/* someone tried to register a blocking notifier to a
> > > +	 * qos object that only supports atomic ones */
> > > +	BUG_ON(!pm_qos_array[pm_qos_class]->blocking_notifiers);
> > > +
> > >  	retval = blocking_notifier_chain_register(
> > > -			pm_qos_array[pm_qos_class]->notifiers, notifier);
> > > +			pm_qos_array[pm_qos_class]->blocking_notifiers, notifier);
> > >  
> > >  	return retval;
> > >  }
> > 
> > Why not:
> > 
> > 	retval = 1;
> > 	if(pm_qos_array[pm_qos_class]->blocking_notifiers) 
> > 		retval = blocking_notifier_chain_register(..
> > 	else 
> > 		WARN();
> > 	return retval;
> > 
> > That way, the offending programmer could eventually fix it, without
> > having to reboot? 
> 
> Because there are no current users that will trip the BUG_ON ... and we
> want to keep it that way.  Code doesn't go into the kernel if it BUGs on
> boot.
> 
> The point about failing hard for an abuse of a kernel API isn't to trap
> current abusers because you fix those before you add it.  It's to
> prevent future abuse.  If your kernel BUGs under test you tend to fix
> the code, so it becomes impossible for anyone to add any users which
> abuse the API in this fashion.
> 
> James
> 

There are actually people who ignore WARN()ings when submitting code??

....thinking about it... Yes, that may be possible. 

Cheers,
Flo

--
Only two things are infinite, the universe and human stupidity, and I'm
not sure about the former. Albert Einstein 
