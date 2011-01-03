Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755448Ab1ACPUo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 10:20:44 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:43831 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755425Ab1ACPUn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 10:20:43 -0500
Date: Mon, 3 Jan 2011 15:19:44 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Dan Williams <dan.j.williams@intel.com>,
        Linus Walleij <linus.walleij@stericsson.com>
Cc: Viresh Kumar <viresh.kumar@st.com>, Kukjin Kim <kgene.kim@samsung.com>,
        yuanyabin1978@sina.com, linux-kernel@vger.kernel.org,
        Ben Dooks <ben-linux@fluff.org>, Peter Pearse <peter.pearse@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Alessandro Rubini <rubini@unipv.it>
Subject: Re: [PATCH 06/13] DMAENGINE: driver for the ARM PL080/PL081
	PrimeCells
Message-ID: <20110103151944.GA32508@n2100.arm.linux.org.uk>
References: <1276270031-1607-1-git-send-email-linus.walleij@stericsson.com> <20101221182037.GA4783@n2100.arm.linux.org.uk> <20101222122904.GC14693@n2100.arm.linux.org.uk> <AANLkTikpyAggDCPef1pS=_QHnu9-FyLcpddGyVHnGwWx@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikpyAggDCPef1pS=_QHnu9-FyLcpddGyVHnGwWx@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Another issue to think about in terms of API guarantees...

Pausing an on-going transfer (which from what I read is a recent addition
to the API) can be problematical - having tripped over one such problem
on my Realview EB (PL081 rev1) platform.

With the PL08x, when you program a channel up for a M->P transfer and
enable it, the DMAC will immediately fetch data from memory and mark
itself busy before the first DMA request from the peripheral.

When the first DMA request occurs from the peripheral, the DMAC starts
feeding this data to the peripheral, and fetches new data into its FIFO
as required.

The problem comes when the peripheral stops requesting data from the
DMAC, and then you want to pause it.  Current code sets the HALT bit,
and then spins indefinitely for the BUSY bit to clear - which it will
only ever do if the peripheral drains the FIFO.  As a result of botched
DMA signal selection code for the Realview EB, the DMA signals never
went active, and on terminate_all() the CPU locked up solid (no
interrupts) spinning on the DMAC to clear the busy bit.

It may be worth specifying that a pause followed by a resume is
expected to never lose data - and that drivers must check the result
of a request to pause the channel.  If DMA engine drivers are unable
to pause the channel within a reasonable amount of time, they should
return -ETIMEOUT, so they know that there may still be data that
could still be transferred to the peripheral.

One important note about this condition is that with the DMA channel
marked BUSY+HALT and the channel being configured for M->P, the
peripheral can still transfer data from the DMAC to itself, and this
causes the transfer size value in the CNTL register to decrement (since
reading the CNTL register returns the number of transfers _to_ the
destination, not the number of transfers from the source.)

I've changed the comment against pl08x_pause_phy_chan() to this:

 * Pause the channel by setting the HALT bit.
 *
 * For M->P transfers, pause the DMAC first and then stop the peripheral -
 * the FIFO can only drain if the peripheral is still requesting data.
 * (note: this can still timeout if the DMAC FIFO never drains of data.)
 *
 * For P->M transfers, disable the peripheral first to stop it filling
 * the DMAC FIFO, and then pause the DMAC.

I've not decided whether it should be possible to resume an ETIMEOUT'd
pause request (in theory with pl08x, that's just a matter of clearing
the HALT bit) or whether an ETIMEOUT'd pause request should restore
the previous HALT bit setting (possibly re-enabling transfers on the
channel.)  Allowing it to be re-enabled in some way would be the safest
thing in terms of data integrity for the reason mentioned in the
"important note" above.

Dan, Linus, any thoughts?
