Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759996Ab0FKJmD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 05:42:03 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:45840 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754637Ab0FKJl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 05:41:59 -0400
Subject: Re: [PATCH v2] sata_sil24: Use memory barriers before issuing
 commands
From: Catalin Marinas <catalin.marinas@arm.com>
To: Nick Piggin <npiggin@suse.de>
Cc: Robert Hancock <hancockrwd@gmail.com>, Tejun Heo <tj@kernel.org>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Colin Tuckley <colin.tuckley@arm.com>, Jeff Garzik <jeff@garzik.org>,
       linux-arch <linux-arch@vger.kernel.org>
In-Reply-To: <20100611013829.GB16436@laptop>
References: <20100611013829.GB16436@laptop>
Content-Type: text/plain; charset="UTF-8"
Organization: ARM Limited
Date: Fri, 11 Jun 2010 10:41:46 +0100
Message-ID: <1276249306.12258.38.camel@e102109-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 11 Jun 2010 09:41:47.0228 (UTC) FILETIME=[4F4409C0:01CB094A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-06-11 at 02:38 +0100, Nick Piggin wrote:
> On Thu, Jun 10, 2010 at 06:43:03PM -0600, Robert Hancock wrote:
> > IMHO, it would be better for the platform code to ensure that MMIO
> > access was strongly ordered with respect to each other and to RAM
> > access. Drivers are just too likely to get this wrong, especially
> > when x86, the most tested platform, doesn't have such issues.
> 
> The plan is to make all platforms do this. writes should be
> strongly ordered with memory. That serves to keep them inside
> critical sections as well.

Are there any public references to this discussion? Maybe a
Documentation/ file (or update the memory-barriers.txt one would be
useful).

I guess correctness takes precedence here but on ARM, the only way to
ensure relative ordering between non-cacheable writes and I/O writes is
by flushing the write buffer (and an L2 write buffer if external cache
is present). Hence the expensive mb().

The only reference of DMA buffers vs I/O I found in the DMA-API.txt
file:

        Consistent memory is memory for which a write by either the
        device or the processor can immediately be read by the processor
        or device without having to worry about caching effects. (You
        may however need to make sure to flush the processor's write
        buffers before telling devices to read that memory.)

But there is no API for "flushing the processor's write buffers". Does
it mean that this should be taken care of in writel()? We would make the
I/O accessors pretty expensive on some architectures.

Thanks.

-- 
Catalin

