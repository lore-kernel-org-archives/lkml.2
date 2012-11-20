Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752791Ab2KTJx2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 04:53:28 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:64292 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751901Ab2KTJx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 04:53:26 -0500
Date: Tue, 20 Nov 2012 01:53:21 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Mike Turquette <mturquette@ti.com>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [RFC/PATCH 0/3] CLK: add more devm_* APIs
Message-ID: <20121120095321.GA11732@core.coreip.homeip.net>
References: <1353403339-11679-1-git-send-email-dmitry.torokhov@gmail.com>
 <20121120093445.GL3290@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121120093445.GL3290@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 20, 2012 at 09:34:45AM +0000, Russell King - ARM Linux wrote:
> On Tue, Nov 20, 2012 at 01:22:16AM -0800, Dmitry Torokhov wrote:
> > Hi,
> > 
> > When looking at recent driver conversions to managed resources (devm_*) there
> > is no devm_clk_prepare() and similar functions, which forces mixing of 2
> > resource management styles (managed/classic) in the same driver, which is not
> > great.
> > 
> > This patch series adds more devm_* managed APIs to the CLK subsystem so that
> > driver conversions can be "pure".
> 
> So, how do you ensure the correct ordering between clk_unprepare() and
> clk_put(), or even clk_disable() and clk_unprepare() ?  I see nothing
> here which makes any guarantees as to the ordering of those operations
> upon cleanup.

devm_* calls form a stack so if you have

static void xxx_probe()
{
	input = devm_input_allocate_device();

	devm_request_irq();
	...
	devm_clk_prepare()
	...
	devm_clk_enable()
	... 
	input_register_device();
	return 0;
}

and

static int xxx_remove()
{
	return 0;
}

then upon remove we'll execute:

	input_unregister_device();
	devm_clk_disable();
	devm_clk_unprepare();
	devm_free_irq();
	input_free_device();

Thanks.

-- 
Dmitry
