Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753422Ab0FEBhI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 21:37:08 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59684 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752406Ab0FEBhF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 21:37:05 -0400
Date: Fri, 4 Jun 2010 18:35:50 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Henrik Rydberg" <rydberg@euromail.se>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>,
       Mika Kuoppala <mika.kuoppala@nokia.com>,
       Benjamin Tissoires <tissoire@cena.fr>, Rafi Rubin <rafi@seas.upenn.edu>
Subject: Re: [PATCH 1/4] input: Introduce buflock, a one-to-many circular
 buffer mechanism
Message-Id: <20100604183550.919cde7d.akpm@linux-foundation.org>
In-Reply-To: <1275552062-8153-2-git-send-email-rydberg@euromail.se>
References: <1275552062-8153-1-git-send-email-rydberg@euromail.se>
	<1275552062-8153-2-git-send-email-rydberg@euromail.se>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  3 Jun 2010 10:00:59 +0200 "Henrik Rydberg" <rydberg@euromail.se> wrote:

> In spite of the many lock patterns and fifo helpers in the kernel, the
> case of a single writer feeding many readers via a circular buffer
> seems to be uncovered. This patch adds the buflock, a minimalistic
> interface implementing SMP-safe locking for such a buffer. Under
> normal operation, given adequate buffer size, the operation is
> lock-less. The template is given the name buflock to emphasize that
> the locking depends on the buffer read/write clashes.
> 

Seems that reviewers have already covered most of the oddities.

> +/*
> + * Write to buffer without locking
> + *
> + * bw - the buflock_writer keeping track of the write position
> + * buf - the buffer to write to (array of item type)
> + * size - the size of the circular buffer (must be a power of two)
> + * item - the item to write
> + *
> + * There is no locking involved during write, so this method is
> + * suitable to use in interrupt context.
> + */

And if the buffer fills up, it silently overwrites old data?

There are many options in this sort of thing.  Certain choices have
been made here and they should be spelled out exhaustively please.

> +#define buflock_write(bw, buf, size, item)				\
> +	do {								\
> +		bw.next_head = (bw.head + 1) & ((size) - 1);		\
> +		smp_wmb();						\
> +		buf[bw.head] = item;					\
> +		smp_wmb();						\
> +		bw.head = bw.next_head;					\
> +		smp_wmb();						\
> +	} while (0)

I don't think there's a reason why these all had to be implemented as
bloaty, un-typesafe macros?  Especially as buggy ones which reference
their arguments multiple times!

Code it in C if possible, please.
