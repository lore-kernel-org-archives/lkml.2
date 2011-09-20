Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751486Ab1ITN4a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 09:56:30 -0400
Received: from casper.infradead.org ([85.118.1.10]:58693 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041Ab1ITN43 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 09:56:29 -0400
Subject: Re: CFS Bandwidth Control - Test results of cgroups tasks pinned vs
 unpinnede
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Paul Turner <pjt@google.com>,
        Vladimir Davydov <vdavydov@parallels.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelianov <xemul@parallels.com>
Date: Tue, 20 Sep 2011 15:56:09 +0200
In-Reply-To: <20110919175129.GA11164@linux.vnet.ibm.com>
References: <1315922848.5977.11.camel@twins>
	 <20110913162119.GA3045@linux.vnet.ibm.com> <1315931775.5977.29.camel@twins>
	 <20110913175425.GB3062@linux.vnet.ibm.com> <1315937995.4226.9.camel@twins>
	 <20110913182841.GO11100@linux.vnet.ibm.com>
	 <1315938646.4226.12.camel@twins>
	 <20110913183502.GP11100@linux.vnet.ibm.com>
	 <20110915175537.GA17701@linux.vnet.ibm.com>
	 <1316123323.4060.24.camel@twins>
	 <20110919175129.GA11164@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1316526969.13664.31.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-09-19 at 23:21 +0530, Kamalesh Babulal wrote:
> * Peter Zijlstra <a.p.zijlstra@chello.nl> [2011-09-15 23:48:43]:
> 
> > On Thu, 2011-09-15 at 23:25 +0530, Kamalesh Babulal wrote:
> > > 2.6.38          | 1551  | 48    | 62    | 47    | 50    |
> > > ----------------+-------+-------+-------+-------+-------+
> > > 2.6.39          | 3784  | 457   | 722   | 3209  | 1037  | 
> > 
> > I'd say we wrecked it going from .38 to .39 and only made it worse after
> > that.
> 
> after reverting the commit 866ab43efd325fae8889ea, of the patches 
> went between .38 and .39 reduces the ping pong of the tasks.
> 
> ------------------------+-------+-------+-------+-------+-------+
> Kernel			| Run 1	| Run 2	| Run 3	| Run 4	| Run 5	|
> ------------------------+-------+-------+-------+-------+-------+
> 2.6.39	        	| 1542  | 2172  | 2727  | 120   | 3681  |
> ------------------------+-------+-------+-------+-------+-------+
> 2.6.39 (with    	|       |       |       |       |       |
> 866ab43efd reverted)	| 65	| 78	| 58	| 99 	| 62	|
> ------------------------+-------+-------+-------+-------+-------+
> 3.1-rc4+tip		|	|	|	|	|	|
> (e467f18f945c)		| 1219	| 2037	| 1943	| 772	| 1701	|
> ------------------------+-------+-------+-------+-------+-------+
> 3.1-rc4+tip (e467f18f9)	|	|	|	|	|	|
> (866ab43efd reverted)	| 64	| 45	| 59	| 59	| 69	|
> ------------------------+-------+-------+-------+-------+-------+

Right, so reverting that breaks the cpuset/cpuaffinity thing again :-(

Now I'm not quite sure why group_imb gets toggled in this use-case at
all, having put a trace_printk() in, we get:

           <...>-1894  [006]   704.056250: find_busiest_group: max: 2048, min: 0, avg: 1024, nr: 2
     kworker/1:1-101   [001]   706.305523: find_busiest_group: max: 3072, min: 0, avg: 1024, nr: 3

Which is of course a bad state to be in, but we also get:

    migration/17-73    [017]   706.284191: find_busiest_group: max: 1024, min: 0, avg: 512, nr: 2
          <idle>-0     [003]   706.325435: find_busiest_group: max: 1250, min: 440, avg: 1024, nr: 2

on a CGROUP=n kernel.. which I think we can attribute to races.

When I enable tracing I also get some good runs, so it smells like the
lb does one bad thing and instead of correcting it it makes it worse.

It looks like its set-off by a mass-wakeup of random crap that really
shouldn't be waking at all, I mean who needs automount to wakeup, or
whatever the fuck rtkit-daemon is. I'm pretty sure my bash loops don't
do anything remotely related to those.

Anyway, once enough random crap wakes up, the load-balancer goes shift
stuff around, once we hit the group_imb conditions we seem to get stuck
in a bad state instead of getting out of it.

Bah!






