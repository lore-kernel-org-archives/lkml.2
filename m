Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759468Ab2FUMTb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 08:19:31 -0400
Received: from linux-sh.org ([111.68.239.195]:52881 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757039Ab2FUMTa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 08:19:30 -0400
Date: Thu, 21 Jun 2012 21:18:44 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Chris Ball <cjb@laptop.org>
Cc: Rob Herring <robherring2@gmail.com>, Mitch Bradley <wmb@laptop.org>,
        mturquette@linaro.org, devicetree-discuss@lists.ozlabs.org,
        sboyd@codeaurora.org, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>, skannan@codeaurora.org,
        shawn.guo@linaro.org, s.hauer@pengutronix.de,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 02/02] clk: clk-of: Use alloc_bootmem() instead of
 kzalloc()
Message-ID: <20120621121843.GA20236@linux-sh.org>
References: <1339512111-11172-1-git-send-email-robherring2@gmail.com>
 <87bokd15x7.fsf@octavius.laptop.org>
 <87395p15or.fsf_-_@octavius.laptop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87395p15or.fsf_-_@octavius.laptop.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 21, 2012 at 03:32:04AM -0400, Chris Ball wrote:
> When of_clk_add_provider() is used at boot time (during .init_early on
> ARM, in the motivating case for this patch), kzalloc() cannot be used
> because slab isn't up yet.
> 
> Signed-off-by: Chris Ball <cjb@laptop.org>

I wouldn't use alloc_bootmem() unconditionally for this, as you have no
idea where other platforms may wire the call site up. slab is also
available a lot earlier now than it used to be, so many places that
required bootmem pages previously can get away with slab allocations now.

You could rework this as:

	if (slab_is_available())
		cp = kzalloc(...)
	else
		cp = alloc_bootmem(...)

and then it doesn't matter when and where it gets called.
