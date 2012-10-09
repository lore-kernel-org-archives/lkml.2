Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756628Ab2JIUgN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 16:36:13 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48620 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752927Ab2JIUgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 16:36:11 -0400
Date: Tue, 9 Oct 2012 13:36:08 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Peter Zijlstra <peterz@infradead.org>
cc: Tang Chen <tangchen@cn.fujitsu.com>, mingo@redhat.com,
        miaox@cn.fujitsu.com, wency@cn.fujitsu.com,
        linux-kernel@vger.kernel.org, linux-numa@vger.kernel.org
Subject: Re: [PATCH] Do not use cpu_to_node() to find an offlined cpu's
 node.
In-Reply-To: <1349780256.7880.12.camel@twins>
Message-ID: <alpine.DEB.2.00.1210091328030.32588@chino.kir.corp.google.com>
References: <1349665183-11718-1-git-send-email-tangchen@cn.fujitsu.com> <1349780256.7880.12.camel@twins>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Oct 2012, Peter Zijlstra wrote:

> On Mon, 2012-10-08 at 10:59 +0800, Tang Chen wrote:
> > If a cpu is offline, its nid will be set to -1, and cpu_to_node(cpu) will
> > return -1. As a result, cpumask_of_node(nid) will return NULL. In this case,
> > find_next_bit() in for_each_cpu will get a NULL pointer and cause panic.
> 
> Hurm,. this is new, right? Who is changing all these semantics without
> auditing the tree and informing all affected people?
> 

I've nacked the patch that did it because I think it should be done from 
the generic cpu hotplug code only at the CPU_DEAD level with a per-arch 
callback to fixup whatever cpu-to-node mappings they maintain since 
processes can reenter the scheduler at CPU_DYING.

The whole issue seems to be because alloc_{fair,rt}_sched_group() does an 
iteration over all possible cpus (not all online cpus) and does 
kzalloc_node() which references a now-offlined node.  Changing it to -1 
makes the slab code fallback to any online node.

What I think we need to do instead of hacking only the acpi code and not 
standardizing this across the kernel is:

 - reset cpu-to-node with a per-arch callback in generic cpu hotplug code 
   at CPU_DEAD, and

 - do an iteration over all possible cpus for node hot-remove ensuring 
   there are no stale references.
