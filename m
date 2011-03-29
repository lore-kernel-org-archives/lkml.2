Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753878Ab1C2GEc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 02:04:32 -0400
Received: from gate.crashing.org ([63.228.1.57]:45918 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753752Ab1C2GEa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 02:04:30 -0400
Subject: Re: [PATCH] POWER: perf_event: Skip updating kernel counters if
 register value shrinks
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Eric B Munson <emunson@mgebm.net>
Cc: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@elte.hu,
        acme@ghostprotocols.net, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, anton@samba.org
In-Reply-To: <1301059689-4556-1-git-send-email-emunson@mgebm.net>
References: <1301059689-4556-1-git-send-email-emunson@mgebm.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 29 Mar 2011 17:03:57 +1100
Message-ID: <1301378637.2402.671.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-03-25 at 09:28 -0400, Eric B Munson wrote:
> It is possible on POWER7 for some perf events to have values decrease.  This
> causes a problem with the way the kernel counters are updated.  Deltas are
> computed and then stored in a 64 bit value while the registers are 32 bits
> wide so if new value is smaller than previous value, the delta is a very
> large positive value.  As a work around this patch skips updating the kernel
> counter in when the new value is smaller than the previous.  This can lead to
> a lack of precision in the coutner values, but from my testing the value is
> typcially fewer than 10 samples at a time.

Unfortunately the patch isn't 100% correct I believe:

I think you don't deal with the rollover of the counters. The new value
could be smaller than the previous one simply because the counter just
rolled over.

In cases like this:

> @@ -449,8 +458,10 @@ static void freeze_limited_counters(struct cpu_hw_events *cpuhw,
>  		val = (event->hw.idx == 5) ? pmc5 : pmc6;
>  		prev = local64_read(&event->hw.prev_count);
>  		event->hw.idx = 0;
> -		delta = (val - prev) & 0xfffffffful;
> -		local64_add(delta, &event->count);
> +		if (val >= prev) {
> +			delta = (val - prev) & 0xfffffffful;
> +			local64_add(delta, &event->count);
> +		}
>  	}
>  }

I wonder if it isn't easier to just define delta to be a s32, get rid
of the mask and test if delta is positive, something like:

		delta =  val - prev;
		if (delta > 0)
			local64_add(delta, &event->count);

Wouldn't that be simpler ? Or do I miss a reason why it wouldn't work ?

Cheers,
Ben.


