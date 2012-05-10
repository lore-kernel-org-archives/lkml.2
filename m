Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752584Ab2EJRCJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 13:02:09 -0400
Received: from mx4-phx2.redhat.com ([209.132.183.25]:45704 "EHLO
	mx4-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751279Ab2EJRCG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 13:02:06 -0400
Date: Thu, 10 May 2012 13:01:44 -0400 (EDT)
From: Igor Mammedov <imammedo@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Jiang Liu <liuj97@gmail.com>, linux-kernel@vger.kernel.org,
        mingo@kernel.org, pjt@google.com, tglx@linutronix.de,
        seto hidetoshi <seto.hidetoshi@jp.fujitsu.com>
Subject: Re: [PATCH] sched_groups are expected to be circular linked list, make it so right after allocation
Message-ID: <9d71ee11-b6c0-41e6-b4fb-75a72c27600e@zmail16.collab.prod.int.phx2.redhat.com>
In-Reply-To: <1336657544.2527.116.camel@twins>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.3.228.113]
X-Mailer: Zimbra 7.1.2_GA_3268 (ZimbraWebClient - FF3.0 (Linux)/7.1.2_GA_3268)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----
> From: "Peter Zijlstra" <peterz@infradead.org>
> To: "Igor Mammedov" <imammedo@redhat.com>
> Cc: "Jiang Liu" <liuj97@gmail.com>, linux-kernel@vger.kernel.org, mingo@kernel.org, pjt@google.com,
> tglx@linutronix.de, "seto hidetoshi" <seto.hidetoshi@jp.fujitsu.com>
> Sent: Thursday, May 10, 2012 3:45:44 PM
> Subject: Re: [PATCH] sched_groups are expected to be circular linked list, make it so right after allocation
> 
> On Thu, 2012-05-10 at 15:26 +0200, Igor Mammedov wrote:
> > [  141.699854] sched: Bonkers domain doesn't include its own cpu: 3
> > 0-1,3
> > [  141.725038] sched: Bonkers domain doesn't include its own cpu: 3
> > 0-1
> 
> Whee!! so cpu_mask (active_mask) does include 3, but the tl->mask()
> doesn't.
> 
> > [  141.775040] sched: Topology is hosed for CPU-3!!
> > [  141.775596] sched: domain: NODE 0-1
> > [  141.776004] sched:  group: 0-1
> > 
> This seems to suggest its the node topology being wrecked.
> 
> which with your code-base would be
> cpu_node_mask()->sched_domain_node_span()..
> 
> Did you specify any node topology on the qemu command line? If not,
> it
> should all reduce to cpumask_of_node(0).
> 
> identify_secondary_cpu()->identify_cpu()->numa_add_cpu() should set
> that
> bit. which is well before the CPU_ONLINE->cpuset_update_active_cpus()
> sched domain rebuild.
> 
> 
> Most puzzling. Can you dig a little deeper as to why these masks
> might
> be wrong? Also, can you reproduce on actual hardware? The reason I
probably not

> never
> use kvm or other virt for debugging is that I always end up spending
> time chasing virt bugs, and I hate virt..

qemu started with -smp 4,sockets=4,cores=1,threads=1

I can answer it right away. It happens when one of cpus failed
to come online on time and boot cpu decided to abandon attempt and exit
do_boot_cpu with error. While exiting with error it clears some masks:

        if (boot_error) {
                /* Try to put things back the way they were before ... */
                numa_remove_cpu(cpu); /* was set by numa_add_cpu */

                /* was set by do_boot_cpu() */
                cpumask_clear_cpu(cpu, cpu_callout_mask);

                /* was set by cpu_init() */
                cpumask_clear_cpu(cpu, cpu_initialized_mask);

                set_cpu_present(cpu, false);
                per_cpu(x86_cpu_to_apicid, cpu) = BAD_APICID;
        }

However cpu that has been blissfully forgotten, continues to boot and sets
cpu_active_mask. So causing all sorts of havoc in places that use this mask.
Then when next cpu is being onlined/offlined it eventually calls 
CPU_[ONLINE|DOWN]->cpuset_update_active_cpus()
result is OOPS.

That is why I've posted https://lkml.org/lkml/2012/5/9/125
that prevent all of this from happening by 'gracefully' aborting boot
process on failed cpu with necessary cleanup.

Checked Ingo's git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git:master
races, that patches 1, 2, 4 are fixing, are still there.
If it is preferable for this patches to go into -tip, then I'll rebase them
on top of it and repost. ???

Please review them if you think it has a sense to fix races in mainline,
before cpu-hotplug overhaul of this part is complete.
