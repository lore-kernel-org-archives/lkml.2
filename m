Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753357Ab0FCLGA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 07:06:00 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:55762 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752333Ab0FCLF7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 07:05:59 -0400
Date: Thu, 3 Jun 2010 12:05:33 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jeremy Kerr <jeremy.kerr@canonical.com>
Cc: Ben Dooks <ben-linux@fluff.org>,
       Ben Herrenchmidt <benh@kernel.crashing.org>,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC,PATCH 1/2] Add a common struct clk
Message-ID: <20100603110533.GB7127@n2100.arm.linux.org.uk>
References: <1275479804.137633.565764505843.0.gpush@pororo> <201006031121.21896.jeremy.kerr@canonical.com> <20100603081354.GA4720@trinity.fluff.org> <201006031824.53832.jeremy.kerr@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201006031824.53832.jeremy.kerr@canonical.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 03, 2010 at 06:24:50PM +0800, Jeremy Kerr wrote:
> OK, this would mean adding parent to struct clk:
> 
> struct clk {
> 	struct clk_operations	*ops;
> 	atomic_t				enable_count;

I don't think it makes sense for this to be an atomic type.

> static inline int clk_enable(struct clk *clk)
> {
> 	int ret;
> 
> 	if (atomic_inc(clk->enable_count) != 1))
> 		return 0;

Okay, so what if we sleep at this point, and someone else comes along
and calls clk_enable(), which'll merely increment the count and return.

Unfortunately, the clock is still disabled at that point - which is a
violation of what's supposed to happen.

Or to put it another way, the above method results in clk_enable()
sometimes returning with the clock enabled and sometimes with the
clock still disabled.

That's not nice behaviour for drivers which may need the clock enabled
to read/write the device registers.
