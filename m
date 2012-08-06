Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755732Ab2HFN0z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 09:26:55 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:55320 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753844Ab2HFN0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 09:26:54 -0400
Date: Mon, 6 Aug 2012 14:26:42 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Cyril Chemparathy <cyril@ti.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, catalin.marinas@arm.com, nico@linaro.org,
        will.deacon@arm.com
Subject: Re: [PATCH 01/22] ARM: add mechanism for late code patching
Message-ID: <20120806132642.GC18957@n2100.arm.linux.org.uk>
References: <1343775898-28345-1-git-send-email-cyril@ti.com> <1343775898-28345-2-git-send-email-cyril@ti.com> <20120806111224.GA18957@n2100.arm.linux.org.uk> <501FC44E.1040806@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <501FC44E.1040806@ti.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 06, 2012 at 09:19:10AM -0400, Cyril Chemparathy wrote:
> With a flush_cache_all(), we could avoid having to operate a cacheline  
> at a time, but that clobbers way more than necessary.

You can't do that, because flush_cache_all() on some CPUs requires the
proper MMU mappings to be in place, and you can't get those mappings
in place because you don't have the V:P offsets fixed up in the kernel.
Welcome to the chicken and egg problem.

> Sure, flushing caches is expensive.  But then, so is running the  
> patching code with caches disabled.  I guess memory access latencies  
> drive the performance trade off here.

There we disagree on a few orders of magnitude.  There are relatively
few places that need updating.  According to the kernel I have here:

   text    data     bss     dec     hex filename
7644346  454320  212984 8311650  7ed362 vmlinux

Idx Name          Size      VMA       LMA       File off  Algn
  1 .text         004cd170  c00081c0  c00081c0  000081c0  2**5
 16 .init.pv_table 00000300  c0753a24  c0753a24  00753a24  2**0

That's about 7MB of text, and only 192 points in that code which need
patching.  Even if we did this with caches on, that's still 192 places,
and only 192 places we'd need to flush a cache line.

Alternatively, with your approach and 7MB of text, you need to flush
238885 cache lines to cover the entire kernel.

It would be far _cheaper_ with your approach to flush the individual
cache lines as you go.
