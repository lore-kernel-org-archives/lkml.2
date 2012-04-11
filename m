Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761179Ab2DKUcY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 16:32:24 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:29106 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754919Ab2DKUcV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 16:32:21 -0400
X-Authority-Analysis: v=2.0 cv=NYRkJh/4 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=j20LOcyRnVUA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=ajBI1610PWinpDKo3GMA:9 a=SnqtZEQT3VgoTs7ddNsA:7 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1334176337.23924.297.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 08/16] sched: add period support for -deadline tasks.
From: Steven Rostedt <rostedt@goodmis.org>
To: Juri Lelli <juri.lelli@gmail.com>
Cc: peterz@infradead.org, tglx@linutronix.de, mingo@redhat.com,
        cfriesen@nortel.com, oleg@redhat.com, fweisbec@gmail.com,
        darren@dvhart.com, johan.eker@ericsson.com, p.faure@akatech.ch,
        linux-kernel@vger.kernel.org, claudio@evidence.eu.com,
        michael@amarulasolutions.com, fchecconi@gmail.com,
        tommaso.cucinotta@sssup.it, nicola.manica@disi.unitn.it,
        luca.abeni@unitn.it, dhaval.giani@gmail.com, hgu1972@gmail.com,
        paulmck@linux.vnet.ibm.com, raistlin@linux.it, insop.song@ericsson.com,
        liming.wang@windriver.com
Date: Wed, 11 Apr 2012 16:32:17 -0400
In-Reply-To: <1333696481-3433-9-git-send-email-juri.lelli@gmail.com>
References: <1333696481-3433-1-git-send-email-juri.lelli@gmail.com>
	 <1333696481-3433-9-git-send-email-juri.lelli@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-04-06 at 09:14 +0200, Juri Lelli wrote:

> @@ -293,7 +293,11 @@ static void replenish_dl_entity(struct sched_dl_entity *dl_se)
>   * assigned (function returns true if it can).
>   *
>   * For this to hold, we must check if:
> - *   runtime / (deadline - t) < dl_runtime / dl_deadline .
> + *   runtime / (deadline - t) < dl_runtime / dl_period .
> + *
> + * Notice that the bandwidth check is done against the period. For
> + * task with deadline equal to period this is the same of using
> + * dl_deadline instead of dl_period in the equation above.

First, it seems that the function returns true if:

	dl_runtime / dl_period < runtime / (deadline - t)


I'm a little confused by this. We are comparing the ratio of runtime
left and deadline left, to the ratio of total runtime to period.

I'm actually confused by this premise anyway. What's the purpose of
comparing the ratio? If runtime < (deadline - t) wouldn't it not be able
to complete anyway? Or are we thinking that the runtime will be
interrupted proportionally by other tasks?

-- Steve




>   */
>  static bool dl_entity_overflow(struct sched_dl_entity *dl_se, u64 t)
>  {
> @@ -312,7 +316,7 @@ static bool dl_entity_overflow(struct sched_dl_entity *dl_se, u64 t)
>  	 * to the (absolute) deadline. Therefore, overflowing the u64
>  	 * type is very unlikely to occur in both cases.
>  	 */
> -	left = dl_se->dl_deadline * dl_se->runtime;
> +	left = dl_se->dl_period * dl_se->runtime;
>  	right = (dl_se->deadline - t) * dl_se->dl_runtime;
>  
>  	return dl_time_before(right, left);


