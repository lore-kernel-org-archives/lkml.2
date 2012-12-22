Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751460Ab2LVO2w (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2012 09:28:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24094 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751238Ab2LVO2u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2012 09:28:50 -0500
Message-ID: <50D5C474.9020906@redhat.com>
Date: Sat, 22 Dec 2012 09:32:20 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Michel Lespinasse <walken@google.com>
CC: linux-kernel@vger.kernel.org, aquini@redhat.com, lwoodman@redhat.com,
        jeremy@goop.org, Jan Beulich <JBeulich@novell.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC PATCH 3/3] x86,smp: auto tune spinlock backoff delay factor
References: <20121221184940.103c31ad@annuminas.surriel.com> <20121221185147.4ae48ab5@annuminas.surriel.com> <CANN689ETQgT48WkW4upUuv-5xj=g1wgkCuhW0AQ0H7pWfG1BPQ@mail.gmail.com>
In-Reply-To: <CANN689ETQgT48WkW4upUuv-5xj=g1wgkCuhW0AQ0H7pWfG1BPQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/22/2012 12:42 AM, Michel Lespinasse wrote:

> However, I have a few concerns about the behavior of this, which I
> think deserve more experimentation (I may try helping with it after
> new years).

More experimentation is always good. Different hardware
will probably behave differently, etc...

> One thing you mentioned in 0/3 is that the best value varies depending
> on the number of CPUs contending. This is somewhat surprising to me; I
> would have guessed/hoped that the (inc.tail - inc.head) multiplicative
> factor would account for that already.

I had hoped the same, but testing things out while
developing the code showed it not to be so.

A larger constant scales to a larger number of CPUs,
while a smaller constant works faster when there are
few CPUs contending on the lock.

The graph attached to patch 0/3 shows this effect.

> What I'm getting at is that I would be more confident that the
> autotune algorithm will work well in all cases if the value only
> depended on the system parameters such as CPU type and frequency,
> rather than per-spinlock parameters such as number of waiters and hold
> time.

The autotune algorithm adjusts the delay factor so
we access the spinlock, on average, 2.7 times before
we acquire it (the 3.7th time).

This provides scalability by keeping the number of
shared cache line touches constant for each lock
acquisition.

Going for a fixed value, either at compile time or
at boot time, cannot provide such a guarantee.

> I feel this review is too high-level to be really helpful, so I'll
> stop until I can find time to experiment :)

I am looking forward to test results.

If anyone manages to break the code, I will fix it...

