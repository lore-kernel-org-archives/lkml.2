Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932943Ab0KOTBy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 14:01:54 -0500
Received: from fafnir.cs.unc.edu ([152.2.129.90]:34196 "EHLO fafnir.cs.unc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932833Ab0KOTBv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 14:01:51 -0500
X-Greylist: delayed 1386 seconds by postgrey-1.27 at vger.kernel.org; Mon, 15 Nov 2010 14:01:51 EST
Message-ID: <4CE17DD2.3060807@cs.unc.edu>
Date: Mon, 15 Nov 2010 13:37:06 -0500
From: "James H. Anderson" <anderson@cs.unc.edu>
User-Agent: Thunderbird 2.0.0.24 (X11/20101027)
MIME-Version: 1.0
To: Raistlin <raistlin@linux.it>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Chris Friesen <cfriesen@nortel.com>, oleg@redhat.com,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Darren Hart <darren@dvhart.com>, Johan Eker <johan.eker@ericsson.com>,
        "p.faure" <p.faure@akatech.ch>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Claudio Scordino <claudio@evidence.eu.com>,
        michael trimarchi <trimarchi@retis.sssup.it>,
        Fabio Checconi <fabio@gandalf.sssup.it>,
        Tommaso Cucinotta <cucinotta@sssup.it>,
        Juri Lelli <juri.lelli@gmail.com>,
        Nicola Manica <nicola.manica@disi.unitn.it>,
        Luca Abeni <luca.abeni@unitn.it>, Dhaval Giani <dhaval@retis.sssup.it>,
        Harald Gustafsson <hgu1972@gmail.com>,
        paulmck <paulmck@linux.vnet.ibm.com>,
        Bjoern Brandenburg <bbb@email.unc.edu>,
        "James H. Anderson" <anderson@cs.unc.edu>
Subject: Re: [RFC][PATCH 18/22] sched: add reclaiming logic to -deadline tasks
References: <1289588215.6525.697.camel@Palantir> <80992760-24F2-42AE-AF2D-15727F6A1C81@email.unc.edu>
In-Reply-To: <80992760-24F2-42AE-AF2D-15727F6A1C81@email.unc.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for the delayed response... I think I must have inadvertently 
deleted this
email last week and Bjoern just mentioned it to me...
> On Fri, 2010-11-12 at 17:04 +0100, Peter Zijlstra wrote:
>   
>> On Fri, 2010-11-12 at 16:36 +0100, Raistlin wrote:
>>     
>>> But at this point I can't avoid asking. That model aims at _pure_
>>> hard real-time scheduling *without* resource reservation capabilities,
>>> provided it deals with temporal overruns by means of a probabilistic
>>> analysis, right? 
>>>       
>> From what I understood from it, its a soft real-time scheduling
>> algorithm with resource reservation. 
>>
>>     
> Mmm... I've gone through it (again!) quickly, and you're right, it
> mentions soft real-time, and I agree that for those systems average CET
> is better than worst CET. However, I'm not sure resource reservation is
> there... Not in the paper I have at least, but I may be wrong.
>
>   
>> The problem the stochastic execution time model tries to address is the
>> WCET computation mess, WCET computation is hard and often overly
>> pessimistic, resulting in under-utilized systems.
>>
>>     
> I know, and it's very reasonable. The point I'm trying to make is that
> resource reservation tries to address the very same issue.
> I am all but against this model, just want to be sure it's not too much
> in conflict to the other features we have, especially with resource
> reservation. Especially considering that --if I got the whole thing
> about this scheduler right-- resource reservation is something we really
> want, and I think UNC people would agree here, since I heard Bjorn
> stating this very clear both in Dresden and in Dublin. :-)
>
> BTW, I'm adding them to the Cc, seems fair, and more useful than all
> this speculation! :-P
>
> Bjorn, Jim, sorry for bothering. If you're interested, this is the very
> beginning of the whole thread:
> http://lkml.org/lkml/2010/10/29/67
>
> And these should be from where this specific discussion starts (I hope,
> the mirror is not updated yet I guess :-( ):
> http://lkml.org/lkml/2010/10/29/49
> http://groups.google.com/group/linux.kernel/msg/1dadeca435631b60
>
> Thanks and Regards,
> Dario
>   
If you're talking about our most recent "stochastic" paper, it is about 
supporting
soft real-time task systems on a multiprocessor where resource 
reservations are
used.  The main result of the paper is that if you provision the 
reservation for a
task slightly higher than it's average-case execution time, and if you use a
scheduling algorithm (like global EDF) that ensures bounded tardiness 
(w.r.t.
these reservations), then the task's expected tardiness will be bounded 
and the
expected bound does not depend on worst-case execution times.  I'm not 
sure if
slack-reallocation methods have come up in this discussion (sorry, I'm 
really
pressed for time and didn't look), but we didn't get into that in our 
paper.  However,
such methods would be easy to incorporate.  I think one of the most 
beautiful
aspects of this paper (which we didn't say enough about) is that the 
analysis
completely separates all the stochastic stuff from the reasoning needed to
derive tardiness bounds under a given scheduler.  In other words, you 
can simply
ignore all stochastic issues when reasoning about tardiness.  I gathered 
there was
some confusion about whether we were using resource reservations.  Such
reservations are actually crucial for our analysis as they allow 
independence to
be assumed across tasks.  And oh yeah: this work has nothing to do with hard
real-time and worst-case execution times are not used at all.

Just to make sure I don't end up creating more confusion, the paper I'm 
talking
about is this one:
http://www.cs.unc.edu/~anderson/papers/rtas11b.pdf

I hope this helps.

-Jim Anderson

