Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758731Ab0EUWbS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 18:31:18 -0400
Received: from cantor.suse.de ([195.135.220.2]:58956 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753292Ab0EUWbR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 18:31:17 -0400
Date: Fri, 21 May 2010 15:22:01 -0700
From: Greg KH <gregkh@suse.de>
To: Haiyang Zhang <haiyangz@microsoft.com>
Cc: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
       "'devel@driverdev.osuosl.org'" <devel@driverdev.osuosl.org>,
       "'virtualization@lists.osdl.org'" <virtualization@lists.osdl.org>,
       Hank Janssen <hjanssen@microsoft.com>
Subject: Re: [PATCH 1/1] staging: hv: Fix race condition on IC channel
 initialization
Message-ID: <20100521222201.GA12429@suse.de>
References: <1FB5E1D5CA062146B38059374562DF7266B8AE7C@TK5EX14MBXC128.redmond.corp.microsoft.com>
 <20100521201228.GA6712@suse.de>
 <1FB5E1D5CA062146B38059374562DF7266B8B5F2@TK5EX14MBXC128.redmond.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1FB5E1D5CA062146B38059374562DF7266B8B5F2@TK5EX14MBXC128.redmond.corp.microsoft.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 21, 2010 at 10:07:17PM +0000, Haiyang Zhang wrote:
> > From: Greg KH [mailto:gregkh@suse.de]
> > > +/* Counter of IC channels initialized */
> > > +atomic_t hv_utils_initcnt = ATOMIC_INIT(0);
> > 
> > This doesn't need to be an atomic variable, does it really?
> > 
> > Why not have a simple bool variable "vmbus_initialized" or something.
> > It starts out as false, and then turns true when you are up and ready.
> > Then provide a function that tests it:
> > 	bool hv_vmbus_ready(void)
> > 	{
> > 		return vmbus_initialized
> > 	}
> > 	EXPORT_SYMBOL_GPL(hv_vmbus_ready);
> > 
> > 
> > this turns into a simple function call, again, never needing to know
> > about message types or any other mess.
> 
> This looks good. I will add the hv_vmbus_ready() function. It doesn't even 
> have to be exported symbol, because it's only used in vmbus module to ensure 
> all channels are ready before vmbus_init() returns. Other modules won't get a 
> chance to see uninitialized channels after hv_vmbus is loaded.
> 
> Also, I'll cleanup the printk in hv_utils load/unload.
> 
> Regarding the atomic variable -- the channel offer processing function is 
> triggered by interrupts from host -- should we be concerned about "counter++" 
> racing with each other in two interrupts happening around the same time?

If you are, having races like this, then you should be using a lock to
protect lots of things, not just one single atomic variable, right?

thanks,

greg k-h
