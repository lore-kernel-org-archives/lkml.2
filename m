Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932950Ab0JSAFd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 20:05:33 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:50614 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755244Ab0JSAFc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 20:05:32 -0400
Message-ID: <4CBCE05E.20408@renesas.com>
Date: Tue, 19 Oct 2010 09:03:42 +0900
From: Shinya Kuribayashi <shinya.kuribayashi.px@renesas.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.12) Gecko/20100914 Lightning/1.0b1 Thunderbird/3.0.8
MIME-Version: 1.0
To: Kevin Cernekee <cernekee@gmail.com>
CC: Shinya Kuribayashi <skuribay@pobox.com>,
        Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH resend 5/9] MIPS: sync after cacheflush
References: <17ebecce124618ddf83ec6fe8e526f93@localhost>        <17d8d27a2356640a4359f1a7dcbb3b42@localhost>        <4CBC4F4E.5010305@pobox.com> <AANLkTinpry=XG-ZDgXJK-VB6QkBL2TO4-vrsV5Tc1eEs@mail.gmail.com>
In-Reply-To: <AANLkTinpry=XG-ZDgXJK-VB6QkBL2TO4-vrsV5Tc1eEs@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/19/2010 3:34 AM, Kevin Cernekee wrote:
> On Mon, Oct 18, 2010 at 6:44 AM, Shinya Kuribayashi <skuribay@pobox.com> wrote:
>> I suspect that SYNC insn alone is still not enough, insn't it?  In
>> such systems with that 'deep' write buffer and data incoherency is
>> visibly observed, there sill may be data write transactions floating
>> in the internal bus system.
>>
>> To make sure that all data (data inside processor's write buffer and
>> data floating in the internal bus system), we need the following
>> three steps:
>>
>> 1. Flush data cache
>> 2. Uncached, dummy load operation from _DRAM_ (not somewhere else)
>> 3. then SYNC instruction
> 
> Some systems do require additional steps along those lines, e.g.
> 
> # ifdef CONFIG_SGI_IP28
> #  define fast_iob()				\
> 	__asm__ __volatile__(			\
> 		".set	push\n\t"		\
> 		".set	noreorder\n\t"		\
> 		"lw	$0,%0\n\t"		\
> 		"sync\n\t"			\
> 		"lw	$0,%0\n\t"		\
> 		".set	pop"			\
> 		: /* no output */		\
> 		: "m" (*(int *)CKSEG1ADDR(0x1fa00004)) \
> 		: "memory")
> 
> Maybe it would be better to use iob() instead of __sync() directly, so
> that it is easy to add extra steps for the CPUs that need them.  DEC
> and Loongson have custom __wbflush() implementations, and something
> similar could be added for your processor to implement the uncached
> dummy load.

I was jumping to conclusions the issue you're facing with is related to
DMA operation.  If so, yes, we need to sync with I/O systems (namely
with DRAM in this case) at some point, prior to initiating DMA.

But getting back to your original scenario, it seems not; at least, I
failed to see a connection with DMA operations.  I wonder why and how
steps through 1-to-7 will be problem.

> Actual problem seen in the wild:
> 
> 1) dma_alloc_coherent() allocates cached memory
> 
> 2) memset() is called to clear the new pages
> 
> 3) dma_cache_wback_inv() is called to flush the zero data out to memory

At this point, write-backed data will go into a queue of 'deep' write
buffer, and will be pushed out to the internal bus system (queued).

> 4) dma_alloc_coherent() returns an uncached (kseg1) pointer to the
> freshly allocated pages
> 
> 5) Caller writes data through the kseg1 pointer

This 'write through KSEG1 segment' operation also goes into a queue of
'deep' write buffer, doesn't it?

> 6) Buffered writeback data finally gets flushed out to DRAM
> 
> 7) Part of caller's data is inexplicably zeroed out
> 
> This patch adds SYNC between steps 3 and 4, which fixed the problem.

IIUC, the problem is that write operation originating from step 5. seems
to overtake the one originating from step 3., correct?

Then we'd like to know, what is that 'Caller mentioned at step 5.', and
what kind of operation will be done by the Caller?
-- 
Shinya Kuribayashi
Renesas Electronics
