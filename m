Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755545Ab1BXCbw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 21:31:52 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58746 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753160Ab1BXCbv convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 21:31:51 -0500
MIME-Version: 1.0
In-Reply-To: <20110223234956.388095876@linutronix.de>
References: <20110223231601.613115832@linutronix.de> <20110223234956.388095876@linutronix.de>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 23 Feb 2011 18:30:56 -0800
Message-ID: <AANLkTikoYrPjf4-6X7PLUShXXXrDU45t_T+ZkxyCtLnG@mail.gmail.com>
Subject: Re: [patch 1/5] genirq: Prepare the handling of shared oneshot interrupts
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 23, 2011 at 3:52 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
>
> +               /*
> +                * We or the mask lockless. Safe because the code
> +                * which clears the mask is serialized
> +                * vs. IRQ_INPROGRESS.
> +                */
> +               desc->threads_oneshot |= action->thread_mask;
> +               wake_up_process(action->thread);

That comment makes no sense.

What has "code which clears the mask" to do with anything?

Even if another CPU _sets_ a bit, doing so in parallel will lose bits
if it's not locked. One CPU will read the old value, set its bit, and
store the new value: with the race, only one of the bits will be set.

So maybe the code is safe, but the comment is still totally wrong. You
had better be safe not just against people clearing bits, you need to
be safe against ANY OTHER WRITER (clear or set), including very much
OTHER BITS in the same word.

So if it really is safe, comment on ALL the cases.

                     Linus
