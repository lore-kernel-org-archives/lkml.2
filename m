Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758640Ab2INPDR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 11:03:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58902 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751531Ab2INPDN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 11:03:13 -0400
Date: Fri, 14 Sep 2012 17:03:06 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Tejun Heo <tj@kernel.org>
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, Li Zefan <lizefan@huawei.com>,
        Glauber Costa <glommer@parallels.com>,
        Peter Zijlstra <peterz@infradead.org>, Paul Turner <pjt@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Thomas Graf <tgraf@suug.ch>,
        "Serge E. Hallyn" <serue@us.ibm.com>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Neil Horman <nhorman@tuxdriver.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [RFC] cgroup TODOs
Message-ID: <20120914150306.GQ28039@dhcp22.suse.cz>
References: <20120913205827.GO7677@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120913205827.GO7677@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 13-09-12 13:58:27, Tejun Heo wrote:
[...]
> 2. memcg's __DEPRECATED_clear_css_refs
> 
>   This is a remnant of another weird design decision of requiring
>   synchronous draining of refcnts on cgroup removal and allowing
>   subsystems to veto cgroup removal - what's the userspace supposed to
>   do afterwards?  Note that this also hinders co-mounting different
>   controllers.
> 
>   The behavior could be useful for development and debugging but it
>   unnecessarily interlocks userland visible behavior with in-kernel
>   implementation details.  To me, it seems outright wrong (either
>   implement proper severing semantics in the controller or do full
>   refcnting) and disallows, for example, lazy drain of caching refs.
>   Also, it complicates the removal path with try / commit / revert
>   logic which has never been fully correct since the beginning.
> 
>   Currently, the only left user is memcg.
> 
>   Solution:
> 
>   * Update memcg->pre_destroy() such that it never fails.
> 
>   * Drop __DEPRECATED_clear_css_refs and all related logic.
>     Convert pre_destroy() to return void.
> 
>   Who:
> 
>   KAMEZAWA, Michal, PLEASE.  I will make __DEPRECATED_clear_css_refs
>   trigger WARN sooner or later.  Let's please get this settled.

I think we are almost there. One big step was that we no longer charge
to the parent and only move statistics but there are still some corner
cases when we race with LRU handling.

[...]
>   * memcg can be fully hierarchical but we need to phase out the flat
>     hierarchy support.  Unfortunately, this involves flipping the
>     behavior for the existing users.  Upstream will try to nudge users
>     with warning messages.  Most burden would be on the distros and at
>     least SUSE seems to be on board with it.  Needs coordination with
>     other distros.

I am currently planning to add a warning to most of the currenly
maintained distributions to have as big coverage as possible. No default
switch for obvious reasons but hopefuly we will get some feedback at
least.

Thanks Tejun for doing this. We needed it for a long time.
-- 
Michal Hocko
SUSE Labs
