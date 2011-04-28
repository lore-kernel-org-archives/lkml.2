Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757524Ab1D1Ast (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 20:48:49 -0400
Received: from kroah.org ([198.145.64.141]:59230 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751866Ab1D1Asd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 20:48:33 -0400
Date: Wed, 27 Apr 2011 17:20:18 -0700
From: Greg KH <greg@kroah.com>
To: KY Srinivasan <kys@microsoft.com>
Cc: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "Abhishek Kane (Mindtree Consulting PVT LTD)" 
	<v-abkane@microsoft.com>
Subject: Re: [PATCH 08/25] Staging: hv: vmbus_driver cannot be unloaded;
 cleanup accordingly
Message-ID: <20110428002018.GC14294@kroah.com>
References: <1303834785-4981-1-git-send-email-kys@microsoft.com>
 <1303834842-5022-1-git-send-email-kys@microsoft.com>
 <1303834842-5022-8-git-send-email-kys@microsoft.com>
 <20110426224545.GC31974@kroah.com>
 <6E21E5352C11B742B20C142EB499E0481DD1C9@TK5EX14MBXC124.redmond.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6E21E5352C11B742B20C142EB499E0481DD1C9@TK5EX14MBXC124.redmond.corp.microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 27, 2011 at 02:31:18AM +0000, KY Srinivasan wrote:
> 
> 
> > -----Original Message-----
> > From: Greg KH [mailto:greg@kroah.com]
> > Sent: Tuesday, April 26, 2011 6:46 PM
> > To: KY Srinivasan
> > Cc: gregkh@suse.de; linux-kernel@vger.kernel.org;
> > devel@linuxdriverproject.org; virtualization@lists.osdl.org; Haiyang Zhang;
> > Abhishek Kane (Mindtree Consulting PVT LTD)
> > Subject: Re: [PATCH 08/25] Staging: hv: vmbus_driver cannot be unloaded;
> > cleanup accordingly
> > 
> > On Tue, Apr 26, 2011 at 09:20:25AM -0700, K. Y. Srinivasan wrote:
> > > The vmbus driver cannot be unloaded; the windows host does not
> > > permit this. Cleanup accordingly.
> > 
> > Woah, you just prevented this driver from ever being able to be
> > unloaded.
> 
> It was never unloadable; while the driver defined an exit routine, 
> there were couple of issues unloading the vmbus driver:
>  
> 1) All guest resources given to the host could not be recovered.

Is this a problem in the Linux side?  If so, that could easily be fixed.

> 2) Windows host would not permit reloading the driver without 
> rebooting the guest.

That's a different issue, and one that I am very surprised to hear.
That kind of invalidates ever being able to update the driver in a guest
for a long-running system that you want to migrate and not reboot.  That
sounds like a major bug in hyper-v, don't you agree?

> All I did was acknowledge the current state and cleanup 
> accordingly. This is not unique to Hyper-V; for what it is worth,
> the Xen platform_pci  driver which is equivalent to the vmbus driver
> is also not unlodable (the last time I checked).

Why isn't that allowed to be unloaded?  What happens if it does?

I would like to see the following be possible from Linux:
	- running Linux guest on hyperv
	- need to migrate to a newer version of hyper-v
	- pause long-running userspace processes.
	- unload hyperv modules
	- migrate guest to newer hyperv version (possible different host
	  machine)
	- load newer hyperv modules
	- resume long-running guest processes

If this isn't possible due to hyper-v bugs, then I guess we need to be
able to live with it, but we had better advertise it pretty well as I
know people will want to be able to do the above sequence for their
guest instances.

If so, can you expand this patch to say more in the changelog entry, and
resend the remaining patches that I didn't apply as they are now gone
from my pending-patch queue.

> > That's not a "cleanup" that's a major change in how things work.  I'm
> > sure, if you want to continue down this line, there are more things you
> > can remove from the code, right?
> > 
> > What is the real issue here?  What happens if you unload the bus?  What
> > goes wrong?  Can it be fixed?
> 
> This needs to be fixed on the host side. I have notified them of the issue. 

Ok, so if this is going to be fixed, why do we need to prevent this from
ever being possible to have happen on our side?

thanks,

greg k-h
