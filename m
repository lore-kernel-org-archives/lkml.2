Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753863Ab1EEURT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 16:17:19 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:41940 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753711Ab1EEURP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 16:17:15 -0400
Subject: Re: [PATCH] time: Add locking to xtime access in get_seconds()
From: john stultz <johnstul@us.ibm.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: lkml <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Anton Blanchard <anton@samba.org>,
        Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20110505175713.GG2925@one.firstfloor.org>
References: <1304478708-1273-1-git-send-email-john.stultz@linaro.org>
	 <m2oc3jxgtt.fsf@firstfloor.org> <1304564090.2943.36.camel@work-vm>
	 <20110505175713.GG2925@one.firstfloor.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 05 May 2011 13:17:01 -0700
Message-ID: <1304626621.20980.19.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-05-05 at 19:57 +0200, Andi Kleen wrote:
> > I suspect the reason this hasn't been triggered on x86 or power6 is due
> > to compiler or processor optimizations reordering the assignment to in
> > effect make it atomic. Or maybe the timing window to see the issue is
> > harder to observe?
> 
> On x86 all aligned stores are atomic. So I don't see how this 
> could be a problem ever.

No no. The issue was with the fact that in update_xtime_cache we modify
xtime_cache twice (once setting it possibly backwards to xtime, then
adding in the nsec offset).

Since get_seconds does no locking, this issue should be visible
anywhere, as long as you manage to hit the race window between the first
assignment and the second.

However, in the testing, the issue only showed up on P7, but not P6 or
x86.

My guess was that the code:

xtime_cache.sec = xtime.sec
xtime_cache.nsec = xtime.nsec
xtime_cache.sec = xtime_cache.sec 
		 + div(xtime_cache.nsec + nsec, NSEC_PER_SEC, &rem);
xtime_cache.nsec = rem

Was getting rearranged to:

xtime_cache.sec = xtime.sec 
		+ div(xtime.nsec + nsec, NSEC_PER_SEC, &rem);
xtime_cache.nsec = rem


Which makes the xtime_cache.sec update atomic.

But its just a guess.

thanks
-john


