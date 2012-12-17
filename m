Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751897Ab2LQKKw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 05:10:52 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:43990 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013Ab2LQKKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 05:10:50 -0500
Date: Mon, 17 Dec 2012 11:10:44 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mel Gorman <mgorman@suse.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, Paul Turner <pjt@google.com>,
        Hillf Danton <dhillf@gmail.com>, David Rientjes <rientjes@google.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Alex Shi <lkml.alex@gmail.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Automatic NUMA Balancing V11
Message-ID: <20121217101044.GA1426@gmail.com>
References: <20121212100338.GS1009@suse.de>
 <CA+55aFzedbhcuo-WObUjigrXGuG2VGLqDOvh_HFA9Cn_BRkwjQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzedbhcuo-WObUjigrXGuG2VGLqDOvh_HFA9Cn_BRkwjQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Wed, Dec 12, 2012 at 2:03 AM, Mel Gorman <mgorman@suse.de> wrote:
> > This is a pull request for "Automatic NUMA Balancing V11". The list
> 
> Ok, guys, I've pulled this and pushed out. There were some 
> conflicts with both the VM changes and with the scheduler 
> tree, but they were pretty small and looked simple, so I fixed 
> them up and hope they all work.

Cool, thanks Linus!

> Has anybody tested the impact on single-node systems? If 
> distros enable this by default (and it does have 'default y', 
> which is a big no-no for new features - I undid that part) 

Yes, that was for easy testing, leaving it in was an oversight.

> then there will be tons of people running this without 
> actually having multiple sockets. Does it gracefully avoid 
> pointless overheads for this case?

Yes. We have:

+       bool numabalancing_default = false;
+
+       if (IS_ENABLED(CONFIG_NUMA_BALANCING_DEFAULT_ENABLED))
+               numabalancing_default = true;
+
+       if (nr_node_ids > 1 && !numabalancing_override) {
+               printk(KERN_INFO "Enabling automatic NUMA balancing. "
+                       "Configure with numa_balancing= or sysctl");
+               set_numabalancing_state(numabalancing_default);
+       }

The nr_node_ids check makes sure that on single-node systems we 
don't enable the feature.

At that point it will be some extra passive code in the kernel - 
last I measured it was around +20K to the kernel image plus a 
couple of extra branches in a couple of generic paths - but no 
measurable runtime overhead.

Any other negative impact would either come from preparatory or 
scalability patches attached to the NUMA balancing feature, 
which would be a regression we want to fix.

> Anyway, hopefully we'll have a more real numa balancing for 
> 3.9, and this is still considered a reasonable base for that 
> work.

We are working on it ;-)

Thanks,

	Ingo
