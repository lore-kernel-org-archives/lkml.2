Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753687Ab0EGQws (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 12:52:48 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:44088 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752563Ab0EGQwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 12:52:47 -0400
Message-ID: <4BE44551.2020809@us.ibm.com>
Date: Fri, 07 May 2010 09:52:33 -0700
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
       Ingo Molnar <mingo@elte.hu>, Eric Dumazet <eric.dumazet@gmail.com>,
       "Peter W. Morreale" <pmorreale@novell.com>,
       Rik van Riel <riel@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Sven-Thorsten Dietrich <sdietrich@novell.com>,
       Chris Mason <chris.mason@oracle.com>,
       John Cooper <john.cooper@third-harmonic.com>,
       Chris Wright <chrisw@sous-sol.org>, Ulrich Drepper <drepper@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Avi Kivity <avi@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 4/4] futex: Add FUTEX_LOCK with optional adaptive spinning
References: <1273127060-30375-1-git-send-email-dvhltc@us.ibm.com> <1273127060-30375-5-git-send-email-dvhltc@us.ibm.com> <alpine.LFD.2.00.1005071818380.3401@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.1005071818380.3401@localhost.localdomain>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> On Wed, 5 May 2010, Darren Hart wrote:
> 
>> Add a non-pi TID value based futex locking mechanism. This enables the
>> use of adaptive spinning which was problematic with the basic FUTEX_WAIT
>> operation.
> 
> You still do way too much work in that spin code with way too much
> code lines.
> 
> Can you try the following (completely uncompiled/untested) patch ?
> 
> Thanks,
> 
> 	tglx
> Subject: futex-simplify.patch
> From: Thomas Gleixner <tglx@linutronix.de>
> Date: Fri, 07 May 2010 17:56:38 +0200
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> ---
>  kernel/futex.c |   42 ++++++++++++------------------------
>  kernel/sched.c |   66 ---------------------------------------------------------
>  2 files changed, 14 insertions(+), 94 deletions(-)
> 


> +		if (to && !to->task) {
> +			ret = -ETIMEOUT;
>  			break;

I had hoped to be able to do it like this too. Unfortunately, we can't 
arm the timer until after we set TASK_INTERRUPTIBLE, and we don't do 
that until after we give up on spinning.


> -
> -		if (timeout) {
> -			now = ktime_get();
> -			if (timeout->tv64 < now.tv64)
> -				break;
>  		}

This bit clearly needs work. Either via some interpolated time 
calculation using something like jiffies, or via another timer that sets 
a bit we can check in here.

-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
