Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752129Ab0JGVeD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 17:34:03 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:44625 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826Ab0JGVeA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 17:34:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=iu1nt/eUqSTEMCI6KA8PFt7OtRrVKtw5VOBqZ1ZVBZcfUl7VyS73eaktHVS9Uu5P1P
         FFiAFgvyRqfBtGqYN6Ffzqjbz2M0p6zs7WGlaC7SzJe1FOOds2WRxYYBuuwGXvW1hrBE
         Opw4PpFVgU83YRJVAKDLLhSG4kasuPdqToN2Q=
Subject: Re: [PATCH] net: clear heap allocations for privileged ethtool
 actions
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Kees Cook <kees.cook@canonical.com>
Cc: linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Ben Hutchings <bhutchings@solarflare.com>,
        Jeff Garzik <jgarzik@redhat.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        netdev@vger.kernel.org
In-Reply-To: <20101007211004.GA20267@outflux.net>
References: <20101007211004.GA20267@outflux.net>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 07 Oct 2010 23:31:25 +0200
Message-ID: <1286487085.3745.99.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 07 octobre 2010 à 14:10 -0700, Kees Cook a écrit :
> Several other ethtool functions leave heap uncleared (potentially) by
> drivers. Some interfaces appear safe (eeprom, etc), in that the sizes
> are well controlled. In some situations (e.g. unchecked error conditions),
> the heap will remain unchanged in areas before copying back to userspace.
> Note that these are less of an issue since these all require CAP_NET_ADMIN.

> @@ -775,7 +775,7 @@ static int ethtool_get_regs(struct net_device *dev, char __user *useraddr)
>  	if (regs.len > reglen)
>  		regs.len = reglen;
>  
> -	regbuf = kmalloc(reglen, GFP_USER);
> +	regbuf = kzalloc(reglen, GFP_USER);
>  	if (!regbuf)
>  		return -ENOMEM;
>  
> -- 
> 1.7.1
> 

Are you sure this is not hiding a more problematic problem ?

Code does :

reglen = ops->get_regs_len(dev);
if (regs.len > reglen)
	regs.len = reglen;
regbuf = kmalloc(reglen, GFP_USER);

So we can not copy back kernel memory.

However, what happens if user provides regs.len = 1 byte, and driver
get_regs() doesnt properly checks regs.len and write past end of regbuf
-> We probably write on other parts of kernel memory

An audit is needed, but first driver I checked is buggy
(drivers/net/qlcnic/qlcnic_ethtool.c)

->
 	memset(p, 0, qlcnic_get_regs_len(dev));



