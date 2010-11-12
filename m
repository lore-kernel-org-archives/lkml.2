Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932560Ab0KLQH3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 11:07:29 -0500
Received: from canuck.infradead.org ([134.117.69.58]:49085 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932550Ab0KLQH0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 11:07:26 -0500
Subject: Re: [RFC][PATCH 18/22] sched: add reclaiming logic to -deadline
 tasks
From: Peter Zijlstra <peterz@infradead.org>
To: Raistlin <raistlin@linux.it>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
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
        paulmck <paulmck@linux.vnet.ibm.com>
In-Reply-To: <1289576177.6525.509.camel@Palantir>
References: <1288333128.8661.137.camel@Palantir>
	 <1288334546.8661.161.camel@Palantir>  <1289513573.2084.199.camel@laptop>
	 <1289576177.6525.509.camel@Palantir>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 12 Nov 2010 17:04:01 +0100
Message-ID: <1289577841.2084.302.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-11-12 at 16:36 +0100, Raistlin wrote:
> But at this point I can't avoid asking. That model aims at _pure_
> hard real-time scheduling *without* resource reservation capabilities,
> provided it deals with temporal overruns by means of a probabilistic
> analysis, right? 

>From what I understood from it, its a soft real-time scheduling
algorithm with resource reservation. It explicitly allows for deadline
misses, but requires the tardiness of those misses to be bounded, ie.
the UNC soft real-time definition.

The problem the stochastic execution time model tries to address is the
WCET computation mess, WCET computation is hard and often overly
pessimistic, resulting in under-utilized systems.

By using the average CET (much more easily obtained) we get a much
higher system utilization, but since its an average we need to deal with
deadline overruns due to temporal overload scenarios.

Their reasoning goes that since its an average, an overrun must be
compensated by a short run in the near future. The variance parameter
provides a measure of 'near'. Once we've 'consumed' this short run and
are back to the average case our tardiness is back to 0 as well
(considering an otherwise tight scheduler, say P-EDF), since then we've
met the bandwidth requirements placed by this scheduler.

And since the pure statistics allow for an arbitrary large deviation
from the average it also requires a max runtime in order to be able to
place a bound on tardiness.

So for G-EDF with stochastic ET we still get a bounded tardiness, its a
simple sum of bounds, one due to the G in G-EDF and one due to the
stochastic ET.


