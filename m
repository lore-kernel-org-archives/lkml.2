Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753553Ab1JCIoy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 04:44:54 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:33368 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752794Ab1JCIos (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 04:44:48 -0400
Date: Mon, 3 Oct 2011 09:44:07 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Jon Masters <jonathan@jonmasters.org>
Cc: Mark Salter <msalter@redhat.com>,
        "ming.lei@canonical.com" <ming.lei@canonical.com>,
        "stern@rowland.harvard.edu" <stern@rowland.harvard.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 2/3] define ARM-specific dma_coherent_write_sync
Message-ID: <20111003084407.GC18195@e102109-lin.cambridge.arm.com>
References: <1314826214-22428-1-git-send-email-msalter@redhat.com>
 <1314826214-22428-3-git-send-email-msalter@redhat.com>
 <CAHkRjk7ZMDQh8sYf7N_4LLS12JU2ps8dkC34gNWNH+-Zp0p8Rg@mail.gmail.com>
 <1315319837.2313.1.camel@deneb.redhat.com>
 <CAHkRjk6TD4Qg-b3nkCE_wwj-tWr-_5evndxo3f+_6gtXEV6gNg@mail.gmail.com>
 <1315321331.2313.10.camel@deneb.redhat.com>
 <026571E7-67F6-4B0F-998C-2A845AA22E59@jonmasters.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <026571E7-67F6-4B0F-998C-2A845AA22E59@jonmasters.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 03, 2011 at 02:40:19AM +0100, Jon Masters wrote:
> On Sep 6, 2011, at 11:02 AM, Mark Salter wrote:
> > In any case, the current thinking is that the original problem with
> > the USB performance seen on cortex A9 multicore is probably something
> > more than just write buffer delays. Once the original problem is better
> > understood, we can take another look at this patch if it is still
> > needed.
> 
> Thanks again for looking into this Mark. My understanding is that this
> is still being investigated. I'll followup with ARM to see how that's
> going since I've heard nothing recently :) Meanwhile, we're continuing
> to carry a hack based on these patches in Fedora ARM kernels.

Not talking about hardware specifics here, the architecture (though
ARMv7 onwards) mandates that the write buffer is eventually drained. But
doesn't state any upper limit, so it could even be half a second.

In this case, some form of buffer draining for devices that poll the
memory may be useful. If we don't want to add a new API, something like
below would work as well:

	write to DMA buffer;
	mb();
	read from DMA buffer;

So an mb() between the last write and a subsequent read would force the
visibility of the write. We have similar scenarios for Device accesses.

If we go for a DMA API extension, the dma_coherent_write_sync() should
probably take an address as well, just in case implementations would
force the draining via some read back from the same area.

-- 
Catalin
