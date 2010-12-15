Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753971Ab0LOOCu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 09:02:50 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:34018 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752650Ab0LOOCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 09:02:49 -0500
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=wum_O5HyHpgA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=oU6zYWCatye9-mzC7KsA:9 a=vi52v2ONrgTT2rVbRvUA:7 a=3wYI2REIkj5Di0To500IcWtrstAA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] rtmutex: multiple candidate owners without unrelated
 boosting
From: Steven Rostedt <rostedt@goodmis.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Young <hidave.darkstar@gmail.com>,
        Darren Hart <dvhart@linux.intel.com>,
        Namhyung Kim <namhyung@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.1012150850380.12146@localhost6.localdomain6>
References: <4D07330A.7020600@cn.fujitsu.com>
	 <1292379516.5015.1837.camel@gandalf.stny.rr.com>
	 <alpine.LFD.2.00.1012150850380.12146@localhost6.localdomain6>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 15 Dec 2010 09:02:46 -0500
Message-ID: <1292421766.5015.1866.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-12-15 at 09:02 +0100, Thomas Gleixner wrote:
> On Tue, 14 Dec 2010, Steven Rostedt wrote:
> 
> > On Tue, 2010-12-14 at 17:04 +0800, Lai Jiangshan wrote:
> > 
> > OK, I was looking at this in a bit more detail (the coffee finally set
> > in) and I was at first looking to nuke the cand_owner since it is
> > redundant to cand_seq. But I think we can nuke the cand_seq instead and
> > use the top_waiter as the decider.
> 
> So you just use cand_owner (the name sucks) to flag that the waiter
> has been woken up either by the boost code or by an unlock. The waiter
> clears that flag with waiter->lock->wait_lock held before calling
> schedule().
> 
> Though I think we do need it at all. wakeup of an already running task
> is almost a nop, so having one less state to worry about is good.

I was hoping to remove it completely, and yes I was hoping we could
because a wakeup of a woken task is almost a nop. But then I saw this in
rt_mutex_adjust_prio_chain():


>         /*
>          * Check the orig_waiter state. After we dropped the locks,
>          * the previous owner of the lock might have released the lock
> -        * and made us the pending owner:
> +        * and made us candidate owner:
>          */
> -       if (orig_waiter && !orig_waiter->task)
> +       if (orig_waiter && orig_waiter->cand_owner)
>                 goto out_unlock_pi;
>  

I'm not sure what else we could use to check if the original waiter has
been given the lock.

-- Steve


