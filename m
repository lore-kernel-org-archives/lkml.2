Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754537Ab1A0BWu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 20:22:50 -0500
Received: from smtp-out.google.com ([74.125.121.67]:55802 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754512Ab1A0BWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 20:22:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=YA1BDSBodHBw7BjPf0ponUYVPBGVZiKozCVB9S485HOmj93wfydTWz9MQBhmKu4IHz
         9fedOR3HaBV292kFQ4JA==
Date: Wed, 26 Jan 2011 17:22:37 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch] kconfig: unify GENERIC_ISA_DMA and ISA_DMA_API
In-Reply-To: <20110126201000.GB7323@n2100.arm.linux.org.uk>
Message-ID: <alpine.DEB.2.00.1101261640460.23194@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1101251706040.9641@chino.kir.corp.google.com> <20110126112908.GD2562@n2100.arm.linux.org.uk> <alpine.DEB.2.00.1101261158490.13163@chino.kir.corp.google.com> <20110126201000.GB7323@n2100.arm.linux.org.uk>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Jan 2011, Russell King - ARM Linux wrote:

> Drivers should depend on ISA_DMA_API as that indicates that the ISA DMA
> API is present - in other words, when the following are available from
> an architecture/platform:
> 
> dma_spin_lock
> claim_dma_lock
> release_dma_lock
> enable_dma
> disable_dma
> clear_dma_ff
> set_dma_mode
> set_dma_page
> set_dma_addr
> set_dma_count
> get_dma_residue
> request_dma
> free_dma
> 
> GENERIC_ISA_DMA should be set by an architecture/platform when ISA_DMA_API
> has already been set -and- it wants to use kernel/dma.c.  No drivers should
> depend on GENERIC_ISA_DMA.

Very good information, thanks!  x86 wants to use kernel/dma.c since it has 
no ISA-style DMA allocator of its own, which should have tipped me off 
since they're both "def_bool y" right now (and the tons of linker failures 
when only CONFIG_GENERIC_ISA_DMA is disabled).  So what I'll do is make 
CONFIG_ISA_DMA_API select CONFIG_GENERIC_ISA_DMA for x86 -- that prevents 
all build errors for allyesconfig.  (Alpha could probably benefit from the 
same requirement.)

My end goal is to make CONFIG_GENERIC_ISA_DMA, CONFIG_ISA_DMA_API, and 
CONFIG_ZONE_DMA configurable for x86 (we've been running with that config 
for a couple years and it's a 1% savings on the kernel image).  Peter 
wanted that to be done under CONFIG_EMBEDDED after it was renamed to 
CONFIG_EXPERT so now that that's been done in 2.6.38-rc2, it should be 
well received.

Thanks Russell!
