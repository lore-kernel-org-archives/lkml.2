Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932419Ab0HDFSA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 01:18:00 -0400
Received: from fafnir.cs.unc.edu ([152.2.129.90]:45112 "EHLO fafnir.cs.unc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754131Ab0HDFR7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 01:17:59 -0400
References: <1278682707.6083.227.camel@Palantir> <1278685133.1900.201.camel@laptop> <51F8E441-58D7-45E1-B7A0-7A717EDF08B5@email.unc.edu> <1278693304.1900.266.camel@laptop> <1278752489.4390.97.camel@Palantir> <F96CDA2C-534B-4344-B4B4-F890F9BA1D8E@email.unc.edu> <1280828475.1923.444.camel@laptop>
Message-Id: <CFACD068-2139-4FAE-8A2D-B138DD6B80D6@cs.unc.edu>
From: Bjoern Brandenburg <bbb@cs.unc.edu>
To: Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <1280828475.1923.444.camel@laptop>
Content-Type: text/plain;
	charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Mailer: iPad Mail (7B405)
Mime-Version: 1.0 (iPad Mail 7B405)
Subject: Re: periods and deadlines in SCHED_DEADLINE
Date: Wed, 4 Aug 2010 01:18:20 -0400
Cc: Bjoern Brandenburg <bbb@email.unc.edu>, Raistlin <raistlin@linux.it>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Song Yuan <song.yuan@ericsson.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Nicola Manica <nicola.manica@disi.unitn.it>,
        Luca Abeni <lucabe72@email.it>,
        Claudio Scordino <claudio@evidence.eu.com>,
        Harald Gustafsson <harald.gustafsson@ericsson.com>,
        "bastoni@cs.unc.edu" <bastoni@cs.unc.edu>,
        Giuseppe Lipari <lipari@retis.sssup.it>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Aug 3, 2010, at 5:41 AM, Peter Zijlstra <peterz@infradead.org> wrote:

> On Sun, 2010-07-11 at 08:42 +0200, Bjoern Brandenburg wrote:
>> 
>> If you want to do G-EDF with limited and different budgets on each CPU
>> (e.g., G-EDF tasks may only run for 100 out of 1000 ms on CPU 0, but
>> for 400 out of 1000 ms on CPU 1), then you are entering the domain of
>> restricted-supply scheduling, which is significantly more complicated
>> to analyze (see [1,2]). 
> 
> Without having looked at the refs, won't the soft case still have
> bounded tardiness? Since the boundedness property mostly depends on
> u<=1, that is, as long as we can always run everything within the
> available time we won't start drifting.

No, not in all cases. Suppose you have a soft task with a  utilization of 0.2 and two G-EDF reservations of utilization 0.15 each (the rest of the CPU time is allocated to partitioned hard tasks), reservation periods and task period are equal, and no CPU is overutilized. If the reservations become available at different times during each period, then the soft task has bounded tardiness, but if they become available in parallel, then tardiness can grow unboundedly because it can only execute on one CPU at a time.

Hennadiy Leontvey has analyzed this in the bounded-tardiness context extensively and provides some counter examples in his dissertation. For hard real-time, the MPR papers that Andrea pointed out are the state of the art afaik. (I stand by my opinion that global hard real-time is less pressing for the Linux kernel.)

> 
>> As far as I know there is no exiting analysis for "almost G-EDF",
>> i.e.,  the case where each task may only migrate among a subset of the
>> processors (= affinity masks), except for the special case of
>> clustered EDF (C-EDF), wherein the subsets of processors are
>> non-overlapping. 
> 
> Right, affinity masks are a pain, hence I proposed to limit that to
> either 1 cpu (yielding fully paritioned) or the full cluster.

Yes, I agree.

> That will leave us with only having to stack a partitioned and global
> scheduler on top of each other, and per the previous point, I think that
> ought to work out trivially for soft, hard otoh will get 'interesting'.

As I mentioned in my other reply, this is exactly what EDF-HSB (http://www.cs.unc.edu/~anderson/papers/ecrts07b.pdf) does.

- Björn

