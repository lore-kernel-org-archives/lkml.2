Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754947Ab0GJA3w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 20:29:52 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:37289 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752439Ab0GJA3u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 20:29:50 -0400
X-Authority-Analysis: v=1.1 cv=eWk9bc5BAcy1KEyGm/gc5mmqTM7Cp/ADlcqpp9MTMWU= c=1 sm=0 a=mSGy7vTMwJ8A:10 a=hO-oPbc3tlwA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=VnNF1IyMAAAA:8 a=JfrnYn6hAAAA:8 a=pGLkceISAAAA:8 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=tlkc0S-Y51piGF4d2pIA:9 a=c9gGH3mqt-jhieWbLDwA:7 a=NR0muhcEao0_NQHWS046tUPPyqcA:4 a=PUjeQqilurYA:10 a=Zh68SRI7RUMA:10 a=3Rfx1nUSh_UA:10 a=MSl-tDqOz04A:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=_RhRFcbxBZMA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH 1/4] rtmutex: avoid null derefence in WARN_ON
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Darren Hart <dvhltc@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Eric Dumazet <eric.dumazet@gmail.com>, John Kacur <jkacur@redhat.com>,
       Mike Galbraith <efault@gmx.de>, linux-rt-users@vger.kernel.org
In-Reply-To: <1278714780-788-2-git-send-email-dvhltc@us.ibm.com>
References: <1278714780-788-1-git-send-email-dvhltc@us.ibm.com>
	 <1278714780-788-2-git-send-email-dvhltc@us.ibm.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Fri, 09 Jul 2010 20:29:48 -0400
Message-ID: <1278721788.1537.170.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-07-09 at 15:32 -0700, Darren Hart wrote:
> If the pi_blocked_on variable is NULL, the subsequent WARN_ON's
> will cause an OOPS. Only perform the susequent checks if
> pi_blocked_on is valid.
> 
> Signed-off-by: Darren Hart <dvhltc@us.ibm.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Eric Dumazet <eric.dumazet@gmail.com>
> Cc: John Kacur <jkacur@redhat.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Mike Galbraith <efault@gmx.de>
> ---
>  kernel/rtmutex.c |    7 ++++---
>  1 files changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/rtmutex.c b/kernel/rtmutex.c
> index 23dd443..baac7d9 100644
> --- a/kernel/rtmutex.c
> +++ b/kernel/rtmutex.c
> @@ -579,9 +579,10 @@ static void wakeup_next_waiter(struct rt_mutex *lock, int savestate)
>  
>  	raw_spin_lock(&pendowner->pi_lock);
>  
> -	WARN_ON(!pendowner->pi_blocked_on);
> -	WARN_ON(pendowner->pi_blocked_on != waiter);
> -	WARN_ON(pendowner->pi_blocked_on->lock != lock);
> +	if (!WARN_ON(!pendowner->pi_blocked_on)) {
> +		WARN_ON(pendowner->pi_blocked_on != waiter);

The above actually has no issue if the pi_blocked_on is NULL.

The below, well yeah.

-- Steve

> +		WARN_ON(pendowner->pi_blocked_on->lock != lock);
> +	}
>  
>  	pendowner->pi_blocked_on = NULL;
>  


