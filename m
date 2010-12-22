Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752528Ab0LVXym (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 18:54:42 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:58208 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752139Ab0LVXyl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 18:54:41 -0500
Date: Wed, 22 Dec 2010 23:54:03 +0000
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
Message-ID: <20101222235403.GE29368@n2100.arm.linux.org.uk>
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
> This is listed in the dmaengine documentation [1], but I obviously
> missed this before merging.  This also would have been caught by
> lockdep as required by SubmitChecklist.  As far as corrective action
> before 2.6.37-final.  It looks like this driver needs a full scrub
> which seems unreasonable to complete and test over the holidays before
> .37 lands.  Linus we either need to mark this "depends on BROKEN" or
> revert it.
> 
> Support for the DMA_COMPL flags are necessary if the DMA_MEMCPY
> capability is advertised, yes this driver got this wrong.  I'll update
> the documentation to make this requirement clear, and audit the other
> drivers.  With slave-only drivers the only usage model is one where
> the client driver owns dma-mapping.  In the non-slave (opportunistic
> memcpy offload) case the client is unaware of the engine so the driver
> owns unmapping.  The minimal fix is to disable memcpy offload.
> 
> --
> Dan
> 
> [1]
> 3.6 Constraints:
> 1/ Calls to async_<operation> are not permitted in IRQ context.  Other
>    contexts are permitted provided constraint #2 is not violated.
> 2/ Completion callback routines cannot submit new operations.  This
>    results in recursion in the synchronous case and spin_locks being
>    acquired twice in the asynchronous case.

(2) seems to be more than a little annoying - it seems that DMA engine
drivers use a tasklet for running their DMA cleanup, which calls drivers
callbacks, and we're going to have to have a whole pile of taskets
in drivers just to be triggered from the completion callback.  I can
see this adding an additional layer of complexity and a nice fine set
of shiney new races to deal with.
