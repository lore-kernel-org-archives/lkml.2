Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755968Ab1HWWQI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 18:16:08 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:34836 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755549Ab1HWWPO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 18:15:14 -0400
X-Sasl-enc: TucKHopBykco4LWjwisA5FFKGzZgAPGjQ6PZ4FnJRxMG 1314137713
Date: Tue, 23 Aug 2011 15:06:59 -0700
From: Greg KH <greg@kroah.com>
To: Martyn Welch <martyn.welch@ge.com>
Cc: gregkh@suse.de, cota@braap.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] staging: vme: allow explicit assignment of bus
 numbers
Message-ID: <20110823220659.GA15721@kroah.com>
References: <1312968830-13377-1-git-send-email-manohar.vanga@cern.ch>
 <1312968830-13377-2-git-send-email-manohar.vanga@cern.ch>
 <4E425725.7080305@ge.com>
 <20110810104143.GA14060@becoht-mvanga>
 <4E427E89.8010700@ge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E427E89.8010700@ge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 10, 2011 at 01:50:17PM +0100, Martyn Welch wrote:
> On 10/08/11 11:41, Manohar Vanga wrote:
> > Hey Martyn,
> > 
> >> I'm sorry, I'm still simply not convinced by this patch:
> >>
> >> 1) For a single bus driver (i.e. in the situation where we have 2 bridges of
> >> the same type), the numbering of the buses is still dependent on the order
> >> that they are found in the scan.
> > 
> > Yes this is still a bug. But this patch doesn't address this case.
> > 
> >> 2) If the bridge drivers are loaded as modules, I have a feeling they will be
> >> loaded sequentially and therefore the order of the bridges would only change
> >> if the order of the loading of the drivers changed.
> > 
> > And this is a major problem when it comes to multiple bridges of differing
> > types. What I'm saying is that this patch simply fixes this one problematic
> > case. We can move this out as soon as we have a more robust implementation.
> > 
> > As of now however, I think applying this is useful as we have a decent
> > workaround to the problem. If you want I can make the fact of it being
> > applicable only to cases with differing bridges explicit in the commit
> > message.
> > 
> 
> The problem is, I'm not convinced that this is the correct approach to take. I
> think this should be parsed from sysfs dynamically (which may require some
> work). I shall use the ethernet devices on my machine as an example:
> 
> I have 2 ethernet devices (and lo) on my machine:
> 
> $ ls /sys/class/net/
> eth0  eth1  lo
> $
> 
> These are symlinks and I can quite quickly find out which each of these
> devices in (based on topology):
> $ ls -l /sys/class/net/
> total 0
> lrwxrwxrwx 1 root root 0 2011-08-10 11:56 eth0 ->
> ../../devices/pci0000:00/0000:00:19.0/net/eth0
> lrwxrwxrwx 1 root root 0 2011-08-10 11:56 eth1 ->
> ../../devices/pci0000:00/0000:00:1c.1/0000:03:00.0/net/eth1
> lrwxrwxrwx 1 root root 0 2011-08-10 11:56 lo -> ../../devices/virtual/net/lo
> $
> 
> I'd think that this contains the information that you have in the config file
> (based on the previous discussion we had) and would allow you to map the bus
> numbering after booting.
> 
> To do this, I think we need to register a class called "vme", I guess in
> vme_init() and add a call to class_device_register in vme_register_bridge and
> a call to class_device_unregister in vme_unregister_bridge.
> 
> Greg: Is that right?

Yes.

> I'm really not convinced that the solution presented in this patch is suitable
> for inclusion upstream.

I agree.  Bus numbers are dynamic and should NEVER be depended on by
userspace to be static and unchanging on reboots.

thanks,

greg k-h
