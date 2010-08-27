Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752949Ab0H0Hvk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 03:51:40 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:54498 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752349Ab0H0Hvi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 03:51:38 -0400
Subject: Re: divide by zero bug in find_busiest_group
From: Peter Zijlstra <peterz@infradead.org>
To: Chetan Ahuja <chetan.ahuja@gmail.com>
Cc: Venkatesh Pallipadi <venki@google.com>, linux-kernel@vger.kernel.org,
        Suresh Siddha <suresh.b.siddha@intel.com>
In-Reply-To: <AANLkTikg7Q_oOecNgVLPPTu3dOu3aO776f4y1bw410PV@mail.gmail.com>
References: <AANLkTimT4T-6dO=Uo05DexYf3exq=0SkZemHuB5aRP3Q@mail.gmail.com>
	 <AANLkTim75Z-X--LDJX8MLYF8G=vPW_GniVFQrkL7QoAy@mail.gmail.com>
	 <AANLkTikg7Q_oOecNgVLPPTu3dOu3aO776f4y1bw410PV@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 27 Aug 2010 09:51:34 +0200
Message-ID: <1282895494.1975.1693.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-08-26 at 16:52 -0700, Chetan Ahuja wrote:
>  For one thing, I don't understand the reason for recomputing
> cpu_power dynamically. How does cpu_power of a gorup (which I believe
> refers to the group of "hyper-threaded" cores on one physical core)
> change while inthe system is in operation ? Is this in support of
> hot-swappable CPU's or something ?

No the groups are used for increasingly larger accumulations of cpus,
the first group is the singleton group which contains on the one cpu in
question, after that we start following the machine topology,
hyper-threads, multi-core, package, node etc. until the last group spans
the whole machine.

The dynamic cpu_power computation comes from RT tasks, when we
load-balance SCHED_OTHER tasks, we want each cpu to have an equal amount
of pending work, however when one CPU is say 50% busy with RT tasks (and
hopefully soon IRQ load), it cannot perform the same amount of work as
another unloaded cpu, therefore we need to normalize the relative load
levels between cpu. We use cpu_power as this load normalization factor.

Load balancing works by balancing this group hierarchy, a number of
groups are contained in a domain. Each cpu does a load-balance pull,
from the busiest group in that domain to his local domain. Since there's
ever smaller groups/domains you eventually end up with a nicely spread
load.

>   To be honest, for my use case, I'd  like to just disable the whole
> work-stealing stuff (referred to as load-balancing in the kernel).
> There seems to be no config option that isolates just the dynamic
> load-balancing parts (or is there ?) so maybe I'd just hack away the
> load-balancing functions by hand so as never to worry about those
> denominators again. 

You can do that at runtime, read: Documentation/cgroups/cpusets.txt
