Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932823Ab1INNvZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 09:51:25 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:46073 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752481Ab1INNvX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 09:51:23 -0400
Subject: Re: [RFC][PATCH 0/3] delayed wakeup list
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Darren Hart <dvhart@linux.intel.com>,
        Manfred Spraul <manfred@colorfullife.com>,
        David Miller <davem@davemloft.net>, Mike Galbraith <efault@gmx.de>
In-Reply-To: <20110914133034.687048806@chello.nl>
References: <20110914133034.687048806@chello.nl>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 14 Sep 2011 15:51:23 +0200
Message-ID: <1316008283.2361.28.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 14 septembre 2011 à 15:30 +0200, Peter Zijlstra a écrit :
> This patch-set provides the infrastructure to delay/batch task wakeups.
> 
> This is useful for locking primitives that can effect multiple wakeups
> per operation and want to avoid lock internal lock contention by
> delaying the wakeups until we've released the lock internal locks.
> 
> Patch 2 converts futexes
> Patch 3 converts sysv sems, and is broken
> 
> [ I've been staring at patch 3 way too long, so I thought I'd post it just
>   to get a few more eyes on it.. ]
> 
> Alternatively it can be used to avoid issuing multiple wakeups, and
> thus save a few cycles, in packet processing. Queue all target tasks
> and wakeup once you've processed all packets. That way you avoid
> waking the target task multiple times if there were multiple packets
> for the same task.
> 
> No actual such usage yet, but ISTR talking to some net folks a long while back
> about this, is there still interest, Dave, Eric?
> 

Yes, I remember playing with such idea some years ago, to speedup
multicast processing.

Say you have 10 receivers on a multicast group, each incoming message
actually wakeups 10 threads.

If we receive a burst of 10 messages, we spend a lot of time in
scheduler.

So adding one queue to batch all scheduler works (and factorize some
work if the same thread is queued), and perform the scheduler calls at
the end of software IRQ for example was a win.



