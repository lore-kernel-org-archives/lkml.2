Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757282Ab2EaAf5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 20:35:57 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35543 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756318Ab2EaAfk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 20:35:40 -0400
Date: Wed, 30 May 2012 17:35:38 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: "Kirill A. Shutemov" <kirill@shutemov.name>
cc: Gao feng <gaofeng@cn.fujitsu.com>, hannes@cmpxchg.org,
        kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, bsingharora@gmail.com,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org, linux-mm@kvack.org,
        containers@lists.linux-foundation.org
Subject: Re: [PATCH] meminfo: show /proc/meminfo base on container's memcg
In-Reply-To: <20120530232004.GA15423@shutemov.name>
Message-ID: <alpine.DEB.2.00.1205301729490.25774@chino.kir.corp.google.com>
References: <1338260214-21919-1-git-send-email-gaofeng@cn.fujitsu.com> <alpine.DEB.2.00.1205301433490.9716@chino.kir.corp.google.com> <20120530232004.GA15423@shutemov.name>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 May 2012, Kirill A. Shutemov wrote:

> > Why?  Because the information exported by /proc/meminfo is considered by 
> > applications to be static whereas the limit of a memcg may change without 
> > any knowledge of the application.
> 
> Memory hotplug does the same, right?
> 

Memory hotplug is a seperate topic, it changes the amount of physical 
memory that is available to the kernel, not any limitation of memory 
available to a set of tasks.  For memory hot-add, this does not 
automatically increase the memory.limit_in_bytes of any non-root memcg, 
the memory usage is still constrained as it was before the hotplug event.  
Thus, applications would want to depend on memory.{limit,usage}_in_bytes 
specifically to determine the amount of available memory even with 
CONFIG_MEMORY_HOTPLUG.

Also, under certain cirucmstances such as when a thread is oom killed, it 
may allocate memory in excess of its memcg limitation and this wouldn't be 
visible as available with this patch via /proc/meminfo.  Cpusets allows 
softwall allocations even when a thread is simply exiting on all nodes 
(and for GFP_ATOMIC allocations) and this also wouldn't be visible in 
/proc/meminfo.
