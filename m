Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754837Ab0KKOJH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 09:09:07 -0500
Received: from casper.infradead.org ([85.118.1.10]:44830 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752492Ab0KKOJE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 09:09:04 -0500
Subject: Re: [RFC][PATCH 02/22] sched: add extended scheduling interface
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
In-Reply-To: <1289483648.6525.10.camel@Palantir>
References: <1288333128.8661.137.camel@Palantir>
	 <1288333622.8661.141.camel@Palantir>  <1289410114.2084.23.camel@laptop>
	 <1289427476.13577.285.camel@Palantir>  <1289482333.2084.102.camel@laptop>
	 <1289483648.6525.10.camel@Palantir>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 11 Nov 2010 15:08:51 +0100
Message-ID: <1289484531.2084.113.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-11-11 at 14:54 +0100, Raistlin wrote:
> > The last three parameters look to be output only as I've not yet found
> > code that reads it, and __getparam_dl() doesn't even appear to set
> > used_runtime.
> > 
> Yeah, just kind of statistical reporting of the task's behaviour. That's
> why I was in agreement with Dhaval about using schedstats for those
> (bumping the version, obviously). What do you think?

So its pure output?  In that case its not really a nice fit for
sched_param, however..

I'm not really a fan of schedstat, esp if you have to use it very
frequently, the overhead of open()+read()+close() + parsing text is
quite high.

Then again, if people are really going to use this (big if I guess) we
could add yet another syscall for this or whatever.

> > One thing you can do is add some padding, versioning and void*
> > extentions are doable for the setparam() path, but getparam() is going
> > to be mighty interesting.
> > 
> Mmm... So, tell me if I got it well: I remove the last three parameters
> (e.g., moving them toward schedstats) and add (besides _var and _max)
> some padding? It that correct?

grmbl, so I was going to say, just pad it to a nice 2^n size, but then I
saw that struct timespec is defined as two long's, which means we're
going to have to do compat crap.

Thomas is there a sane time format in existence? I thought the whole
purpose of timeval/timespec was to avoid having to use a u64, but then
using longs as opposed to int totally defeats the purpose. 

> what about the len <== sizeof(struct sched_param2) in
> sched_{set,get}{param,scheduler}2()... Does this still make sense, or
> are we removing it? 

Since we're going for a constant sized structure we might as well take
it out.
