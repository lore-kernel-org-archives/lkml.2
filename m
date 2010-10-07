Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751690Ab0JGVkN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 17:40:13 -0400
Received: from mail.solarflare.com ([216.237.3.220]:53504 "EHLO
	exchange.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720Ab0JGVkL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 17:40:11 -0400
Subject: Re: [PATCH] net: clear heap allocations for privileged ethtool
 actions
From: Ben Hutchings <bhutchings@solarflare.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Kees Cook <kees.cook@canonical.com>, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jeff Garzik <jgarzik@redhat.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        netdev@vger.kernel.org
In-Reply-To: <1286487085.3745.99.camel@edumazet-laptop>
References: <20101007211004.GA20267@outflux.net>
	 <1286487085.3745.99.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"
Organization: Solarflare Communications
Date: Thu, 07 Oct 2010 22:40:07 +0100
Message-ID: <1286487607.2271.42.camel@achroite.uk.solarflarecom.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 (2.30.2-4.fc13) 
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 07 Oct 2010 21:40:11.0442 (UTC) FILETIME=[381FA120:01CB6668]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-6.500.1024-17688.005
X-TM-AS-Result: No--29.954200-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-10-07 at 23:31 +0200, Eric Dumazet wrote:
> Le jeudi 07 octobre 2010 à 14:10 -0700, Kees Cook a écrit :
> > Several other ethtool functions leave heap uncleared (potentially) by
> > drivers. Some interfaces appear safe (eeprom, etc), in that the sizes
> > are well controlled. In some situations (e.g. unchecked error conditions),
> > the heap will remain unchanged in areas before copying back to userspace.
> > Note that these are less of an issue since these all require CAP_NET_ADMIN.
> 
> > @@ -775,7 +775,7 @@ static int ethtool_get_regs(struct net_device *dev, char __user *useraddr)
> >  	if (regs.len > reglen)
> >  		regs.len = reglen;
> >  
> > -	regbuf = kmalloc(reglen, GFP_USER);
> > +	regbuf = kzalloc(reglen, GFP_USER);

Actually, I recently changed this to vmalloc() so your patch won't
apply.

> >  	if (!regbuf)
> >  		return -ENOMEM;
> >  
> > -- 
> > 1.7.1
> > 
> 
> Are you sure this is not hiding a more problematic problem ?
> 
> Code does :
> 
> reglen = ops->get_regs_len(dev);
> if (regs.len > reglen)
> 	regs.len = reglen;
> regbuf = kmalloc(reglen, GFP_USER);
> 
> So we can not copy back kernel memory.
> 
> However, what happens if user provides regs.len = 1 byte, and driver
> get_regs() doesnt properly checks regs.len and write past end of regbuf
> -> We probably write on other parts of kernel memory
[...]

Why should the driver's get_regs() check regs.len?  The buffer is
allocated based on reglen which is provided by the driver, not the user.

reglen (length of the kernel buffer) is not reduced; regs.len (length of
the user buffer) is.  That lets the user know how much of the user
buffer was actually used.

Ben.

-- 
Ben Hutchings, Senior Software Engineer, Solarflare Communications
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

