Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753382Ab0I1VLw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 17:11:52 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:33880 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753322Ab0I1VLw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 17:11:52 -0400
Date: Tue, 28 Sep 2010 22:11:06 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Boaz Harrosh <bharrosh@panasas.com>, Julia Lawall <julia@diku.dk>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        uml-devel <user-mode-linux-devel@lists.sourceforge.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Stephen Hemminger <shemminger@vyatta.com>
Subject: Re: {painfully BISECTED} Please revert f25c80a4b2: arch/um/drivers:
 remove duplicate structure field initialization
Message-ID: <20100928211106.GE19804@ZenIV.linux.org.uk>
References: <4CA09977.80506@panasas.com>
 <AANLkTim85sH_2o=xCiDuoQrHq_7ZL96Y91xQMGxUP5Fy@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTim85sH_2o=xCiDuoQrHq_7ZL96Y91xQMGxUP5Fy@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 28, 2010 at 01:24:40PM -0700, Linus Torvalds wrote:
> It looks like that commit is indeed very misleading. The commit message says:
> 
>   "arch/um/drivers: remove duplicate structure field initialization"
> 
> but it is in fact not duplicate: there's two field initializations,
> but they are _different_. Looking at the patch, it has:
> 
>         .ndo_set_mac_address    = uml_net_set_mac,
> -       .ndo_set_mac_address    = eth_mac_addr,
> 
> so it removes the later one, but it is not at all clear which one the
> compiler actually used. My guess is that it used to use the later one
> (the standard eth_mac_addr function), and the patch made it suddenly
> use the uml_net_set_mac function.

C99 6.7.8p19:

	The initialization shall occur in initializer list order, each
initializer provided for a particular subobject overriding any previously
listed initializer for the same subobject[*]; all subobjects that are not
initialized explicitly shall be initialized implicitly the same as objects
that have static storage duration.

[*] Any initializer for subobject which is overridden and so not used to
initialize that subobject might not be evaluated at all.


IOW, it _must_ use the last one in such cases.

As for the driver, I smell an interface change (in eth_mac_addr() arguments)
that has been missed...  FWIW, grep through the tree shows one more instance
of eth_mac_addr() called with such argument and it's also in net_kern.c; there
we simply want memcpy() instead, since device is definitely not running at
that point and we'd done the validity checks earlier.

Not sure if we need lp->lock around that eth_mac_addr() call - not familiar
with the driver in question.  If we don't, we should switch to eth_mac_addr
for the method, indeed...
