Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753284Ab0FZKc6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jun 2010 06:32:58 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:45382 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752206Ab0FZKc4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jun 2010 06:32:56 -0400
Subject: Re: [RFC][PATCH] irq_work -v2
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Huang Ying <ying.huang@intel.com>, Ingo Molnar <mingo@elte.hu>,
       "H.PeterA" <"nvin hpa"@zytor.com>, linux-kernel@vger.kernel.org,
       tglx <tglx@linutronix.de>, davem <davem@davemloft.net>,
       paulus <paulus@samba.org>
In-Reply-To: <20100626100846.GA20233@basil.fritz.box>
References: <1277348698-17311-1-git-send-email-ying.huang@intel.com>
	 <1277361352.1875.838.camel@laptop> <1277490625.1875.986.camel@laptop>
	 <20100625193031.GD13421@basil.fritz.box> <1277494784.1875.989.camel@laptop>
	 <20100625222953.GE13421@basil.fritz.box> <1277541405.1875.993.camel@laptop>
	 <20100626100846.GA20233@basil.fritz.box>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sat, 26 Jun 2010 12:32:43 +0200
Message-ID: <1277548363.1875.1009.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-06-26 at 12:08 +0200, Andi Kleen wrote:
> You could as well drop the excessive event. In fact it surprises me that you 
> don't simply do that in perf. The state should be in the PMU registers 
> anyways, so you'll pick it up from there (and if you get NMIs as quickly that 
> you cannot process them you have to eventually throttle by dropping anyways)

I'm not quite seeing what you mean, the PMU state is reset on PMI, it
doesn't know about previous overflows, and it most certainly doesn't
know if for the previous event we had to wake the buffer consumers.

For non-uniform events (like basically everything but
cycles/instructions) you can get high bursts of PMIs, only when the rate
stays too high will we eventually throttle, but we can (and should) deal
with short periods of high rate PMIs.

The PMU is stopped during the PMI, we write out data to the buffer and
possible queue a callback to wake the consumers and or de-schedule the
event.

By setting the the pending op state and enqueueing the callback we
ensure the pending op isn't lost/ignored. If there was already one in
flight it will pick up our pending state, if not we just queued a new
one.

In fact Huang argued for something very similar, so I assumed he
actually needed this too.

