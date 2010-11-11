Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755190Ab0KKS2J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 13:28:09 -0500
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:31492 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751294Ab0KKS2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 13:28:08 -0500
Subject: Re: divide error in select_task_rq_fair()
From: Myron Stowe <myron.stowe@hp.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Venkatesh Pallipadi <venki@google.com>, Nikhil Rao <ncrao@google.com>,
        Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>,
        linux-kernel@vger.kernel.org, knikanth@suse.de, rjenties@google.com
In-Reply-To: <1288937844.3234.1.camel@edumazet-laptop>
References: <20101104041236.GA9389@helgaas.com>
	 <1288847992.2718.37.camel@edumazet-laptop>
	 <20101104142853.GA11656@helgaas.com>
	 <1288881474.2659.123.camel@edumazet-laptop>
	 <20101105020013.GA13484@helgaas.com>
	 <1288937844.3234.1.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 11 Nov 2010 11:28:04 -0700
Message-ID: <1289500084.2698.12.camel@zim>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-11-05 at 07:17 +0100, Eric Dumazet wrote:
> Le jeudi 04 novembre 2010 à 20:00 -0600, Bjorn Helgaas a écrit :
> 
> > Is that going to help you debug the problem?  The solution is not going
> > to be something like "set NR_CPUS=x".  If NR_CPUS is too small, the
> > machine should still *boot*, even if we can't use all the CPUs in the
> > box.
> > 
> 
> Yes, it will help to understand the layout of cpu / domains and make
> appropriate changes.
> 
> Alternative is you send me such a machine :=)

I opened a BZ on this issue as it seems to be a regression -
https://bugzilla.kernel.org/show_bug.cgi?id=22662

I also, as indicated in the BZ, bisected the kernel which gave the
following results and reverting 50f2d7f682f9c0ed58191d0982fe77888d59d162
did re-enable booting on the box in question (an HP dl980g7).  Let me
know what further info you need or patches to test for debugging this.

Thanks,

commit 50f2d7f682f9c0ed58191d0982fe77888d59d162
Author: Nikanth Karthikesan <knikanth@suse.de>
Date:   Thu Sep 30 17:34:10 2010 +0530

    x86, numa: Assign CPUs to nodes in round-robin manner on fake NUMA

    commit d9c2d5ac6af87b4491bff107113aaf16f6c2b2d9 "x86, numa: Use near(er)
    online node instead of roundrobin for NUMA" changed NUMA initialization on
    Intel to choose the nearest online node or first node.  Fake NUMA would be
    better of with round-robin initialization, instead of the all CPUS on
    first node.  Change the choice of first node, back to round-robin.

    For testing NUMA kernel behaviour without cpusets and NUMA aware
    applications, it would be better to have cpus in different nodes, rather
    than all in a single node.  With cpusets migration of tasks scenarios
    cannot not be tested.

    I guess having it round-robin shouldn't affect the use cases for all cpus
    on the first node.

    The code comments in arch/x86/mm/numa_64.c:759 indicate that this used to
    be the case, which was changed by commit d9c2d5ac6.  It changed from
    roundrobin to nearer or first node.  And I couldn't find any reason for
    this change in its changelog.

    Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>
    Cc: David Rientjes <rientjes@google.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> 
> Thanks
>  
> 


-- 
Myron Stowe                             Linux Kernel Developer
Fort Collins, CO                        Office of Corporate Strategy and Technology

