Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757452Ab2F0UEz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 16:04:55 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:52196 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753768Ab2F0UEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 16:04:54 -0400
Date: Wed, 27 Jun 2012 13:04:51 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Michal Hocko <mhocko@suse.cz>
cc: Zhouping Liu <zliu@redhat.com>, linux-mm@kvack.org,
        Li Zefan <lizefan@huawei.com>, Tejun Heo <tj@kernel.org>,
        CAI Qian <caiqian@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: memcg: cat: memory.memsw.* : Operation not supported
In-Reply-To: <20120627154827.GA4420@tiehlicka.suse.cz>
Message-ID: <alpine.DEB.2.00.1206271256120.22162@chino.kir.corp.google.com>
References: <2a1a74bf-fbb5-4a6e-b958-44fff8debff2@zmail13.collab.prod.int.phx2.redhat.com> <34bb8049-8007-496c-8ffb-11118c587124@zmail13.collab.prod.int.phx2.redhat.com> <20120627154827.GA4420@tiehlicka.suse.cz>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Jun 2012, Michal Hocko wrote:

> > # mount -t cgroup -o memory xxx /cgroup/
> > # ll /cgroup/memory.memsw.*
> > -rw-r--r--. 1 root root 0 Jun 26 23:17 /cgroup/memory.memsw.failcnt
> > -rw-r--r--. 1 root root 0 Jun 26 23:17 /cgroup/memory.memsw.limit_in_bytes
> > -rw-r--r--. 1 root root 0 Jun 26 23:17 /cgroup/memory.memsw.max_usage_in_bytes
> > -r--r--r--. 1 root root 0 Jun 26 23:17 /cgroup/memory.memsw.usage_in_bytes
> > # cat /cgroup/memory.memsw.*
> > cat: /cgroup/memory.memsw.failcnt: Operation not supported
> > cat: /cgroup/memory.memsw.limit_in_bytes: Operation not supported
> > cat: /cgroup/memory.memsw.max_usage_in_bytes: Operation not supported
> > cat: /cgroup/memory.memsw.usage_in_bytes: Operation not supported
> > 
> > I'm confusing why it can't read memory.memsw.* files.
> 
> Those files are exported if CONFIG_CGROUP_MEM_RES_CTLR_SWAP=y even
> if the feature is turned off when any attempt to open the file returns
> EOPNOTSUPP which is exactly what you are seeing.
> This is a deliberate decision see: b6d9270d (memcg: always create memsw
> files if CONFIG_CGROUP_MEM_RES_CTLR_SWAP).
> 

You mean af36f906c0f4?

> Does this help to explain your problem? Do you actually see any problem
> with this behavior?
> 

I think it's a crappy solution and one that is undocumented in 
Documentation/cgroups/memory.txt.  If you can only enable swap accounting 
at boot either via .config or the command line then these files should 
never be added for CONFIG_CGROUP_MEM_RES_CTLR_SWAP=n or when 
do_swap_account is 0.  It's much easier to test if the feature is enabled 
by checking for the presence of these files at the memcg mount point 
rather than doing an open(2) and checking for -EOPNOTSUPP, which isn't 
even a listed error code.  I don't care how much cleaner it makes the 
internal memcg code.
