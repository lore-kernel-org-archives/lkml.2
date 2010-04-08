Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755668Ab0DHF6w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 01:58:52 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:38875 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751803Ab0DHF6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 01:58:49 -0400
Message-ID: <4BBD7094.5090908@us.ibm.com>
Date: Wed, 07 Apr 2010 22:58:44 -0700
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100317)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Eric Dumazet <eric.dumazet@gmail.com>,
       "Peter W. Morreale" <pmorreale@novell.com>,
       Rik van Riel <riel@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Sven-Thorsten Dietrich <sdietrich@novell.com>,
       Chris Mason <chris.mason@oracle.com>,
       John Cooper <john.cooper@third-harmonic.com>,
       Chris Wright <chrisw@sous-sol.org>, Avi Kivity <avi@redhat.com>,
       Ulrich Drepper <drepper@gmail.com>
Subject: Re: [PATCH 6/6] futex: Add aggressive adaptive spinning argument
 to FUTEX_LOCK
References: <1270499039-23728-1-git-send-email-dvhltc@us.ibm.com> <1270499039-23728-7-git-send-email-dvhltc@us.ibm.com>
In-Reply-To: <1270499039-23728-7-git-send-email-dvhltc@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To eliminate syscall overhead from the equation, I modified the testcase 
to allow for forcing the syscall on lock(). Doing so cut the 
non-adaptive scores by more than half. The adaptive scores dropped 
accordingly. The relative difference between normal and adaptive 
remained in tact (with my adaptive implementation lagging by 10x). So 
while the syscall overhead does impact the scores, it is not the source 
of the performance issue with the adaptive futex implementation I posted.

The following bits were being used to test for spinners and attempt to 
only allow one spinner. Obviously it failed miserably at that. I found 
up to 8 spinners running at a time with an instrumented kernel.

> @@ -2497,6 +2502,14 @@ static int futex_lock(u32 __user *uaddr, int flags, int detect, ktime_t *time)
>  retry:
>  #ifdef CONFIG_SMP
>  	if (flags & FLAGS_ADAPTIVE) {
> +		if (!aas) {
> +			ret = get_user(uval, uaddr);
> +			if (ret)
> +				goto out;
> +			if (uval & FUTEX_WAITERS)
> +				goto skip_adaptive;
> +		}

Trouble is at this point is there are no more bits in the word to be 
able to have a FUTEX_SPINNER bit. The futex word is the only per-futex 
storage we have, the futex_q is per task.

If we overload the FUTEX_WAITERS bit it will force more futex_wake() 
calls on the unlock() path. It also will effectively disable spinning 
under contention as there are bound to be FUTEX_WAITERS in that case.

Another option I dislike is to forget about robust futexes in 
conjunction with adaptive futexes and overload the FUTEX_OWNER_DIED bit. 
Ulrich mentioned in another mail that "If we have 31 bit TID values 
there isn't enough room for another bit." Since we have two flag bits 
now, I figured TID values were 30 bits. Is there an option to run with 
31 bits or something?

Assuming we all agree that these options are "bad", that leaves us with 
looking for somewhere else to store the information we need, which in 
turn brings us back around to what Avi, Alan, and Ulrich were discussing 
regarding non swappable TLS data and a pointer in the futex value.

-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
