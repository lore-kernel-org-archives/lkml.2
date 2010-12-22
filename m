Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752796Ab0LVMX1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 07:23:27 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:38427 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751826Ab0LVMXZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 07:23:25 -0500
Date: Wed, 22 Dec 2010 12:22:40 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: Viresh Kumar <viresh.kumar@st.com>, Kukjin Kim <kgene.kim@samsung.com>,
        yuanyabin1978@sina.com, linux-kernel@vger.kernel.org,
        Ben Dooks <ben-linux@fluff.org>, Peter Pearse <peter.pearse@arm.com>,
        Dan Williams <dan.j.williams@intel.com>,
        linux-arm-kernel@lists.infradead.org,
        Alessandro Rubini <rubini@unipv.it>
Subject: Re: [PATCH 06/13] DMAENGINE: driver for the ARM PL080/PL081
	PrimeCells
Message-ID: <20101222122240.GB14693@n2100.arm.linux.org.uk>
References: <1276270031-1607-1-git-send-email-linus.walleij@stericsson.com> <20101221182037.GA4783@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101221182037.GA4783@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 21, 2010 at 06:20:37PM +0000, Russell King - ARM Linux wrote:
> Having just looked at this while trying to undo the DMA API abuses
> in the PL011 UART driver, I'm getting rather frustrated with this
> code.

Right, just tried this on the Versatile PB/926, which has a PL080.
The result is DMA errors.  This turns out to be the hard-coding of
which AHB bus is used.

You can't hard-code this information into the driver - it's part of
the bus matrix configuration.  On Versatile PB/926, the two AHB
buses have different memory maps - see DUI0224 page 3-13:

* DMA0 (which is DMA AHB M1) has access to the APB peripherals
  but not the system memory.
* DMA1 (which is DMA AHB M2) has access to the system memory but
  none of the APB peripherals.

Throwing in #ifdef's to sort this out resolves the problem on the PB/926.

Looking at the driver code too, I'm having a hard time understanding it,
probably because of the use of "master" and "slave" - I don't think this
has anything to do with which AHB master is used.  The comments against
pl08x_choose_master_bus() seem to imply that it controls which AHB master
is used, but it has no apparant effect on that.  I don't think this
function does anything like that anymore.
