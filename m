Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754668Ab1EEPIW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 11:08:22 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:45495 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754130Ab1EEPIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 11:08:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=xQ/s2qA/IzWeUvvqNWT2wmGULyU8r43y51C0PX8LG24HZC9n0WdSXv0VNva5dpLcjT
         aac/qZmr+zOpC7WIySa+8Kb9ezhe2QOzIjeruLnU1eVc7mZGZR3W6WMQtV3AJe6FG1+E
         vy8g+Yy980T87LZTQO+uKuf2E0JjdhOaavDNo=
Subject: Re: [RFC] time: xtime_lock is held too long
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: john stultz <johnstul@us.ibm.com>, Andi Kleen <andi@firstfloor.org>,
        lkml <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Anton Blanchard <anton@samba.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <alpine.LFD.2.02.1105051630390.3005@ionos>
References: <1304478708-1273-1-git-send-email-john.stultz@linaro.org>
	 <m2oc3jxgtt.fsf@firstfloor.org>  <1304564090.2943.36.camel@work-vm>
	 <1304574244.32152.666.camel@edumazet-laptop>
	 <1304576495.2943.40.camel@work-vm>
	 <1304604284.3032.78.camel@edumazet-laptop>
	 <alpine.LFD.2.02.1105051630390.3005@ionos>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 05 May 2011 17:08:15 +0200
Message-ID: <1304608095.3032.95.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 05 mai 2011 à 16:39 +0200, Thomas Gleixner a écrit :
> On Thu, 5 May 2011, Eric Dumazet wrote:
> 
> > I feel xtime_lock seqlock is abused these days.
> > 
> > seqlock abstraction is somewhat lazy/dangerous because write_sequnlock()
> > does both the seqcount increment and spinlock release.
> > 
> > I am concerned by fact that readers might wait for long times, because
> > writers hold the whole seqlock, while sometime they only want to guard
> > other writers to come in.
> > 
> > Maybe it's time to separate the things (the seqcount and the spinlock)
> > so that writer can manipulate data in different sections : 
> > - Sections while holding spinlock, allowing "readers" to run
> > - Very small sections enclosed in a pair of seqcount increments, to
> > synchronize with readers.
> 
> Well, in the case of timekeeping that might be problematic. I'm not
> sure whether we can calculate the new values under the spinlock and
> then update the timekeeper under the seqlock because we might adjust
> the mult/shift pair which then can result in observabcle time going
> backwards problems. It might be worth a try, though. John ???
>  
> The only thing which really can move right away outside the xtime
> seqlock region is calc_global_load().
> 

That would be a start, but we also could have finer granularity in
locks :

update_vsyscall() has its own protection and could be done outside of
the seqcount inc pair used for ktime_get().

[ but my patch numbers were for a 32bit kernel, so vsyscall is not
accounted for. ]

Another idea would be to prime cache lines to be dirtied in cpu cache
before taking locks, and better pack variables to reduce number of cache
lines.



