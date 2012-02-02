Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756527Ab2BBUoa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 15:44:30 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:41900 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756436Ab2BBUo2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 15:44:28 -0500
Date: Thu, 2 Feb 2012 20:44:11 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH] ARM: cache-v7: Disable preemption when reading CCSIDR
Message-ID: <20120202204411.GB14129@n2100.arm.linux.org.uk>
References: <1328210686-15909-1-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328210686-15909-1-git-send-email-sboyd@codeaurora.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 02, 2012 at 11:24:46AM -0800, Stephen Boyd wrote:
> armv7's flush_cache_all() flushes caches via set/way. To
> determine the cache attributes (line size, number of sets,
> etc.) the assembly first writes the CSSELR register to select a
> cache level and then reads the CCSIDR register. The CSSELR register
> is banked per-cpu and is used to determine which cache level CCSIDR
> reads. If the task is migrated between when the CSSELR is written and
> the CCSIDR is read the CCSIDR value may be for an unexpected cache
> level (for example L1 instead of L2) and incorrect cache flushing
> could occur.
> 
> Disable preemption across the write and read so that the correct
> cache attributes are read and used for the cache flushing
> routine. This fixes a problem we see in scm_call() when
> flush_cache_all() is called from preemptible context and
> sometimes the L2 cache is not properly flushed out.

This isn't going to work for two reasons:

(1) (and the VFP code suffers from this) after we re-enable preemption,
    we really should check for a pending preemption event in every case.

(2) v7_flush_dcache_all() is called from __v7_setup() using a very small
    private stack.  This doesn't have a thread info structure at the
    bottom.

So, if we need to disable preemption here, we need to find a different
solution to it.

> Should we move get_thread_info into assembler.h? It seems odd
> to include entry-header.S but I saw that vfp was doing the same.

Probably yes, and probably also have preempt_disable and preempt_enable
assembler macros.  That's going to get rather icky if we have to
explicitly call the scheduler though (to solve (1)).
