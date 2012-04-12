Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761987Ab2DLGjO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 02:39:14 -0400
Received: from mail3.unitn.it ([193.205.206.70]:39431 "EHLO mail3.unitn.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761061Ab2DLGjM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 02:39:12 -0400
Message-ID: <4F867885.3050106@unitn.it>
Date: Thu, 12 Apr 2012 08:39:01 +0200
From: Luca Abeni <luca.abeni@unitn.it>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Juri Lelli <juri.lelli@gmail.com>, peterz@infradead.org,
        tglx@linutronix.de, mingo@redhat.com, cfriesen@nortel.com,
        oleg@redhat.com, fweisbec@gmail.com, darren@dvhart.com,
        johan.eker@ericsson.com, p.faure@akatech.ch,
        linux-kernel@vger.kernel.org, claudio@evidence.eu.com,
        michael@amarulasolutions.com, fchecconi@gmail.com,
        tommaso.cucinotta@sssup.it, nicola.manica@disi.unitn.it,
        dhaval.giani@gmail.com, hgu1972@gmail.com, paulmck@linux.vnet.ibm.com,
        raistlin@linux.it, insop.song@ericsson.com, liming.wang@windriver.com
Subject: Re: [PATCH 08/16] sched: add period support for -deadline tasks.
References: <1333696481-3433-1-git-send-email-juri.lelli@gmail.com>  <1333696481-3433-9-git-send-email-juri.lelli@gmail.com> <1334176337.23924.297.camel@gandalf.stny.rr.com>
In-Reply-To: <1334176337.23924.297.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven,

On 04/11/2012 10:32 PM, Steven Rostedt wrote:
> On Fri, 2012-04-06 at 09:14 +0200, Juri Lelli wrote:
>
>> @@ -293,7 +293,11 @@ static void replenish_dl_entity(struct sched_dl_entity *dl_se)
>>    * assigned (function returns true if it can).
>>    *
>>    * For this to hold, we must check if:
>> - *   runtime / (deadline - t)<  dl_runtime / dl_deadline .
>> + *   runtime / (deadline - t)<  dl_runtime / dl_period .
>> + *
>> + * Notice that the bandwidth check is done against the period. For
>> + * task with deadline equal to period this is the same of using
>> + * dl_deadline instead of dl_period in the equation above.
>
> First, it seems that the function returns true if:
>
> 	dl_runtime / dl_period<  runtime / (deadline - t)
>
>
> I'm a little confused by this. We are comparing the ratio of runtime
> left and deadline left, to the ratio of total runtime to period.
>
> I'm actually confused by this premise anyway. What's the purpose of
> comparing the ratio? If runtime<  (deadline - t) wouldn't it not be able
> to complete anyway? Or are we thinking that the runtime will be
> interrupted proportionally by other tasks?
I see that other people have been faster than me to reply (and Tommaso's
reply is pretty good).

I just add that the original CBS algorithm (which introduced this kind
of check) assumed "relative deadline = reservation period". So, if you
are wondering why
	dl_runtime / dl_deadline
is changed into
	dl_runtime / dl_period
I agree that this is not too clear... In my opinion, a more correct (but
probably too pessimistic) check should use
	dl_runtime / min(dl_deadline, dl_period)


Also, note that this check is presented as
	c_s >= (d_{s,k} - r_{i,j})U_s
(where U_s = Q_s/T_s = dl_runtime / dl_period - with dl_period = dl_deadline)
in the original paper (see the "When a job J_{i,j} arrives and the server is
idle..." item at the end of the first column of the third page of the paper).

Also, regarding the "Server mechanisms for multimedia applications" technical
report mentioned by Tommaso, you can download it from here:
http://xoomer.virgilio.it/lucabe72/pubs/tr-98-01.ps



				Luca
