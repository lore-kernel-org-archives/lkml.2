Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758287Ab2CBHxj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 02:53:39 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:48196 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756918Ab2CBHxi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 02:53:38 -0500
Message-ID: <1330674796.2361.36.camel@work-vm>
Subject: Re: [PATCH 4/9] time: Update timekeeper structure using a local
 shadow
From: John Stultz <john.stultz@linaro.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: lkml <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>
Date: Thu, 01 Mar 2012 23:53:16 -0800
In-Reply-To: <20120302073848.GB32401@elte.hu>
References: <1330672368-32290-1-git-send-email-john.stultz@linaro.org>
	 <1330672368-32290-5-git-send-email-john.stultz@linaro.org>
	 <20120302073848.GB32401@elte.hu>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12030207-1976-0000-0000-00000B1AD3D4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-03-02 at 08:38 +0100, Ingo Molnar wrote:
> * John Stultz <john.stultz@linaro.org> wrote:
> 
> > diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
> > index f9ee96c..09460c1 100644
> > --- a/kernel/time/timekeeping.c
> > +++ b/kernel/time/timekeeping.c
> > @@ -74,6 +74,7 @@ struct timekeeper {
> >  };
> >  
> >  static struct timekeeper timekeeper;
> > +static struct timekeeper shadow_tk;
> 
> Sigh.
> 
> As I said it in the first round of review, it's fundamentally 
> wrong to copy live fields like locks or the clocksource pointer 
> around.

So I actually removed the locks out from the timekeeper structure to try
to address this concern.

> It's doubly wrong to do it in a global variable that no-one else 
> but the copying function (update_wall_time()) is supposed to 
> access.
> 
> There are over a dozen fields in 'struct timekeeper' - exactly 
> which ones of them are used on this private copy, as 
> update_wall_time() does the cycle accumulation and calls down 
> into timkeeping_adjust()?

Just about all of timekeeper state is used and modified in the
update_wall_time. 

> The right solution would be to separate timekeeping time state 
> from global state:
> 
> struct timekeeper {
> 	spinlock_t		lock;
> 
> 	struct time_state	time_state;
> };
> 
> And then standardize the time calculation code on passing around 
> not 'struct timekeeper *' but 'struct time_state *' ! Then you 
> can have a local shadow copy of the global state:
> 
> 	struct time_state time_state_copy;
> 
> and copy it from the global one and then pass it down to 
> calculation functions.
> 
> This also gives the freedom to add other global state fields 
> beyond the lock. (Right now the lock appears to be the only 
> global state field - there might be more.)

So, just to be clear, you want me to push basically everything in the
timekeeper structure, except the lock (which would be re-added), into a
time_state sub-structure?

Sorry for being dense here (its been a long day), but maybe could you
clarify a bit more about the differences you're describing between
time-state and global-state wrt the timekeeper?

thanks
-john

