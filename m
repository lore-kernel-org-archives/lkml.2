Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759079Ab2EJNqA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 09:46:00 -0400
Received: from merlin.infradead.org ([205.233.59.134]:35319 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755489Ab2EJNp5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 09:45:57 -0400
Message-ID: <1336657544.2527.116.camel@twins>
Subject: Re: [PATCH] sched_groups are expected to be circular linked list,
 make it so right after allocation
From: Peter Zijlstra <peterz@infradead.org>
To: Igor Mammedov <imammedo@redhat.com>
Cc: Jiang Liu <liuj97@gmail.com>, linux-kernel@vger.kernel.org,
        mingo@kernel.org, pjt@google.com, tglx@linutronix.de,
        seto.hidetoshi@jp.fujitsu.com
Date: Thu, 10 May 2012 15:45:44 +0200
In-Reply-To: <20120510132625.GA1455@thinkpad.mammed.net>
References: <1336559908-32533-1-git-send-email-imammedo@redhat.com>
	 <4FAA452A.1070909@gmail.com> <4FAA588B.5010404@redhat.com>
	 <1336564330.2527.23.camel@twins> <4FAA5BFB.40309@redhat.com>
	 <1336566096.2527.30.camel@twins> <1336566644.2527.33.camel@twins>
	 <20120510132625.GA1455@thinkpad.mammed.net>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-10 at 15:26 +0200, Igor Mammedov wrote:
> [  141.699854] sched: Bonkers domain doesn't include its own cpu: 3 0-1,3
> [  141.725038] sched: Bonkers domain doesn't include its own cpu: 3 0-1 

Whee!! so cpu_mask (active_mask) does include 3, but the tl->mask()
doesn't.

> [  141.775040] sched: Topology is hosed for CPU-3!!
> [  141.775596] sched: domain: NODE 0-1
> [  141.776004] sched:  group: 0-1
> 
This seems to suggest its the node topology being wrecked.

which with your code-base would be
cpu_node_mask()->sched_domain_node_span()..

Did you specify any node topology on the qemu command line? If not, it
should all reduce to cpumask_of_node(0).

identify_secondary_cpu()->identify_cpu()->numa_add_cpu() should set that
bit. which is well before the CPU_ONLINE->cpuset_update_active_cpus()
sched domain rebuild.


Most puzzling. Can you dig a little deeper as to why these masks might
be wrong? Also, can you reproduce on actual hardware? The reason I never
use kvm or other virt for debugging is that I always end up spending
time chasing virt bugs, and I hate virt..
