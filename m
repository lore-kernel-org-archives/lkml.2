Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754315Ab2EZTXT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 15:23:19 -0400
Received: from one.firstfloor.org ([213.235.205.2]:45917 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753716Ab2EZTXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 15:23:17 -0400
Date: Sat, 26 May 2012 21:23:11 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, acme@redhat.com, a.p.zijlstra@chello.nl,
        mingo@elte.hu, paulus@samba.org, cjashfor@linux.vnet.ibm.com,
        fweisbec@gmail.com, linux-kernel@vger.kernel.org, tglx@linutronix.de
Subject: Re: [RFCv2 0/8] perf tool: Add new event group management
Message-ID: <20120526192311.GM27374@one.firstfloor.org>
References: <1333574176-11388-1-git-send-email-jolsa@redhat.com> <20120525223646.GL27374@one.firstfloor.org> <20120526123858.GA1679@m.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120526123858.GA1679@m.brq.redhat.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 26, 2012 at 02:38:58PM +0200, Jiri Olsa wrote:
> The startup patches just got in recently
> http://marc.info/?l=linux-kernel&m=133758460912306&w=2
> 
> so I'll continue on this shortly.. 

Great.

> If you have some ideas on this or real world examples,

Any of the proposed syntaxes looked fine for me. The important
part is that it works in some form.

> that would really help.. so far, here's the latest discussion:
> http://marc.info/?t=133357436900005&r=1&w=2

For example you want to measure sandy bridge frontend contention in a 
more useful way than the dubious event in standard perf.

The formula for this is 

N = 4*CPU_CLK_UNHALTED.THREAD           (4 execution slots) 
Percent_FE_bound = 100*(IDQ_UOPS_NOT_DELIVERED.CORE / N)

Translated into perf this is 

-e r53003c -e r53019c

and some glue to compute the formula:

#!/usr/bin/python
import sys

cyc, e1 = sys.stdin.readline().split(",")
uops, e2 = sys.stdin.readline().split(",")

N = 4 * float(cyc) 
P_FE = 100.0 * (float(uops) / N)
print "percent frontend bound: %.2f" % (P_FE)


perf stat -x, -e r53003c -e r53019c /bin/ls 2>log
./frontend.py < log
percent frontend bound: 41.53

My /bin/ls is 42% frontend bound.

Now you see we always have to measure the CPU_CLK_UNHALTED and 
IDQ_UOPS_NOT_DELIVERED.CORE together. Otherwise there is no useful output
from the formula.

The problem happens when we want to measure other things too. You tend
to quickly run out of 4 counters per CPU thread, so have to multiplex.
And that is where the groups are needed. Without the groups we have
to do multiple runs, instead of one that measures this all time sliced.

This is pretty common with all kinds of measurements.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
