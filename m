Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755236Ab2JIKFB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 06:05:01 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:43371 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754609Ab2JIKE6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 06:04:58 -0400
Date: Tue, 9 Oct 2012 03:04:52 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Tang Chen <tangchen@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>
cc: Wen Congyang <wency@cn.fujitsu.com>, mingo@redhat.com,
        peterz@infradead.org, miaox@cn.fujitsu.com,
        linux-kernel@vger.kernel.org, linux-numa@vger.kernel.org
Subject: Re: [PATCH] Do not use cpu_to_node() to find an offlined cpu's
 node.
In-Reply-To: <5073E2BF.9050306@cn.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1210090259250.24261@chino.kir.corp.google.com>
References: <1349665183-11718-1-git-send-email-tangchen@cn.fujitsu.com> <alpine.DEB.2.00.1210082308230.360@chino.kir.corp.google.com> <5073E18A.2090203@cn.fujitsu.com> <5073E2BF.9050306@cn.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Oct 2012, Tang Chen wrote:

> > > Eek, the nid shouldn't be -1 yet, though, for cpu hotplug since this
> > > should be called at CPU_DYING level and migrate_tasks() still sees a valid
> > > cpu.
> 
> As Wen said below, nid is now set to -1 when cpu is hotremoved.
> I reproduce this problem in this situation:
> 
> all cpus are online, and hot remove a system board directorily, without
> offlining any cpu.
> 
> As a result, the removed cpu's nid is set to -1, and this causes
> problems.
> 

Let's add Andrew to the cc list then, because I'm nacking 
cpu_hotplug-unmap-cpu2node-when-the-cpu-is-hotremoved.patch in the -mm 
tree for this reason.

We can only clear a cpu-to-node mapping when the cpu is completely 
offline, not before or during the CPU_DYING stage.  Kernel code, such as 
the sched code that you are now trying to "fix", depends on this mapping 
to work correctly; obviously no audit was done of cpu hotplug code 
depending on it before the patch was proposed.

I say "fix" because even this workaround isn't a good solution since it 
would be much better to pick another cpu on the same node as the offlining 
cpu for the runqueue before falling back to the set of all allowed nodes.  
We lose all NUMA affinity information with that patch.  There's no reason 
why we shouldn't know the node of a cpu that is being offlined.

So nack to cpu_hotplug-unmap-cpu2node-when-the-cpu-is-hotremoved.patch.  
After it's removed because it's buggy, this "fix" will no longer be 
necessary.
