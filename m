Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755505Ab1AKJQ3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 04:16:29 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:46592 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753015Ab1AKJQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 04:16:24 -0500
Date: Tue, 11 Jan 2011 09:16:07 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jeremy Kerr <jeremy.kerr@canonical.com>
Cc: linux-sh@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Ben Herrenschmidt <benh@kernel.crashing.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Subject: Re: Locking in the clk API
Message-ID: <20110111091607.GI12552@n2100.arm.linux.org.uk>
References: <201101111016.42819.jeremy.kerr@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201101111016.42819.jeremy.kerr@canonical.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 11, 2011 at 10:16:42AM +0800, Jeremy Kerr wrote:
> At present, we can satisfy these with:
> 
> * clk_enable: may sleep

I object to this as one of the purposes behind the clk API is to allow
power savings to be made, and unless we can perform clk enable/disable
from atomic contexts, the best you can do is enable the clock when the
device is probed and disable it when it's released.

For a lot of systems, modules are loaded at boot, and devices are probed
at boot time.  They're never unloaded.

This means that clocks will be enabled at boot time and never turned off.

If you're lucky, there may be open/release methods which can be used to
enable/disable the clock, which reduces the 'clock on' period down to
the point where userspace opens/closes the device.  That's still
insufficient and in some cases there aren't calls for this.

Sometimes the only point that you know you need the clock enabled is when
your driver has already been called in an atomic context.

If such a requirement is imposed, it means that a driver would either have
to leave the clock always on, or would have to drop such calls if the
clock wasn't already enabled.
