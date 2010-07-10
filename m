Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756253Ab0GJAct (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 20:32:49 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:38442 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756143Ab0GJAcq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 20:32:46 -0400
X-Authority-Analysis: v=1.1 cv=eWk9bc5BAcy1KEyGm/gc5mmqTM7Cp/ADlcqpp9MTMWU= c=1 sm=0 a=FxVaKnQonkgA:10 a=UBIxAjGgU1YA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=VnNF1IyMAAAA:8 a=JfrnYn6hAAAA:8 a=pGLkceISAAAA:8 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=-nfnCIaRlyPoVXiutQUA:9 a=EQQEWeeSJx9348ZPpOoA:7 a=AXjvSinoaBKQrPfGQGI9oDMlOAYA:4 a=PUjeQqilurYA:10 a=Zh68SRI7RUMA:10 a=3Rfx1nUSh_UA:10 a=MSl-tDqOz04A:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=_RhRFcbxBZMA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH 3/4 V2] futex: free_pi_state outside of hb->lock
 sections
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Darren Hart <dvhltc@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Eric Dumazet <eric.dumazet@gmail.com>, John Kacur <jkacur@redhat.com>,
       Mike Galbraith <efault@gmx.de>, linux-rt-users@vger.kernel.org
In-Reply-To: <4C37A8FA.2020607@us.ibm.com>
References: <1278714780-788-1-git-send-email-dvhltc@us.ibm.com>
	 <1278714780-788-4-git-send-email-dvhltc@us.ibm.com>
	 <4C37A8FA.2020607@us.ibm.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Fri, 09 Jul 2010 20:32:45 -0400
Message-ID: <1278721965.1537.173.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-07-09 at 15:55 -0700, Darren Hart wrote:
> Apologies, mangled a rebase and this patch had bits of 4/4 in it.
> Corrected below:
> 
> 
> >From f40b8e684df6ed2b1ba9167cad3922ab43f4a717 Mon Sep 17 00:00:00 2001
> From: Darren Hart <dvhltc@us.ibm.com>
> Date: Fri, 9 Jul 2010 17:07:10 -0400
> Subject: [PATCH 3/4 V2] futex: free_pi_state outside of hb->lock sections
> 
> free_pi_state() calls kfree() and might sleep. To prepare for raw hb->locks,
> get the calls to free_pi_state() out of the hb->lock() sections.
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
>  kernel/futex.c |    8 +++++---
>  1 files changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/futex.c b/kernel/futex.c
> index a6cec32..2cd58a2 100644
> --- a/kernel/futex.c
> +++ b/kernel/futex.c
> @@ -1339,7 +1339,6 @@ retry_private:

This is why I always add a space before labels. I have no idea what
function this was in.

>  			} else if (ret) {
>  				/* -EDEADLK */
>  				this->pi_state = NULL;
> -				free_pi_state(pi_state);

Where do we free the pi state here?

-- Steve

>  				goto out_unlock;
>  			}
>  		}
> @@ -1483,16 +1482,19 @@ retry:
>   */
>  static void unqueue_me_pi(struct futex_q *q)
>  {
> +	struct futex_pi_state *pi_state = NULL;
> +
>  	WARN_ON(plist_node_empty(&q->list));
>  	plist_del(&q->list, &q->list.plist);
>  
>  	BUG_ON(!q->pi_state);
> -	free_pi_state(q->pi_state);
> +	pi_state = q->pi_state;
>  	q->pi_state = NULL;
>  
>  	spin_unlock(q->lock_ptr);
> -
>  	drop_futex_key_refs(&q->key);
> +
> +	free_pi_state(pi_state);
>  }
>  
>  /*


