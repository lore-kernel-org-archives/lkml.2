Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933121Ab2BBVoS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 16:44:18 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:44019 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757339Ab2BBVoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 16:44:16 -0500
Date: Thu, 2 Feb 2012 21:43:50 +0000
From: Russell King <rmk@arm.linux.org.uk>
To: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: vinod.koul@intel.com, dan.j.williams@intel.com,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Kumar Gala <galak@kernel.crashing.org>,
        Matt Porter <mporter@kernel.crashing.org>,
        Li Yang <leoli@freescale.com>
Subject: Re: [PATCH 01/11] dmaengine: add context parameter to
	prep_slave_sg and prep_dma_cyclic
Message-ID: <20120202214350.GB4432@flint.arm.linux.org.uk>
References: <1328218341-31436-1-git-send-email-alexandre.bounine@idt.com> <1328218341-31436-2-git-send-email-alexandre.bounine@idt.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328218341-31436-2-git-send-email-alexandre.bounine@idt.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 02, 2012 at 04:32:11PM -0500, Alexandre Bounine wrote:
> Add context parameter to device_prep_slave_sg() and device_prep_dma_cyclic()
> interfaces to allow passing client/target specific information associated
> with the data transfer.

I'm slightly concerned about having this as a vague 'void *' pointer.
What that means is that the data being passed through it is entirely
unspecified, and quite specific to the DMA engine.

That's rather worrying when we (on ARM) are moving towards a model
where the same peripheral IP can be backed by multiple different DMA
engines.  We already have peripheral drivers (clients of DMA engine)
which can be attached to completely different DMA engine drivers.

If DMA engines continue to operate conventionally with this parameter
NULL then that's fine for current stuff.  I would suggest that it's
made to be something a little better defined though, as the 'void *'
approach encourages each driver writer to invent their own way to
specify, eg, an interleaved transfer.  We'll then end up with N
different ways to specify the same thing.

Not only that, but peripheral drivers won't know what kind of data to
pass there (they would have to have additional knowledge of the DMA
engine which they're attached to.)

Basically, allowing a DMA engine specific blob of data to be passed
destroys the idea of having a consistent API for peripheral drivers
to use, because they can then no longer be independent of their DMA
engine.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
