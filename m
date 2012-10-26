Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932558Ab2JZMJh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 08:09:37 -0400
Received: from www.linutronix.de ([62.245.132.108]:33990 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932469Ab2JZMJg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 08:09:36 -0400
Date: Fri, 26 Oct 2012 14:09:33 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Zhang, Yanmin" <yanmin.zhang@intel.com>
cc: "He, Bo" <bo.he@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        "yanmin_zhang@linux.intel.com" <yanmin_zhang@linux.intel.com>
Subject: RE: [PATCH] hrtimer:__run_hrtimer races with enqueue_hrtimer
In-Reply-To: <144086DDB7BB6D429C79280EB1C804D41687C9@SHSMSX101.ccr.corp.intel.com>
Message-ID: <alpine.LFD.2.02.1210261359210.2756@ionos>
References: <1351219917.28400.6.camel@hebo> <alpine.LFD.2.02.1210261147000.2756@ionos> <144086DDB7BB6D429C79280EB1C804D41687C9@SHSMSX101.ccr.corp.intel.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Oct 2012, Zhang, Yanmin wrote:
> >From: Thomas Gleixner [mailto:tglx@linutronix.de]
> >Your code is returning HRTIMER_RESTART from the timer callback and at
> >the same time it starts the timer from some other context. That's what
> >needs to be fixed.
> 
> The timer user should fix it. But could we also change hrtimer to
> make it more stable?  At least, instead of panic, could we print
> some information and go ahead to let kernel continue?

That's unfortunately not possible. At this point the timer might be
already corrupted.

CPU0				CPU 1

timer expires
  callback runs		
                                hrtimer_start()
				   expiry value is set
				   hrtimer_enqueue()

   hrtimer_forward()
      expiry value is set

  return HRTIMER_RESTART				

So while we can prevent the double enqueue, we have no way to deal
with the corrupted expiry value and the inconsistent RB tree. We can
give better debugging information, but we can't pretend that
everything is nice and cool.

If we really want to do something about it which keeps the machine
alive, then we need to 

       1) dequeue the timer
       2) run a consistency check over the rbtree
       3) enqueue the timer

Not sure if that's worth the trouble.

Thanks,

	tglx
