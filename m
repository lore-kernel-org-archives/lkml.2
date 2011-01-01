Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753064Ab1AAPQ0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jan 2011 10:16:26 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:33286 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752867Ab1AAPQZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jan 2011 10:16:25 -0500
Date: Sat, 1 Jan 2011 15:15:45 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        Viresh Kumar <viresh.kumar@st.com>, Kukjin Kim <kgene.kim@samsung.com>,
        yuanyabin1978@sina.com, linux-kernel@vger.kernel.org,
        Ben Dooks <ben-linux@fluff.org>, Peter Pearse <peter.pearse@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Alessandro Rubini <rubini@unipv.it>
Subject: Re: [PATCH 06/13] DMAENGINE: driver for the ARM PL080/PL081
	PrimeCells
Message-ID: <20110101151545.GC25924@n2100.arm.linux.org.uk>
References: <1276270031-1607-1-git-send-email-linus.walleij@stericsson.com> <20101221182037.GA4783@n2100.arm.linux.org.uk> <20101222122904.GC14693@n2100.arm.linux.org.uk> <AANLkTikpyAggDCPef1pS=_QHnu9-FyLcpddGyVHnGwWx@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikpyAggDCPef1pS=_QHnu9-FyLcpddGyVHnGwWx@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 22, 2010 at 03:45:39PM -0800, Dan Williams wrote:
> Support for the DMA_COMPL flags are necessary if the DMA_MEMCPY
> capability is advertised, yes this driver got this wrong.  I'll update
> the documentation to make this requirement clear, and audit the other
> drivers.  With slave-only drivers the only usage model is one where
> the client driver owns dma-mapping.  In the non-slave (opportunistic
> memcpy offload) case the client is unaware of the engine so the driver
> owns unmapping.  The minimal fix is to disable memcpy offload.

As a side note, the DMA mapping for slaves should be done using the
DMA struct device, not the struct device of the peripheral making use
of the DMA engine.

Why?  The slave device has no knowledge of how the DMA engine is
connected into the system, or the DMA parameters associated with the
device performing the DMA, such as the DMA mask and boundaries.  (If
there are several generic DMA agents in the system, it can't know
which is the correct one to use until a channel has been allocated.)
The only struct device which has this information is the one for the
DMA engine itself.

Therefore, the struct device which is passed into the DMA mapping APIs
to prepare memory for DMA must always be the DMA engine struct device
(chan->device->dev) and never the slave struct device.

This is no different from USB - consider the slave devices to be USB
peripherals, and the DMA engine device to be the USB host controller.
The USB host controller performs all the DMA, and DMA mappings are
setup and torn down against the DMA host controller device structure.
