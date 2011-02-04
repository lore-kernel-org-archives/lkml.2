Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752787Ab1BDWye (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 17:54:34 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42404
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752631Ab1BDWyd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 17:54:33 -0500
Date: Fri, 04 Feb 2011 14:55:08 -0800 (PST)
Message-Id: <20110204.145508.59670453.davem@davemloft.net>
To: benh@kernel.crashing.org
Cc: jackdachef@gmail.com, linux-kernel@vger.kernel.org,
        ruediger.herbst@googlemail.com, geert@linux-m68k.org
Subject: Re: Sun GEM PPC32 Bug?
From: David Miller <davem@davemloft.net>
In-Reply-To: <1296852667.2349.804.camel@pasglop>
References: <AANLkTimBFBKJf0-TNRLr2hHNEehR2cnKPvx06=yyHGVj@mail.gmail.com>
	<1296852667.2349.804.camel@pasglop>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Sat, 05 Feb 2011 07:51:07 +1100

> The FIFO overflow could be a driver bug or a HW issue, there are some
> known issues with the small FIFOs in that chip, but it's also possible
> that we don't configure them quite right. Anybody wants to dig in and
> see what's going on there ? May want to look at the Darwin sungem driver
> for reference on how it configures them... However, it should generally
> recover when that happens. If not, then we have a bug there.

I think we're simply not resetting enough when the RX FIFO overflow
happens.

Just for fun I checked the OpenBSD GEM driver to see what they do.
When an overflow occurs, they bump the statistic, record the current
read and write fifo pointer registers, and schedule a watchdog timer
for 400ms into the future.

If the watchdog timer sees that the RX FIFO overflow bit is still set
in the RX status register, and the RX FIFO read and write pointers
have not changed, it resets the entire chip.

We unconditionally reset the RX MAC when an overflow occurs, that may
simply not be enough to unwedge this thing.
