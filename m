Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753501Ab0JGVkp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 17:40:45 -0400
Received: from smtp.outflux.net ([198.145.64.163]:47365 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753125Ab0JGVko (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 17:40:44 -0400
Date: Thu, 7 Oct 2010 14:40:21 -0700
From: Kees Cook <kees.cook@canonical.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Ben Hutchings <bhutchings@solarflare.com>,
        Jeff Garzik <jgarzik@redhat.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH] net: clear heap allocations for privileged ethtool
 actions
Message-ID: <20101007214021.GL14666@outflux.net>
References: <20101007211004.GA20267@outflux.net>
 <1286487085.3745.99.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1286487085.3745.99.camel@edumazet-laptop>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eric,

On Thu, Oct 07, 2010 at 11:31:25PM +0200, Eric Dumazet wrote:
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

This code is basically a max() call from what I see.

regbuf = kmalloc(max(regs.len, ops->get_regs_len(dev)), GFP_USER);

If the user passes regs.len = 1, it will be ignored in favor of reglen,
so we'll not write past the end of regbuf, unless I'm misunderstanding.

-Kees

-- 
Kees Cook
Ubuntu Security Team
