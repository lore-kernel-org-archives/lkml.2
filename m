Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754881Ab0C3R4s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 13:56:48 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:52032 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753612Ab0C3R4q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 13:56:46 -0400
Subject: Re: [PATCH] increase PREEMPT_BITS to 12 to avoid overflow when
 starting KVM
From: Peter Zijlstra <peterz@infradead.org>
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org, avi@redhat.com, aarcange@redhat.com,
       akpm@linux-foundation.org, Kent Overstreet <kent.overstreet@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, tglx <tglx@linutronix.de>
In-Reply-To: <20100330133634.2f1bf3d6@cuia.bos.redhat.com>
References: <20100330133634.2f1bf3d6@cuia.bos.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 30 Mar 2010 19:56:42 +0200
Message-ID: <1269971802.5258.524.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-03-30 at 13:36 -0400, Rik van Riel wrote:
> Increase the PREEMPT_BITS to 12, to deal with a larger number
> of locks that can be taken in mm_take_all_locks or other places
> where many instances of the same type of lock can be taken.
> 
> The overflow of PREEMPT_BITS should be harmless, since it simply
> increments the counter into the SOFTIRQ_BITS, and the counter
> will be decremented again later.
> 
> However, the overflow does lead to backtraces with CONFIG_PREEMPT_DEBUG
> enabled.
> 
> Signed-off-by: Rik van Riel <riel@redhat.com>
> Reported-by: Kent Overstreet <kent.overstreet@gmail.com>
> 
> ---
> Kent, does this patch fix the issue you saw?
> 
> Peter, I know you do not like this approach. However, I could not
> think of a way around mm_take_all_locks. We need to take those locks
> and want to track that fact for lock debugging...

Does this even boot? It tramples all over PREEMPT_ACTIVE for x86.

Also, you'll need to convince mingo and tglx too.. taking that many
spinlocks is utter suckage..

> diff --git a/include/linux/hardirq.h b/include/linux/hardirq.h
> index d5b3876..e74108f 100644
> --- a/include/linux/hardirq.h
> +++ b/include/linux/hardirq.h
> @@ -14,8 +14,8 @@
>   * We put the hardirq and softirq counter into the preemption
>   * counter. The bitmask has the following meaning:
>   *
> - * - bits 0-7 are the preemption count (max preemption depth: 256)
> - * - bits 8-15 are the softirq count (max # of softirqs: 256)
> + * - bits 0-12 are the preemption count (max preemption depth: 4096)
> + * - bits 13-19 are the softirq count (max # of softirqs: 256)
>   *
>   * The hardirq count can in theory reach the same as NR_IRQS.
>   * In reality, the number of nested IRQS is limited to the stack
> @@ -24,16 +24,16 @@
>   * hardirq nesting. An arch may choose to give less than 10 bits.
>   * m68k expects it to be 8.
>   *
> - * - bits 16-25 are the hardirq count (max # of nested hardirqs: 1024)
> - * - bit 26 is the NMI_MASK
> - * - bit 28 is the PREEMPT_ACTIVE flag
> + * - bits 26-29 are the hardirq count (max # of nested hardirqs: 1024)
> + * - bit 30 is the NMI_MASK
> + * - bit 31 is the PREEMPT_ACTIVE flag
>   *
> - * PREEMPT_MASK: 0x000000ff
> - * SOFTIRQ_MASK: 0x0000ff00
> - * HARDIRQ_MASK: 0x03ff0000
> - *     NMI_MASK: 0x04000000
> + * PREEMPT_MASK: 0x00000fff
> + * SOFTIRQ_MASK: 0x000ff000
> + * HARDIRQ_MASK: 0x3ff00000
> + *     NMI_MASK: 0x40000000
>   */
> -#define PREEMPT_BITS	8
> +#define PREEMPT_BITS	12
>  #define SOFTIRQ_BITS	8
>  #define NMI_BITS	1
>  
> 



