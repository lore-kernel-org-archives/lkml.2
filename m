Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751167Ab1EEOjI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 10:39:08 -0400
Received: from www.linutronix.de ([62.245.132.108]:38071 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082Ab1EEOjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 10:39:06 -0400
Date: Thu, 5 May 2011 16:39:02 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Eric Dumazet <eric.dumazet@gmail.com>
cc: john stultz <johnstul@us.ibm.com>, Andi Kleen <andi@firstfloor.org>,
        lkml <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Anton Blanchard <anton@samba.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC] time: xtime_lock is held too long
In-Reply-To: <1304604284.3032.78.camel@edumazet-laptop>
Message-ID: <alpine.LFD.2.02.1105051630390.3005@ionos>
References: <1304478708-1273-1-git-send-email-john.stultz@linaro.org>  <m2oc3jxgtt.fsf@firstfloor.org>  <1304564090.2943.36.camel@work-vm>  <1304574244.32152.666.camel@edumazet-laptop>  <1304576495.2943.40.camel@work-vm>
 <1304604284.3032.78.camel@edumazet-laptop>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 May 2011, Eric Dumazet wrote:

> I feel xtime_lock seqlock is abused these days.
> 
> seqlock abstraction is somewhat lazy/dangerous because write_sequnlock()
> does both the seqcount increment and spinlock release.
> 
> I am concerned by fact that readers might wait for long times, because
> writers hold the whole seqlock, while sometime they only want to guard
> other writers to come in.
> 
> Maybe it's time to separate the things (the seqcount and the spinlock)
> so that writer can manipulate data in different sections : 
> - Sections while holding spinlock, allowing "readers" to run
> - Very small sections enclosed in a pair of seqcount increments, to
> synchronize with readers.

Well, in the case of timekeeping that might be problematic. I'm not
sure whether we can calculate the new values under the spinlock and
then update the timekeeper under the seqlock because we might adjust
the mult/shift pair which then can result in observabcle time going
backwards problems. It might be worth a try, though. John ???
 
The only thing which really can move right away outside the xtime
seqlock region is calc_global_load().

Thanks,

	tglx

