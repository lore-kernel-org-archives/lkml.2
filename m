Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751820Ab0LWTYW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 14:24:22 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55633
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751213Ab0LWTYV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 14:24:21 -0500
Date: Thu, 23 Dec 2010 11:24:50 -0800 (PST)
Message-Id: <20101223.112450.246547841.davem@davemloft.net>
To: jhautbois@gmail.com
Cc: richard.cochran@omicron.at, shemminger@vyatta.com, tj@kernel.org,
        randy.dunlap@oracle.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] net: phy: balance disable/enable irq on change
From: David Miller <davem@davemloft.net>
In-Reply-To: <1292756331-3735-1-git-send-email-jhautbois@gmail.com>
References: <1292756331-3735-1-git-send-email-jhautbois@gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jean-Michel Hautbois <jhautbois@gmail.com>
Date: Sun, 19 Dec 2010 11:58:48 +0100

> When phy interface changes its status, it calls phy_change() function.
> This function calls the interrupt disabling functions for the driver
> registered, but if this driver doesn't implement it, there is no IRQ
> disabling. After doing the work, we call enable_irq and not the
> respective driver function. This fixes it, as it could lead to an
> unbalanced IRQ. Error code changed to EOPNOTSUPP.
> 
> Signed-off-by: Jean-Michel Hautbois <jhautbois@gmail.com>

This is completely bogus.

First of all, there are 5 call sites for phy_change_interrupt() but
you've only implemented the new semantics for two of those.

Therefore, if we even wanted this, we should implement the behavior in
phy_change_interrupt() itself instead of duplicating the logic at
each and every call site.

But we don't want this.

It's not appropriate at all.  If a device lacks a way to turn
interrupt off and on, using disable_irq() and enable_irq() is not
necessarily correct.

If the interrupt line is shared, for example, this will break
everything.

