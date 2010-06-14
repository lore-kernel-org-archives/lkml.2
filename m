Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754673Ab0FNPEf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 11:04:35 -0400
Received: from mail2.shareable.org ([80.68.89.115]:43665 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754277Ab0FNPEe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 11:04:34 -0400
Date: Mon, 14 Jun 2010 16:04:25 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Philby John <pjohn@mvista.com>
Cc: linux-mtd@lists.infradead.org, linux-mips@linux-mips.org,
       David Daney <ddaney@caviumnetworks.com>, linux-kernel@vger.kernel.org,
       Artem Bityutskiy <dedekind1@gmail.com>
Subject: Re: [PATCH] mtd: Fix bug using smp_processor_id() in preemptible ubi_bgt1d kthread
Message-ID: <20100614150425.GC9550@shareable.org>
References: <1276513457.16642.3.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1276513457.16642.3.camel@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Philby John wrote:
> mtd: Fix bug using smp_processor_id() in preemptible ubi_bgt1d kthread
> 
> On a MIPS Cavium Octeon CN5020 when trying to create a UBI volume,
> on the NOR flash, the kernel thread ubi_bgt1d calls
> cfi_amdstd_write_buffers() --> do_write_buffer() -->
> INVALIDATE_CACHE_UDELAY --> __udelay(). Its __udelay() that calls
> smp_processor_id() in preemptible code, which you are not supposed to.
> Fix the problem by disabling preemption.

The MTD code just calls udelay().
Are you sure it isn't permitted to call udelay() from preemptible code?
I think it is fine.

Perhaps MIPS udelay() should be disabling preemption itself, or
(as x86 does) using raw_smp_processor_id() instead?  Or perhaps the x86
version is a bug because the current CPU might change during the delay loop?

See git commit 5c1ea08215f1f830dfaf4819a5f22efca41c3832
"x86: enable preemption in delay"

I don't think it makes sense to disable preemption in all udelay()
calls in drivers, so my NAK to this MTD patch.  To workaround,
consider putting the preempt_disable in MIPS udelay(), or using
raw_smp_processor_id() in it, after reading the above git commit's
message.  A proper fix would accept a context switch during the delay
and rescale the remaining count, but even on x86 they haven't done
that yet :-)

Regards,
-- Jamie
