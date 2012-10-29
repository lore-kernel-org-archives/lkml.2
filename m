Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932573Ab2J2RaZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 13:30:25 -0400
Received: from mga01.intel.com ([192.55.52.88]:15729 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751430Ab2J2RaX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 13:30:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,668,1344236400"; 
   d="scan'208";a="239598362"
Message-ID: <1351472280.4415.2.camel@ymzhang.sh.intel.com>
Subject: RE: [PATCH] hrtimer:__run_hrtimer races with enqueue_hrtimer
From: Yanmin Zhang <yanmin_zhang@linux.intel.com>
Reply-To: yanmin_zhang@linux.intel.com
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "Zhang, Yanmin" <yanmin.zhang@intel.com>, "He, Bo" <bo.he@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
Date: Mon, 29 Oct 2012 08:58:00 +0800
In-Reply-To: <alpine.LFD.2.02.1210261359210.2756@ionos>
References: <1351219917.28400.6.camel@hebo>
	 <alpine.LFD.2.02.1210261147000.2756@ionos>
	 <144086DDB7BB6D429C79280EB1C804D41687C9@SHSMSX101.ccr.corp.intel.com>
	 <alpine.LFD.2.02.1210261359210.2756@ionos>
Organization: Intel.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-10-26 at 14:09 +0200, Thomas Gleixner wrote:
> On Fri, 26 Oct 2012, Zhang, Yanmin wrote:
> > >From: Thomas Gleixner [mailto:tglx@linutronix.de]
> > >Your code is returning HRTIMER_RESTART from the timer callback and at
> > >the same time it starts the timer from some other context. That's what
> > >needs to be fixed.
> > 
> > The timer user should fix it. But could we also change hrtimer to
> > make it more stable?  At least, instead of panic, could we print
> > some information and go ahead to let kernel continue?
> 
> That's unfortunately not possible. At this point the timer might be
> already corrupted.
> 
> CPU0				CPU 1
> 
> timer expires
>   callback runs		
>                                 hrtimer_start()
> 				   expiry value is set
> 				   hrtimer_enqueue()
> 
>    hrtimer_forward()
>       expiry value is set
> 
>   return HRTIMER_RESTART				
> 
> So while we can prevent the double enqueue, we have no way to deal
> with the corrupted expiry value and the inconsistent RB tree. We can
> give better debugging information, but we can't pretend that
> everything is nice and cool.
> 
> If we really want to do something about it which keeps the machine
> alive, then we need to 
> 
>        1) dequeue the timer
>        2) run a consistency check over the rbtree
>        3) enqueue the timer
> 
> Not sure if that's worth the trouble.
I strongly agree with you. Such checking might cause more trouble than
what we could benefit from it.

Could we add more dumping, especially about the timer address and callback
function? Next time, developers could find the bad timer quickly.



