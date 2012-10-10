Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753175Ab2JJU5R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 16:57:17 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:63305 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751305Ab2JJU5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 16:57:14 -0400
Date: Wed, 10 Oct 2012 13:57:11 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Peter Zijlstra <peterz@infradead.org>, Tang Chen <tangchen@cn.fujitsu.com>,
        mingo@redhat.com, miaox@cn.fujitsu.com, wency@cn.fujitsu.com,
        linux-kernel@vger.kernel.org, linux-numa@vger.kernel.org
Subject: Re: [PATCH] Do not use cpu_to_node() to find an offlined cpu's
 node.
In-Reply-To: <20121010133709.7eaefcdb.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.2.00.1210101351050.31237@chino.kir.corp.google.com>
References: <1349665183-11718-1-git-send-email-tangchen@cn.fujitsu.com> <1349780256.7880.12.camel@twins> <alpine.DEB.2.00.1210091328030.32588@chino.kir.corp.google.com> <1349815676.7880.85.camel@twins> <alpine.DEB.2.00.1210091617260.10143@chino.kir.corp.google.com>
 <1349860216.7880.105.camel@twins> <alpine.DEB.2.00.1210101324000.28583@chino.kir.corp.google.com> <20121010133709.7eaefcdb.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Oct 2012, Andrew Morton wrote:

> > > So for now, let me NACK that patch. You cannot go change stuff like
> > > that.
> > > 
> > 
> > Agreed, that makes the nack-count up to 2 now.  Andrew, please remove 
> > cpu_hotplug-unmap-cpu2node-when-the-cpu-is-hotremoved.patch
> > cpu_hotplug-unmap-cpu2node-when-the-cpu-is-hotremoved-fix.patch
> > from -mm.
> 
> Nope.  It fixes a BUG() and so I'll be keeping it around until I see a
> better fix.  It's one of the ways in which I prevent things from falling
> through cracks.
> 

It fixes a BUG() that only affects users who are doing node hot-remove, 
which is still radically under development, and nobody cares about except 
those on the cc list, but it also introduces the NULL pointer dereference 
that is attempting to be addressed in this patch.  The "fix" that causes 
this NULL pointer is clearly not the direction we want to go, I think we 
have agreement at node hot-remove to iterate all possible cpus are map all 
offline cpus with cpu_to_node(cpu) == node to NUMA_NO_NODE instead in the 
generic hotplug code.

Regardless, this shouldn't be touching the acpi code which
cpu_hotplug-unmap-cpu2node-when-the-cpu-is-hotremoved.patch and 
cpu_hotplug-unmap-cpu2node-when-the-cpu-is-hotremoved-fix.patch do since 
it makes the behavior inconsistent across interfaces and architectures.
