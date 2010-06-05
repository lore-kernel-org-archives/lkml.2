Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933192Ab0FELV7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jun 2010 07:21:59 -0400
Received: from smtp-out21.han.skanova.net ([195.67.226.208]:55266 "EHLO
	smtp-out21.han.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752779Ab0FELV5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jun 2010 07:21:57 -0400
Message-ID: <4C0A3343.4030902@euromail.se>
Date: Sat, 05 Jun 2010 13:21:39 +0200
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>,
       Mika Kuoppala <mika.kuoppala@nokia.com>,
       Benjamin Tissoires <tissoire@cena.fr>, Rafi Rubin <rafi@seas.upenn.edu>
Subject: Re: [PATCH 1/4] input: Introduce buflock, a one-to-many circular
 buffer mechanism
References: <1275552062-8153-1-git-send-email-rydberg@euromail.se>	<1275552062-8153-2-git-send-email-rydberg@euromail.se> <20100604183550.919cde7d.akpm@linux-foundation.org>
In-Reply-To: <20100604183550.919cde7d.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Thu,  3 Jun 2010 10:00:59 +0200 "Henrik Rydberg" <rydberg@euromail.se> wrote:
> 
>> In spite of the many lock patterns and fifo helpers in the kernel, the
>> case of a single writer feeding many readers via a circular buffer
>> seems to be uncovered. This patch adds the buflock, a minimalistic
>> interface implementing SMP-safe locking for such a buffer. Under
>> normal operation, given adequate buffer size, the operation is
>> lock-less. The template is given the name buflock to emphasize that
>> the locking depends on the buffer read/write clashes.
>>
> 
> Seems that reviewers have already covered most of the oddities.
> 
>> +/*
>> + * Write to buffer without locking
>> + *
>> + * bw - the buflock_writer keeping track of the write position
>> + * buf - the buffer to write to (array of item type)
>> + * size - the size of the circular buffer (must be a power of two)
>> + * item - the item to write
>> + *
>> + * There is no locking involved during write, so this method is
>> + * suitable to use in interrupt context.
>> + */
> 
> And if the buffer fills up, it silently overwrites old data?
> 
> There are many options in this sort of thing.  Certain choices have
> been made here and they should be spelled out exhaustively please.
> 
>> +#define buflock_write(bw, buf, size, item)				\
>> +	do {								\
>> +		bw.next_head = (bw.head + 1) & ((size) - 1);		\
>> +		smp_wmb();						\
>> +		buf[bw.head] = item;					\
>> +		smp_wmb();						\
>> +		bw.head = bw.next_head;					\
>> +		smp_wmb();						\
>> +	} while (0)
> 
> I don't think there's a reason why these all had to be implemented as
> bloaty, un-typesafe macros?  Especially as buggy ones which reference
> their arguments multiple times!
> 
> Code it in C if possible, please.

Thanks Andrew, Dmitry, Oleg and Jonathan for your reviews. Next round of the
buflock stuff will be targeting the wider audience in include/linux/.

Henrik

