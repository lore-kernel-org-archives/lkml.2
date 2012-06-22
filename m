Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762669Ab2FVR6Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 13:58:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5776 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755838Ab2FVR6W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 13:58:22 -0400
Date: Fri, 22 Jun 2012 19:57:46 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Hillf Danton <dhillf@gmail.com>, Dan Smith <danms@us.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Paul Turner <pjt@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Mike Galbraith <efault@gmx.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Bharata B Rao <bharata.rao@gmail.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Christoph Lameter <cl@linux.com>, srikar@linux.vnet.ibm.com,
        mjw@linux.vnet.ibm.com
Subject: Re: [PATCH 00/35] AutoNUMA alpha14
Message-ID: <20120622175746.GS4954@redhat.com>
References: <1337965359-29725-1-git-send-email-aarcange@redhat.com>
 <4FC94505.3090506@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FC94505.3090506@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mauricio and everyone,

On Fri, Jun 01, 2012 at 07:41:09PM -0300, Mauricio Faria de Oliveira wrote:
> I got SPECjbb2005 results for 3.4-rc2 mainline, numasched, 
> autonuma-alpha10, and autonuma-alpha13. If you judge the data is OK it 
> may suit a comparison between autonuma-alpha13/14 to verify NUMA 
> affinity regressions.
> 
> The system is an Intel 2-socket Blade. Each NUMA node has 6 cores (+6 
> hyperthreads) and 12 GB RAM. Different permutations of THP, KSM, and VM 
> memory size were tested for each kernel.
> 
> I'll have to leave the analysis of each variable for you, as I'm not 
> familiar w/ the code and expected impacts; but I'm perfectly fine with 
> providing more details about the tests, environment and procedures, and 
> even some reruns, if needed.

So autonuma10 didn't have a fully working idle balancing yet, that's
why it's under-performing. My initial regression test didn't verify the
idle balancing, that got fixed in autonuma11 (notably: it also fixes
multi instance streams)

Your testing methodology was perfect, because you tested with THP off
too, on the host. This rules out the possibility that different
khugepaged default settings could skew the results (AutoNUMA when
engaging boosts khugepaged to offset for the fact THP native migration
isn't available yet so THP gets splitted across memory migrations and
so we need to collapse them more aggressively).

Another thing I noticed is the THP off, KSM off, and VM1 < node, on
autonuma13 the VM1 gets slightly less priority and scores only 87%
(but VM2/3 scores higher than on mainline). It may be a not
reproducible hyperthreading effect that happens once in a while (the
active balancing probably isn't as fast as it should and I'm seeing
some effect of that even on upstream without patches when half of the
hyperthreads are idle), but more likely it's one of the bugs that I've
been fixing lately.

If you have time. you may consider running this again on
autonuma18. Lots of changes and improvements happened since
autonuma13. The amount of memory used in page_autonuma (per-page) has
also been significantly reduced from 24 (or 32 since autonuma14) bytes
to 12, the scheduler should be much faster if overscheduling.

git clone --reference linux -b autonuma18 git://git.kernel.org/pub/scm/linux/kernel/git/andrea/aa.git autonuma18

Other two tweaks to test (only if you have time):

echo 15000 >/sys/kernel/mm/autonuma/knuma_scand/scan_sleep_pass_millisecs

Thanks a lot for your great effort, this was very useful!
Andrea
