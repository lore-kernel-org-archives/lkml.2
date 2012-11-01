Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761534Ab2KAOKi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 10:10:38 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:40971 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756011Ab2KAOKf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 10:10:35 -0400
Message-ID: <509282D6.8010808@hp.com>
Date: Thu, 01 Nov 2012 07:10:30 -0700
From: Don Morris <don.morris@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Rik van Riel <riel@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Paul Turner <pjt@google.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Christoph Lameter <cl@linux.com>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 20/31] sched, numa, mm/mpol: Make mempolicy home-node
 aware
References: <20121025121617.617683848@chello.nl> <20121025124834.012980641@chello.nl> <20121101135813.GX3888@suse.de>
In-Reply-To: <20121101135813.GX3888@suse.de>
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/01/2012 06:58 AM, Mel Gorman wrote:
> On Thu, Oct 25, 2012 at 02:16:37PM +0200, Peter Zijlstra wrote:
>> Add another layer of fallback policy to make the home node concept
>> useful from a memory allocation PoV.
>>
>> This changes the mpol order to:
>>
>>  - vma->vm_ops->get_policy	[if applicable]
>>  - vma->vm_policy		[if applicable]
>>  - task->mempolicy
>>  - tsk_home_node() preferred	[NEW]
>>  - default_policy
>>
>> Note that the tsk_home_node() policy has Migrate-on-Fault enabled to
>> facilitate efficient on-demand memory migration.
>>
> 
> Makes sense and it looks like a VMA policy, if set, will still override
> the home_node policy as you'd expect. At some point this may need to cope
> with node hot-remove. Also, at some point this must be dealing with the
> case where mbind() is called but the home_node is not in the nodemask.
> Does that happen somewhere else in the series? (maybe I'll see it later)
> 

I'd expect one of the first things to be done in the sequence of
hot-removing a node would be to take the cpus offline (at least
out of being schedulable). Hence the tasks would be migrated
to other nodes/processors, which should result in a home node
update the same as if the scheduler had simply chosen a better
home for them anyway. The memory would then migrate either
via the home node change by the tasks themselves or via
migration to evacuate the outgoing node (with the preferred
migration target using the new home node).

As long as no one wants to do something crazy like offline
a node before taking the resources away from the scheduler
and memory management, it should all work out.

Don Morris
