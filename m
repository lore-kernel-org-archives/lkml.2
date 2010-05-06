Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758662Ab0EFOVa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 10:21:30 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:38126 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758610Ab0EFOV1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 10:21:27 -0400
Subject: Re: [RFC] perf_events: ctx_flexible_sched_in() not maximizing PMU 
 utilization
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, mingo@elte.hu,
       Paul Mackerras <paulus@samba.org>,
       =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       "David S. Miller" <davem@davemloft.net>
In-Reply-To: <AANLkTikQCkR2K438llKOh43yEgW-Bw7j0f8GoXR50A0V@mail.gmail.com>
References: <AANLkTikQCkR2K438llKOh43yEgW-Bw7j0f8GoXR50A0V@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 06 May 2010 16:20:40 +0200
Message-ID: <1273155640.5605.300.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-05-06 at 16:03 +0200, Stephane Eranian wrote:
> Hi,
> 
> Looking at ctx_flexible_sched_in(), the logic is that if  group_sched_in()
> fails for a HW group, then no other HW group in the list is even tried.
> I don't understand this restriction. Groups are independent of each other.
> The failure of one group should not block others from being scheduled,
> otherwise you under-utilize the PMU.
> 
> What is the reason for this restriction? Can we lift it somehow?

Sure, but it will make scheduling much more expensive. The current
scheme will only ever check the first N events because it stops at the
first that fails, and since you can max fix N events on the PMU its
constant time.

To fix this issue you'd have to basically always iterate all events and
only stop once the PMU is fully booked, which reduces to an O(n) worst
case algorithm.

But yeah, I did think of making the thing an RB-tree and basically
schedule on service received, that should fix the lop-sided RR we get
with constrained events.
