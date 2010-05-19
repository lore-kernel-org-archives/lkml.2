Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751947Ab0ESVVa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 17:21:30 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41674 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751131Ab0ESVV3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 17:21:29 -0400
Date: Wed, 19 May 2010 13:39:01 -0700
From: Greg KH <gregkh@suse.de>
To: Haiyang Zhang <haiyangz@microsoft.com>
Cc: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
       "'devel@driverdev.osuosl.org'" <devel@driverdev.osuosl.org>,
       "'virtualization@lists.osdl.org'" <virtualization@lists.osdl.org>,
       Hank Janssen <hjanssen@microsoft.com>
Subject: Re: [PATCH 1/2] staging: hv: Fix race condition in hv_utils module
 initialization.
Message-ID: <20100519203901.GA23214@suse.de>
References: <1FB5E1D5CA062146B38059374562DF7266B8930E@TK5EX14MBXC128.redmond.corp.microsoft.com>
 <20100519161011.GA20266@suse.de>
 <1FB5E1D5CA062146B38059374562DF7266B894B0@TK5EX14MBXC128.redmond.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1FB5E1D5CA062146B38059374562DF7266B894B0@TK5EX14MBXC128.redmond.corp.microsoft.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 19, 2010 at 08:30:25PM +0000, Haiyang Zhang wrote:
> > > +	/* Wait until all IC channels are initialized */
> > > +	while (atomic_read(&hv_utils_initcnt) < MAX_MSG_TYPES)
> > > +		msleep(100);
> > 
> > No, don't do this here, do something in your hv_vmbus core to handle
> > registering sub-drivers properly.  Perhaps you need to sleep there
> > before you can succeed on a initialization.
> 
> Thanks for the recommendation. I will put the sleep into vmbus_init to 
> ensure all channels are ready before the vmbus_init function exits.
> 
> > >  	hv_cb_utils[HV_SHUTDOWN_MSG].channel->OnChannelCallback =
> > >  		&shutdown_onchannelcallback;
> > 
> > The problem is that you just have a bunch of callbacks you are setting
> > up, it's not a "real" function call.  Please change it over to a
> > function call, like all other subsystems have.  Then, you can handle
> > any
> > "sleep until we are set up properly" issues in the vmbus code, not in
> > each and every individual bus driver.
> 
> Actually, we already assign a default callback function, chn_cb_negotiate(),
> when the channels are opened in vmbus module. It's a real function and can 
> handle common negotiation messages.

Then why don't you use it here?

> I will move the sleep into vmbus module as well.

I still think there's a real problem somewhere else in the architecture
if such a sleep is necessary...

Is the issue that the modprobe of the hv_vmbus can return before the bus
is really all set up and ready to go?  If so, just fix that, then you
will not need any "sleep" calls anywhere, right?

thanks,

greg k-h
