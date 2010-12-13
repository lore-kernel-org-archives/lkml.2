Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753328Ab0LMTSI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 14:18:08 -0500
Received: from canuck.infradead.org ([134.117.69.58]:46699 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752536Ab0LMTSH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 14:18:07 -0500
Subject: Re: [PATCH 1/2] perf tools: Add reference timestamp to perf header
From: Peter Zijlstra <peterz@infradead.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: "David S. Ahern" <daahern@cisco.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20101213190831.GA7984@ghostprotocols.net>
References: <20101213170923.GB1691@nowhere>
	 <1292260289.6803.297.camel@twins> <20101213171537.GC1691@nowhere>
	 <1292260699.6803.305.camel@twins>
	 <20101213172216.GB7417@ghostprotocols.net>
	 <1292261716.6803.332.camel@twins> <1292262433.6803.351.camel@twins>
	 <4D065CB2.7050104@cisco.com> <1292263024.6803.370.camel@twins>
	 <4D065F69.7080707@cisco.com>  <20101213190831.GA7984@ghostprotocols.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 13 Dec 2010 20:17:23 +0100
Message-ID: <1292267843.6803.481.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-12-13 at 17:08 -0200, Arnaldo Carvalho de Melo wrote:
> Em Mon, Dec 13, 2010 at 11:01:13AM -0700, David S. Ahern escreveu:
> > On 12/13/10 10:57, Peter Zijlstra wrote:
> > >> What about creating a PERF_RECORD_TIME and generate an event when the
> > >> counter is opened? It contains a PERF_SAMPLE_TIME and say
> > >> PERF_SAMPLE_TOD (time-of-day)? We're not sending rockets to saturn; we
> > >> just need the timestamps to match other log files.
> 
> > > That's similar to the first thing I proposed. The problem is with long
> > > record sessions your drift can become quite significant, then when you
> > > merge sort your other log events stuff can get out of order. Which can
> > > lead to some serious head-scratching..
> 
> > Gotcha. Missed that in the flury of emails.
> 
> > Arnaldo: Are you ok with this option? This should append mode as well.
> 
> What option, this one:
> 
> -----------------------------------------------------------------------
> Peter Zijlstra wrote:
> 
> > In fact, the only sane way to do that is by creating a software counter
> > that represents CLOCK_MONOTONIC and sample that say once a minute (or
> > more often if you want smaller drift).
> -----------------------------------------------------------------------
> 
> ?
> 
> Yes, that looks the best option. I.e. no changes on headers, no new
> user fake events, a new software event that may be useful for other
> usecases.
> 
> We have:
> 
> [acme@mica linux]$ perf list | grep -- -clock
>   cpu-clock                                  [Software event]
>   task-clock                                 [Software event]
> [acme@mica linux]$ 
> 
> So we would have a new one:
> 
>   monotonic-clock
> 
> Peter, agreed? I'll try to implement it now, good opportunity to learn a
> bit more about soft pmus, I'd have to do that anyway for NIC stats, etc.

Right, don't look too closely at cpu-clock though, its currently a tad
broken, but it should give enough hints as how to implement what you
want.

Once you've got it working we might consider adding something like
PERF_TYPE_CLOCK, where perf_event_attr::config is the posix clock id to
read. That might (or might not) be sensible, given that they're
proposing dynamic posix clocks, which suggests there will be more than
the normal few.
