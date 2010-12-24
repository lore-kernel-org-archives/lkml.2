Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752093Ab0LXIqy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Dec 2010 03:46:54 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:56995 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784Ab0LXIqw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Dec 2010 03:46:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=pZbEert7AkPqf+D7oGeiictHhCnzaTXIESukDxeCC7uUGmlLB9QNx22Sjnc0n7QR8u
         xskyQgd4wsqDRBfP65lBKHcRryZ0ScumUOohSEb4UAp7OexanlzcajRIsIbCOlmcJmsQ
         dmly4nrSAYhgtUYqhyftt/A9h61w0oHNZOZ9w=
MIME-Version: 1.0
In-Reply-To: <20101223.112450.246547841.davem@davemloft.net>
References: <1292756331-3735-1-git-send-email-jhautbois@gmail.com>
	<20101223.112450.246547841.davem@davemloft.net>
Date: Fri, 24 Dec 2010 09:46:51 +0100
Message-ID: <AANLkTinVEVcVCH01Hg4QXAV0V-J9UE+9guM1ttorQGLR@mail.gmail.com>
Subject: Re: [PATCH 1/4] net: phy: balance disable/enable irq on change
From: Jean-Michel Hautbois <jhautbois@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: richard.cochran@omicron.at, shemminger@vyatta.com, tj@kernel.org,
        randy.dunlap@oracle.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/12/23 David Miller <davem@davemloft.net>:
> From: Jean-Michel Hautbois <jhautbois@gmail.com>
> Date: Sun, 19 Dec 2010 11:58:48 +0100
>
>> When phy interface changes its status, it calls phy_change() function.
>> This function calls the interrupt disabling functions for the driver
>> registered, but if this driver doesn't implement it, there is no IRQ
>> disabling. After doing the work, we call enable_irq and not the
>> respective driver function. This fixes it, as it could lead to an
>> unbalanced IRQ. Error code changed to EOPNOTSUPP.
>>
>> Signed-off-by: Jean-Michel Hautbois <jhautbois@gmail.com>
>
> This is completely bogus.
>
> First of all, there are 5 call sites for phy_change_interrupt() but
> you've only implemented the new semantics for two of those.
>
> Therefore, if we even wanted this, we should implement the behavior in
> phy_change_interrupt() itself instead of duplicating the logic at
> each and every call site.
>
> But we don't want this.

OK, I understand that point.

> It's not appropriate at all.  If a device lacks a way to turn
> interrupt off and on, using disable_irq() and enable_irq() is not
> necessarily correct.
>
> If the interrupt line is shared, for example, this will break
> everything.
>

OK, well, maybe is there at least one thing we could do : in
phy_change, instead of calling phy_disable_interrupts(), balanced by
enable_irq, we probably should use phy_enable_interrupts().
