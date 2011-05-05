Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753542Ab1EEUZG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 16:25:06 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:39463 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753130Ab1EEUZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 16:25:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=ADgg7e7raY40RaePdoPh67YmboS0oD6ScN+fvp1dDGotX3vIjT767GxubjjokhVpXD
         gqaXvpqbTLsDC9yDtjt7mg6zy9pAI1X3zQ2FV2PNslHypnCg+SkMbSf6cClc3zDFy0vx
         CQ7RbSUPDv1+YOsy3Iv0oVXkXvR4nksQihho8=
Subject: Re: [PATCH] time: Add locking to xtime access in get_seconds()
From: Eric Dumazet <eric.dumazet@gmail.com>
To: john stultz <johnstul@us.ibm.com>
Cc: Andi Kleen <andi@firstfloor.org>, lkml <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Anton Blanchard <anton@samba.org>,
        Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1304626621.20980.19.camel@work-vm>
References: <1304478708-1273-1-git-send-email-john.stultz@linaro.org>
	 <m2oc3jxgtt.fsf@firstfloor.org> <1304564090.2943.36.camel@work-vm>
	 <20110505175713.GG2925@one.firstfloor.org>
	 <1304626621.20980.19.camel@work-vm>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 05 May 2011 22:24:58 +0200
Message-ID: <1304627098.3131.1.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 05 mai 2011 à 13:17 -0700, john stultz a écrit :
> On Thu, 2011-05-05 at 19:57 +0200, Andi Kleen wrote:
> > > I suspect the reason this hasn't been triggered on x86 or power6 is due
> > > to compiler or processor optimizations reordering the assignment to in
> > > effect make it atomic. Or maybe the timing window to see the issue is
> > > harder to observe?
> > 
> > On x86 all aligned stores are atomic. So I don't see how this 
> > could be a problem ever.
> 
> No no. The issue was with the fact that in update_xtime_cache we modify
> xtime_cache twice (once setting it possibly backwards to xtime, then
> adding in the nsec offset).
> 
> Since get_seconds does no locking, this issue should be visible
> anywhere, as long as you manage to hit the race window between the first
> assignment and the second.
> 
> However, in the testing, the issue only showed up on P7, but not P6 or
> x86.
> 
> My guess was that the code:
> 
> xtime_cache.sec = xtime.sec
> xtime_cache.nsec = xtime.nsec
> xtime_cache.sec = xtime_cache.sec 
> 		 + div(xtime_cache.nsec + nsec, NSEC_PER_SEC, &rem);
> xtime_cache.nsec = rem
> 
> Was getting rearranged to:
> 
> xtime_cache.sec = xtime.sec 
> 		+ div(xtime.nsec + nsec, NSEC_PER_SEC, &rem);
> xtime_cache.nsec = rem
> 
> 
> Which makes the xtime_cache.sec update atomic.
> 
> But its just a guess.

Sure (disassembly could help to check this), but get_seconds() reads
xtime.tv_sec  ;)



